Return-Path: <linux-kernel-owner+w=401wt.eu-S964785AbXBYKqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785AbXBYKqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964801AbXBYKqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:46:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40535 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964785AbXBYKqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:46:23 -0500
Date: Sun, 25 Feb 2007 11:46:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
       ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       Aneesh Kumar <aneesh.kumar@gmail.com>
Subject: Re: [RFC][PATCH 4/7] Freezer: Fix vfork problem
Message-ID: <20070225104612.GM2045@elf.ucw.cz>
References: <200702231116.23607.rjw@sisk.pl> <200702231122.44040.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702231122.44040.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Currently try_to_freeze_tasks() has to wait until all of the vforked processes
> exit and for this reason every user can make it fail.  To fix this problem
> we can introduce the additional process flag PF_FREEZER_SKIP to be used by tasks
> that do not want to be counted as freezable by the freezer and want to have
> TIF_FREEZE set nevertheless.  Then, this flag can be set by tasks using
> sys_vfork() before they call wait_for_completion() and cleared after they have
> woken up and called try_to_freeze().  In case such a task freezes with
> PF_FREEZER_SKIP set, refrigerator() clears this flag for the current task before
> calling frozen_process(current) to avoid having both PF_FREEZER_SKIP and
> PF_FROZEN set at the same time.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

> @@ -1393,7 +1394,9 @@ long do_fork(unsigned long clone_flags,
>  		tracehook_report_clone_complete(clone_flags, nr, p);
>  
>  		if (clone_flags & CLONE_VFORK) {
> +			freezer_do_not_count();
>  			wait_for_completion(&vfork);
> +			freezer_count();
>  			tracehook_report_vfork_done(p, nr);
>  		}
>  	} else {

All the infrastructure for this...Would it be easier to introduce

void fastcall __sched wait_for_completion_freezeable(struct completion *x)
{
        might_sleep();

        spin_lock_irq(&x->wait.lock);
        if (!x->done) {
                DECLARE_WAITQUEUE(wait, current);

                wait.flags |= WQ_FLAG_EXCLUSIVE;
                __add_wait_queue_tail(&x->wait, &wait);
                do {
                        __set_current_state(TASK_UNINTERRUPTIBLE);
                        spin_unlock_irq(&x->wait.lock);
                        schedule();
try_to_freeze(); /* HERE */
                        spin_lock_irq(&x->wait.lock);
                } while (!x->done);
                __remove_wait_queue(&x->wait, &wait);
        }
        x->done--;
        spin_unlock_irq(&x->wait.lock);
}

...and be done with that, in a very obvious way? (Ok, you probably do
not want to duplicate the function, but you get the idea).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
