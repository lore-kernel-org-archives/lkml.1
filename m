Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYFRSFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYFRSFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 14:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYFRSFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 14:05:21 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:12058 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYFRSFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 14:05:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:reply-to:content-type
         :content-transfer-encoding;
        b=XZ7N8NPS0UIDieCk9ztWjTl9BkCUD/CKHK+OFrJlGkdr1gbhd/RD+OBhntWd4ZlUKx
         ZPMHYslrcAYWMGOab4MpXog4F/kugZhil2QPI+vLwsDoD0H536R8cmdBzdE5vk0+tRee
         7/Z/N0trkyet0INms/G6hKZ4VVhiN0IDQaTF0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: cleanup machine_specific_memory_setup
Date: Wed, 18 Jun 2008 11:06:08 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806161303.31997.yhlu.kernel@gmail.com> <200806161958.28627.yhlu.kernel@gmail.com>
In-Reply-To: <200806161958.28627.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806181106.08491.yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1. let 64bit support 88 and e801 too
2. introduce default_machine_specific_memory_setup, and reuse it
   for voyager

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c        |   13 +++++++------
 arch/x86/mach-voyager/setup.c |   32 +-------------------------------
 include/asm-x86/e820.h        |    1 +
 3 files changed, 9 insertions(+), 37 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1029,7 +1029,7 @@ void __init e820_reserve_resources(void)
 	}
 }
 
-char *__init __attribute__((weak)) machine_specific_memory_setup(void)
+char *__init default_machine_specific_memory_setup(void)
 {
 	char *who = "BIOS-e820";
 	int new_nr;
@@ -1045,10 +1045,7 @@ char *__init __attribute__((weak)) machi
 			&new_nr);
 	boot_params.e820_entries = new_nr;
 	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries) < 0) {
-#ifdef CONFIG_X86_64
-		early_panic("Cannot find a valid memory map");
-#else
-		unsigned long mem_size;
+		u64 mem_size;
 
 		/* compare results from other methods and take the greater */
 		if (boot_params.alt_mem_k
@@ -1063,13 +1060,17 @@ char *__init __attribute__((weak)) machi
 		e820.nr_map = 0;
 		e820_add_region(0, LOWMEMSIZE(), E820_RAM);
 		e820_add_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
-#endif
 	}
 
 	/* In case someone cares... */
 	return who;
 }
 
+char *__init __attribute__((weak)) machine_specific_memory_setup(void)
+{
+	return default_machine_specific_memory_setup();
+}
+
 /* Overridden in paravirt.c if CONFIG_PARAVIRT */
 char * __init __attribute__((weak)) memory_setup(void)
 {
Index: linux-2.6/arch/x86/mach-voyager/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-voyager/setup.c
+++ linux-2.6/arch/x86/mach-voyager/setup.c
@@ -104,35 +104,5 @@ char *__init machine_specific_memory_set
 		return who;
 	}
 
-	who = "BIOS-e820";
-
-	/*
-	 * Try to copy the BIOS-supplied E820-map.
-	 *
-	 * Otherwise fake a memory map; one section from 0k->640k,
-	 * the next section from 1mb->appropriate_mem_k
-	 */
-	new_nr = boot_params.e820_entries;
-	sanitize_e820_map(boot_params.e820_map,
-			ARRAY_SIZE(boot_params.e820_map),
-			&new_nr);
-	boot_params.e820_entries = new_nr;
-	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries)
-	    < 0) {
-		unsigned long mem_size;
-
-		/* compare results from other methods and take the greater */
-		if (boot_params.alt_mem_k < boot_params.screen_info.ext_mem_k) {
-			mem_size = boot_params.screen_info.ext_mem_k;
-			who = "BIOS-88";
-		} else {
-			mem_size = boot_params.alt_mem_k;
-			who = "BIOS-e801";
-		}
-
-		e820.nr_map = 0;
-		e820_add_region(0, LOWMEMSIZE(), E820_RAM);
-		e820_add_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
-	}
-	return who;
+	return default_machine_specific_memory_setup();
 }
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -102,6 +102,7 @@ extern u64 e820_hole_size(u64 start, u64
 extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
 extern void setup_memory_map(void);
+extern char *default_machine_specific_memory_setup(void);
 extern char *machine_specific_memory_setup(void);
 extern char *memory_setup(void);
