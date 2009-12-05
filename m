Return-Path: <linux-kernel-owner+w=401wt.eu-S932880AbZLESxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbZLESxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 13:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbZLESxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 13:53:21 -0500
Received: from mail.codesourcery.com ([38.113.113.100]:55628 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877AbZLESxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 13:53:13 -0500
Message-ID: <4B1AAC16.5030107@codesourcery.com>
Date: Sat, 05 Dec 2009 21:53:10 +0300
From: Maxim Kuvyrkov <maxim@codesourcery.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Ungerer <gerg@snapgear.com>, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       uClinux development list <uclinux-dev@uclinux.org>
Subject: Re: M68k tree updates
References: <alpine.DEB.2.00.0911252213340.31650@ayla.of.borg>	 <4B13CC00.9080607@codesourcery.com> <10f740e80912041157j41984f4ay6ca2e56d70ac08e2@mail.gmail.com>
In-Reply-To: <10f740e80912041157j41984f4ay6ca2e56d70ac08e2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Mon, Nov 30, 2009 at 14:43, Maxim Kuvyrkov <maxim@codesourcery.com> wrote:
>> Geert Uytterhoeven wrote:
>>> It took me a while, but finally I managed to update
>>> http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git again.
>> ...
>>> If anything is missing, please tell me. Thx!
>> How about the NPTL patch (0001-Add-NPTL-support-for-m68k.patch,
>> http://marc.info/?l=linux-m68k&m=125447760017098&w=2)?
> 
> As you're adding syscalls (which are shared with m68knommu), I'll have
> to ask whether
> you will make it work on nommu, too?

Yes, that's quite straight-forward so I'll try to post the patch tomorrow.

> 
> Furthermore, when building for Sun3:
> 
> arch/m68k/kernel/sys_m68k.c:706: warning: passing argument 1 of
> 'kunmap' from incompatible pointer type
> arch/m68k/kernel/sys_m68k.c:714: warning: passing argument 1 of
> 'kunmap' from incompatible pointer type
> 
> Which looks like a problem with the Sun 3 version of pte_unmap().

Right.  Sun3's implementation assumes that one can cast between (pte_t 
*) and pgtable_t interchangeably; fwiw, I don't know if this is the case.

> 
> I'm gonna add it to the m68k tree though, unless someone complains.

Thanks!

> 
>> Also, this trivial fix (0004-Fix-m68k-s-asm-swab.h-for-ColdFire.patch,
>> http://marc.info/?l=linux-m68k&m=125447494213740&w=2) can go in.
> 
> I want to run this one by the nommu people as well...

To illustrate the problem more clearly, here is the code that the patch 
fixes:

#if defined (__mcfisaaplus__) || defined (__mcfisac__)
static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
{
	__asm__("byterev %0" : "=d" (val) : "0" (val));
	return val;
}

#define __arch_swab32 __arch_swab32
#elif !defined(__uClinux__)

static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
{
	__asm__("rolw #8,%0; swap %0; rolw #8,%0" : "=d" (val) : "0" (val));
	return val;
}
#define __arch_swab32 __arch_swab32
#endif

As far as I know, all non-ColdFire CPUs support rolw instruction, so 
enabling it for uClinux should not be a problem.  Regarding the ColdFire 
  CPUs, none of the CF ISAs include rolw, so the patch fixes the case of 
building the kernel for MMU Linux ISA_B CPU, e.g., mcf547x/8x family.

-- 
Maxim Kuvyrkov
CodeSourcery
maxim@codesourcery.com
(650) 331-3385 x724
