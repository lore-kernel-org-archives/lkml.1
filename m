Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbYFYMpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbYFYMpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbYFYMor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:44:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36165 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756582AbYFYMoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:44:46 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Wed, 25 Jun 2008 05:44:46 -0700
Message-Id: <20080625124446.25036.25226.sendpatchset@polaris-admin.engr.sgi.com>
In-Reply-To: <20080625124440.25036.96518.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080625124440.25036.96518.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 2/2] x86 boot: only pick up additional EFI memmap if add_efi_memmap flag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Applies on top of the previous patch:
  x86 boot: add code to add BIOS provided EFI memory entries to kernel

Instead of always adding EFI memory map entries (if present) to the
memory map after initially finding either E820 BIOS memory map entries
and/or kernel command line memmap entries, -instead- only add such
additional EFI memory map entries if the kernel boot option:

    add_efi_memmap

is specified.

Requiring this 'add_efi_memmap' option is backward compatible with
kernels that didn't load such additional EFI memory map entries in
the first place, and it doesn't override a configuration that tries
to replace all E820 or EFI BIOS memory map entries with ones given
entirely on the kernel command line.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 Documentation/kernel-parameters.txt |    3 +++
 Documentation/x86/x86_64/uefi.txt   |    4 ++++
 arch/x86/kernel/efi.c               |   16 ++++++++++++++--
 3 files changed, 21 insertions(+), 2 deletions(-)

--- linux-next.orig/Documentation/kernel-parameters.txt	2008-06-22 06:35:49.000000000 -0700
+++ linux-next/Documentation/kernel-parameters.txt	2008-06-24 18:33:57.233112308 -0700
@@ -2146,6 +2146,9 @@ and is between 256 and 4096 characters. 
 	usbhid.mousepoll=
 			[USBHID] The interval which mice are to be polled at.
 
+	add_efi_memmap	[EFI; x86-32,X86-64] Include EFI memory map in
+			kernel's map of available physical RAM.
+
 	vdso=		[X86-32,SH,x86-64]
 			vdso=2: enable compat VDSO (default with COMPAT_VDSO)
 			vdso=1: enable VDSO (default)
--- linux-next.orig/Documentation/x86/x86_64/uefi.txt	2008-06-22 06:35:49.000000000 -0700
+++ linux-next/Documentation/x86/x86_64/uefi.txt	2008-06-24 13:14:24.100601352 -0700
@@ -36,3 +36,7 @@ Mechanics:
   services.
 	noefi		turn off all EFI runtime services
 	reboot_type=k	turn off EFI reboot runtime service
+- If the EFI memory map has additional entries not in the E820 map,
+  you can include those entries in the kernels memory map of available
+  physical RAM by using the following kernel command line parameter.
+	add_efi_memmap	include EFI memory map of available physical RAM
--- linux-next.orig/arch/x86/kernel/efi.c	2008-06-22 06:40:10.000000000 -0700
+++ linux-next/arch/x86/kernel/efi.c	2008-06-24 13:14:51.830287173 -0700
@@ -64,6 +64,17 @@ static int __init setup_noefi(char *arg)
 }
 early_param("noefi", setup_noefi);
 
+int add_efi_memmap;
+EXPORT_SYMBOL(add_efi_memmap);
+
+static int __init setup_add_efi_memmap(char *arg)
+{
+	add_efi_memmap = 1;
+	return 0;
+}
+early_param("add_efi_memmap", setup_add_efi_memmap);
+
+
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
 	return efi_call_virt2(get_time, tm, tc);
@@ -219,7 +230,7 @@ unsigned long efi_get_time(void)
  * (zeropage) memory map.
  */
 
-static void __init add_efi_memmap(void)
+static void __init do_add_efi_memmap(void)
 {
 	void *p;
 
@@ -406,7 +417,8 @@ void __init efi_init(void)
 	if (memmap.desc_size != sizeof(efi_memory_desc_t))
 		printk(KERN_WARNING "Kernel-defined memdesc"
 		       "doesn't match the one from EFI!\n");
-	add_efi_memmap();
+	if (add_efi_memmap)
+		do_add_efi_memmap();
 
 	/* Setup for EFI runtime service */
 	reboot_type = BOOT_EFI;

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
