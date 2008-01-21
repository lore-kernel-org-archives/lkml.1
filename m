Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYAUTwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYAUTwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 14:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYAUTwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 14:52:31 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:27881 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750710AbYAUTwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 14:52:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wP/eMn+Ubjd+y+2VNTmbfG2bYsYqUhwmFTgXewKURxpgVJGmARzaF1QciuYs/SoYKoNmtLmZftILS6e/5SPh1Kg9JPTqxz0oVg/ZwkKxb8vv7hrlWNcIg8QEdUVsHtDb98+Gn76pdbiz0/bwQdz+JhGecAvFvWIEigAdfZdN4uk=  ;
X-YMail-OSG: uSJrvqYVM1kuOJlfKDOVxtGd3IhFaYyMrc84rOUu4HINQuiMyTffCvPDYpXrsrI0J0J.nBvs4w--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch/rfc 2.6.24-rc8-git] genirq: partial lockdep fixes
Date: Mon, 21 Jan 2008 10:22:36 -0800
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, mingo@redhat.com
References: <200801181429.00485.david-b@pacbell.net> <1200904299.6341.2.camel@lappy>
In-Reply-To: <1200904299.6341.2.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801211022.36312.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008, Peter Zijlstra wrote:
> 
> On Fri, 2008-01-18 at 14:29 -0800, David Brownell wrote:
> > EXPERIMENTAL and incomplete patch to make LOCKDEP behave better in
> > the face of irq chaining, by annotating irqs with a lock_class which
> > can reflect that hierarchy.
> 
> This is too short for me (who has no clue about genirq) to understand
> what this patch does or why it does it.

I thought the example was complete ...


> > This version of the patch is incomplete in at least two respects:
> > 
> >  - There's no spin_lock_irq_nested() primitive, so that locking calls
> >    on irq probing (yeech!) paths must ignore the annotations.
> > 
> > 	==> LOCKDEP feature is evidently missing:
> > 		spin_lock_irq_nested(lock_ptr, lock_class)
> 
> This rant is more lines than adding the API :-/ the reason for it not
> being there is simple, it wasn't needed up until now.

I suspected that was the case, but for all I knew there was some
religious objection.  But in any case, there'd be little point in
fixing that if the more significant issue can't get resolved.


> >  - We'd really need new API to declare the parent/child relationships
> >    between IRQs to handle this properly.  Lacking such calls, this just
> >    piggybacks set_irq_chained_handler() to modify the parent's class.
> >    That's a problem, since only the lowest level of any lock tree gets
> >    accurate nesting annotations.  On the plus side: no platform changes
> >    are needed this way, so testing is easy.
> > 
> > 	==> GENIRQ programming interface evidently missing
> > 		set_irq_parent(parent_irqnum, child_irqnum) (?)

... that one's the real dirty bit of this example patch; having
multiple levels of IRQ chaining is quite realistic.

 
> > Example:  when a GPIO controller's set_wake() handler needs to call its
> > parent's set_irq_wake() method to ensure all appropriate signal paths are
> > set up, that currently generates a bogus lockdep warning.  This patch
> > removes those bogus warnings ... when there's only one level of parent.
> 
> OK.... still need a bit more detail here.

What, like an example of such a bogus warning?  See below.
First set_irq_wake() call owns child's lock; bogus warning
issued when getting parent's lock.

This is on AT91, but ISTR seeing similar warnings (different
drivers of course) on OMAP too.

- Dave


# echo standby > state
Syncing filesystems ... done.
PM: Preparing system for standby sleep
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering standby sleep
Suspending console(s)

=============================================
[ INFO: possible recursive locking detected ]
2.6.24-rc8 #57
---------------------------------------------
sh/474 is trying to acquire lock:
 (&irq_desc_lock_class){++..}, at: [<c005ca90>] set_irq_wake+0x34/0xfc

but task is already holding lock:
 (&irq_desc_lock_class){++..}, at: [<c005ca90>] set_irq_wake+0x34/0xfc

other info that might help us debug this:
4 locks held by sh/474:
 #0:  (&buffer->mutex){--..}, at: [<c00b9044>] sysfs_write_file+0x30/0x148
 #1:  (pm_mutex){--..}, at: [<c005b788>] enter_state+0x13c/0x19c
 #2:  (dpm_mtx){--..}, at: [<c010beac>] device_suspend+0x28/0x250
 #3:  (&irq_desc_lock_class){++..}, at: [<c005ca90>] set_irq_wake+0x34/0xfc

stack backtrace:
[<c0022034>] (dump_stack+0x0/0x14) from [<c0056454>] (__lock_acquire+0x94c/0xd80)
[<c0055b08>] (__lock_acquire+0x0/0xd80) from [<c0056d64>] (lock_acquire+0x70/0x88)
[<c0056cf4>] (lock_acquire+0x0/0x88) from [<c01bb51c>] (_spin_lock_irqsave+0x48/0x5c)
 r6:20000093 r5:c005ca90 r4:c02446cc
[<c01bb4d4>] (_spin_lock_irqsave+0x0/0x5c) from [<c005ca90>] (set_irq_wake+0x34/0xfc)
 r6:00000001 r5:00000005 r4:c024469c
[<c005ca5c>] (set_irq_wake+0x0/0xfc) from [<c0026a9c>] (gpio_irq_set_wake+0x6c/0x78)
[<c0026a30>] (gpio_irq_set_wake+0x0/0x78) from [<c005cb24>] (set_irq_wake+0xc8/0xfc)
[<c005ca5c>] (set_irq_wake+0x0/0xfc) from [<c014534c>] (at91_mci_suspend+0x3c/0x58)
[<c0145310>] (at91_mci_suspend+0x0/0x58) from [<c0109ae8>] (platform_drv_suspend+0x20/0x24)
 r5:c023ed64 r4:c024e0c0
[<c0109ac8>] (platform_drv_suspend+0x0/0x24) from [<c0109b3c>] (platform_suspend+0x2c/0x38)
[<c0109b10>] (platform_suspend+0x0/0x38) from [<c010bfcc>] (device_suspend+0x148/0x250)
[<c010be84>] (device_suspend+0x0/0x250) from [<c005b574>] (suspend_devices_and_enter+0x4c/0x124)
 r8:00000008 r7:00000001 r6:00000001 r5:c047ca14 r4:00000000
[<c005b528>] (suspend_devices_and_enter+0x0/0x124) from [<c005b744>] (enter_state+0xf8/0x19c)
 r6:c020c33b r5:c047cc58 r4:00001602
[<c005b64c>] (enter_state+0x0/0x19c) from [<c005b888>] (state_store+0xa0/0xbc)
 r7:c1d4e000 r6:00000001 r5:00000007 r4:c020c33b
[<c005b7e8>] (state_store+0x0/0xbc) from [<c00b8d20>] (subsys_attr_store+0x34/0x38)
 r8:c024a260 r7:c0244338 r6:00000008 r5:c1d02b6c r4:c1c0b630
[<c00b8cec>] (subsys_attr_store+0x0/0x38) from [<c00b9124>] (sysfs_write_file+0x110/0x148)
[<c00b9014>] (sysfs_write_file+0x0/0x148) from [<c007ea20>] (vfs_write+0xb8/0xe0)
[<c007e968>] (vfs_write+0x0/0xe0) from [<c007ef54>] (sys_write+0x4c/0x7c)
 r6:c1d11540 r5:0
 


