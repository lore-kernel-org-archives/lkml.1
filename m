Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYFVOXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYFVOXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbYFVOWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:22:06 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34846 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755372AbYFVOWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:22:04 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Sun, 22 Jun 2008 07:22:02 -0700
Message-Id: <20080622142202.5591.32443.sendpatchset@polaris-admin.engr.sgi.com>
In-Reply-To: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 2/5 v2] x86 boot: x86_64 efi compiler warning fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Fix a compiler warning.  Rather than always casting a u32 to a pointer
(which generates a warning on x86_64 systems) instead separate the
x86_32 and x86_64 assignments entirely with ifdefs.  Until other recent
changes to this code, it used to have x86_64 separated like this.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/efi.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- linux.orig/arch/x86/kernel/efi.c	2008-06-12 17:18:57.000000000 -0700
+++ linux/arch/x86/kernel/efi.c	2008-06-12 17:32:14.984928792 -0700
@@ -242,9 +242,11 @@ void __init efi_reserve_early(void)
 {
 	unsigned long pmap;
 
+#ifdef CONFIG_X86_32
 	pmap = boot_params.efi_info.efi_memmap;
-#ifdef CONFIG_X86_64
-	pmap += (__u64)boot_params.efi_info.efi_memmap_hi << 32;
+#else
+	pmap = (boot_params.efi_info.efi_memmap |
+		((__u64)boot_params.efi_info.efi_memmap_hi<<32));
 #endif
 	memmap.phys_map = (void *)pmap;
 	memmap.nr_map = boot_params.efi_info.efi_memmap_size /
@@ -284,10 +286,12 @@ void __init efi_init(void)
 	int i = 0;
 	void *tmp;
 
+#ifdef CONFIG_X86_32
 	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
-#ifdef CONFIG_X86_64
-	efi_phys.systab = (void *)efi_phys.systab +
-		((__u64)boot_params.efi_info.efi_systab_hi<<32);
+#else
+	efi_phys.systab = (efi_system_table_t *)
+		(boot_params.efi_info.efi_systab |
+		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
 #endif
 
 	efi.systab = early_ioremap((unsigned long)efi_phys.systab,

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
