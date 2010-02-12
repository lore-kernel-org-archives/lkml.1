Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab0BLRr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 12:47:56 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54922 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab0BLRry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 12:47:54 -0500
Date: Fri, 12 Feb 2010 18:47:51 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100212174751.GD3114@aftab>
References: <4B6C93A2.1090302@zytor.com>
 <20100206093659.GA28326@aftab>
 <4B6E1DA3.50204@zytor.com>
 <20100208092845.GB12618@a1.tnic>
 <4B6FDAED.9060204@zytor.com>
 <20100208095945.GA14740@a1.tnic>
 <20100211172424.GB19779@aftab>
 <4B743F7D.3090605@zytor.com>
 <20100212170649.GC3114@aftab>
 <4B758FC0.1020600@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B758FC0.1020600@zytor.com>
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

On Fri, Feb 12, 2010 at 09:28:32AM -0800, H. Peter Anvin wrote:
> On 02/12/2010 09:06 AM, Borislav Petkov wrote:
> > On Thu, Feb 11, 2010 at 09:33:49AM -0800, H. Peter Anvin wrote:
> >> You don't do the push/pop inline -- if you're going to take the hit of
> >> pushing this into the caller, it's better to list them as explicit
> >> clobbers and let the compiler figure out how to do it.  The point of
> >> doing an explicit push/pop is that it can be pushed into the out-of-line
> >> subroutine.
> > 
> > Doh! Of course, this was wrong. See below.
> > 
> > diff --git a/arch/x86/lib/hweight.c b/arch/x86/lib/hweight.c
> > new file mode 100644
> > index 0000000..9b4bfa5
> > --- /dev/null
> > +++ b/arch/x86/lib/hweight.c
> > @@ -0,0 +1,72 @@
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/bitops.h>
> > +
> > +#ifdef CONFIG_64BIT
> > +/* popcnt %rdi, %rax */
> > +#define POPCNT ".byte 0xf3\n\t.byte 0x48\n\t.byte 0x0f\n\t.byte 0xb8\n\t.byte 0xc7"
> > +#define REG_IN "D"
> > +#define REG_OUT "a"
> > +#else
> > +/* popcnt %eax, %eax */
> > +#define POPCNT ".byte 0xf3\n\t.byte 0x0f\n\t.byte 0xb8\n\t.byte 0xc0"
> > +#define REG_IN "a"
> > +#define REG_OUT "a"
> > +#endif
> > +
> > +/*
> > + * Those are called out-of-line in the alternative below and are added here only
> > + * so that gcc is able to figure out which registers have been clobbered by
> > + * __sw_hweightXX so that it could restore their values before returning from
> > + * the __arch_hweightXX versions. See also <arch/x86/lib/Makefile>.
> > + */
> > +unsigned int _sw_hweight32(unsigned int w)
> > +{
> > +	return __sw_hweight32(w);
> > +}
> > +
> > +unsigned long _sw_hweight64(__u64 w)
> > +{
> > +	return __sw_hweight64(w);
> > +}
> > +
> > +unsigned int __arch_hweight32(unsigned int w)
> > +{
> > +	unsigned int res = 0;
> > +
> > +	asm (ALTERNATIVE("call _sw_hweight32", POPCNT, X86_FEATURE_POPCNT)
> > +		     : "="REG_OUT (res)
> > +		     : REG_IN (w));
> > +
> 
> Now you have no clobbers and no assembly wrapper.  That really doesn't work.

I see, this means we have to build lib/hweight.c with -fcall-saved*. I
just did a test and it uses %rcx and %rdx temporarily by saving their
values on the stack and restoring them before it returns.

However, this is generic code and for the above to work we have to
enforce x86-specific CFLAGS for it. What is the preferred way to do
that?

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
