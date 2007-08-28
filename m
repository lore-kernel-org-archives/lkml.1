Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbXH1MIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbXH1MIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 08:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbXH1MIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 08:08:01 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:59354 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752753AbXH1MH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 08:07:59 -0400
Date: Tue, 28 Aug 2007 08:07:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070828120756.GD12241@Krystal>
References: <20070827202203.GB5653@Krystal> <Pine.LNX.4.64.0708271324001.5884@schroedinger.engr.sgi.com> <20070827203913.GA7416@Krystal> <Pine.LNX.4.64.0708271401070.6435@schroedinger.engr.sgi.com> <20070827211003.GA10627@Krystal> <Pine.LNX.4.64.0708271421130.6566@schroedinger.engr.sgi.com> <20070827213845.GB9748@Krystal> <Pine.LNX.4.64.0708271510020.8783@schroedinger.engr.sgi.com> <20070827222715.GA16982@Krystal> <Pine.LNX.4.64.0708271811200.10344@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708271811200.10344@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:01:03 up 29 days, 12:19,  5 users,  load average: 0.21, 0.35, 0.80
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I just had a look at ia64 instruction set, and I fear that cmpxchg
must always come with the acquire or release semantic. Is there any
cmpxchg equivalent on ia64 that would be acquire and release semantic
free ? This implicit memory ordering in the instruction seems to be
responsible for the slowdown.

If such primitive does not exist, then we should think about an irq
disable fallback for this local atomic operation. However, I would
prefer to let the cmpxchg_local primitive be bound to the "slow"
cmpxchg_acq and create something like _cmpxchg_local that would be
interrupt-safe, but not reentrant wrt NMIs.

This way, cmpxchg_local users could choose either the fast flavor
(_cmpxchg_local: not necessarily atomic wrt NMIs) or the most atomic
flavor (cmpxchg_local) available on the architecture. If you think of a
better name, please tell me... it could also be: fast version (mostly
used): cmpxchg_local(); slow, fully reentrant version:
cmpxchg_local_nmi().

Mathieu

