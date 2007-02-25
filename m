Return-Path: <linux-kernel-owner+w=401wt.eu-S964790AbXBYKwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790AbXBYKwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964801AbXBYKwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:52:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55069 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964790AbXBYKwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:52:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 4/7] Freezer: Fix vfork problem
Date: Sun, 25 Feb 2007 11:45:37 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
       ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       Aneesh Kumar <aneesh.kumar@gmail.com>
References: <200702231116.23607.rjw@sisk.pl> <200702231122.44040.rjw@sisk.pl> <20070225104612.GM2045@elf.ucw.cz>
In-Reply-To: <20070225104612.GM2045@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702251145.39595.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, 25 February 2007 11:46, Pavel Machek wrote:
> Hi!
> 
> > Currently try_to_freeze_tasks() has to wait until all of the vforked processes
> > exit and for this reason every user can make it fail.  To fix this problem
> > we can introduce the additional process flag PF_FREEZER_SKIP to be used by tasks
> > that do not want to be counted as freezable by the freezer and want to have
> > TIF_FREEZE set nevertheless.  Then, this flag can be set by tasks using
> > sys_vfork() before they call wait_for_completion() and cleared after they have
> > woken up and called try_to_freeze().  In case such a task freezes with
> > PF_FREEZER_SKIP set, refrigerator() clears this flag for the current task before
> > calling frozen_process(current) to avoid having both PF_FREEZER_SKIP and
> > PF_FROZEN set at the same time.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> > @@ -1393,7 +1394,9 @@ long do_fork(unsigned long clone_flags,
> >  		tracehook_report_clone_complete(clone_flags, nr, p);
> >  
> >  		if (clone_flags & CLONE_VFORK) {
> > +			freezer_do_not_count();
> >  			wait_for_completion(&vfork);
> > +			freezer_count();
> >  			tracehook_report_vfork_done(p, nr);
> >  		}
> >  	} else {
> 
> All the infrastructure for this...Would it be easier to introduce
> 
> void fastcall __sched wait_for_completion_freezeable(struct completion *x)
> {
>         might_sleep();
> 
>         spin_lock_irq(&x->wait.lock);
>         if (!x->done) {
>                 DECLARE_WAITQUEUE(wait, current);
> 
>                 wait.flags |= WQ_FLAG_EXCLUSIVE;
>                 __add_wait_queue_tail(&x->wait, &wait);
>                 do {
>                         __set_current_state(TASK_UNINTERRUPTIBLE);
>                         spin_unlock_irq(&x->wait.lock);
>                         schedule();
> try_to_freeze(); /* HERE */
>                         spin_lock_irq(&x->wait.lock);
>                 } while (!x->done);
>                 __remove_wait_queue(&x->wait, &wait);
>         }
>         x->done--;
>         spin_unlock_irq(&x->wait.lock);
> }
> 
> ...and be done with that, in a very obvious way? (Ok, you probably do
> not want to duplicate the function, but you get the idea).

Yes, I though about that too, but I was thinking of sticking try_to_freeze()
in wait wait_for_completion() itself, which was obviously wrong.

Still, the above might work.  I'll try to prepare a patch.

Greetings,
Rafael
