Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbYDSPJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbYDSPJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762304AbYDSPH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:07:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:10983 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758282AbYDSPHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=bItsruNNHv5x0mJj7a44+L1zaO0C+3g1hJte2ZyOVqPiRZ6bWlIGGLNogIiQLOGY/eKkk2GsuhKQpS/pZ2E5k4FR/rg4hVJ0E3ZLKkMpvXbhNhmhHbCUq1/gtfHKz0h1v3bdOlHqD5ZP2TyynlqpsiDhKTwlIoeCQQxy/WeSct4=
References: <20080419145510.150338641@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 19 Apr 2008 23:55:20 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 10/10] x86: use get_bios_ebda()
Content-Disposition: inline; filename=x86-use-get-bios-ebda-3.patch
Message-ID: <480a0aaa.1e068e0a.1c13.ffff8669@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_bios_ebda().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/head64.c    |    5 ++---
 arch/x86/kernel/setup_32.c  |    4 +---
 arch/x86/kernel/summit_32.c |    5 +++--
 3 files changed, 6 insertions(+), 8 deletions(-)

Index: 2.6-git/arch/x86/kernel/summit_32.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/summit_32.c
+++ 2.6-git/arch/x86/kernel/summit_32.c
@@ -29,6 +29,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <asm/io.h>
+#include <asm/bios_ebda.h>
 #include <asm/mach-summit/mach_mpparse.h>
 
 static struct rio_table_hdr *rio_table_hdr __initdata;
@@ -140,8 +141,8 @@ void __init setup_summit(void)
 	int			i, next_wpeg, next_bus = 0;
 
 	/* The pointer to the EBDA is stored in the word @ phys 0x40E(40:0E) */
-	ptr = *(unsigned short *)phys_to_virt(0x40Eul);
-	ptr = (unsigned long)phys_to_virt(ptr << 4);
+	ptr = get_bios_ebda();
+	ptr = (unsigned long)phys_to_virt(ptr);
 
 	rio_table_hdr = NULL;
 	offset = 0x180;
Index: 2.6-git/arch/x86/kernel/head64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/head64.c
+++ 2.6-git/arch/x86/kernel/head64.c
@@ -22,6 +22,7 @@
 #include <asm/sections.h>
 #include <asm/kdebug.h>
 #include <asm/e820.h>
+#include <asm/bios_ebda.h>
 
 static void __init zap_identity_mappings(void)
 {
@@ -49,7 +50,6 @@ static void __init copy_bootdata(char *r
 	}
 }
 
-#define BIOS_EBDA_SEGMENT 0x40E
 #define BIOS_LOWMEM_KILOBYTES 0x413
 
 /*
@@ -80,8 +80,7 @@ static void __init reserve_ebda_region(v
 	lowmem <<= 10;
 
 	/* start of EBDA area */
-	ebda_addr = *(unsigned short *)__va(BIOS_EBDA_SEGMENT);
-	ebda_addr <<= 4;
+	ebda_addr = get_bios_ebda();
 
 	/* Fixup: bios puts an EBDA in the top 64K segment */
 	/* of conventional memory, but does not adjust lowmem. */
Index: 2.6-git/arch/x86/kernel/setup_32.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/setup_32.c
+++ 2.6-git/arch/x86/kernel/setup_32.c
@@ -388,7 +388,6 @@ unsigned long __init find_max_low_pfn(vo
 	return max_low_pfn;
 }
 
-#define BIOS_EBDA_SEGMENT 0x40E
 #define BIOS_LOWMEM_KILOBYTES 0x413
 
 /*
@@ -419,8 +418,7 @@ static void __init reserve_ebda_region(v
 	lowmem <<= 10;
 
 	/* start of EBDA area */
-	ebda_addr = *(unsigned short *)__va(BIOS_EBDA_SEGMENT);
-	ebda_addr <<= 4;
+	ebda_addr = get_bios_ebda();
 
 	/* Fixup: bios puts an EBDA in the top 64K segment */
 	/* of conventional memory, but does not adjust lowmem. */

-- 
