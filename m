Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbYESN6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbYESN6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbYESN6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:58:40 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64625 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750904AbYESN6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:58:39 -0400
Date: Mon, 19 May 2008 14:57:45 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] I/O APIC: Timer through 8259A revamp
In-Reply-To: <20080519123056.GB11318@elte.hu>
Message-ID: <Pine.LNX.4.55.0805191430390.19879@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805180237350.10067@cliff.in.clinika.pl>
 <20080519123056.GB11318@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Ingo Molnar wrote:

> >  It works for my system, but it definitely requires much, much more 
> > testing.  The patch depends on patch-2.6.26-rc1-20080505-timer_ack-1 
> > sent earlier.
> 
> agreed, scary patch - but nice cleanups!

 Well, I think somebody has to understand these pieces of code after all,
right? ;-)

> > Of course these "if (pin? != -1)" statements are useless (though 
> > harmless) now, but I think that change deserves a separate patch not 
> > to obfuscate changes to code which is obscure enough already.
> 
> please send another patch for that. If you can think of a good way of 

 That's syntactic sugar -- I am not sure whether it's worth doing it yet.  
I think let's test semantic changes first -- there may be more needed --
and once things have settled, fix up the syntax.  That's boring enough it
can be done in 30 seconds :-) and can certainly happen before you push
changes to Linus.

> splitting up this patch into smaller units feel free to do that too ... 

 Well, actually the NMI failure clean-up and the associated
"timer_through_8259" variable can certainly be separate.  They are a new
feature that builds on top of the clean-up and without them the fix is
consistent as well.  I'll do that and see whether there is anything else
that could be split off.

 Additionally I think the following enhancements should be done as the
next step:

1. Also mask LVT0/LVTPC entries as necessary when the NMI watchdog fails.

2. I think the 64-bit version wants the I/O APIC rerouting bits as well.
   I recall they were needed for the affinity setting to work for the 
   timer interrupt -- has anybody tested it with the 64-bit architecture?

3. Nobody will probably care, but since we still claim support for the
   i82489DX -- for this APIC the NMI return path for the watchdog should
   reassert the motherboard NMI source through the mask register at the 
   I/O port 0x80 like it is done for the other reasons.

 In case somebody reading this is about to head for the skip now -- I am
still interested in test equipment for the case #2.

> Dangerous changes are much better if they happen in small incremental 
> steps. (even if the sum of the changes is not any less dangerous - it 
> just makes any trouble easier to bisect and fix)

 Yes, of course.  But sometimes they are not written in the order that
would make the split obvious from the beginning. ;-)

  Maciej
