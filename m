Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbYLCUiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbYLCUiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760717AbYLCUYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:24:49 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:54553 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711AbYLCUYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:24:47 -0500
Date: Wed, 3 Dec 2008 20:24:30 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Jay Lan <jlan@sgi.com>,
       Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce get_mm_hiwater_xxx(), fix taskstats->hiwater_xxx
 accounting
In-Reply-To: <20081203181220.GA22918@redhat.com>
Message-ID: <Pine.LNX.4.64.0812031957570.19174@blonde.anvils>
References: <20081203181220.GA22918@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Oleg Nesterov wrote:
> Unless we are going to decrease rss/vm there is no point to call the
> (racy) update_hiwater_xxx() helpers. Still do_exit() does this, and

I'm puzzled by this comment.  exit() _is_ about to decrease rss/vm,
so isn't it right to be calling update_hiwater_xxx()?

There is a question of who's going to be able to see the result from
this point on: I forget whether I was doing it for my own satisfaction,
or for a real observer.  Even if there isn't a real observer today,
I think I'd prefer do_exit() to continue to update_hiwater_xxx(),
in case an observer is added tomorrow - unless you feel it's
unjustifiably adding code to and slowing down process exit.

You say "(racy)": in my view, it was only as racy as whatever might
cause it to be racy.  By that, I mean that if the numbers ended up
slightly wrong, you could reasonably imagine that the races happened
in a different sequence which would have ended up with the numbers 
seen.  Have you noticed something more serious we need to fix?

> the accounting code uses mm->hiwater_xxx directly.
> 
> This is not right. fill_pid()->xacct_add_tsk() can be called by
> taskstats_user_cmd() at any time, not only when the task exits.
> in that case taskstats->hiwater_xxx can be very wrong.

Here you're very right.  There was no tsacct.c when I added those
hiwaters in 2.6.15, it's quite wrong to have been using those
numbers without comparing against current values, well spotted.

> 
> Introduce get_mm_hiwater_rss() and get_mm_hiwater_vm() to use instead,
> and kill the "if (tsk->mm) {}" code in do_exit().

If you're going to add special helper macros (I don't care myself),
wouldn't it be better to convert fs/proc/task_mmu.c (the original
consumer) to use them too?

And, as I say, I'd _prefer_ that block to remain in do_exit(),
but don't have strong evidence why it should.

> The first helper will
> be also used to actually fill/report rusage->ru_maxrss.

Oh, yes, I noticed a mail yesterday in which you claimed to Cc me,
but didn't (like we all claim to be attaching missing patches ;)
I then forgot it, but yes, I am glad to see Jiri putting
hiwater_rss to more use, fewer ever-0s from /usr/bin/time.

Hugh

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> --- K-28/include/linux/sched.h~HIWATER	2008-12-02 17:12:40.000000000 +0100
> +++ K-28/include/linux/sched.h	2008-12-03 18:17:18.000000000 +0100
> @@ -388,6 +388,9 @@ extern void arch_unmap_area_topdown(stru
>  		(mm)->hiwater_vm = (mm)->total_vm;	\
>  } while (0)
>  
> +#define get_mm_hiwater_rss(mm)	max((mm)->hiwater_rss, get_mm_rss(mm))
> +#define get_mm_hiwater_vm(mm)	max((mm)->hiwater_vm, (mm)->total_vm)
> +
>  extern void set_dumpable(struct mm_struct *mm, int value);
>  extern int get_dumpable(struct mm_struct *mm);
>  
> --- K-28/kernel/tsacct.c~HIWATER	2008-10-10 00:13:53.000000000 +0200
> +++ K-28/kernel/tsacct.c	2008-12-03 18:24:28.000000000 +0100
> @@ -90,8 +90,8 @@ void xacct_add_tsk(struct taskstats *sta
>  	mm = get_task_mm(p);
>  	if (mm) {
>  		/* adjust to KB unit */
> -		stats->hiwater_rss   = mm->hiwater_rss * PAGE_SIZE / KB;
> -		stats->hiwater_vm    = mm->hiwater_vm * PAGE_SIZE / KB;
> +		stats->hiwater_rss   = get_mm_hiwater_rss(mm) * PAGE_SIZE / KB;
> +		stats->hiwater_vm    = get_mm_hiwater_vm(mm)  * PAGE_SIZE / KB;
>  		mmput(mm);
>  	}
>  	stats->read_char	= p->ioac.rchar;
> --- K-28/kernel/exit.c~HIWATER	2008-12-02 17:12:40.000000000 +0100
> +++ K-28/kernel/exit.c	2008-12-03 18:21:06.000000000 +0100
> @@ -1048,10 +1048,7 @@ NORET_TYPE void do_exit(long code)
>  				preempt_count());
>  
>  	acct_update_integrals(tsk);
> -	if (tsk->mm) {
> -		update_hiwater_rss(tsk->mm);
> -		update_hiwater_vm(tsk->mm);
> -	}
> +
>  	group_dead = atomic_dec_and_test(&tsk->signal->live);
>  	if (group_dead) {
>  		hrtimer_cancel(&tsk->signal->real_timer);
