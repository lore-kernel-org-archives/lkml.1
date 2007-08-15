Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbXHOHRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbXHOHRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 03:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXHOHRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 03:17:32 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:32797 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbXHOHRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 03:17:31 -0400
Message-ID: <46C2A824.3080907@linux.vnet.ibm.com>
Date: Wed, 15 Aug 2007 12:45:48 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Guillaume Chazarain <guichaz@yahoo.fr>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add all thread stats for TASKSTATS_CMD_ATTR_TGID
References: <3d8471ca0708020653l575db8cam464a3cffce68fb26@mail.gmail.com>
In-Reply-To: <3d8471ca0708020653l575db8cam464a3cffce68fb26@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guillaume Chazarain wrote:
> [Resent with different recipients as nagar@watson.ibm.com bounced with
> a User unknown]
> 
> Hi,
> 
> This patch adds all thread accounting stats for the global tgid stats.
> As a shameless plug, this fixes iotop -P (http://guichaz.free.fr/misc/iotop.py).
> 

Since this changes CSA behaviour, it would be nice to get Jay Lan
to confirm if the change looks ok to him..

> Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
> ---
> 
> diff -r 22708012ca6e kernel/taskstats.c
> --- a/kernel/taskstats.c	Tue Jul 31 21:12:07 2007 -0700
> +++ b/kernel/taskstats.c	Wed Aug 01 17:43:54 2007 +0200
> @@ -233,6 +233,7 @@ static int fill_tgid(pid_t tgid, struct
>  		memset(stats, 0, sizeof(*stats));
> 
>  	tsk = first;
> +	bacct_add_tsk(stats, first);
>  	do {
>  		if (tsk->exit_state)
>  			continue;
> @@ -246,6 +247,7 @@ static int fill_tgid(pid_t tgid, struct
> 
>  		stats->nvcsw += tsk->nvcsw;
>  		stats->nivcsw += tsk->nivcsw;
> +		xacct_add_tsk(stats, tsk);
>  	} while_each_thread(first, tsk);
> 

using bacct and xacct might not work well in this case. You'll end
up with basic accounting data for the thread group leader (utime,
stime. For delay accounting, we accumulate data of tasks that have
exited the thread group in fill_tgid_exit(), that way when we
sum up data, we continue storing data of all tasks that exited.
You might want to revisit the code to do that as well.

>  	unlock_task_sighand(first, &flags);
> diff -r 22708012ca6e kernel/tsacct.c
> --- a/kernel/tsacct.c	Tue Jul 31 21:12:07 2007 -0700
> +++ b/kernel/tsacct.c	Wed Aug 01 17:41:40 2007 +0200
> @@ -81,8 +81,8 @@ void xacct_add_tsk(struct taskstats *sta
>  	struct mm_struct *mm;
> 
>  	/* convert pages-jiffies to Mbyte-usec */
> -	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
> -	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
> +	stats->coremem += jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
> +	stats->virtmem += jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
>  	mm = get_task_mm(p);
>  	if (mm) {
>  		/* adjust to KB unit */
> @@ -90,18 +90,14 @@ void xacct_add_tsk(struct taskstats *sta
>  		stats->hiwater_vm    = mm->hiwater_vm * PAGE_SIZE / KB;
>  		mmput(mm);
>  	}
> -	stats->read_char	= p->rchar;
> -	stats->write_char	= p->wchar;
> -	stats->read_syscalls	= p->syscr;
> -	stats->write_syscalls	= p->syscw;
> +	stats->read_char	+= p->rchar;
> +	stats->write_char	+= p->wchar;
> +	stats->read_syscalls	+= p->syscr;
> +	stats->write_syscalls	+= p->syscw;
>  #ifdef CONFIG_TASK_IO_ACCOUNTING
> -	stats->read_bytes	= p->ioac.read_bytes;
> -	stats->write_bytes	= p->ioac.write_bytes;
> -	stats->cancelled_write_bytes = p->ioac.cancelled_write_bytes;
> -#else
> -	stats->read_bytes	= 0;
> -	stats->write_bytes	= 0;
> -	stats->cancelled_write_bytes = 0;
> +	stats->read_bytes	+= p->ioac.read_bytes;
> +	stats->write_bytes	+= p->ioac.write_bytes;
> +	stats->cancelled_write_bytes += p->ioac.cancelled_write_bytes;
>  #endif
>  }
>  #undef KB


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
