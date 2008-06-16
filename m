Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbYFPGa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbYFPGa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYFPGaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:30:30 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54215 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755675AbYFPG35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:29:57 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Sun, 15 Jun 2008 23:29:56 -0700
Message-Id: <20080616062956.14597.10460.sendpatchset@polaris-admin.engr.sgi.com>
In-Reply-To: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 3/8] x86 boot: x86_64 efi compiler warning fix
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
