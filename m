Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbXDAV4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbXDAV4Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 17:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbXDAV4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 17:56:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50695 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbXDAV4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 17:56:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc5-mm3
Date: Sun, 1 Apr 2007 23:59:33 +0200
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20070330010559.2a232d9a.akpm@linux-foundation.org> <20070401120305.932a493b.akpm@linux-foundation.org> <200704012239.01964.rjw@sisk.pl>
In-Reply-To: <200704012239.01964.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704012359.34594.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 1 April 2007 22:39, Rafael J. Wysocki wrote:
> On Sunday, 1 April 2007 21:03, Andrew Morton wrote:
> > On Sun, 01 Apr 2007 18:00:12 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > 
> > > Andrew Morton napisał(a):
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm3/
> > > > 
> > > 
> > > BUG: at /mnt/md0/devel/linux-mm/arch/i386/kernel/smp.c:571 native_smp_call_function_mask()
> > >  [<c01051a1>] dump_trace+0x63/0x1eb
> > >  [<c0105343>] show_trace_log_lvl+0x1a/0x30
> > >  [<c0105f8a>] show_trace+0x12/0x14
> > >  [<c0106027>] dump_stack+0x16/0x18
> > >  [<c0113a92>] native_smp_call_function_mask+0x57/0x14b
> > >  [<c0113c9b>] smp_call_function+0x1e/0x22
> > >  [<c0129a60>] on_each_cpu+0x2a/0x73
> > >  [<c013a12d>] clock_was_set+0x1b/0x1d
> > >  [<c013b99d>] timekeeping_resume+0xb5/0xbb
> > >  [<c027af35>] __sysdev_resume+0x17/0x5d
> > >  [<c027b2aa>] sysdev_resume+0x19/0x4b
> > >  [<c027fd12>] device_power_up+0xb/0x12
> > >  [<c014f30b>] swsusp_suspend+0x55/0x63
> > >  [<c014fad0>] pm_suspend_disk+0x163/0x28f
> > >  [<c014e7be>] enter_state+0x54/0x1d5
> > >  [<c014e9c5>] state_store+0x86/0x9c
> > >  [<c01bfe47>] subsys_attr_store+0x23/0x2b
> > >  [<c01bff89>] sysfs_write_file+0xc1/0xe9
> > >  [<c0186485>] vfs_write+0xd1/0x15a
> > >  [<c0186ab7>] sys_write+0x3d/0x72
> > >  [<c010424c>] syscall_call+0x7/0xb
> > >  [<b7f9b410>] 0xb7f9b410
> > 
> > We're calling smp_call_function() with local interrupts disabled, which is
> > deadlockable.
> > 
> > This, I expect, is because swsusp_suspend() optimistically tries to run
> > everything with local interrupts disabled.
> 
> Well, not everything, but device_power_down()/device_power_up() which only
> handle sysdevs.
> 
> > I don't know why this has suddenly started happening -
> > timekeeping_resume()->clock_was_set()->on_each_cpu() has been there for a
> > while.  Doesn't mainline do the same thing?
> 
> Yes, and it has always done it.  It even is documented in 
> Documentation/power/devices.txt:System Devices . ;-)

Some clarification is necessary, I suppose:

I meant that the mainline had always called device_power_up() with IRQs
disabled, which was documented.

_OTOH_ the clock_was_set() was added to timekeeping_resume() after
2.6.20 and it shouldn't call on_each_cpu(), because it is run on one CPU.

Greetings,
Rafael (who's apparently too tired to read email now)
