Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZGAMdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZGAMdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZGAMdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:33:05 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:37848 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbZGAMdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:33:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19019.22396.776453.297335@cargo.ozlabs.ibm.com>
Date: Wed, 1 Jul 2009 22:33:00 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter: Add Generalized Hardware FPU
	support for AMD
In-Reply-To: <20090630224220.GI1241@elte.hu>
References: <1246267985.3185.3.camel@hpdv5.satnam>
	<20090630101105.GF6942@elte.hu>
	<1246368049.3026.11.camel@hpdv5.satnam>
	<20090630224220.GI1241@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

>         19583739  vec-adds               (   2.01x scaled)
>         20856051  vec-muls               (   2.01x scaled)
>         20856051  vec-divs               (   2.01x scaled)
>      25100224054  vec-idle-cycles        (   1.99x scaled)
>         12540131  vec-busy-cycles        (   1.99x scaled)
>         42286702  vec-ops                (   2.01x scaled)
> 
> Paulus: would this categorization fit PowerPC too?

Conceptually that looks nice, but unfortunately we don't have events
that correspond to that categorization on any PowerPC with vector
hardware (VMX/Altivec).  POWER6 seems to have the most vector events,
and they are mostly divided up along the lines of simple / complex /
permute / load / store operations, and whether they are integer or
floating-point operations.

Here are the vector-related events we have on POWER6:

MRK_VMX0_LD_WRBACK	Marked VMX0 load writeback valid
MRK_VMX1_LD_WRBACK	Marked VMX1 load writeback valid
MRK_VMX_COMPLEX_ISSUED	Marked VMX instruction issued to complex
MRK_VMX_FLOAT_ISSUED	Marked VMX instruction issued to float
MRK_VMX_PERMUTE_ISSUED	Marked VMX instruction issued to permute
MRK_VMX_SIMPLE_ISSUED	Marked VMX instruction issued to simple
MRK_VMX_ST_ISSUED	Marked VMX store issued
VMX0_INST_ISSUED	VMX0 instruction issued
VMX0_LD_ISSUED		VMX0 load issued
VMX0_LD_WRBACK		VMX0 load writeback valid
VMX0_STALL		VMX0 stall
VMX1_INST_ISSUED	VMX1 instruction issued
VMX1_LD_ISSUED		VMX1 load issued
VMX1_LD_WRBACK		VMX1 load writeback valid
VMX1_STALL		VMX1 stall
VMX_COMPLEX_ISSUED	VMX instruction issued to complex
VMX_FLOAT_ISSUED	VMX instruction issued to float
VMX_FLOAT_MULTICYCLE	VMX multi-cycle floating point instruction issued
VMX_PERMUTE_ISSUED	VMX instruction issued to permute
VMX_RESULT_SAT_0_1	VMX valid result with sat bit is set (0->1)
VMX_RESULT_SAT_1	VMX valid result with sat=1
VMX_SIMPLE_ISSUED	VMX instruction issued to simple
VMX_ST_ISSUED		VMX store issued

I'm not sure what the exact distinction is between VMX0 and VMX1.
I'll find out.

The MPC7450 (G4, 32-bit) cpu also has quite a few VMX/Altivec events,
such as counts of cycles that individual vector units are waiting for
operands, but not counts of how many vector add or vector multiply
operations are done.

Paul.
