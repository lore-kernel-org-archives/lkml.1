Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0BFJgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 04:36:46 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46241 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab0BFJgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 04:36:44 -0500
Date: Sat, 6 Feb 2010 10:36:59 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100206093659.GA28326@aftab>
References: <20100203074251.e2caa3f3.akpm@linux-foundation.org>
 <20100203181425.GB1367@aftab>
 <1265222875.24455.1020.camel@laptop>
 <4B69D362.10608@zytor.com>
 <20100204151050.GC32711@aftab>
 <1265296432.22001.18.camel@laptop>
 <20100204155419.GD32711@aftab>
 <1265299457.22001.72.camel@laptop>
 <20100205121139.GA9044@aftab>
 <4B6C93A2.1090302@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6C93A2.1090302@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 01:54:42PM -0800, H. Peter Anvin wrote:
> On 02/05/2010 04:11 AM, Borislav Petkov wrote:
> > +
> > +unsigned int __arch_hweight16(unsigned int w)
> > +{
> > +	unsigned int res = 0;
> > +
> > +	asm volatile("xor %%dh, %%dh\n\t"
> > +		     __arch_hweight_alt(32)
> > +			: "=di" (res)
> > +			: "di" (w)
> > +			: "ecx", "memory");
> > +
> 
> This is wrong in more ways than I can shake a stick at.

Thanks for reviewing it though - how else would I learn :).

> a) "di" doesn't mean the DI register - it means the DX register (d) or
> an immediate (i).  Since you don't have any reference to either %0 or %1
> in your code, you have no way of knowing which one it is.  The
> constraint for the di register is "D".

right.

> b) On 32 bits, the first argument register is in %eax (with %edx used
> for the upper half of a 32-bit argument), but on 64 bits, the first
> argument is in %rdi, with the return still in %rax.

Sure, it is right there in arch/x86/include/asm/calling.h. Shame on me.

> c) You call a C function, but you don't clobber the set of registers
> that a C function would clobber.  You either need to put the function in
> an assembly wrapper (which is better in the long run), or clobber the
> full set of registers that is clobbered by a C function (which is better
> in the short term) -- which is eax, edx, ecx on 32 bits, but rax, rdi,
> esi, rdx, rcx, r8, r9, r10, r11 on 64 bits.

I think you mean rsi instead of esi here.

Well, the example Brian pointed me to - __mutex_fastpath_lock - lists
the full set of clobbered registers. Please elaborate on the assembly
wrapper for the function, wouldn't I need to list all the clobbered
registers there too or am I missing something?

> d) On the other hand, you do *not* need a "memory" clobber.

Right, in this case we have all non-barrier like inlines so no memory
clobber, according to the comment above alternative() macro.

Thanks.

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
