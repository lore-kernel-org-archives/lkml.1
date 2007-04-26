Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXDZCGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXDZCGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 22:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXDZCGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 22:06:10 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041AbXDZCGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 22:06:09 -0400
Date: Wed, 25 Apr 2007 19:04:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Pavel Machek <pavel@ucw.cz>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <1177551601.5025.131.camel@nigel.suspend2.net>
Message-ID: <alpine.LFD.0.98.0704251847310.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu>  <20070424202336.GC16503@elf.ucw.cz>
  <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> 
 <20070424212408.GD16457@elf.ucw.cz>  <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
  <20070425072350.GA6866@ucw.cz>  <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
  <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> 
 <20070425202741.GC17387@elf.ucw.cz>  <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
  <20070425214420.GG17387@elf.ucw.cz>  <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
  <1177540027.5025.87.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org>
 <1177551601.5025.131.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Nigel Cunningham wrote:
>
> That's where I think you're overstretching the argument. Like suspend 
>(to ram), we're concerned at the snapshot point with getting the hardware 
>in the same state at a later stage.

Really, no.

"suspend to ram" doesn't _have_ a "snapshot point".

I've tried to explain this multiple times, I don't know why it's not 
apparently sinking in. This is much more fundamental than the fact that 
you don't want to stop disks for snapshotting, although it really boils 
down to all the same issues: the operations are simply not at all the 
same!

I agree 100% that "snapshot to disk" is a "snapshot event". You have to 
create a single point in time when everything is stable. And I'd much 
rather call it "snapshot to disk" than "suspend to disk" to make it clear 
that it's something _totally_ different from "suspend".

Because the thing is, "suspend to ram" is *not* a snapshot event. At no 
point do you actually need to "snapshot" the system at all. You can just 
gradually shut more and more things down, and equally gradually bring them 
back up. There simply is *never* any "snapshot" time from a device 
standpoint, because you can just shut down devices in the right order AND 
YOU ARE DONE.

Really. 

[ Obviously s2ram does have one "magic moment", namely the time when the 
  CPU does the magic read from the northbridge that actually turns off 
  power for the CPU. But that's really a total non-event from a device 
  standpoint, so while it's undoubtedly a very interesting moment in the 
  suspend sequence, it's not really relevant in any way for device 
  drivers in general. Not at all like the "snapshot moment" that requires 
  the whole system to be totally quiescent in a "snapshot to disk"! ]

And the reason s2ram doesn't have a that "snapshot" moment is exactly that 
the RAM contents are just always there, so there's no need to have a 
"synchronization event" when ram and devices match. The RAM will *always* 
match whatever any particular device has done to it, and the proper way to 
handle things is to just do a simple per-device "save-and-suspend" event.

And yes, the _individual_ "save-and-suspend" events obviously needs to be 
"atomic", but it's purely about that particular individual device, so 
there's never any cross-device issues about that.

For example, if you're a USB hub controller, which is just about the most 
complex issue you can have, you obviously want to "save the state" with 
the controller in a STOPPED state, but that should just go without saying: 
if the controller isn't stopped, you simply *cannot* save the state, since 
the state is changing under you. 

The difference is, that the USB driver needs to just "stop, save, and 
suspend" as one simple operation for s2ram. In contrast, when doing 
snapshot to disk, it cannot do that, because while it does want to do the 
"stop" part, it needs to do so _separately_ from the "save" part because 
you need to stop everything else *too* before you "save" anythng at all.

		Linus
