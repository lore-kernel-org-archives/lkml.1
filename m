Return-Path: <linux-kernel-owner+w=401wt.eu-S965717AbXDBTQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965717AbXDBTQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 15:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965719AbXDBTQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 15:16:25 -0400
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:30732 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965717AbXDBTQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 15:16:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=m4O2shmyilLhlCO/RwYK5e8jdB+m/N5yMnde+Npb2NYWTalXLqz06peBXUJoclYgn2JSCD4L7LiSw/k5OeAILVGLDCj4qRQF7JiLTCjBKwM6uW59r2GGHEcWRwMcJ7ABCqRG3gyxz8Lm4WqiB4Mc+33elNVUP6YZA5DwYC16ddU=  ;
X-YMail-OSG: Jdwq9vcVM1kYvSroFxRKVudvvu4yL_yc9Eq9XgMLCKYT_iUG
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH v2] Add suspend/resume for HPET
Date: Mon, 2 Apr 2007 12:16:21 -0700
User-Agent: KMail/1.7.1
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
References: <Pine.LNX.4.44L0.0704021000450.1743-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0704021000450.1743-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704021216.22280.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 7:16 am, Alan Stern wrote:
> On Saturday March 31, 2007, David Brownell wrote:
> 
> > Change how the PM list is constructed, so that devices are added right
> > after their parents (when they have one) rather than at the end of the
> > list.  ...
> > 
> > This patch has a potential downside for devices that have multiple
> > power dependencies and which "just happened to work" before.
> 
> Dave:
> 
> Would you mind retracting this patch?  It will interfere with some work
> I've been doing in USB, work that relies on exactly the sort of multiple 
> power dependency you mention.

It's out there for discussion right now more than merging.

What the driver model does now is problematic.  Even if the clockevent
stuff gets different fixes, those driver model issues still exist:  the
existence of dependencies that are not part of the device tree.


> The problem is this: When a low- or full-speed USB device is resumed 
> following a power loss (this is part of the "persistent USB" patch), it's 

Yeah, that "persistent USB" stuff that I don't like at all!   Power off
is power off, and should be treated just like any other case of the USB
circuit being broken.  (Offtopic here, of course.)


> necessary for the corresponding EHCI root hub to be resumed first so that 
> the port's OWNER bit can be set properly.
> 
> It works fine as long as devices are resumed in order of registration,
> because a low- or full-speed USB device can't be registered before the
> high-speed root hub.  (If it was, it would be disconnected when the
> high-speed root hub initialized and took control of the port.)  So this
> isn't a "just happened to work" situation; it really is a critical
> ordering dependency.

No, it's a "just happened to work" because the only ordering promise
that was explicitly made is that the parent/child relationships will
be obeyed.  Any additional ordering dependency is out-of-scope of the
current driver model -- and that's a proble that eventually needs to
be fixed.

This is the kind of thing that the pm_parent relationship was (AFAICT)
originally supposed to handle.  Of course, it doesn't/can't, given the
current implementation ... that relationship is never used.


> The clock source problem can be solved in other ways.  For instance, right 
> now things are set up so that clock sources are registered at various 
> random times and the clockevents code adapts to use the best available 
> device, right?.

Clocksource ~= counter, clockevent ~= timer irq ... you're mixing the
two, they're different!  Both can be registered at various times; and
the best available instance of both is used.  (Unfortunately "best" is
not a static policy on x86 hardware.)


> So simply arrange for a clock source to "depart" as it is  
> suspended; then clockevents can fall back to using other lower-precision 
> sources.  As long as devices suspend in reverse order of discovery, the 
> system should always function properly.

It's not that simple though, especially with HPET.  The BIOS may expect
the PIT to work, but Linux currently (and problematically!) uses HPET in
"legacy replacement mode".  And ISTR the problems are coming up when the
system is already in a low-functionality state:  IRQs off everywhere,
even timer ticks have stopped.

- Dave
