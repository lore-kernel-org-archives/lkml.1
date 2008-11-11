Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbYKKVB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbYKKVB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYKKVBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:01:06 -0500
Received: from relais.videotron.ca ([24.201.245.36]:35320 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYKKVBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:01:03 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 11 Nov 2008 16:00:46 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       rmk+lkml@arm.linux.org.uk, dhowells@redhat.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] convert cnt32_to_63 to inline
In-reply-to: <20081111182759.GA8052@Krystal>
Message-id: <alpine.LFD.2.00.0811111543060.27509@xanadu.home>
References: <20081109064855.GA23782@Krystal>
 <alpine.LFD.2.00.0811090827160.13034@xanadu.home>
 <20081109162250.GB10181@Krystal>
 <alpine.LFD.2.00.0811092304300.13034@xanadu.home>
 <20081109204256.89ab7925.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0811101627510.13034@xanadu.home>
 <20081110135850.0d620f3c.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0811101811130.13034@xanadu.home>
 <20081110152221.64948d23.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0811101917450.13034@xanadu.home>
 <20081111182759.GA8052@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Mathieu Desnoyers wrote:

> * Nicolas Pitre (nico@cam.org) wrote:
> > That hasn't anything to do with "a macro is faster" at all.  It's all 
> > about the order used to evaluate provided arguments.  And the first one 
> > might be anything like a memory value, an IO operation, an expression, 
> > etc.  An inline function would work correctly with pointers only and 
> > therefore totally break apart on x86 for example.
> > 
> > 
> > Nicolas
> 
> Let's see what it gives once implemented. Only compile-tested. Assumes
> pxa, sa110 and mn10300 are all UP-only. Correct smp_rmb() are used for
> arm versatile.
> 
> Turn cnt32_to_63 into an inline function.
> Change all callers to new API.
> Document barrier usage.

Look, I'm not interested at all into this mess.

The _WHOLE_ point of the cnt32_to_63 macro was to abstract and 
encapsulate the subtlety of the algorithm.  It initially started as an 
open coded implementation in PXA's sched_clock().  Then I was asked to 
make it a macro that can be reused for other ARM platforms.  Then David 
wanted to reuse it on other platforms than ARM.

Now you are simply destroying all the value of having that macro in the 
first place.  The argument is that the macro could be misused because it 
has a static variable inside it, etc. etc.  The solution: spread the 
subtlety all around instead of keeping it into the macro and risk having 
it wrong or broken due to future changes surrounding it in the future.  
And it _will_ happen due to the increased exposure making the whole idea 
even more fragile compared to having it concentrated in only one spot.  
This is a total non sense and I can't believe you truly think your patch 
makes things better...

You're even disabling preemption where it is really unneeded making the 
whole thing about the double its initial cost.  Look at the generated 
assembly and count the cycles if you don't believe me!

No thank you.  If this trend continues I'm going to make it back private 
to ARM again so you could pessimize your own code as much as you want.

NACK.


Nicolas