* Christoph Lameter (clameter@sgi.com) wrote:
> Measurements on IA64 slub w/per cpu vs slub w/per cpu/cmpxchg_local 
> emulation. Results are not good:
> 
> slub/per cpu
> 10000 times kmalloc(8)/kfree -> 105 cycles
> 10000 times kmalloc(16)/kfree -> 104 cycles
> 10000 times kmalloc(32)/kfree -> 105 cycles
> 10000 times kmalloc(64)/kfree -> 104 cycles
> 10000 times kmalloc(128)/kfree -> 104 cycles
> 10000 times kmalloc(256)/kfree -> 115 cycles
> 10000 times kmalloc(512)/kfree -> 116 cycles
> 10000 times kmalloc(1024)/kfree -> 115 cycles
> 10000 times kmalloc(2048)/kfree -> 115 cycles
> 10000 times kmalloc(4096)/kfree -> 115 cycles
> 10000 times kmalloc(8192)/kfree -> 117 cycles
> 10000 times kmalloc(16384)/kfree -> 439 cycles
> 10000 times kmalloc(32768)/kfree -> 800 cycles
> 
> 
> slub/per cpu + cmpxchg_local emulation
> 10000 times kmalloc(8)/kfree -> 143 cycles
> 10000 times kmalloc(16)/kfree -> 143 cycles
> 10000 times kmalloc(32)/kfree -> 143 cycles
> 10000 times kmalloc(64)/kfree -> 143 cycles
> 10000 times kmalloc(128)/kfree -> 143 cycles
> 10000 times kmalloc(256)/kfree -> 154 cycles
> 10000 times kmalloc(512)/kfree -> 154 cycles
> 10000 times kmalloc(1024)/kfree -> 154 cycles
> 10000 times kmalloc(2048)/kfree -> 154 cycles
> 10000 times kmalloc(4096)/kfree -> 155 cycles
> 10000 times kmalloc(8192)/kfree -> 155 cycles
> 10000 times kmalloc(16384)/kfree -> 440 cycles
> 10000 times kmalloc(32768)/kfree -> 819 cycles
> 10000 times kmalloc(65536)/kfree -> 902 cycles
> 
> 
> Parallel allocs:
> 
> Kmalloc N*alloc N*free(16): 0=102/136 1=97/136 2=99/140 3=98/140 4=100/138 
> 5=99/139 6=100/139 7=101/141 Average=99/139
> 
> cmpxchg_local emulation
> Kmalloc N*alloc N*free(16): 0=116/147 1=116/145 2=115/151 3=115/147 
> 4=115/149 5=117/147 6=116/148 7=116/146 Average=116/147
> 
> Patch used:
> 
> Index: linux-2.6/include/asm-ia64/atomic.h
> ===================================================================
> --- linux-2.6.orig/include/asm-ia64/atomic.h	2007-08-27 16:42:02.000000000 -0700
> +++ linux-2.6/include/asm-ia64/atomic.h	2007-08-27 17:50:24.000000000 -0700
> @@ -223,4 +223,17 @@ atomic64_add_negative (__s64 i, atomic64
>  #define smp_mb__after_atomic_inc()	barrier()
>  
>  #include <asm-generic/atomic.h>
> +
> +static inline void *cmpxchg_local(void **p, void *old, void *new)
> +{
> +	unsigned long flags;
> +	void *before;
> +
> +	local_irq_save(flags);
> +	before = *p;
> +	if (likely(before == old))
> +		*p = new;
> +	local_irq_restore(flags);
> +	return before;
> +}
>  #endif /* _ASM_IA64_ATOMIC_H */
> 
> kmem_cache_alloc before
> 
> 0000000000008900 <kmem_cache_alloc>:
>     8900:       01 28 31 0e 80 05       [MII]       alloc r37=ar.pfs,12,7,0
>     8906:       40 02 00 62 00 00                   mov r36=b0
>     890c:       00 00 04 00                         nop.i 0x0;;
>     8910:       0b 18 01 00 25 04       [MMI]       mov r35=psr;;
>     8916:       00 00 04 0e 00 00                   rsm 0x4000
>     891c:       00 00 04 00                         nop.i 0x0;;
>     8920:       08 50 90 1b 19 21       [MMI]       adds r10=3300,r13
>     8926:       70 02 80 00 42 40                   mov r39=r32
>     892c:       05 00 c4 00                         mov r42=b0
>     8930:       09 40 01 42 00 21       [MMI]       mov r40=r33
>     8936:       00 00 00 02 00 20                   nop.m 0x0
>     893c:       f5 e7 ff 9f                         mov r41=-1;;
>     8940:       0b 48 00 14 10 10       [MMI]       ld4 r9=[r10];;
>     8946:       00 00 00 02 00 00                   nop.m 0x0
>     894c:       01 48 58 00                         sxt4 r8=r9;;
>     8950:       0b 18 20 40 12 20       [MMI]       shladd r3=r8,3,r32;;
>     8956:       20 80 0f 82 48 00                   addl r2=8432,r3
>     895c:       00 00 04 00                         nop.i 0x0;;
>     8960:       0a 00 01 04 18 10       [MMI]       ld8 r32=[r2];;
>     8966:       e0 a0 80 00 42 60                   adds r14=20,r32
>     896c:       05 00 01 84                         mov r43=r32
>     8970:       0b 10 01 40 18 10       [MMI]       ld8 r34=[r32];;
>     8976:       70 00 88 0c 72 00                   cmp.eq p7,p6=0,r34
>     897c:       00 00 04 00                         nop.i 0x0;;
>     8980:       cb 70 00 1c 10 90       [MMI] (p06) ld4 r14=[r14];;
>     8986:       e1 70 88 24 40 00             (p06) shladd r14=r14,3,r34
>     898c:       00 00 04 00                         nop.i 0x0;;
>     8990:       c2 70 00 1c 18 10       [MII] (p06) ld8 r14=[r14]
>     8996:       00 00 00 02 00 00                   nop.i 0x0;;
>     899c:       00 00 04 00                         nop.i 0x0
>     89a0:       d8 00 38 40 98 11       [MMB] (p06) st8 [r32]=r14
>     89a6:       00 00 00 02 00 03                   nop.m 0x0
>     89ac:       30 00 00 40                   (p06) br.cond.sptk.few 89d0 <kmem_cache_alloc+0xd0>
>     89b0:       11 00 00 00 01 00       [MIB]       nop.m 0x0
>     89b6:       00 00 00 02 00 00                   nop.i 0x0
>     89bc:       18 d8 ff 58                         br.call.sptk.many b0=61c0 <__slab_alloc>;;
>     89c0:       08 10 01 10 00 21       [MMI]       mov r34=r8
>     89c6:       00 00 00 02 00 00                   nop.m 0x0
>     89cc:       00 00 04 00                         nop.i 0x0
>     89d0:       03 00 00 00 01 00       [MII]       nop.m 0x0
>     89d6:       20 01 00 00 49 20                   mov r18=16384;;
>     89dc:       22 19 31 80                         and r17=r18,r35;;
>     89e0:       0a 38 44 00 06 b8       [MMI]       cmp.eq p7,p6=r17,r0;;
>     89e6:       01 00 04 0c 00 00             (p06) ssm 0x4000
>     89ec:       00 00 04 00                         nop.i 0x0
>     89f0:       eb 00 00 02 07 80       [MMI] (p07) rsm 0x4000;;
>     89f6:       01 00 00 60 00 00             (p06) srlz.d
>     89fc:       00 00 04 00                         nop.i 0x0;;
>     8a00:       08 00 00 00 01 00       [MMI]       nop.m 0x0
>     8a06:       b0 00 88 14 72 e0                   cmp.eq p11,p10=0,r34
>     8a0c:       e1 09 01 52                         extr.u r15=r33,15,1
>     8a10:       09 58 60 40 00 21       [MMI]       adds r11=24,r32
>     8a16:       70 02 88 00 42 00                   mov r39=r34
>     8a1c:       05 00 00 84                         mov r40=r0;;
>     8a20:       42 71 04 00 00 e4       [MII] (p10) mov r14=1
>     8a26:       e2 00 00 00 42 00             (p11) mov r14=r0;;
>     8a2c:       00 00 04 00                         nop.i 0x0
>     8a30:       0b 80 3c 1c 0c 20       [MMI]       and r16=r15,r14;;
>     8a36:       80 00 40 12 73 00                   cmp4.eq p8,p9=0,r16
>     8a3c:       00 00 04 00                         nop.i 0x0;;
>     8a40:       31 49 01 16 10 10       [MIB] (p09) ld4 r41=[r11]
>     8a46:       00 00 00 02 80 04                   nop.i 0x0
>     8a4c:       08 00 00 51                   (p09) br.call.spnt.many b0=8a40 <kmem_cache_alloc+0x140>;;
>     8a50:       08 00 00 00 01 00       [MMI]       nop.m 0x0
>     8a56:       80 00 88 00 42 00                   mov r8=r34
>     8a5c:       40 0a 00 07                         mov b0=r36
>     8a60:       11 00 00 00 01 00       [MIB]       nop.m 0x0
>     8a66:       00 28 01 55 00 80                   mov.i ar.pfs=r37
>     8a6c:       08 00 84 00                         br.ret.sptk.many b0;;
>     8a70:       08 00 00 00 01 00       [MMI]       nop.m 0x0
>     8a76:       00 00 00 02 00 00                   nop.m 0x0
>     8a7c:       00 00 04 00                         nop.i 0x0
> 
> kmem_cache_alloc with cmpxchg emulation:
> 
> 0000000000008da0 <kmem_cache_alloc>:
>     8da0:       09 28 31 0e 80 05       [MMI]       alloc r37=ar.pfs,12,7,0
>     8da6:       a0 80 36 32 42 80                   adds r10=3280,r13
>     8dac:       04 00 c4 00                         mov r36=b0;;
>     8db0:       02 00 00 00 01 00       [MII]       nop.m 0x0
>     8db6:       00 41 29 00 42 00                   adds r16=40,r10;;
>     8dbc:       00 00 04 00                         nop.i 0x0
>     8dc0:       0a 58 00 20 10 10       [MMI]       ld4 r11=[r16];;
>     8dc6:       e0 08 2c 00 42 00                   adds r14=1,r11
>     8dcc:       00 00 04 00                         nop.i 0x0
>     8dd0:       0b 00 00 00 01 00       [MMI]       nop.m 0x0;;
>     8dd6:       00 70 40 20 23 00                   st4 [r16]=r14
>     8ddc:       00 00 04 00                         nop.i 0x0;;
>     8de0:       09 78 50 14 00 21       [MMI]       adds r15=20,r10
>     8de6:       00 00 00 02 00 40                   nop.m 0x0
>     8dec:       02 00 00 92                         mov r18=16384;;
>     8df0:       0b 48 00 1e 10 10       [MMI]       ld4 r9=[r15];;
>     8df6:       00 00 00 02 00 00                   nop.m 0x0
>     8dfc:       01 48 58 00                         sxt4 r8=r9;;
>     8e00:       0b 18 20 40 12 20       [MMI]       shladd r3=r8,3,r32;;
>     8e06:       20 80 0f 82 48 00                   addl r2=8432,r3
>     8e0c:       00 00 04 00                         nop.i 0x0;;
>     8e10:       02 10 01 04 18 10       [MII]       ld8 r34=[r2]
>     8e16:       00 00 00 02 00 20                   nop.i 0x0;;
>     8e1c:       42 11 01 84                         adds r17=20,r34
>     8e20:       09 00 00 00 01 00       [MMI]       nop.m 0x0
>     8e26:       f0 00 88 30 20 00                   ld8 r15=[r34]
>     8e2c:       00 00 04 00                         nop.i 0x0;;
>     8e30:       10 00 00 00 01 00       [MIB]       nop.m 0x0
>     8e36:       60 00 3c 0e 72 03                   cmp.eq p6,p7=0,r15
>     8e3c:       20 01 00 41                   (p06) br.cond.spnt.few 8f50 <kmem_cache_alloc+0x1b0>
>     8e40:       0a b8 00 22 10 10       [MMI]       ld4 r23=[r17];;
>     8e46:       60 b9 3c 24 40 00                   shladd r22=r23,3,r15
>     8e4c:       00 00 04 00                         nop.i 0x0
>     8e50:       0b 00 00 00 01 00       [MMI]       nop.m 0x0;;
>     8e56:       40 01 58 30 20 00                   ld8 r20=[r22]
>     8e5c:       00 00 04 00                         nop.i 0x0;;
>     8e60:       0b a8 00 00 25 04       [MMI]       mov r21=psr;;
>     8e66:       00 00 04 0e 00 00                   rsm 0x4000
>     8e6c:       00 00 04 00                         nop.i 0x0;;
>     8e70:       02 18 01 44 18 10       [MII]       ld8 r35=[r34]
>     8e76:       30 91 54 18 40 00                   and r19=r18,r21;;
>     8e7c:       00 00 04 00                         nop.i 0x0
>     8e80:       0b 48 3c 46 08 78       [MMI]       cmp.eq p9,p8=r15,r35;;
>     8e86:       02 a0 88 30 23 00             (p09) st8 [r34]=r20
>     8e8c:       00 00 04 00                         nop.i 0x0;;
>     8e90:       0a 38 4c 00 06 b8       [MMI]       cmp.eq p7,p6=r19,r0;;
>     8e96:       01 00 04 0c 00 00             (p06) ssm 0x4000
>     8e9c:       00 00 04 00                         nop.i 0x0
>     8ea0:       eb 00 00 02 07 80       [MMI] (p07) rsm 0x4000;;
>     8ea6:       01 00 00 60 00 00             (p06) srlz.d
>     8eac:       00 00 04 00                         nop.i 0x0;;
>     8eb0:       11 00 00 00 01 00       [MIB]       nop.m 0x0
>     8eb6:       00 00 00 02 00 04                   nop.i 0x0
>     8ebc:       70 ff ff 49                   (p08) br.cond.spnt.few 8e20 <kmem_cache_alloc+0x80>;;
>     8ec0:       03 00 00 00 01 00       [MII]       nop.m 0x0
>     8ec6:       80 81 36 32 42 20                   adds r24=3280,r13;;
>     8ecc:       83 c2 00 84                         adds r25=40,r24;;
>     8ed0:       0a d8 00 32 10 10       [MMI]       ld4 r27=[r25];;
>     8ed6:       a0 f9 6f 7e 46 00                   adds r26=-1,r27
>     8edc:       00 00 04 00                         nop.i 0x0
>     8ee0:       0b 00 00 00 01 00       [MMI]       nop.m 0x0;;
>     8ee6:       00 d0 64 20 23 00                   st4 [r25]=r26
>     8eec:       00 00 04 00                         nop.i 0x0;;
>     8ef0:       0b 90 40 30 00 21       [MMI]       adds r18=16,r24;;
>     8ef6:       10 01 48 60 21 00                   ld4.acq r17=[r18]
>     8efc:       00 00 04 00                         nop.i 0x0;;
>     8f00:       11 00 00 00 01 00       [MIB]       nop.m 0x0
>     8f06:       c0 10 44 1a a8 06                   tbit.z p12,p13=r17,1
>     8f0c:       08 00 00 51                   (p13) br.call.spnt.many b0=8f00 <kmem_cache_alloc+0x160>;;
>     8f10:       02 00 00 00 01 00       [MII]       nop.m 0x0
>     8f16:       a0 f0 84 16 a8 c5                   tbit.z p10,p11=r33,15;;
>     8f1c:       81 11 01 84                   (p11) adds r14=24,r34
>     8f20:       62 39 01 46 00 e1       [MII] (p11) mov r39=r35
>     8f26:       82 02 00 00 42 00             (p11) mov r40=r0;;
>     8f2c:       00 00 04 00                         nop.i 0x0
>     8f30:       79 49 01 1c 10 10       [MMB] (p11) ld4 r41=[r14]
>     8f36:       00 00 00 02 80 05                   nop.m 0x0
>     8f3c:       08 00 00 51                   (p11) br.call.spnt.many b0=8f30 <kmem_cache_alloc+0x190>;;
>     8f40:       10 00 00 00 01 00       [MIB]       nop.m 0x0
>     8f46:       80 00 8c 00 42 00                   mov r8=r35
>     8f4c:       30 00 00 40                         br.few 8f70 <kmem_cache_alloc+0x1d0>
>     8f50:       08 38 01 40 00 21       [MMI]       mov r39=r32
>     8f56:       80 02 84 00 42 40                   mov r40=r33
>     8f5c:       05 20 01 84                         mov r42=r36
>     8f60:       19 58 01 44 00 21       [MMB]       mov r43=r34
>     8f66:       90 fa f3 ff 4f 00                   mov r41=-1
>     8f6c:       28 d3 ff 58                         br.call.sptk.many b0=6280 <__slab_alloc>;;
>     8f70:       00 00 00 00 01 00       [MII]       nop.m 0x0
>     8f76:       00 20 05 80 03 00                   mov b0=r36
>     8f7c:       00 00 04 00                         nop.i 0x0
>     8f80:       11 00 00 00 01 00       [MIB]       nop.m 0x0
>     8f86:       00 28 01 55 00 80                   mov.i ar.pfs=r37
>     8f8c:       08 00 84 00                         br.ret.sptk.many b0;;
>     8f90:       08 00 00 00 01 00       [MMI]       nop.m 0x0
>     8f96:       00 00 00 02 00 00                   nop.m 0x0
>     8f9c:       00 00 04 00                         nop.i 0x0
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
