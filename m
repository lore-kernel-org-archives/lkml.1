Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbXHBTEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbXHBTEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbXHBTEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:04:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844AbXHBTEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:04:42 -0400
Date: Thu, 2 Aug 2007 12:04:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Guillaume Chazarain" <guichaz@yahoo.fr>
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Shailabh Nagar <nagar@watson.ibm.com>, Jay Lan <jlan@engr.sgi.com>,
       Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] Add all thread stats for TASKSTATS_CMD_ATTR_TGID
Message-Id: <20070802120427.270e5589.akpm@linux-foundation.org>
In-Reply-To: <3d8471ca0708020653l575db8cam464a3cffce68fb26@mail.gmail.com>
References: <3d8471ca0708020653l575db8cam464a3cffce68fb26@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007 15:53:13 +0200
"Guillaume Chazarain" <guichaz@yahoo.fr> wrote:

> [Resent with different recipients as nagar@watson.ibm.com bounced with
> a User unknown]
> 
> Hi,
> 
> This patch adds all thread accounting stats for the global tgid stats.
> As a shameless plug, this fixes iotop -P (http://guichaz.free.fr/misc/iotop.py).

uhm, that's a fairly skimpy changelog for a fairly significant functional
change.

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

How come hiwater_rss and hiwater_vm weren't similarly treated?

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

Suitable cc's added.  Guys, please have a think about the implications of
this change?  In particular, why didn't we do this on day one?  It's so
obvious that I have a feeling we must have had a reason?

