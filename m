Return-Path: <linux-kernel-owner+w=401wt.eu-S2993092AbXDYU17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993092AbXDYU17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993095AbXDYU17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:27:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54197 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993092AbXDYU16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:27:58 -0400
Date: Wed, 25 Apr 2007 22:27:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425202741.GC17387@elf.ucw.cz>
References: <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain> <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

_Can we get a suspend-to-RAM maintainer_?

Noone cares about s2ram these days. I do care a little, seife
maintains whitelist, you care for mac mini, Len/Andrew/Intel acpi team
helps sometimes... But I feel we should have someone listed in the
MAINTAINERS file. Patrick was close, but... 

> > Any working suspend-to-disk method takes care of that for me.  (I'm
> > really not sure why Linus hates S2D so much, though. Back in the day
> > there was a lot more BIOS support, but that's been years now.)
> 
> The really sad part is that APM actually did this better.. 

I agree that APM STR worked better than current ACPI STR. I think
swsusp already works better than APM STD, but...

> I think you could do STD right too, but:
> 
>  - if you think it's about suspending devices, you are immediately 
>    disqualified. If you call the device driver "suspend" or "resume" 
>    functions, you are doing something wrong.
> 
>  - "suspend" is: snapshot memory, and anything you do *after* the snapshot 
>    is totally irrelevant. You MUST NOT suspend devices before, since 
>    devices are what that snapshot should be written out to, and you MUST 
>    NOT suspend devices afterwards either, because that shows that you are 
>    a moron who didn't understand the "machine will be turned off" part.

Can I get you on IRC somewhere? No, I do not think I'm a moron, and
yes, I need to suspend^Wsnapshot the devices before, so I have that in
the snapshot. Of course, I'll need to resume^Wrestore the devices
before writing snapshot. That's okay, it does not take long.

>  - "resume" is basically: get image into memory, turn *off* every device, 

Exactly. I need to turn devices *off* before restoring image, and I
need them *off* before saving image, too -- DMAs are dangerous.

I currently do that using "suspend" and "resume" hooks, before they
turn DMAs / IRQs off as a sideeffect.

>    put image into its proper location, and call the "startup" function. If 
>    you call a device "resume()" function, you again show that you are a 
>    moron, because you're not resuming anything at all, you're resetting 
>    the device from scratch. You _reinitialize_ the device. You don't 
>    resume it, and somebody may hve (and indeed, *WILL HAVE* used the 
>    device in between). There should be absolutely zero shared code, and 
>    the *last* thing you should do is to call the device with the same 
>    function, and give it a flag to tell it to do one thing or the other.

Well, "startup" function or how you want to call it has to deal with
device not initialized (s2disk driver is module, s2ram with hw powered
off) and has to deal with device initialized (s2disk driver in kernel
case, s2ram device was powered). 

I fear that "resume"/"restore" functions need to be pretty robust,
anyway... 

> And THAT is why I hate the kernel STD. It is fundamentally confused. In 
> ways that APM was not, I'd like to point out.

Ok, yes, it is confused/confusing.

> I'd love to get it fixed. But the first fix is to not call it "suspend", 
> because language *does* matter, and using that term is what I'm convinced 
> has confused so many people.

> If it had been called "snapshot + restore", I suspect a lot of
> people 

snapshot/restore sounds okay to me.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
