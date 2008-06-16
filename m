Return-Path: <linux-kernel-owner+w=401wt.eu-S1759764AbYFPGbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764AbYFPGbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757812AbYFPGac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:30:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50332 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757297AbYFPGaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:30:02 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Sun, 15 Jun 2008 23:30:01 -0700
Message-Id: <20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
In-Reply-To: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap memory ranges
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

In order to support EFI firmware which places the EFI memmap within
the EBDA (Extended BIOS Data Area), allow for the possibility that we
might try to reserve_early() the "EFI memmap" area twice, once as part
of the larger EBDA area and once by itself.  Since the reserve_early()
mechanism does not allow such double reservations, detect and avoid the
"EFI memmap" reserve_early() call if it would overlap the EBDA area.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/efi.c       |    3 ++-
 arch/x86/kernel/head.c      |   12 +++++++++++-
 include/asm-x86/bios_ebda.h |    1 +
 include/asm-x86/e820.h      |    1 +
 4 files changed, 15 insertions(+), 2 deletions(-)

--- linux.orig/arch/x86/kernel/efi.c	2008-06-13 00:51:17.350774123 -0700
+++ linux/arch/x86/kernel/efi.c	2008-06-13 00:53:10.053599898 -0700
@@ -253,7 +253,8 @@ void __init efi_reserve_early(void)
 		boot_params.efi_info.efi_memdesc_size;
 	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
 	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
-	reserve_early(pmap, pmap + memmap.nr_map * memmap.desc_size,
+	if (!range_in_ebda_area(pmap, pmap + memmap.nr_map * memmap.desc_size))
+		reserve_early(pmap, pmap + memmap.nr_map * memmap.desc_size,
 		      "EFI memmap");
 }
 
--- linux.orig/arch/x86/kernel/head.c	2008-06-13 00:51:17.350774123 -0700
+++ linux/arch/x86/kernel/head.c	2008-06-13 00:52:45.208095174 -0700
@@ -6,6 +6,9 @@
 
 #define BIOS_LOWMEM_KILOBYTES 0x413
 
+static unsigned int __initdata ebda_start;
+static unsigned int __initdata ebda_end;
+
 /*
  * The BIOS places the EBDA/XBDA at the top of conventional
  * memory, and usually decreases the reported amount of
@@ -51,7 +54,14 @@ void __init reserve_ebda_region(void)
 		lowmem = 0x9f000;
 
 	/* reserve all memory between lowmem and the 1MB mark */
-	reserve_early(lowmem, 0x100000, "BIOS reserved");
+	ebda_start = lowmem;
+	ebda_end = 0x100000;
+	reserve_early(ebda_start, ebda_end, "BIOS reserved");
+}
+
+int __init range_in_ebda_area(u64 start, u64 end)
+{
+	return start >= ebda_start && end <= ebda_end;
 }
 
 void __init reserve_setup_data(void)
--- linux.orig/include/asm-x86/bios_ebda.h	2008-06-13 00:51:17.350774123 -0700
+++ linux/include/asm-x86/bios_ebda.h	2008-06-13 00:51:31.819650439 -0700
@@ -15,5 +15,6 @@ static inline unsigned int get_bios_ebda
 }
 
 void reserve_ebda_region(void);
+int range_in_ebda_area(u64 start, u64 end);
 
 #endif /* _MACH_BIOS_EBDA_H */
--- linux.orig/include/asm-x86/e820.h	2008-06-13 00:51:17.354774365 -0700
+++ linux/include/asm-x86/e820.h	2008-06-13 00:51:31.831651166 -0700
@@ -84,6 +84,7 @@ extern unsigned long end_user_pfn;
 extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
 extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
 extern void reserve_early(u64 start, u64 end, char *name);
+extern int range_in_ebda_area(u64 start, u64 end);
 extern void free_early(u64 start, u64 end);
 extern void early_res_to_bootmem(u64 start, u64 end);
 extern int page_is_reserved_early(unsigned long pagenr);

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
