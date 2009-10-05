Return-Path: <linux-kernel-owner+w=401wt.eu-S932635AbZJEMAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbZJEMAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 08:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932617AbZJEMAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 08:00:44 -0400
Received: from www.tglx.de ([62.245.132.106]:44328 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621AbZJEMAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 08:00:43 -0400
Date: Mon, 5 Oct 2009 13:59:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Anirban Sinha <ani@anirban.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Kaz Kylheku <kaz@zeugmasystems.com>,
       Anirban Sinha <asinha@zeugmasystems.com>
Subject: Re: futex question
In-Reply-To: <1254743934.26976.42.camel@twins>
Message-ID: <alpine.LFD.2.00.0910051358060.2646@localhost.localdomain>
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local>  <20091001092218.GH15345@elte.hu>  <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local>  <4AC68F13.8050601@us.ibm.com>  <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain>
  <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local>  <4AC8CF32.8060108@anirban.org>  <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain>  <1254738974.26976.24.camel@twins> <1254743934.26976.42.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009, Peter Zijlstra wrote:

> On Mon, 2009-10-05 at 12:36 +0200, Peter Zijlstra wrote:
> > On Sun, 2009-10-04 at 18:59 +0200, Thomas Gleixner wrote:
> > 
> > > > do. It does not feel right. Currently, with or without my change,
> > > > such a thing would indefinitely block other waiters on the same
> > > > futex.
> > > 
> > > Right. Which completely defeats the purpose of the robust list. Will
> > > have a look tomorrow.
> > 
> > Right, so mm_release() which is meant to destroy the old mm context
> > actually does exit_robust_list(), but the problem is that it does so on
> > the new mm, not the old one that got passed down to mm_release().
> > 
> > The other detail is that exit_robust_list() doesn't clear
> > current->robust_list.
> > 
> > The problem with the patch send my Ani is that it clears the robust
> > lists before the point of no return, so on a failing execve() we'd have
> > messed up the state.
> > 
> > Making exit_robust_list() deal with an mm that is not the current mm is
> > interesting indeed.
> 
> Hmm...
> 
> static int exec_mmap(struct mm_struct *mm)
> {
>         struct task_struct *tsk;
>         struct mm_struct * old_mm, *active_mm;
> 
>         /* Notify parent that we're no longer interested in the old VM */
>         tsk = current;
>         old_mm = current->mm;
>         mm_release(tsk, old_mm);
> 
>         if (old_mm) {
>                 /*
>                  * Make sure that if there is a core dump in progress
>                  * for the old mm, we get out and die instead of going
>                  * through with the exec.  We must hold mmap_sem around
>                  * checking core_state and changing tsk->mm.
>                  */
>                 down_read(&old_mm->mmap_sem);
>                 if (unlikely(old_mm->core_state)) {
>                         up_read(&old_mm->mmap_sem);
>                         return -EINTR;
>                 }
>         }
>         task_lock(tsk);
>         active_mm = tsk->active_mm;
>         tsk->mm = mm;
>         tsk->active_mm = mm;
>         activate_mm(active_mm, mm);
>         task_unlock(tsk);
>         arch_pick_mmap_layout(mm);
>         if (old_mm) {
>                 up_read(&old_mm->mmap_sem);
>                 BUG_ON(active_mm != old_mm);
>                 mm_update_next_owner(old_mm);
>                 mmput(old_mm);
>                 return 0;
>         }
>         mmdrop(active_mm);
>         return 0;
> }
> 
> Actually calls mm_release() before the flip, so the below might actually
> be sufficient?

Stared at the same place a minute ago :) But still I wonder if it's a
good idea to silently release locks and set the state to OWNERDEAD
instead of hitting the app programmer with a big clue stick in case
the app holds locks when calling execve().

Thanks,

	tglx
 
> ---
>  kernel/fork.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 266c6af..4c20fff 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -570,12 +570,18 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
>  
>  	/* Get rid of any futexes when releasing the mm */
>  #ifdef CONFIG_FUTEX
> -	if (unlikely(tsk->robust_list))
> +	if (unlikely(tsk->robust_list)) {
>  		exit_robust_list(tsk);
> +		tsk->robust_list = NULL;
> +	}
>  #ifdef CONFIG_COMPAT
> -	if (unlikely(tsk->compat_robust_list))
> +	if (unlikely(tsk->compat_robust_list)) {
>  		compat_exit_robust_list(tsk);
> +		tsk->compat_robust_list = NULL;
> +	}
>  #endif
> +	if (unlikely(!list_empty(&tsk->pi_state_list)))
> +		exit_pi_state_list(tsk);
>  #endif
>  
>  	/* Get rid of any cached register state */
> 
