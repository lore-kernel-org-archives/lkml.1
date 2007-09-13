Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbXIMASm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbXIMASm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 20:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXIMASe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 20:18:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53303 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbXIMASd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 20:18:33 -0400
Date: Wed, 12 Sep 2007 17:18:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: balbir@linux.vnet.ibm.com, Jonathan Lim <jlim@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Lan <jlan@cthulhu.engr.sgi.com>
Subject: Re: Add all thread stats for TASKSTATS_CMD_ATTR_TGID (v3)
Message-Id: <20070912171816.f0993440.akpm@linux-foundation.org>
In-Reply-To: <20070831143535.2e4709c7@localhost.localdomain>
References: <200708310302.l7V32ZpV410222@sabah.engr.sgi.com>
	<46D7C23F.7020509@linux.vnet.ibm.com>
	<20070831143535.2e4709c7@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 14:35:35 +0200
Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> TASKSTATS_CMD_ATTR_TGID used to return only the delay accounting stats,
> not the basic and extended accounting. With this patch,
> TASKSTATS_CMD_ATTR_TGID also aggregates the accounting info for all threads of a
> thread group. This makes TASKSTATS_CMD_ATTR_TGID usable in a similar
> fashion to TASKSTATS_CMD_ATTR_PID, for commands like iotop -P
> (http://guichaz.free.fr/misc/iotop.py).
> 
> Here is the output of the testcase before the patch:
> 
> ...

>  Documentation/accounting/dump-test.c |  314 +++++++++++++++++++++++++++++++++++

Another C file in the Documentation directory.  Sigh.  At kernel summit I
suggested that we should be putting these things in a place from where we
can actually build and install them.  People said there was no need to do
that because kernel developers can now easily get new stuff into
util-linux.  I don't believe them.  Wanna be a guinea pig?


> +static void loop_reading(const char *filename)
> +{
> +	int fd = open(filename, O_RDONLY);
> +	char buffer[4096];
> +
> +	if (fd < 0) {
> +		perror(filename);
> +		return;
> +	}
> +
> +	for (;;) {
> +		lseek(fd, 0, SEEK_SET);
> +		while (read(fd, buffer, sizeof(buffer)) > 0) ;

newline here.  Just because it's userspace doesn't mean that it needs to
look crappy, despite all the code out there which disproves this ;)

I think you just invented pread().

> +	}
> +}
> +
>
> ...
>
> --- a/kernel/taskstats.c	Fri Aug 31 01:42:23 2007 -0700
> +++ b/kernel/taskstats.c	Fri Aug 31 13:36:29 2007 +0200
> @@ -168,6 +168,60 @@ static void send_cpu_listeners(struct sk
>  	up_write(&listeners->sem);
>  }
>  
> +/*
> + * There are two types of taskstats fields when considering a thread group:
> + *	- those that can be aggregated from each thread in the group (like CPU
> + *	times),
> + *	- those that cannot be aggregated (like UID) or are identical (like
> + *	memory usage), so are taken from the group leader.
> + * XXX_threadgroup() methods deal with the first type while XXX_add_tsk() with
> + * the second.
> + */
> +static void fill_threadgroup(struct taskstats *stats, struct task_struct *task)
> +{
> +	/*
> +	 * Each accounting subsystem adds calls to its functions to initialize
> +	 * relevant parts of struct taskstsats for a single tgid as follows:
> +	 *
> +	 *	per-task-foo-fill_threadgroup(stats, task);
> +	 */
> +
> +	stats->version = TASKSTATS_VERSION;
> +
> +	/* fill in basic acct fields */
> +	bacct_fill_threadgroup(stats, task);
> +
> +	/* fill in extended acct fields */
> +	xacct_fill_threadgroup(stats, task);
> +}
> +
> +/*
> + * Stats specific to each thread in the thread group. Stats of @task should be
> + * combined with those already present in @stats. add_tsk() works in
> + * conjunction with fill_threadgroup(), taskstats fields should not be touched
> + * by both functions.
> + */

It's odd to use kerneldoc-style markup in a non-kerneldoc comment.

> @@ -232,32 +272,21 @@ static int fill_tgid(pid_t tgid, struct 
>  	else
>  		memset(stats, 0, sizeof(*stats));
>  
> +	leader = first->group_leader;
> +	get_task_struct(leader);
> +	fill_threadgroup(stats, leader);
> +	put_task_struct(leader);
> +

Are the get_task_struct/put_task_struct here actually needed?


