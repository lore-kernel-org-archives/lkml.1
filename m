Return-Path: <linux-kernel-owner+w=401wt.eu-S1764278AbYDPOA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764278AbYDPOA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYDPOAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:00:14 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:34949 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087AbYDPOAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:00:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EALejBUhMROPA/2dsb2JhbACBYK0v
Date: Wed, 16 Apr 2008 10:00:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080416140009.GA13968@Krystal>
References: <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins> <20080415131744.GA5248@elte.hu> <20080415134705.GB22351@Krystal> <20080415164814.GA15842@elte.hu> <20080415213832.GC7873@Krystal> <20080416131751.GI6304@elte.hu> <20080416064630.22428aea@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080416064630.22428aea@laptopd505.fenrus.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:54:44 up 47 days, 10:05,  4 users,  load average: 0.09, 0.17,
	0.19
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> 
> > >     4631:       b0 00                   mov    $0x0,%al
> > >     4633:       84 c0                   test   %al,%al
> > >     4635:       0f 85 c6 00 00 00       jne    4701
> 
> the use of partial registers here is unfortunate and probably quite expensive ;(
> 
> 

Yes, but it saves instruction cache. That's a tradeoff.

> > > If we want to support NMI context and have the ability to
> > > instrument preemptable code without too much headache, we must
> > > insure that every modification will leave the code in a "correct"
> > > state and that we do not grow the size of any reachable
> > > instruction.  Also, we must insure gcc did not put code between
> > > these instructions. Modifying non-relocatable instructions would
> > > also be a pain, since we would have to deal with instruction
> > > pointer relocation in the breakpoint code when the code
> > > modification is being done.
> 
> you also need to make sure no cpu is executing that code ever.. 
> but you already deal with that right?
> 

By "insure that every modification will leave the code in a "correct"
state", I mean that at any given time before, during or after the code
modification, if an NMI comes on any CPU and try to run the modified
code, it should have a valid version of the code to execute. Does it
make more sense ?

> > > 
> > > Luckily, gcc almost never place any code between the mov, test and
> > > jne instructions. But since we cannot we sure, we could dynamically
> > > check for this code pattern after the mov instruction. If we find
> > > it, then we play with it as if it was a single asm block, but if we
> > > don't find what we expect, then we use standard immediate values
> > > for that. I expect the heavily optimised version will be usable
> > > almost all the time.
> 
> I expect gcc to start using the macro-fusion capable ones more and more over time at least,
> and for that the compare and jmp need to be consecutive.
> 

Early reasults of the work I've done last night : I can detect about 96%
of the ~120 markers I've put in my instrumented kernel.

Not only does the compare and jmp need to be consecutive, but the movb
$0x0,%al also does. I *could* try to detect specific code inserted in
between, but I really have to make sure I don't get burned by the
compiler inserting a jmp there.

I'll post my work shortly.

Mathieu

> 
> -- 
> If you want to reach me at my work email, use arjan@linux.intel.com
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
