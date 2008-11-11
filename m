Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbYKKTQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbYKKTQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYKKTQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:16:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57152 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbYKKTQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:16:26 -0500
Date: Tue, 11 Nov 2008 19:13:55 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Nicolas Pitre <nico@cam.org>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, dhowells@redhat.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] convert cnt32_to_63 to inline
Message-ID: <20081111191355.GA13724@flint.arm.linux.org.uk>
Mail-Followup-To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Nicolas Pitre <nico@cam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, dhowells@redhat.com, mingo@elte.hu,
	a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
	ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
	davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
	rostedt@goodmis.org, linux-arch@vger.kernel.org
References: <alpine.LFD.2.00.0811090827160.13034@xanadu.home> <20081109162250.GB10181@Krystal> <alpine.LFD.2.00.0811092304300.13034@xanadu.home> <20081109204256.89ab7925.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101627510.13034@xanadu.home> <20081110135850.0d620f3c.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101811130.13034@xanadu.home> <20081110152221.64948d23.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101917450.13034@xanadu.home> <20081111182759.GA8052@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111182759.GA8052@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 01:28:00PM -0500, Mathieu Desnoyers wrote:
> Let's see what it gives once implemented. Only compile-tested. Assumes
> pxa, sa110 and mn10300 are all UP-only. Correct smp_rmb() are used for
> arm versatile.

Versatile is also UP only.

The following are results from PXA built with gcc 3.4.3:

1. two additional registers used in sched_clock()
2. 8 additional bytes of code (which are needless if gcc was more inteligent)

both of these I put down to inefficiencies in gcc's register allocation.

3. worse instruction scheduling - two inter-dependent loads next to each
   other causing a pipeline stall

Actual reading of variables/hardware is unaffected by this patch.

Old code:

   c:   e59f3050        ldr     r3, [pc, #80]   ; load address of oscr2ns_scale
  10:   e59fc050        ldr     ip, [pc, #80]   ; load address of __m_cnt_hi
  14:   e5932000        ldr     r2, [r3]	; read oscr2ns_scale
  18:   e59f304c        ldr     r3, [pc, #76]   ; load address of OSCR
  1c:   e59c1000        ldr     r1, [ip]	; read __m_cnt_hi
  20:   e1a07002        mov     r7, r2
  24:   e3a08000        mov     r8, #0  ; 0x0
  28:   e5933000        ldr     r3, [r3]	; read OSCR register
...
  58:   e1820b04        orr     r0, r2, r4, lsl #22
  5c:   e1a01524        lsr     r1, r4, #10
  60:   e89da9f0        ldm     sp, {r4, r5, r6, r7, r8, fp, sp, pc}


New code:

   c:   e59f0058        ldr     r0, [pc, #88]   ; load address of oscr2ns_scale
  10:   e5901000        ldr     r1, [r0]	; read oscr2ns_scale <= pipeline stall
  14:   e59f3054        ldr     r3, [pc, #84]   ; load address of __m_cnt_hi
  18:   e1a08001        mov     r8, r1
  1c:   e5932000        ldr     r2, [r3]	; read __m_cnt_hi
  20:   e59f304c        ldr     r3, [pc, #76]   ; load address of OSCR
  24:   e1a09002        mov     r9, r2
  28:   e3a0a000        mov     sl, #0  ; 0x0
  2c:   e5933000        ldr     r3, [r3]	; read OSCR
...
  58:   e1825b04        orr     r5, r2, r4, lsl #22
  5c:   e1a06524        lsr     r6, r4, #10
  60:   e1a01006        mov     r1, r6
  64:   e1a00005        mov     r0, r5
  68:   e89daff0        ldm     sp, {r4, r5, r6, r7, r8, r9, sl, fp, sp, pc}

Versatile:

1. 12 additional bytes of code
2. same number of registers
3. worse instruction scheduling causing pipeline stall

Actual reading of variables/hardware is unaffected by this patch.

So, we have two platforms where this patch makes things visibly worse
with no material benefit.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
