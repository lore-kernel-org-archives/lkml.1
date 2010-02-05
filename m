Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908Ab0BEV7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:59:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41886 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933863Ab0BEV7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:59:41 -0500
Message-ID: <4B6C93A2.1090302@zytor.com>
Date: Fri, 05 Feb 2010 13:54:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for hweight_long(CONSTANT)
References: <20100203070825.e36b3932.akpm@linux-foundation.org> <1265210157.24455.646.camel@laptop> <20100203074251.e2caa3f3.akpm@linux-foundation.org> <20100203181425.GB1367@aftab> <1265222875.24455.1020.camel@laptop> <4B69D362.10608@zytor.com> <20100204151050.GC32711@aftab> <1265296432.22001.18.camel@laptop> <20100204155419.GD32711@aftab> <1265299457.22001.72.camel@laptop> <20100205121139.GA9044@aftab>
In-Reply-To: <20100205121139.GA9044@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2010 04:11 AM, Borislav Petkov wrote:
> +
> +unsigned int __arch_hweight16(unsigned int w)
> +{
> +	unsigned int res = 0;
> +
> +	asm volatile("xor %%dh, %%dh\n\t"
> +		     __arch_hweight_alt(32)
> +			: "=di" (res)
> +			: "di" (w)
> +			: "ecx", "memory");
> +

This is wrong in more ways than I can shake a stick at.

a) "di" doesn't mean the DI register - it means the DX register (d) or
an immediate (i).  Since you don't have any reference to either %0 or %1
in your code, you have no way of knowing which one it is.  The
constraint for the di register is "D".

b) On 32 bits, the first argument register is in %eax (with %edx used
for the upper half of a 32-bit argument), but on 64 bits, the first
argument is in %rdi, with the return still in %rax.

c) You call a C function, but you don't clobber the set of registers
that a C function would clobber.  You either need to put the function in
an assembly wrapper (which is better in the long run), or clobber the
full set of registers that is clobbered by a C function (which is better
in the short term) -- which is eax, edx, ecx on 32 bits, but rax, rdi,
esi, rdx, rcx, r8, r9, r10, r11 on 64 bits.

d) On the other hand, you do *not* need a "memory" clobber.

	-hpa
