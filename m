Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbYC2NK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbYC2NK6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 09:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbYC2NKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 09:10:46 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51014 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbYC2NKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 09:10:46 -0400
Date: Sat, 29 Mar 2008 16:10:19 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace children revamp
Message-ID: <20080329131019.GA472@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain> <20080329033542.BFF4526FA1D@magilla.localdomain> <20080329103929.GB359@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080329103929.GB359@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Oleg Nesterov wrote:
> 
> On 03/28, Roland McGrath wrote:
> >
> > @@ -1528,19 +1534,11 @@ static int do_wait_thread(struct task_struct *tsk, int *retval,
> >  			return 1;
> >  	}
> >  
> > -	/*
> > -	 * If we never saw an eligile child, check for children stolen by
> > -	 * ptrace.  We don't leave -ECHILD in *@retval if there are any,
> > -	 * because we will eventually be allowed to wait for them again.
> > -	 */
> > -	if (*retval)
> > -		list_for_each_entry(p, &tsk->ptrace_children, ptrace_list) {
> > -			int ret = eligible_child(type, pid, options, p);
> > -			if (ret) {
> > -				*retval = unlikely(ret < 0) ? ret : 0;
> > -				break;
> > -			}
> > -		}
> > +	list_for_each_entry(p, &tsk->ptrace_attach, ptrace_list) {
> > +		if (wait_consider_task(tsk, p, retval, type, pid, options,
> > +				       infop, stat_addr, ru))
> > +			return 1;
> > +	}
> 
> Afaics, this adds a minor pessimization. We shouldn't scan ->ptrace_attach
> list if it was already found that another thread has a "hidden" task.

Please ignore. I confused ->ptrace_attach with ->ptrace_children which
doesn't exists any longer. The added pessimization is very minor.


I personally think this is very nice change, it really makes the code better.
A couple of nits.

> @@ -1070,18 +1064,26 @@ struct task_struct {
>  	/*
>  	 * pointers to (original) parent process, youngest child, younger sibling,
>  	 * older sibling, respectively.  (p->father can be replaced with
> -	 * p->parent->pid)
> +	 * p->real_parent->pid)

There is no ->father in task_struct, the comment is obsolete

> -#define remove_parent(p)	list_del_init(&(p)->sibling)
> -#define add_parent(p)		list_add_tail(&(p)->sibling,&(p)->parent->children)

FYI, arch/mips/kernel/irixsig.c uses add_parent/remove_parent. I don't know
why irixsig.c reimplements do_wait() and friends...

> @@ -692,58 +723,24 @@ static void forget_original_parent(struct task_struct *father)
>  		}
>  	} while (reaper->flags & PF_EXITING);
>
> +	ptrace_exit(father, &ptrace_dead);
> +
>  	/*
> -	 * There are only two places where our children can be:
> -	 *
> -	 * - in our child list
> -	 * - in our ptraced child list
> -	 *
> -	 * Search them and reparent children.
> +	 * Reparent our natural children.
>  	 */
>  	list_for_each_entry_safe(p, n, &father->children, sibling) {
> -		int ptrace;
> -
> -		ptrace = p->ptrace;
> -
> -		/* if father isn't the real parent, then ptrace must be enabled */
> -		BUG_ON(father != p->real_parent && !ptrace);
> -
> -		if (father == p->real_parent) {
> -			/* reparent with a reaper, real father it's us */
> -			p->real_parent = reaper;
> -			reparent_thread(p, father, 0);
> -		} else {
> -			/* reparent ptraced task to its real parent */
> -			__ptrace_unlink (p);
> -			if (p->exit_state == EXIT_ZOMBIE && p->exit_signal != -1 &&
> -			    thread_group_empty(p))
> -				do_notify_parent(p, p->exit_signal);
> -		}
> -
> -		/*
> -		 * if the ptraced child is a zombie with exit_signal == -1
> -		 * we must collect it before we exit, or it will remain
> -		 * zombie forever since we prevented it from self-reap itself
> -		 * while it was being traced by us, to be able to see it in wait4.
> -		 */
> -		if (unlikely(ptrace && p->exit_state == EXIT_ZOMBIE && p->exit_signal == -1))
> -			list_add(&p->ptrace_list, &ptrace_dead);
> -	}
> -
> -	list_for_each_entry_safe(p, n, &father->ptrace_children, ptrace_list) {
>  		p->real_parent = reaper;
> -		reparent_thread(p, father, 1);
> +		if (p->parent == father) {
> +			ptrace_unlink(p);
> +			p->parent = p->real_parent;
> +		}
> +		reparent_thread(p, father);

Unless I missed something again, this is not 100% right.

Suppose that we are ->real_parent, the child was traced by us, we ignore
SIGCHLD, and we are doing the threaded reparenting. In that case we should
release the child if it is dead, like the current code does.

Even if we don't ignore SIGCHLD, we should notify our thread-group, but
reparent_thread() skips do_notify_parent() when the new parent is from
is from the same thread-group.

Note also that reparent_thread() has a very old bug. When it sees the
EXIT_ZOMBIE task, it notifies the new parent, but doesn't check if the task
becomes detached because the new parent ignores SIGCHLD. Currently this means
that init must have a handler for SIGCHLD or we leak zombies.

(btw, this patch has many conflicts with Linus's or Andrew's tree)

Oleg.

