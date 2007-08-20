Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbXHTBAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbXHTBAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 21:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbXHTBAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 21:00:30 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:34980 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754221AbXHTBA3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 21:00:29 -0400
Date: Sun, 19 Aug 2007 20:55:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, "S. P. Prasanna" <prasanna@in.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Non atomic unaligned writes
Message-ID: <20070820005522.GA5069@Krystal>
References: <200707191105.44056.ak@suse.de> <p73d4yow0ys.fsf@bingen.suse.de> <469FC9D4.5070604@goop.org> <200707192246.58047.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200707192246.58047.ak@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:50:33 up 21 days,  1:09,  6 users,  load average: 0.53, 0.75, 0.70
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
> Normally there are not that many NMIs or MCEs at boot, but it would
> be still good to avoid the very rare crash by auditing the code first
> [better than try to debug it on some production system later]
> 
> > > - smp lock patching only ever changes a single byte (lock prefix) of
> > > a single instruction
> > > - kprobes only ever change a single byte
> > >
> > > For the immediate value patching it also cannot happen because
> > > you'll never modify multiple instructions and all immediate values
> > > can be changed atomically. 
> > >   
> > 
> > Are misaligned/cross-cache-line updates atomic?
> 
> In theory yes, in practice there can be errata of course. There tend 
> to be a couple with self modifying code, especially cross modifying
> (from another CPU) -- but you don't do that.
> 
> -Andi

I must disagree with Andi on this point. Considering the quoted
paragraph below, misaligned/cross-cache-line updates are not atomic.
This is why I align the immediate values in such a way that the
immediate value within the mov instruction is itself aligned.

Intel System Programming Guide

7.1.1 Guaranteed Atomic Operations

The Intel386™, Intel486™, Pentium®, and P6 family processors guarantee
that the following basic memory operations will always be carried out
atomically:
• Reading or writing a byte.
• Reading or writing a word aligned on a 16-bit boundary.
• Reading or writing a doubleword aligned on a 32-bit boundary.
The P6 family processors guarantee that the following additional memory
operations will always be carried out atomically:
• Reading or writing a quadword aligned on a 64-bit boundary. (This
operation is also guaranteed on the Pentium® processor.)
• 16-bit accesses to uncached memory locations that fit within a 32-bit
data bus.
• 16-, 32-, and 64-bit accesses to cached memory that fit within a
32-Byte cache line.

Accesses to cacheable memory that are split across bus widths, cache
lines, and page boundaries are not guaranteed to be atomic by the
Intel486™, Pentium®, or P6 family processors. The P6 family processors
provide bus control signals that permit external memory subsystems to
make split accesses atomic; however, nonaligned data accesses will
seriously impact the performance of the processor and should be avoided
where possible.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
