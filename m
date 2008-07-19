Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYGSM44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYGSM44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYGSM4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:56:48 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53711 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbYGSM4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:56:47 -0400
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068
	trace_hardirqs_on_caller
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kernel-testers@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org
In-Reply-To: <19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com>
References: <20080718195352.e562a00f.sfr@canb.auug.org.au>
	 <200807190928.33978.m.kozlowski@tuxland.pl>
	 <19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com>
Date: Sat, 19 Jul 2008 15:56:29 +0300
Message-Id: <1216472189.6762.166.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-19 at 11:55 +0200, Vegard Nossum wrote:
> On Sat, Jul 19, 2008 at 9:28 AM, Mariusz Kozlowski
> <m.kozlowski@tuxland.pl> wrote:
> > Hello,
> >
> >        I get this on my x86_32 laptop.
> >
> > ------------[ cut here ]------------
> > WARNING: at /home/mako/linux/lkt/sources/linux-next/kernel/lockdep.c:2068 trace_hardirqs_on_caller+0xdc/0x128()
> > Modules linked in:
> > Pid: 0, comm: swapper Not tainted 2.6.26-next-20080718 #1
> >  [<c011d5ca>] warn_on_slowpath+0x4e/0x68
> >  [<c0132600>] ? init_srcu_struct+0x17/0x3b
> >  [<c011de86>] ? release_console_sem+0x1c2/0x1e8
> >  [<c0139818>] ? trace_hardirqs_off+0xb/0xd
> >  [<c02b95cb>] ? _spin_unlock_irqrestore+0x39/0x60
> >  [<c011de9a>] ? release_console_sem+0x1d6/0x1e8
> >  [<c01326be>] ? up+0x23/0x30
> >  [<c011de86>] ? release_console_sem+0x1c2/0x1e8
> >  [<c01326be>] ? up+0x23/0x30
> >  [<c011de86>] ? release_console_sem+0x1c2/0x1e8
> >  [<c013b83b>] ? __lock_acquire+0x365/0x1151
> >  [<c013b048>] trace_hardirqs_on_caller+0xdc/0x128
> >  [<c013b09f>] trace_hardirqs_on+0xb/0xd
> >  [<c016a40b>] __slab_alloc+0x329/0x61e
> >  [<c011665f>] ? kmemcheck_memset+0x24/0xe5
> >  [<c016a7a0>] kmem_cache_alloc+0xa0/0xb6
> >  [<c01dedb4>] ? kobject_init+0x3b/0xdd
> >  [<c01dedb4>] ? kobject_init+0x3b/0xdd
> >  [<c01dedb4>] kobject_init+0x3b/0xdd
> >  [<c025997f>] firmware_map_add_entry+0x2a/0x4b
> >  [<c03b8e0c>] firmware_map_add_early+0x32/0x56
> >  [<c03a3faf>] e820_reserve_resources+0x10a/0x14e
> >  [<c03a1965>] setup_arch+0x375/0x540
> >  [<c0136e81>] ? clockevents_register_notifier+0x28/0x2d
> >  [<c011e477>] ? printk+0x1b/0x1d
> >  [<c03a09df>] start_kernel+0x67/0x278
> >  [<c03a0304>] i386_start_kernel+0x64/0x70
> >  =======================
> > ---[ end trace 4eaa2a86a8e2da22 ]---
> >
> 
> What I don't get here is how SLUB can be used this early in the boot
> process. Notice that this is still miles away from the
> 
>     SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> 
> line, which comes much later. And that kobject_init() _is_ calling
> kzalloc() via verify_dynamic_kobject_allocation(). Isn't this an
> error?
> 
> (Unfortunately, my "git log" doesn't turn up any recent changes for
> any of the affected code paths here.)

Indeed, looks like a bug in kobject_init(). You need to wait for
kmem_cache_init() to be run before using kzalloc().

		Pekka

