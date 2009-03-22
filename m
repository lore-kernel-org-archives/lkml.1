Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZCVVs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZCVVs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 17:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbZCVVsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 17:48:47 -0400
Received: from gw.goop.org ([64.81.55.164]:44311 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbZCVVsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 17:48:47 -0400
Message-ID: <49C6B23C.2040308@goop.org>
Date: Sun, 22 Mar 2009 14:48:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <20090322150917.GA17815@elte.hu> <49C6719B.2020303@goop.org> <20090322172217.GA22639@elte.hu>
In-Reply-To: <20090322172217.GA22639@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> last entry seemed to be related to the brk patches:
>
>   
>> WARNING: vmlinux.o(.text+0x6a288e): Section mismatch in reference from
>> the function dmi_alloc() to the function .init.text:extend_brk()
>> The function dmi_alloc() references
>> the function __init extend_brk().
>> This is often because dmi_alloc lacks a __init annotation or the
>> annotation of extend_brk is wrong.
>>     
>
> most of them are not.
>   

Hm, dmi_alloc() is a static inline which simply calls extend_brk(), so 
it should be a non-issue.  Does this fix it?

    J

>From 382f0ea466d1b831f87b5dc84d418c2f5b3881c1 Mon Sep 17 00:00:00 2001
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Sun, 22 Mar 2009 14:46:09 -0700
Subject: [PATCH] x86/dmi: fix dmi_alloc() section mismatches

Impact: section mismatch fix

Ingo reports these warnings:
> WARNING: vmlinux.o(.text+0x6a288e): Section mismatch in reference from
> the function dmi_alloc() to the function .init.text:extend_brk()
> The function dmi_alloc() references
> the function __init extend_brk().
> This is often because dmi_alloc lacks a __init annotation or the
> annotation of extend_brk is wrong.

dmi_alloc() is a static inline, and so should be immune to this
kind of error.  But force it to be inlined and make it __init
anyway, just to be extra sure.

All of dmi_alloc()'s callers are already __init.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/dmi.h b/arch/x86/include/asm/dmi.h
index aa32f7e..fd8f9e2 100644
--- a/arch/x86/include/asm/dmi.h
+++ b/arch/x86/include/asm/dmi.h
@@ -1,10 +1,13 @@
 #ifndef _ASM_X86_DMI_H
 #define _ASM_X86_DMI_H
 
+#include <linux/compiler.h>
+#include <linux/init.h>
+
 #include <asm/io.h>
 #include <asm/setup.h>
 
-static inline void *dmi_alloc(unsigned len)
+static __always_inline __init void *dmi_alloc(unsigned len)
 {
 	return extend_brk(len, sizeof(int));
 }


