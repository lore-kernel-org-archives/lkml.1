Return-Path: <linux-kernel-owner+w=401wt.eu-S1763571AbXFERDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763571AbXFERDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756585AbXFERDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:03:16 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51048 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbXFERDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:03:16 -0400
Message-ID: <4665970A.6080501@zytor.com>
Date: Tue, 05 Jun 2007 10:02:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lguest-fix-divide-error-implement-sched_clock
References: <20070522223828.GV11115@waste.org> <20070605090714.22bfcfd4.akpm@linux-foundation.org> <46658C41.9090105@zytor.com> <200706051837.22847.ak@suse.de>
In-Reply-To: <200706051837.22847.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> I don't think it's a good idea for the TSC. There are various
> setups where it is unreliable and also often simulators don't 
> implement it correctly. And it's always a valuable workaround
> to be able to turn it off.
> 
> Except possibly for the FPU only features used by the gcc output
> should be tested this way. For everything else it is better to 
> test at runtime.
> 
> That is x86-64 makes some more assumptions. But even it
> doesn't assume TSC. 
> 
> I added the mechanism to statically evaluate mostly to share cpufeatures.h
> between 32bit and 64bit at some point -- but didn't quite finish that work 
> before the last merge.
> 

Note that tsc_setup in i386 at least has:


static int __init tsc_setup(char *str)
{
        printk(KERN_WARNING "notsc: Kernel compiled with CONFIG_X86_TSC,"
                                "cannot disable TSC.\n");
        return 1;
}


If TSC isn't actually a compile-time feature then we should allow it to
be disabled on the command line!


This is what I have for i386:

#ifndef CONFIG_MATH_EMULATION
# define NEED_FPU       (1<<(X86_FEATURE_FPU & 31))
#else
# define NEED_FPU       0
#endif

#ifdef CONFIG_X86_TSC
# define NEED_TSC       (1<<(X86_FEATURE_TSC & 31))
#else
# define NEED_TSC       0
#endif

#ifdef CONFIG_X86_PAE
# define NEED_PAE       (1<<(X86_FEATURE_PAE & 31))
#else
# define NEED_PAE       0
#endif

#ifdef CONFIG_X86_CMOV
# define NEED_CMOV      (1<<(X86_FEATURE_CMOV & 31))
#else
# define NEED_CMOV      0
#endif

#ifdef CONFIG_X86_CMPXCHG64
# define NEED_CX8       (1<<(X86_FEATURE_CX8 & 31))
#else
# define NEED_CX8       0
#endif

#define REQUIRED_MASK0  (NEED_FPU|NEED_TSC|NEED_PAE|NEED_CMOV|NEED_CX8)

#ifdef CONFIG_X86_USE_3DNOW
# define NEED_3DNOW     (1<<(X86_FEATURE_3DNOW & 31))
#else
# define NEED_3DNOW     0
#endif

#define REQUIRED_MASK1  (NEED_3DNOW)

And for x86-64:


/* x86-64 baseline features */
#define NEED_FPU        (1<<(X86_FEATURE_FPU & 31))
#define NEED_PSE        (1<<(X86_FEATURE_PSE & 31))
#define NEED_TSC        (1<<(X86_FEATURE_TSC & 31))
#define NEED_MSR        (1<<(X86_FEATURE_MSR & 31))
#define NEED_PAE        (1<<(X86_FEATURE_PAE & 31))
#define NEED_CX8        (1<<(X86_FEATURE_CX8 & 31))
#define NEED_PGE        (1<<(X86_FEATURE_PGE & 31))
#define NEED_FXSR       (1<<(X86_FEATURE_FXSR & 31))
#define NEED_CMOV       (1<<(X86_FEATURE_CMOV & 31))
#define NEED_XMM        (1<<(X86_FEATURE_XMM & 31))
#define NEED_XMM2       (1<<(X86_FEATURE_XMM2 & 31))

#define REQUIRED_MASK0  (NEED_FPU|NEED_PSE|NEED_TSC|NEED_MSR|NEED_PAE|\
                         NEED_CX8|NEED_PGE|NEED_FXSR|NEED_CMOV|\
                         NEED_XMM|NEED_XMM2)
#define SSE_MASK        (NEED_XMM|NEED_XMM2)

/* x86-64 baseline features */
#define NEED_LM         (1<<(X86_FEATURE_LM & 31))

#ifdef CONFIG_X86_USE_3DNOW
# define NEED_3DNOW     (1<<(X86_FEATURE_3DNOW & 31))
#else
# define NEED_3DNOW     0
#endif

#define REQUIRED_MASK1  (NEED_LM|NEED_3DNOW)



