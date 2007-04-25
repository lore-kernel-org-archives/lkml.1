Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbXDYVX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbXDYVX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbXDYVX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:23:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44729 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbXDYVX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:23:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Wed, 25 Apr 2007 23:07:25 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <20070418220228.GA14536@elte.hu> <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704252307.27148.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 25 April 2007 22:44, Linus Torvalds wrote:
> 
> On Wed, 25 Apr 2007, Pavel Machek wrote:
> > 
> > Can I get you on IRC somewhere? No, I do not think I'm a moron, and
> > yes, I need to suspend^Wsnapshot the devices before, so I have that in
> > the snapshot. Of course, I'll need to resume^Wrestore the devices
> > before writing snapshot. That's okay, it does not take long.
> 
> You do NOT need to "suspend" the devices, and that's the whole point.
> 
> You may want to save the device info somewhere, BUT THAT IS SOMETHING 
> TOTALLY DIFFERENT!
> 
> This is *exactly* the confusion I'm talking about. The STD and STR 
> codepaths try to use the same function for two TOTALLY DIFFERENT things.
> 
> STR actually wants to "suspend".
> 
> STD actually wants to "atomic snapshot", and it must not allow allocations 
> or anything like that, because the whole snapshot image should be done 
> atomically as one event. But it should *not* suspend, because that device 
> may actually be needed afterwards. 
> 
> So not the same thing at all.
> 
> So here's what "suspend()" wants:
>  - suspend() - preparatory work, can error our, can delay, can park the 
>    disk, etc etc.
>  - suspend_late() - called late, with interrupts disabled, should actually
>    suspend if the early suspend didn't do it already
> 
> And here is what "snapshot()" wants:
>  - prepare_to_snapshot() (for memory allocation)
>  - snapshot() - called late, with interrupts disabled, save state.
> 
> and there is absolutely _zero_ overlap between them. There just isn't 
> anything in common. Yes, both are two-phase (for the simple reason that 
> both want an "atomic" part), but there's really no real overlap.
> 
> Just trying to *make* them be the same operations is just going to 
> introduce flags that then cause them to be totally different *and* 
> confusing and generate bugs. It also means that people do one of them, and 
> "it works" for that case, and the other case is totally broken, but it's 
> not obvious, because doing one means that the system _thinks_ that you did 
> both!
> 
> In the very unlikely case that some driver actually *wants* to use the 
> same function for snapshots and suspending, that driver could just go 
> ahead and _use_ the same function pointer. But now, as things are set up, 
> we force a total confusion on drivers by calling them through the same 
> interface for two totally different things.

I agree, except there are surprisingly many drivers like that.

You're right, we should be doing all of it in a different way, but this means
a lot of changes and we can't do them overnight.

As I wrote in the reply to Pavel, I think we can introduce .freeze(), .thaw()
(and .prethaw() for that matter) callbacks for hibernation and make drivers
use them, but that will be a long series of patches.  Still, I think it's
doable.

Greetings,
Rafael

