Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbYKIPKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbYKIPKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 10:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbYKIPKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 10:10:36 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:57370 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbYKIPKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 10:10:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j8bwg4xJqT+suSttFqQqFvhXxVMdTac6M27lFDTy8Ci44e3fDt0+llNvHwlpFVDyQ4
         Un7V7cjFKBY/n+wysWuSVVRhCk9l9ozW6leLio8vuyxLiAjEyBKOBjElba5qRTwCIyA1
         6c5GwyGC+aZfaif4geR8YL16ABTdja1EjaYJo=
Message-ID: <a6b9f31a0811090710y17e956bawf20675d6678b145e@mail.gmail.com>
Date: Mon, 10 Nov 2008 00:10:34 +0900
From: "Hitoshi Mitake" <h.mitake@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Cc: "Hitoshi Mitake" <mitake@clustcom.com>, "Doug Thompson" <norsk5@yahoo.com>,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org,
       ktaka@clustcom.com
In-Reply-To: <20081106231102.aab83cd4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081105222911.d76e7e1c.mitake@clustcom.com>
	 <413709.12821.qm@web50106.mail.re2.yahoo.com>
	 <20081106164641.ed369060.akpm@linux-foundation.org>
	 <20081107152830.a42766f3.mitake@clustcom.com>
	 <20081106223122.8a255211.akpm@linux-foundation.org>
	 <20081107153824.0ec934e6.mitake@clustcom.com>
	 <20081106231102.aab83cd4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm a same person as mitake@clustcom.com. h.mitake@gmail.com is my
private mail address.

On Fri, Nov 7, 2008 at 4:11 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 7 Nov 2008 15:38:24 +0000 Hitoshi Mitake <mitake@clustcom.com> wrote:
>
>>
>> This patch makes x38_edac.c to use kernel's
>> readq() function when it is compiled for x86_64.
>>
>> Signed-off-by: Hitoshi Mitake <mitake@clustcom.com>
>> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
>> ---
>>
>> Index: linux-2.6.28-rc3-git2/drivers/edac/Kconfig
>> ===================================================================
>> --- linux-2.6.28-rc3-git2.orig/drivers/edac/Kconfig   2008-11-07 11:27:05.000000000 +0000
>> +++ linux-2.6.28-rc3-git2/drivers/edac/Kconfig        2008-11-07 11:27:14.000000000 +0000
>> @@ -104,7 +104,7 @@
>>
>>  config EDAC_X38
>>       tristate "Intel X38"
>> -     depends on EDAC_MM_EDAC && PCI && X86
>> +     depends on EDAC_MM_EDAC && PCI && (X86 || X86_64)
>
> CONFIG_X86 is true for both CONFIG_X86_32=y amek CONFIG_X86_64=y, so
> this change isn't needed.  I'll fix that up.

Thanks for your fix up. This was redundancy, I should not change that point...

>
>> --- linux-2.6.28-rc3-git2.orig/drivers/edac/x38_edac.c        2008-11-07 11:27:06.000000000 +0000
>> +++ linux-2.6.28-rc3-git2/drivers/edac/x38_edac.c     2008-11-07 11:27:29.000000000 +0000
>> @@ -162,10 +162,12 @@
>>                        X38_ERRSTS_BITS);
>>  }
>>
>> -static u64 x38_readq(const void __iomem *addr)
>> +#ifndef CONFIG_X86_64
>> +static u64 readq(const void __iomem *addr)
>
> hm, it'd be nice if there was some more general way of determining
> whether the architecture provides readq/writeq.
>


I found this code in include/asm-x86/io.h

#ifdef CONFIG_X86_64

...

/* Let people know we have them */
#define readq readq
#define writeq writeq
#endif

x86 programmers are able to know existence of readq/writeq by using
this definition.

And I grepped,

% grep readq `find include/asm-* -name "*.h"`
include/asm-mips/io.h:			".set	mips3"		"\t\t# __readq"	"\n\t"	\
include/asm-mips/io.h:#define readq_relaxed			readq
include/asm-mips/io.h:#define readq				readq
include/asm-mips/txx9/tx4927.h:	((__u32)__raw_readq(&tx4927_ccfgptr->crir)
>> 16)
include/asm-mips/txx9/tx4927.h:#define
TX4927_SDRAMC_CR(ch)	__raw_readq(&tx4927_sdramcptr->cr[(ch)])
include/asm-mips/txx9/tx4927.h:#define
TX4927_EBUSC_CR(ch)	__raw_readq(&tx4927_ebuscptr->cr[(ch)])
include/asm-mips/txx9/tx4927.h:	____raw_writeq(____raw_readq(adr) & ~bits, adr);
include/asm-mips/txx9/tx4927.h:	____raw_writeq(____raw_readq(adr) | bits, adr);
include/asm-mips/txx9/tx4927.h:	____raw_writeq(____raw_readq(&tx4927_ccfgptr->ccfg)
include/asm-mips/txx9/tx4927.h:	____raw_writeq((____raw_readq(&tx4927_ccfgptr->ccfg)
include/asm-mips/txx9/tx4927.h:	____raw_writeq((____raw_readq(&tx4927_ccfgptr->ccfg)
include/asm-mips/txx9/tx4938.h:	((__u32)__raw_readq(&tx4938_ccfgptr->crir)
>> 16)
include/asm-parisc/io.h:static inline unsigned long long
gsc_readq(unsigned long addr)
include/asm-parisc/io.h:static inline unsigned long long
__raw_readq(const volatile void __iomem *addr)
include/asm-parisc/io.h:#define readq(addr) __fswab64(__raw_readq(addr))
include/asm-parisc/io.h:#define readq_relaxed(addr) readq(addr)
include/asm-x86/io.h:build_mmio_read(readq, "q", unsigned long, "=r", :"memory")
include/asm-x86/io.h:build_mmio_read(__readq, "q", unsigned long, "=r", )
include/asm-x86/io.h:#define readq_relaxed(a) __readq(a)
include/asm-x86/io.h:#define __raw_readq __readq
include/asm-x86/io.h:#define readq readq

It seems that architectures that provide readq/writeq are
mips, parisc and x86 (and x86_64).

mips and x86 provides this line
#define readq readq
to let user know existence of readq (and writeq),
and parisc doesn't provide.
But there is,
#define readq(addr) __fswab64(__raw_readq(addr))
in parisc.

There is a difference between mips and x86's readq/writeq and
parisc's readq/writeq. mips and x86's definition is only token,
but parisc's definition is macro function.

But these defines can be used to determine existence of readq/writeq
by common preprocessor like this,
#ifndef readq
/* programmer can define private version of readq (or writeq) */
#endif

Is this way enough general for our requirement?
(If we use this as general way to determine existence of readq/writeq,
I want other architecture's developer (whose architecture provides
readq/writeq in the future)
to support same way.)
