Return-Path: <linux-kernel-owner+w=401wt.eu-S964831AbXBYNus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831AbXBYNus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 08:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964854AbXBYNus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 08:50:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55545 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964831AbXBYNus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 08:50:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Aneesh Kumar" <aneesh.kumar@gmail.com>
Subject: Re: [RFC][PATCH 4/7] Freezer: Fix vfork problem
Date: Sun, 25 Feb 2007 14:43:50 +0100
User-Agent: KMail/1.9.5
Cc: "Pavel Machek" <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org,
       mingo@elte.hu, vatsa@in.ibm.com, dipankar@in.ibm.com,
       venkatesh.pallipadi@intel.com
References: <200702231116.23607.rjw@sisk.pl> <20070225104612.GM2045@elf.ucw.cz> <cc723f590702250501t7f920336hd383da3a703a99fa@mail.gmail.com>
In-Reply-To: <cc723f590702250501t7f920336hd383da3a703a99fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702251443.52339.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 February 2007 14:01, Aneesh Kumar wrote:
> On 2/25/07, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> > > Currently try_to_freeze_tasks() has to wait until all of the vforked processes
> > > exit and for this reason every user can make it fail.  To fix this problem
> > > we can introduce the additional process flag PF_FREEZER_SKIP to be used by tasks
> > > that do not want to be counted as freezable by the freezer and want to have
> > > TIF_FREEZE set nevertheless.  Then, this flag can be set by tasks using
> > > sys_vfork() before they call wait_for_completion() and cleared after they have
> > > woken up and called try_to_freeze().  In case such a task freezes with
> > > PF_FREEZER_SKIP set, refrigerator() clears this flag for the current task before
> > > calling frozen_process(current) to avoid having both PF_FREEZER_SKIP and
> > > PF_FROZEN set at the same time.
> > >
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > > @@ -1393,7 +1394,9 @@ long do_fork(unsigned long clone_flags,
> > >               tracehook_report_clone_complete(clone_flags, nr, p);
> > >
> > >               if (clone_flags & CLONE_VFORK) {
> > > +                     freezer_do_not_count();
> > >                       wait_for_completion(&vfork);
> > > +                     freezer_count();
> > >                       tracehook_report_vfork_done(p, nr);
> > >               }
> > >       } else {
> >
> > All the infrastructure for this...Would it be easier to introduce
> >
> > void fastcall __sched wait_for_completion_freezeable(struct completion *x)
> > {
> >         might_sleep();
> >
> >         spin_lock_irq(&x->wait.lock);
> >         if (!x->done) {
> >                 DECLARE_WAITQUEUE(wait, current);
> >
> >                 wait.flags |= WQ_FLAG_EXCLUSIVE;
> >                 __add_wait_queue_tail(&x->wait, &wait);
> >                 do {
> >                         __set_current_state(TASK_UNINTERRUPTIBLE);
> >                         spin_unlock_irq(&x->wait.lock);
> >                         schedule();
> > try_to_freeze(); /* HERE */
> >                         spin_lock_irq(&x->wait.lock);
> >                 } while (!x->done);
> >                 __remove_wait_queue(&x->wait, &wait);
> >         }
> >         x->done--;
> >         spin_unlock_irq(&x->wait.lock);
> > }
> >
> >
> 
> I don't see a call  to freezer_do_not_count here. Rafel was talking
> about a similar change but that would involve special cases in
> refrigerator such as  wakeup parent if the process which is going to
> be frozen have vfork_done set.
> 
> if (->vfork_done) {
> wakeup_parent()
> }
> 
> how about
> 
> void fastcall __sched wait_for_completion_freezeable(struct completion *x)
> {
>      freezer_do_not_count();
>      wait_for_completion(x);
>      freezer_count();
> }

I think we can something like that on top of my original patch (or rather, the
patch that I've just sent in another message) if it's needed by anything else
than vfork.

Greetings,
Rafael
