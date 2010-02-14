Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab0BNLY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 06:24:56 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:57050 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab0BNLYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 06:24:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=x1gpjycz7pj9XH9NAIXKgViBt09dvUWUQS91AsEPH5zfPqqf0ytL3OHNgQ3n/6ed3v
         1boixngIULJI40nBva87TF4q4VgLKEl8N6EYJ0Z6gikTJVMYQraLesn61neNUiFC1ZWp
         MXNZzGVcMPikH9l0Rk7gh41p8r0LxjzCZvkR8=
Date: Sun, 14 Feb 2010 12:24:47 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100214112447.GA8353@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wu Fengguang <fengguang.wu@intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Jamie Lokier <jamie@shareable.org>,
	Roland Dreier <rdreier@cisco.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
References: <1265299457.22001.72.camel@laptop>
 <20100205121139.GA9044@aftab>
 <4B6C93A2.1090302@zytor.com>
 <20100206093659.GA28326@aftab>
 <4B6E1DA3.50204@zytor.com>
 <20100208092845.GB12618@a1.tnic>
 <4B6FDAED.9060204@zytor.com>
 <20100208095945.GA14740@a1.tnic>
 <20100211172424.GB19779@aftab>
 <1266142343.5273.419.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1266142343.5273.419.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 11:12:23AM +0100, Peter Zijlstra wrote:
> On Thu, 2010-02-11 at 18:24 +0100, Borislav Petkov wrote:
> > On Mon, Feb 08, 2010 at 10:59:45AM +0100, Borislav Petkov wrote:
> > > Let me prep another version when I get back on Wed. (currently
> > > travelling) with all the stuff we discussed to see how it would turn.
> > 
> > Ok, here's another version ontop of PeterZ's patch at
> > http://lkml.org/lkml/2010/2/4/119. I need to handle 32- and 64-bit
> > differently wrt to popcnt opcode so on 32-bit I do "popcnt %eax, %eax"
> > while on 64-bit I do "popcnt %rdi, %rdi".
> 
> Right, so I don't like how you need to touch !x86 for this, and I think
> that is easily avoidable by not making x86 include
> asm-generic/bitops/arch_hweight.h.
> 
> If you then add __sw_hweightN() -> __arch_hweightN() wrappers in
> arch_hweight.h, then you can leave const_hweight.h use __arch_hweightN()
> and simply provide __arch_hweightN() from x86/include/asm/bitops.h

Hmm, all these different names start to get a little confusing. Can we first
agree on the naming please, here's my proposal:

__const_hweightN - for at compile time known constants as arguments
__arch_hweightN - arch possibly has an optimized hweight version
__sw_hweightN - fall back when nothing else is there, aka the functions in
lib/hweight.c

Now, in the x86 case, when the compiler can't know that the argument is
a constant, we call the __arch_hweightN versions. The alternative does
call the __sw_hweightN version in case the CPU doesn't support popcnt.
In this case, we need to build __sw_hweightN with -fcall-saved* for gcc
to be able to take care of the regs clobbered ny __sw_hweightN.

So, if I understand you correctly, your suggestion might work, we
simply need to rename the lib/hweight.c versions to __sw_hweightN
and have <asm-generic/bitops/arch_hweight.h> have __arch_hweightN ->
__sw_hweightN wrappers in the default case, all arches which have an
optimized version will provide it in their respective bitops header...

Hows that?

-- 
Regards/Gruss,
    Boris.
