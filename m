Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYIHTK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYIHTK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbYIHTKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:10:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56036 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbYIHTKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:10:11 -0400
Message-ID: <48C57884.30607@zytor.com>
Date: Mon, 08 Sep 2008 12:09:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org> <20080908170029.GP26079@one.firstfloor.org> <alpine.LFD.1.10.0809081000490.3117@nehalem.linux-foundation.org> <48C55C0A.7070203@zytor.com> <alpine.LFD.1.10.0809081028590.3117@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809081028590.3117@nehalem.linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------010702050100020905080201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010702050100020905080201
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
>>>
>> Yes, it does:
>>
>>   /* We need to decide which NOP sequence to use for 32bit and
>>      64bit. When -mtune= is used:
>>
>>      1. For PROCESSOR_I386, PROCESSOR_I486, PROCESSOR_PENTIUM and
>>      PROCESSOR_GENERIC32, f32_patt will be used.
>>      2. For PROCESSOR_PENTIUMPRO, PROCESSOR_PENTIUM4, PROCESSOR_NOCONA,
>>      PROCESSOR_CORE, PROCESSOR_CORE2, and PROCESSOR_GENERIC64,
>>      alt_long_patt will be used.
>>      3. For PROCESSOR_ATHLON, PROCESSOR_K6, PROCESSOR_K8 and
>>      PROCESSOR_AMDFAM10, alt_short_patt will be used.
>>
>>      When -mtune= isn't used, alt_long_patt will be used if
>>      cpu_arch_isa_flags has Cpu686. Otherwise, f32_patt will
>>      be used.
>>
>> "alt_long_patt" uses NOPL and its variants.
> 
> That is A TOTAL PIECE OF SH*T, and against gcc's own documentation.
> 
> "-mtune=x" is very much defined to be a performance _tuning_ option, not 
> an "architectural" option. 
> 
> Quite frankly, this is a gcc bug. Plain and simple. 
> 

OK, digging some more into this garbage...

Apparently the situation isn't quite as dire as it first seems.
At least gcc 4.3.0 doesn't actually pass -mtune= to gas; it just drops 
the option on the floor.  This means this bug isn't manifest when 
calling from gcc (as opposed to invoking as directly.)

However, I would still like to push the following patch to be on the 
safe side, ok?

	-hpa


--------------010702050100020905080201
Content-Type: text/x-patch;
 name="0002-x86-prevent-binutils-from-being-smart-and-generat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0002-x86-prevent-binutils-from-being-smart-and-generat.patch"

>From 0fbbf1008e5177677dbdb6292d94ec40df965d82 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Mon, 8 Sep 2008 12:01:48 -0700
Subject: [PATCH] x86: prevent binutils from being "smart" and generating NOPLs for us

binutils, contrary to documented behaviour, will generate long NOPs (a
P6-or-higher instruction which is broken on at least some VIA chips,
Virtual PC/Virtual Server, and some versions of Qemu) depending on the
-mtune= option, which is not supposed to change architectural
behaviour.

Pass an explicit override to the assembler, in case ends up passing
the -mtune= parameter to gas (gcc 4.3.0 does not appear to.)

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Makefile_32.cpu |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index e372b58..b72b4f7 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -45,3 +45,8 @@ cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
 # cpu entries
 cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
 
+# Bug fix for binutils: this option is required in order to keep
+# binutils from generating NOPL instructions against our will.
+ifneq ($(CONFIG_X86_P6_NOP),y)
+cflags-y			+= $(call cc-option,-Wa$(comma)-mtune=generic32,)
+endif
-- 
1.5.5.1


--------------010702050100020905080201--
