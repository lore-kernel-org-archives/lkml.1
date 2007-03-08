Return-Path: <linux-kernel-owner+w=401wt.eu-S2992802AbXCHAVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992802AbXCHAVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992801AbXCHAVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:21:17 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40880 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992800AbXCHAVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:21:15 -0500
Date: Wed, 7 Mar 2007 16:21:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ash Milsted <thatistosayiseenem@gawab.com>
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       dmitry.torokhov@gmail.com
Subject: Re: 2.6.21-rc2 regression vs. 2.6.20: AT keyboard only works with
 pci=noacpi
In-Reply-To: <20070307234914.430caffa.thatistosayiseenem@gawab.com>
Message-ID: <Pine.LNX.4.64.0703071608270.5963@woody.linux-foundation.org>
References: <20070303151424.3b08c33e.thatistosayiseenem@gawab.com>
 <20070304142350.7c3c79af.thatistosayiseenem@gawab.com>
 <20070307120004.0bab0f76.thatistosayiseenem@gawab.com>
 <20070307212534.325f2f32.thatistosayiseenem@gawab.com>
 <20070307234914.430caffa.thatistosayiseenem@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Ash Milsted wrote:
> 
> Anyway, here's the bootlog for Dmitry from a boot with broken keyboard (2.6.21-rc3):

The non-working setup doesn't get any interrupts back, and thus doesn't 
see the ACK for the "\xd4\xed" command.

It really looks interrupt-related (especially considering that it goes 
away when you ask ACPI to not do certain things), but at the same time, 
the differences between -git6 and -git7 really don't seem to have *any* 
ACPI or PCI irq routing changes, so I think this really is related to the 
input-layer, and perhaps the real difference between ACPI irq routing and 
not is just the timing or IO acecss patterns that you get when you use the 
local apic vs the i8259 legacy irq controller.

For example, if there is a edge-triggered interrupt involved (and both 
keyboard *and* mouse are edge-triggered), the io-apic and the i8259 work 
differently: temporarily disabling the interrupt will reset the edge 
trigger logic on the i8259, but not on an IO-APIC.

So the lack of interrupts could be due to the input layer not clearing the 
interrupt source during setup, so some *old* interrupt just stays around, 
and because it's always set, on an IO-APIC it will never show as an edge 
at all - but on the i8259 the very action of registering the irq routine 
will create an edge.

There's some reason to believe that you may have a pending interrupt 
waiting: for the working case, you actually have:

> Mar  7 23:20:41 joker atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.

so there was certainly *something* unexpected there.

I'm not saying that's it, but it could explain why something that looks 
interrupt-related and that changes depending on whether you use ACPI to 
set up interrupts or not can have these kinds of reasons, that just depend 
on which interrupt controller the kernel happens to use, even though it's 
not "really" about lost interrupts at all, but just a driver that doesn't 
acknowledge a pending one.

Or something.

Doing the git bisect would really help.

		Linus
