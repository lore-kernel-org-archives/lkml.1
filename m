Return-Path: <linux-kernel-owner+w=401wt.eu-S1031307AbXDZQL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031307AbXDZQL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031311AbXDZQL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:11:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031307AbXDZQL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:11:26 -0400
Date: Thu, 26 Apr 2007 09:10:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <4630B183.1000905@rtr.ca>
Message-ID: <alpine.LFD.0.98.0704260903570.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
 <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
 <20070425235718.66b71f01@the-village.bc.nu>
 <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org>
 <20070426012454.3495b5d8@the-village.bc.nu>
 <alpine.LFD.0.98.0704251808150.9964@woody.linux-foundation.org>
 <4630B183.1000905@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Mark Lord wrote:
> Linus Torvalds wrote:
> > 
> > See? Two *totally* different cases. They have *nothing* in common. Not the
> > call sequence, not the logic, not *anything*.
> 
> Except that both methods cannot rely upon hot-pluggable devices
> still being present on resume/restore.  It is exceptionally common
> to unplug all USB/firewire cables, mouse, keyboard, docking cables etc..
> after a machine is in S2R state.

Right, and that has nothing to do with suspend/resume. You'd better be 
able to handle unexpected hotplugs _regardless_.

For example, it's quite common that people just "remove" the 
pcmcia/cardbus card while the driver is active. And in fact, when that 
happens, it's also quite common that the hardware raises the irq for that 
(active) driver (in fact, it's more than common: since the "card removal" 
interrupt for the Cardbus controller is generally always the same as the 
"card interrupt" interrupt for the low-level card driver, you can pretty 
much *guarantee* that you get that interrupt).

So the end result is that the interrupt handler and all normal IO routines 
for a hotpluggable piece of hardware baically _have_ to be able to 
gracefully handle the "oops, the hw simply isn't there any more" case!

The resume code isn't any different at all. It should run perfectly 
normally, but for hotpluggable devices, it has to follow all the same 
rules: handle the "oops, the hw is gone" case gracefully.  No different, 
and it's totally unrelated to suspend/resume: it's a *generic* issue.

In fact, suspend/resume is better off than a lot of the other code is, 
simply because it's easier to test that case and know you hit that 
particular sequence! It's much harder to verify that the "send packet" 
case is safe, because how are you going to know to remove the card at the 
right point to trigger it?

			Linus
