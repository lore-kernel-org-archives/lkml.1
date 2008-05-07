Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbYEGJf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbYEGJf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 05:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYEGJfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 05:35:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46903 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbYEGJfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 05:35:39 -0400
Date: Wed, 7 May 2008 11:36:21 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 1/2] Freezer: Introduce PF_FREEZER_NOSIG
Message-ID: <20080507093621.GF13858@elf.ucw.cz>
References: <200805070003.56387.rjw@sisk.pl> <200805070005.20403.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805070005.20403.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The freezer currently attempts to distinguish kernel threads from
> user space tasks by checking if their mm pointer is unset and it
> does not send fake signals to kernel threads.  However, there are
> kernel threads, mostly related to networking, that behave like
> user space tasks and may want to be sent a fake signal to be frozen.
> 
> Introduce the new process flag PF_FREEZER_NOSIG that will be set
> by default for all kernel threads and make the freezer only send
> fake signals to the tasks having PF_FREEZER_NOSIG unset.  Provide
> the set_freezable_with_signal() function to be called by the kernel
> threads that want to be sent a fake signal for freezing.
> 
> This patch should not change the freezer's observable behavior.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.


> -static int has_mm(struct task_struct *p)
> +static inline bool should_send_signal(struct task_struct *p)
>  {
> -	return (p->mm && !(p->flags & PF_BORROWED_MM));
> +	return !(current->flags & PF_FREEZER_NOSIG);
>  }
>

Note that we used to tell kernel threads by ->mm, and now you assume
that anything created by ktrheadd is kernel thread, ->mm or not.

I'm not sure if those can differ (->mm = NULL somewhere? Or ->mm =
something somewhere else?). I guess this should go to -mm for a long
test...

> @@ -234,7 +234,7 @@ int kthreadd(void *unused)
>  	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
>  	set_cpus_allowed(tsk, CPU_MASK_ALL);
>  
> -	current->flags |= PF_NOFREEZE;
> +	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
>  
>  	for (;;) {
>  		set_current_state(TASK_INTERRUPTIBLE);

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
