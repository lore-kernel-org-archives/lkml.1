Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZEVWVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZEVWVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 18:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbZEVWVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 18:21:10 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:41175 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbZEVWVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 18:21:09 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Fri, 22 May 2009 17:21:05 -0500
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <20090522183622.GA8385@elte.hu> <4A16F62B.40207@zytor.com>
In-Reply-To: <4A16F62B.40207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221721.08495.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri May 22 2009, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> > * Michael S. Zick <lkml@morethan.org> wrote:
> > 
> >> Found in the bit-rot for 32-bit, x86, Uni-processor builds:
> >>
> >> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
> >> index f6aa18e..3c790ef 100644
> >> --- a/arch/x86/include/asm/alternative.h
> >> +++ b/arch/x86/include/asm/alternative.h
> >> @@ -35,7 +35,7 @@
> >>                 "661:\n\tlock; "
> >>
> >>  #else /* ! CONFIG_SMP */
> >> -#define LOCK_PREFIX ""
> >> +#define LOCK_PREFIX "\n\tlock; "
> >>  #endif
> > 
> > What is your motivation for this change? At first sight this makes 
> > the UP kernel a bit larger and a bit smaller. Are you fixing some 
> > real regression/bug here?
> > 
> 
> That looks very odd indeed.  The whole point of the LOCK_PREFIX macro is
> to squelch it on UP (locks that should not be squelched on UP should not
> be annotated LOCK_PREFIX.)
> 

I can only act as a messanger to report the behavior I observe;
But let me see if I can't do a better job of that limited role.

hpa makes the best point of all in the responses here...

What I see (erratic operation, erratic lock-ups of the machine, 
and the previously posted lockdep dump) -

This may well be misplaced usage of the LOCK_PREFIX macro;
I have already agreed to keep my eyes open for this more 
specific problem.

A secondary possibility, hinted at in the context of other replies;
The usage of the LOCK_PREFIX may not apply equally to all processors
for which this code gets included.
It is possible that I am building for one of the exceptions.
That tells us nothing, since the CPU technical details are under NDA.
All that can be done in this case is report behavior differences from
the closest publicly described processor (Pentium-M).

For that purpose, I suggest that a single processor box, with other 
hardware that makes memory access independent of the processor's 
control using a processor older than P-4 is a potential test bed.
"Other hardware that makes memory access..." I previously termed:
"buss master DMA" - which is overly specific.  It misleads people
into thinking I am seeing hardware control issues rather than
non-exclusive memory access.

My earlier comments about taking an interrupt between the memory read
and the memory write operations is from a different manual than the
one posted.  A manual that only applies to processors older than 
the ones supported by the Linux kernel.  
Sorry, my bad, grabbed the wrong book, posted the correct link (SH).

Until one or more specific usages of the LOCK_PREFIX macro can be 
demonstrated to be incorrect (at least for some of the processors 
using this code) - -

Then making the posted change is a single point change that gives a 
pair of builds (one with, one without) to compare the behavior of on 
the test bed.

It is *not* the preferred change for a general release kernel, the
preferred change would be one that makes a specific rather than
general correction.  
Perhaps only for some functions, perhaps only for some of the 
processors that currently select this code.

The observation that executing an unnecessary 'lock' opcode in some
cases slows down the machine is not felt by myself to be significant 
to duplicating my observations.  Note: I have been wrong before.

This is as informative as I can make the message.

PS: *not* a single machine failure, tested on five machines, owned
by four different people, two brands, with different use histories.

Mike
> 	-hpa
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


