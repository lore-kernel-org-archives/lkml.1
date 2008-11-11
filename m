Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYKKULq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYKKULq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYKKULf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:11:35 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:36788 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbYKKULe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:11:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhAFAP9zGUlMQWxa/2dsb2JhbACBdstpg1c
Date: Tue, 11 Nov 2008 15:11:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nicolas Pitre <nico@cam.org>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, dhowells@redhat.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] convert cnt32_to_63 to inline
Message-ID: <20081111201130.GA10801@Krystal>
References: <20081109162250.GB10181@Krystal> <alpine.LFD.2.00.0811092304300.13034@xanadu.home> <20081109204256.89ab7925.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101627510.13034@xanadu.home> <20081110135850.0d620f3c.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101811130.13034@xanadu.home> <20081110152221.64948d23.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101917450.13034@xanadu.home> <20081111182759.GA8052@Krystal> <20081111191355.GA13724@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081111191355.GA13724@flint.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:32:41 up 160 days, 13 min, 12 users,  load average: 0.83,
	1.54, 1.23
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King (rmk+lkml@arm.linux.org.uk) wrote:
> On Tue, Nov 11, 2008 at 01:28:00PM -0500, Mathieu Desnoyers wrote:
> > Let's see what it gives once implemented. Only compile-tested. Assumes
> > pxa, sa110 and mn10300 are all UP-only. Correct smp_rmb() are used for
> > arm versatile.
> 
> Versatile is also UP only.
> 
> The following are results from PXA built with gcc 3.4.3:
> 
> 1. two additional registers used in sched_clock()
> 2. 8 additional bytes of code (which are needless if gcc was more inteligent)
> 
> both of these I put down to inefficiencies in gcc's register allocation.
> 
> 3. worse instruction scheduling - two inter-dependent loads next to each
>    other causing a pipeline stall
> 
> Actual reading of variables/hardware is unaffected by this patch.
> 
> Old code:
> 
>    c:   e59f3050        ldr     r3, [pc, #80]   ; load address of oscr2ns_scale
>   10:   e59fc050        ldr     ip, [pc, #80]   ; load address of __m_cnt_hi
>   14:   e5932000        ldr     r2, [r3]	; read oscr2ns_scale
>   18:   e59f304c        ldr     r3, [pc, #76]   ; load address of OSCR
>   1c:   e59c1000        ldr     r1, [ip]	; read __m_cnt_hi
>   20:   e1a07002        mov     r7, r2
>   24:   e3a08000        mov     r8, #0  ; 0x0
>   28:   e5933000        ldr     r3, [r3]	; read OSCR register
> ...
>   58:   e1820b04        orr     r0, r2, r4, lsl #22
>   5c:   e1a01524        lsr     r1, r4, #10
>   60:   e89da9f0        ldm     sp, {r4, r5, r6, r7, r8, fp, sp, pc}
> 
> 
> New code:
> 
>    c:   e59f0058        ldr     r0, [pc, #88]   ; load address of oscr2ns_scale
>   10:   e5901000        ldr     r1, [r0]	; read oscr2ns_scale <= pipeline stall
>   14:   e59f3054        ldr     r3, [pc, #84]   ; load address of __m_cnt_hi
>   18:   e1a08001        mov     r8, r1
>   1c:   e5932000        ldr     r2, [r3]	; read __m_cnt_hi
>   20:   e59f304c        ldr     r3, [pc, #76]   ; load address of OSCR
>   24:   e1a09002        mov     r9, r2
>   28:   e3a0a000        mov     sl, #0  ; 0x0
>   2c:   e5933000        ldr     r3, [r3]	; read OSCR
> ...
>   58:   e1825b04        orr     r5, r2, r4, lsl #22
>   5c:   e1a06524        lsr     r6, r4, #10
>   60:   e1a01006        mov     r1, r6
>   64:   e1a00005        mov     r0, r5
>   68:   e89daff0        ldm     sp, {r4, r5, r6, r7, r8, r9, sl, fp, sp, pc}
> 
> Versatile:
> 
> 1. 12 additional bytes of code
> 2. same number of registers
> 3. worse instruction scheduling causing pipeline stall
> 
> Actual reading of variables/hardware is unaffected by this patch.
> 
> So, we have two platforms where this patch makes things visibly worse
> with no material benefit.
> 

I think the added barrier() are causing these pipeline stalls. They
don't allow the compiler to read variables such as oscr2ns_scale before
the barrier because gcc cannot assume it won't be modified. However, to
insure that OSCR read is done after __m_cnt_hi read, this barrier seems
required to be safe against gcc optimizations.

Have you compared my patch to Nicolas'patch, which adds a smp_rmb() in
the macro or to a vanilla tree ?

I wonder if reading those values sooner would help gcc ?

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
