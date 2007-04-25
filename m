Return-Path: <linux-kernel-owner+w=401wt.eu-S2993048AbXDYUJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993048AbXDYUJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993050AbXDYUJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:09:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993048AbXDYUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:09:01 -0400
Date: Wed, 25 Apr 2007 13:08:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kenneth Crudup <kenny@panix.com>
cc: Pavel Machek <pavel@ucw.cz>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
Message-ID: <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
References: <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu>
 <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
 <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu>
 <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz>
 <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Apr 2007, Kenneth Crudup wrote:
> 
> Any working suspend-to-disk method takes care of that for me.  (I'm
> really not sure why Linus hates S2D so much, though. Back in the day
> there was a lot more BIOS support, but that's been years now.)

The really sad part is that APM actually did this better.. 

It's not often you can say that, and APM didn't do diddly-squat for 
run-time power management, but when it comes to suspend-to-disk, APM 
actually did ok.

I think you could do STD right too, but:

 - if you think it's about suspending devices, you are immediately 
   disqualified. If you call the device driver "suspend" or "resume" 
   functions, you are doing something wrong.

 - "suspend" is: snapshot memory, and anything you do *after* the snapshot 
   is totally irrelevant. You MUST NOT suspend devices before, since 
   devices are what that snapshot should be written out to, and you MUST 
   NOT suspend devices afterwards either, because that shows that you are 
   a moron who didn't understand the "machine will be turned off" part.

 - "resume" is basically: get image into memory, turn *off* every device, 
   put image into its proper location, and call the "startup" function. If 
   you call a device "resume()" function, you again show that you are a 
   moron, because you're not resuming anything at all, you're resetting 
   the device from scratch. You _reinitialize_ the device. You don't 
   resume it, and somebody may hve (and indeed, *WILL HAVE* used the 
   device in between). There should be absolutely zero shared code, and 
   the *last* thing you should do is to call the device with the same 
   function, and give it a flag to tell it to do one thing or the other.

The important thing to take away from this is that it has nothing to do 
with "suspend" or "resume" at any level what-so-ever. Not at a device 
level, not at a system level, and not even when it comes to hardware. But 
for completely idiotic and wrong reasons, it is currently intimately 
involved in suspend/resume, and calls the same device management functions 
as a suspend/resume thing does, and shares a lot of the code.

And THAT is why I hate the kernel STD. It is fundamentally confused. In 
ways that APM was not, I'd like to point out.

I'd love to get it fixed. But the first fix is to not call it "suspend", 
because language *does* matter, and using that term is what I'm convinced 
has confused so many people.

If it had been called "snapshot + restore", I suspect a lot of people 
wouldn't have been so confused about what it does and how it needs to do 
it, and wouldn't have tried to shoehorn it into the same corner of the 
kernel as "suspend-to-ram" (where you really *can* do things like 
"suspend" devices, and while they might certainly lose power in between, 
they also really might not, and they certainly won't be *doing* things in 
between).

			Linus
