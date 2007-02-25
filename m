Return-Path: <linux-kernel-owner+w=401wt.eu-S964958AbXBYPky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958AbXBYPky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 10:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964964AbXBYPky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 10:40:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:18750 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964958AbXBYPkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 10:40:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RpCk3eEvyQdCW5v0gGDw9J4I41K7cDc5pI5dAK/LXWGaeJUONKiaaniYNujzZ24wQS23RRQXQepLV5zuw77hdUN+hHBjGiwHsnpy+kv+pjvwYyJTWg0U7WF/5V4rx3aQhmIxaoZIxTzcac9pJkmYkBBp4g7nOiNuIJ9I67hkq8M=
Message-ID: <cc723f590702250740t1fec263cq5378027527c3d9f8@mail.gmail.com>
Date: Sun, 25 Feb 2007 21:10:51 +0530
From: "Aneesh Kumar" <aneesh.kumar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH 4/7] Freezer: Fix vfork problem
Cc: "Pavel Machek" <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org,
       mingo@elte.hu, vatsa@in.ibm.com, dipankar@in.ibm.com,
       venkatesh.pallipadi@intel.com, "Oleg Nesterov" <oleg@tv-sign.ru>
In-Reply-To: <cc723f590702250728ra1bbb10l190ab73ce3d6fc77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702231116.23607.rjw@sisk.pl> <200702251359.53411.rjw@sisk.pl>
	 <cc723f590702250633i27a79a9tedd5fe670cd9e4ed@mail.gmail.com>
	 <200702251605.42312.rjw@sisk.pl>
	 <cc723f590702250728ra1bbb10l190ab73ce3d6fc77@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/25/07, Aneesh Kumar <aneesh.kumar@gmail.com> wrote:
> On 2/25/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, 25 February 2007 15:33, Aneesh Kumar wrote:
> > > On 2/25/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Sunday, 25 February 2007 11:45, Rafael J. Wysocki wrote:
> > > > > Hi,
> > > > >
> > > > > =========
> > > > --- linux-2.6.20-mm2.orig/kernel/power/process.c        2007-02-22 23:44:04.000000000 +0100
> > > > +++ linux-2.6.20-mm2/kernel/power/process.c     2007-02-23 22:33:11.000000000 +0100
> > > > @@ -127,22 +127,12 @@ static unsigned int try_to_freeze_tasks(
> > > >                                 cancel_freezing(p);
> > > >                                 continue;
> > > >                         }
> > > > -                       if (is_user_space(p)) {
> > > > -                               if (!freeze_user_space)
> > > > -                                       continue;
> > > > -
> > > > -                               /* Freeze the task unless there is a vfork
> > > > -                                * completion pending
> > > > -                                */
> > > > -                               if (!p->vfork_done)
> > > > -                                       freeze_process(p);
> > > > -                       } else {
> > > > -                               if (freeze_user_space)
> > > > -                                       continue;
> > > > +                       if (is_user_space(p) == !freeze_user_space)
> > > > +                               continue;
> > > >
> > >
> > > How about ?
> > > if ( ! (is_user_space(p) == freeze_user_space) )
> > >      continue;
> >
> > I think it would be safer to do
> >
> > if ( is_user_space(p) != !!freeze_user_space)
> >       continue;
> >
> > which is equivalent to my previous version, but contains one '!' more. ;-)
> >
> > Seriously, the one in the patch is consistent with the other occurrences of
> > it in the file and I'm going to change it anyway in a separate patch
> > (while freezing kernel threads we need to freeze userspace tasks too in case
> > one of the kernel threads called kernel_execve() in the meantime).
> >
> > > BTW one of the concern that vatsa had was; is it ok to allow some of
> > > the tasks to be left running  ( the parent from vfork ) while
> > > freezing.  I guess we can solve this in a nice way.
> > >
> > > in fork.c
> > >
> > > if (clone_flags & CLONE_VFORK) {
> > >                         p->vfork_done = &vfork;
> > >                         p->flags |= PF_PARENT_WAKEUP_ON_FREEZE;
> > >                         init_completion(&vfork);
> > > }
> > >
> > >
> > > and in freeze_process(struct task_struct *p)
> > >
> > > if ( p->flags & PF_PARENT_WAKEUP_ON_FREEZE ) {
> > >   wake_up_parent();
> > > }
> > >
> > > now parent should be wating for these completion via
> > >
> > > wait_for_completion_freezable(); // pavel's implementation.
> >
> > Hm, I think this leaves us with an analogous problem: we need a method
> > to tell a vforking task that the child should set PF_PARENT_WAKEUP_ON_FREEZE.
> >
> > In the approach with PF_FREEZER_SKIP we need a method to tell the
> > vforking task that it should skip try_to_freeze() in freezer_count(), and I
> > think there are some possible ways to do this.  The patch doesn't implement
> > any of them, because this is a different issue that can be deal with later.
>
>
> But approach i outlined above make sure both parent and child get
> frozen during the freeze_process. where as with PF_FREEZER_SKIP the
> child waits in the completion wait_queue in an uninterruptible state.
> I am not sure whether it really make any difference from any of the
> freezer users point of view. (suspend, hotplug, kprobes etc ).
>
>

Thinking about this  i guess we have a problem with the above approach
i outlined. if we have one task that is waiting on the event and more
than one that can generate the event then the above logic would not
work. Also with cases other than vfork; logic of tracking the waiting
task gets complex. I guess what we have right now is better.

-aneesh
