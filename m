Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbYGQHft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbYGQHft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759775AbYGQHbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:31:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759981AbYGQHba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:31:30 -0400
Date: Thu, 17 Jul 2008 00:30:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ptrace children revamp
Message-Id: <20080717003050.87f96ab0.akpm@linux-foundation.org>
In-Reply-To: <20080717071322.B80F315411D@magilla.localdomain>
References: <20080717071141.012BD15411D@magilla.localdomain>
	<20080717071322.B80F315411D@magilla.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 00:13:22 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:

> ptrace no longer fiddles with the children/sibling links, and the
> old ptrace_children list is gone.  Now ptrace, whether of one's own
> children or another's via PTRACE_ATTACH, just uses the new ptraced
> list instead.
> 
> There should be no user-visible difference that matters.  The only
> change is the order in which do_wait() sees multiple stopped
> children and stopped ptrace attachees.  Since wait_task_stopped()
> was changed earlier so it no longer reorders the children list, we
> already know this won't cause any new problems.
> 
> ...
>
> +repeat:
>  	task_lock(current);
>  	if (!(current->ptrace & PT_PTRACED)) {
> +		/*
> +		 * See ptrace_attach() comments about the locking here.
> +		 */

	/*
	 * Nasty, nasty.
	 *
	 * We want to hold both the task-lock and the
	 * tasklist_lock for writing at the same time.
	 * But that's against the rules (tasklist_lock
	 * is taken for reading by interrupts on other
	 * cpu's that may have task_lock).
	 */

> +		unsigned long flags;
> +		if (!write_trylock_irqsave(&tasklist_lock, flags)) {
> +			task_unlock(current);
> +			do {
> +				cpu_relax();
> +			} while (!write_can_lock(&tasklist_lock));
> +			goto repeat;
> +		}
> +

hm, copying this code didn't do much to improve the world.

Is there any prospect of "fixing" this somehow?

Perhaps this code should be pulled up into a separate function, not
that this will help things a lot.


>  		ret = security_ptrace(current->parent, current,
>  				      PTRACE_MODE_ATTACH);
> +
>  		/*
>  		 * Set the ptrace bit in the process ptrace flags.
> +		 * Then link us on our parent's ptraced list.
>  		 */
> -		if (!ret)
> +		if (!ret) {
>  			current->ptrace |= PT_PTRACED;
> +			__ptrace_link(current, current->real_parent);
> +		}
> +
> +		write_unlock_irqrestore(&tasklist_lock, flags);
>  	}
>  	task_unlock(current);
>  	return ret;
