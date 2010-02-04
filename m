Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab0BDPOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:14:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:45488 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab0BDPOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:14:16 -0500
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100204151050.GC32711@aftab>
References: <20100130094515.475881280@intel.com>
	 <20100130094957.692671259@intel.com>
	 <20100201124825.cc024f2a.akpm@linux-foundation.org>
	 <20100203133951.GA24357@localhost>
	 <20100203070825.e36b3932.akpm@linux-foundation.org>
	 <1265210157.24455.646.camel@laptop>
	 <20100203074251.e2caa3f3.akpm@linux-foundation.org>
	 <20100203181425.GB1367@aftab> <1265222875.24455.1020.camel@laptop>
	 <4B69D362.10608@zytor.com>  <20100204151050.GC32711@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 16:13:52 +0100
Message-ID: <1265296432.22001.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 16:10 +0100, Borislav Petkov wrote:
> On Wed, Feb 03, 2010 at 11:49:54AM -0800, H. Peter Anvin wrote:
> > On 02/03/2010 10:47 AM, Peter Zijlstra wrote:
> > > On Wed, 2010-02-03 at 19:14 +0100, Borislav Petkov wrote:
> > > 
> > >> alternative("call hweightXX", "popcnt", X86_FEATURE_POPCNT)
> > > 
> > > Make sure to apply a 0xff bitmask to the popcnt r16 call for hweight8(),
> > > and hweight64() needs a bit of magic for 32bit, but yes, something like
> > > that ought to work nicely.
> > > 
> > 
> > Arguably the "best" option is to have the alternative being a jump to an
> > out-of-line stub which does the necessary parameter marshalling before
> > calling a stub.  This technique is already used in a few other places.
> 
> Ok, here's a first alpha prototype and completely untested. The asm
> output looks ok though. I've added separate 32-bit and 64-bit helpers in
> order to dispense with the if-else tests. The hw-popcnt versions are the
> opcodes for "popcnt %eax, %eax" and "popcnt %rax, %rax", respectively,
> so %rAX has to be preloaded with the bitmask and the computed value
> has to be retrieved from there afterwards. And yes, it looks not that
> elegant so I'm open for suggestions.
> 
> The good thing is, this should work on any toolchain since we don't rely
> on the compiler to know about popcnt and we're protected by CPUID flag
> so that the hw-popcnt version is used only on processors which support
> it.
> 
> Please take a good look and let me know what do you guys think.

> +int arch_hweight_long(unsigned long w)
> +{
> +	if (sizeof(w) == 4) {
> +		asm volatile("movl %[w], %%eax" :: [w] "r" (w));
> +		alternative("call _hweight32",
> +			    "call _popcnt32",
> +			    X86_FEATURE_POPCNT);
> +		asm volatile("" : "=a" (w));
> +
> +	} else {
> +		asm volatile("movq %[w], %%rax" :: [w] "r" (w));
> +		alternative("call _hweight64",
> +			    "call _popcnt64",
> +			    X86_FEATURE_POPCNT);
> +		asm volatile("" : "=a" (w));
> +	}
> +	return w;
> +}

hweight_long() isn't an arch primitive, only __arch_hweight{8,16,32,64}
are.


