Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbZB1Q0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbZB1Q0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 11:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZB1Q03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 11:26:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33769 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbZB1Q02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 11:26:28 -0500
Message-ID: <49A965AD.10701@redhat.com>
Date: Sat, 28 Feb 2009 11:26:21 -0500
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix e820 end address with EFI
Content-Type: multipart/mixed;
 boundary="------------080503090003010201090000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080503090003010201090000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


    On some EFI systems (i.e. Apple) EFI runtime is mapped into higher mem
regions. These EFI mem regions are not always taken into consideration when
max_pfn is calculated in setup.c being that e820_end_of_ram_pfn() only 
counts
mappings types marked as usable (E820_RAM). Currently we only count to 
the last
usable e820 address range and nothing beyond. EFI can be mapped anywhere 
within
e820 and is not always marked as usable e820, and so EFI runtime may be 
missed
if mapped somewhere beyond last usable e820. This patch attempts to resolve
this problem by including all E820 mappings when EFI is enabled, so that
the entire e820 (and EFI runtime area) is included in computing max_pfn. 
Tested
on a MacBook Pro 3.1 and resolves the issue (system now boots 
w/elilo+grub & EFI).

Signed-off-by: Brian Maly <bmaly@redhat>


e820.c |   13 +++++++++++--
1 file changed, 11 insertions(+), 2 deletions(-)




--------------080503090003010201090000
Content-Type: text/x-patch;
 name="apple-include-efi-runtime-in-e820_end-2.6.29.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="apple-include-efi-runtime-in-e820_end-2.6.29.patch"


--- a/arch/x86/kernel/e820.c	2009-02-08 15:37:27.000000000 -0500
+++ b/arch/x86/kernel/e820.c	2009-02-28 07:20:09.000000000 -0500
@@ -51,6 +51,10 @@ unsigned long pci_mem_start = 0xaeedbabe
 EXPORT_SYMBOL(pci_mem_start);
 #endif
 
+#ifdef CONFIG_EFI
+extern int efi_enabled;
+#endif
+
 /*
  * This function checks if any part of the range <start,end> is mapped
  * with type.
@@ -1071,7 +1075,7 @@ static unsigned long __init e820_end_pfn
 		unsigned long start_pfn;
 		unsigned long end_pfn;
 
-		if (ei->type != type)
+		if (type && (ei->type != type))
 			continue;
 
 		start_pfn = ei->addr >> PAGE_SHIFT;
@@ -1096,7 +1100,12 @@ static unsigned long __init e820_end_pfn
 }
 unsigned long __init e820_end_of_ram_pfn(void)
 {
-	return e820_end_pfn(MAX_ARCH_PFN, E820_RAM);
+#ifdef CONFIG_EFI
+	if (efi_enabled)
+		return e820_end_pfn(MAX_ARCH_PFN, NULL);
+	else
+#endif
+		return e820_end_pfn(MAX_ARCH_PFN, E820_RAM);
 }
 
 unsigned long __init e820_end_of_low_ram_pfn(void)

--------------080503090003010201090000--
