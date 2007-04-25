Return-Path: <linux-kernel-owner+w=401wt.eu-S2993173AbXDYUpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993173AbXDYUpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030977AbXDYUpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:45:22 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030930AbXDYUpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:45:21 -0400
Date: Wed, 25 Apr 2007 13:44:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070425202741.GC17387@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
References: <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net>
 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Apr 2007, Pavel Machek wrote:
> 
> Can I get you on IRC somewhere? No, I do not think I'm a moron, and
> yes, I need to suspend^Wsnapshot the devices before, so I have that in
> the snapshot. Of course, I'll need to resume^Wrestore the devices
> before writing snapshot. That's okay, it does not take long.

You do NOT need to "suspend" the devices, and that's the whole point.

You may want to save the device info somewhere, BUT THAT IS SOMETHING 
TOTALLY DIFFERENT!

This is *exactly* the confusion I'm talking about. The STD and STR 
codepaths try to use the same function for two TOTALLY DIFFERENT things.

STR actually wants to "suspend".

STD actually wants to "atomic snapshot", and it must not allow allocations 
or anything like that, because the whole snapshot image should be done 
atomically as one event. But it should *not* suspend, because that device 
may actually be needed afterwards. 

So not the same thing at all.

So here's what "suspend()" wants:
 - suspend() - preparatory work, can error our, can delay, can park the 
   disk, etc etc.
 - suspend_late() - called late, with interrupts disabled, should actually
   suspend if the early suspend didn't do it already

And here is what "snapshot()" wants:
 - prepare_to_snapshot() (for memory allocation)
 - snapshot() - called late, with interrupts disabled, save state.

and there is absolutely _zero_ overlap between them. There just isn't 
anything in common. Yes, both are two-phase (for the simple reason that 
both want an "atomic" part), but there's really no real overlap.

Just trying to *make* them be the same operations is just going to 
introduce flags that then cause them to be totally different *and* 
confusing and generate bugs. It also means that people do one of them, and 
"it works" for that case, and the other case is totally broken, but it's 
not obvious, because doing one means that the system _thinks_ that you did 
both!

In the very unlikely case that some driver actually *wants* to use the 
same function for snapshots and suspending, that driver could just go 
ahead and _use_ the same function pointer. But now, as things are set up, 
we force a total confusion on drivers by calling them through the same 
interface for two totally different things.

			Linus
