Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab0BNU2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 15:28:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:37636 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0BNU2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 15:28:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=horSqSBObP9hfxRbkbwefeh0Q+CVP78H2Ss74lAX5ZZ7qsZOw86SWR3IfAWzfHtQ0E
         H6aHJJvdYcpj+CI9+4R3m747YxQ/VP+lxEvIcy1+W1QytOowyaYn3NQMd2MDAGgPDPFQ
         uv1yUOBBtabCGjPKwXAkrvSNR6qBlP+f5E0Vw=
Date: Sun, 14 Feb 2010 21:28:41 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@amd64.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100214202841.GA25110@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Borislav Petkov <bp@amd64.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wu Fengguang <fengguang.wu@intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Jamie Lokier <jamie@shareable.org>,
	Roland Dreier <rdreier@cisco.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
References: <4B6C93A2.1090302@zytor.com>
 <20100206093659.GA28326@aftab>
 <4B6E1DA3.50204@zytor.com>
 <20100208092845.GB12618@a1.tnic>
 <4B6FDAED.9060204@zytor.com>
 <20100208095945.GA14740@a1.tnic>
 <20100211172424.GB19779@aftab>
 <1266142343.5273.419.camel@laptop>
 <20100214112447.GA8353@liondog.tnic>
 <4B7842C0.20701@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B7842C0.20701@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 10:36:48AM -0800, H. Peter Anvin wrote:
> On 02/14/2010 03:24 AM, Borislav Petkov wrote:
> > 
> > __const_hweightN - for at compile time known constants as arguments
> > __arch_hweightN - arch possibly has an optimized hweight version
> > __sw_hweightN - fall back when nothing else is there, aka the functions in
> > lib/hweight.c
> > 
> > Now, in the x86 case, when the compiler can't know that the argument is
> > a constant, we call the __arch_hweightN versions. The alternative does
> > call the __sw_hweightN version in case the CPU doesn't support popcnt.
> > In this case, we need to build __sw_hweightN with -fcall-saved* for gcc
> > to be able to take care of the regs clobbered ny __sw_hweightN.
> > 
> > So, if I understand you correctly, your suggestion might work, we
> > simply need to rename the lib/hweight.c versions to __sw_hweightN
> > and have <asm-generic/bitops/arch_hweight.h> have __arch_hweightN ->
> > __sw_hweightN wrappers in the default case, all arches which have an
> > optimized version will provide it in their respective bitops header...
> > 
> 
> I'm not entirely sure what you're asking; if what you're asking what to
> name an x86-specific fallback function, it presumably should be
> __arch_sw_hweightN (i.e. __arch prefix with a modifier.)

Hmm, basically, what PeterZ suggested is that I drop one indirection
under __arch_hweightN, which would make x86-specific fallback functions
superfluous.

IOW, what we have so far is:

#define hweightN(w) (__builtin_constant_p(w) ? __const_hweightN(w) : __arch_hweightN(w))

and have <asm-generic/bitops/arch_hweight.h> provide __arch_hweightN()
-> __sw_hweightN wrappers per default, where the __sw_hweightN are the
lib/hweight.c generic versions.

On architectures/CPUs which provide popcnt in
hardware, we create __arch_hweightN implementations in
<arch/[:ARCH_NAME:]/include/asm/bitops.h> overriding the
<asm-generic/bitops/arch_hweight.h> versions by simply not including
that last header.

Is that agreeable?

-- 
Regards/Gruss,
    Boris.
