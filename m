Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbYGDO52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbYGDO52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYGDO5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:57:16 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:16543 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbYGDO5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:57:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=H+9LJxuDESEj4BDEzKGInkT1vWWHeEKbDFfF83LJIhSwS1EL7GlsATxIrGFQcwrH31
         3tbgn3uN0FpCNOhPilk2RZBuZcbPPGaNjQJOpvojZ9IJp672pfoBDDdU/Rf6HHX4vVvh
         Hd0up402kKFPieW08qPdpinvGzVaP2yDfz32I=
Message-ID: <486E3A46.4000206@gmail.com>
Date: Fri, 04 Jul 2008 16:57:10 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Tomas Smetana <t.smetana@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/proc: Per thread I/O accounting
References: <20080629160446.07eef194@saiph.smetana.name>
In-Reply-To: <20080629160446.07eef194@saiph.smetana.name>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Smetana wrote:
> Hello,
>   here's an attempt to fix the bug #10702: The /proc/#/io doesn't aggregate
> I/O statistics of all the process' threads -- just the main one. The patch
> fixes this and also adds /proc/#/task/#/io file for per-thread accounting
> which should make I/O accounting consistent with CPU stats.
> 
> Reference: http://bugzilla.kernel.org/show_bug.cgi?id=10702
> 
> Please cc: me in the answers.

Hi Tomas,

have a look at distinct-tgid-tid-i-o-statistics.patch in -mm (also
available here http://lwn.net/Articles/283937/).

Your patch seems ok (except the rcu locking, see below), but it doesn't
account the i/o activity of a task if it creates a lot of short-lived
children doing i/o.

> 
> 
> Signed-off-by: Tomas Smetana <t.smetana@gmail.com>
> ---
>  fs/proc/base.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 3b45537..5437ae3 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2377,6 +2377,51 @@ static int proc_base_fill_cache(struct file *filp, void *dirent,
>  #ifdef CONFIG_TASK_IO_ACCOUNTING
>  static int proc_pid_io_accounting(struct task_struct *task, char *buffer)
>  {
> +#ifdef CONFIG_TASK_XACCT
> +	unsigned long long rchar = 0, wchar = 0;
> +	unsigned long long syscr = 0, syscw = 0;
> +#endif
> +	unsigned long long read_bytes = 0, write_bytes = 0;
> +	unsigned long long cancelled_write_bytes = 0;
> +	struct task_struct *t = task;
> +

rcu_read_lock();

> +	do {
> +#ifdef CONFIG_TASK_XACCT
> +		rchar += (unsigned long long)t->rchar;
> +		wchar += (unsigned long long)t->wchar;
> +		syscr += (unsigned long long)t->syscr;
> +		syscw += (unsigned long long)t->syscw;
> +#endif
> +		read_bytes += (unsigned long long)t->ioac.read_bytes;
> +		write_bytes += (unsigned long long)t->ioac.write_bytes;
> +		cancelled_write_bytes +=
> +		    (unsigned long long)t->ioac.cancelled_write_bytes;
> +		t = next_thread(t);
> +	} while (t != task);

rcu_read_unlock();

> +
> +	return sprintf(buffer,
> +#ifdef CONFIG_TASK_XACCT
> +			"rchar: %llu\n"
> +			"wchar: %llu\n"
> +			"syscr: %llu\n"
> +			"syscw: %llu\n"
> +#endif
> +			"read_bytes: %llu\n"
> +			"write_bytes: %llu\n"
> +			"cancelled_write_bytes: %llu\n",
> +#ifdef CONFIG_TASK_XACCT
> +			rchar,
> +			wchar,
> +			syscr,
> +			syscw,
> +#endif
> +			read_bytes,
> +			write_bytes,
> +			cancelled_write_bytes);
> +}
> +
> +static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
> +{
>  	return sprintf(buffer,
>  #ifdef CONFIG_TASK_XACCT
>  			"rchar: %llu\n"
> @@ -2796,6 +2841,9 @@ static const struct pid_entry tid_base_stuff[] = {
>  #ifdef CONFIG_FAULT_INJECTION
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
>  #endif
> +#ifdef CONFIG_TASK_IO_ACCOUNTING
> +	INF("io",	S_IRUGO, tid_io_accounting)
> +#endif
>  };
>  
>  static int proc_tid_base_readdir(struct file * filp,

-Andrea
