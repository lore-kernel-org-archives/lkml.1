Return-Path: <linux-kernel-owner+w=401wt.eu-S937586AbXHLSz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937586AbXHLSz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 14:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934087AbXHLSzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 14:55:09 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:34316 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933701AbXHLSzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 14:55:07 -0400
Date: Sun, 12 Aug 2007 14:55:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] Immediate Values
Message-ID: <20070812185501.GA4480@Krystal>
References: <20070812150702.769065566@polymtl.ca> <1186943243.2854.17.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1186943243.2854.17.camel@laptopd505.fenrus.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:46:28 up 13 days, 19:05,  2 users,  load average: 3.36, 2.45, 2.14
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> 
> On Sun, 2007-08-12 at 11:07 -0400, Mathieu Desnoyers wrote:
> > Hi Andrew,
> > 
> > Here is the latest version of immediate values. It applies on 2.6.23-rc2-mm2 in
> > this order:
> 
> 
> I have a concern; you seem to be patching potentially "live" code....
> 
> there are basically two options
> 1) you run the risk of triple faulting (patching an instruction while
> some other core/cpu may be decoding it may cause a triple fault)
> 2) you do an IPI to all other cpus and prevent them from executing any
> code except a small loop during the patching... this is expensive.
> 
> To be honest, neither sound very attractive to me ;(
> 

Yup, the concern is appropriate. That's why I dealt with it in the
"Immediate Values - i386 Optimization" patch. (I guess your concern
is specific to i386, x86_64 and ia64).

I have currently only implemented the i386 optimization, but x86_64 and
ia64 should be similar.

The triple fault in question is discussed in Intel's errata under the
title "Centrino Duo Processor Technology Specification Update, AH33.
Unsynchronized Cross-Modifying Code Operations Can Cause Unexpected
Instruction Execution Results." (if you refer to something else, please
tell me).

I discuss thoroughly the algorithm I use in the patch comments, which is
none of the two options you point out.

Quoting the patch:

"Overall design

The algorithm proposed by Intel applies not so well in kernel context: it
would imply disabling interrupts and looping on every CPUs while modifying
the code and would not support instrumentation of code called from interrupt
sources that cannot be disabled.

Therefore, we use a different algorithm to respect Intel's erratum (see the
quoted discussion above). We make sure that no CPU sees an out-of-date copy
of a pre-fetched instruction by 1 - using a breakpoint, which skips the
instruction that is going to be modified, 2 - issuing an IPI to every CPU to
execute a sync_core(), to make sure that even when the breakpoint is removed,
no cpu could possibly still have the out-of-date copy of the instruction,
modify the now unused 2nd byte of the instruction, and then put back the
original 1st byte of the instruction.

It has exactly the same intent as the algorithm proposed by Intel, but
it has less side-effects, scales better and supports NMI, SMI and MCE."

Moreover, just to be cautious, I arrange the alignment of instructions
to modify so their updates will be atomic. Therefore, a 5 bytes movl
will always be aligned on 4 bytes boundaries - 1, so the immediate value
that follows the 1 byte opcode will be itself aligned on 4 bytes
boundaries.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
