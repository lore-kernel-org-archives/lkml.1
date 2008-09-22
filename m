Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbYIVNfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbYIVNfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYIVNfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:35:45 -0400
Received: from sh.osrg.net ([192.16.179.4]:47826 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYIVNfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:35:45 -0400
Date: Mon, 22 Sep 2008 22:35:08 +0900
To: joerg.roedel@amd.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] AMD IOMMU: revert "x86, AMD IOMMU: honor iommu=off instead
 of amd_iommu=off"
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080922223457W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against tip/x86/iommu.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] AMD IOMMU: revert "x86, AMD IOMMU: honor iommu=off instead of amd_iommu=off"

This reverts:

commit 8b14518fadd9d5915827d86d5c10e602fedf042e
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Jul 3 19:35:09 2008 +0200

    x86, AMD IOMMU: honor iommu=off instead of amd_iommu=off

    This patch removes the amd_iommu=off kernel parameter and honors the generic

    iommu=off parameter for the same purpose.


The above commit is wrong.

amd_iommu=off kernel parameter and the generic iommu=off parameter
don't have the same purpose.

Intel IOMMU also has 'off' option as Intel IOMMU specific parameter
(intel_iommu=off) like AMD IOMMU had. intel_iommu=off parameter
for disabling Intel IOMMU.

The generic iommu=off parameter means that the kernel doesn't use any
kind of IOMMU, including SWIOTLB (as documented). So you can't use the
generic iommu=off parameter to disable hardware IOMMU if you use a box
with max_pfn > MAX_DMA32_PFN. It's is a critical difference.

Seems that amd_iommu=off parameter worked in the exact same way as
intel_iommu=off works (though I might be wrong since I can't confirm
this with AMD IOMMU). So the above commit removed the useful feature
to disalbe AMD IOMMU safely.

I'm not sure what the maintainer wanted to do with the commit so I
can't say that the commit (to remove the above feature) is a bug or
regression. I'll leave this issue to the maintainer but at least the
description of how the IOMMU options works is wrong.

Note that this patch is not a simple revert patch due to some
modifications after the above commit.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/kernel-parameters.txt |    1 +
 arch/x86/kernel/amd_iommu_init.c    |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 569527e..feddbb7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -281,6 +281,7 @@ and is between 256 and 4096 characters. It is defined in the file
 	amd_iommu=	[HW,X86-84]
 			Pass parameters to the AMD IOMMU driver in the system.
 			Possible values are:
+			off     - disable AMD IOMMU driver
 			isolate - enable device isolation (each device, as far
 			          as possible, will get its own protection
 			          domain)
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index db0c83a..a71beb4 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -115,6 +115,7 @@ struct ivmd_header {
 } __attribute__((packed));
 
 static int __initdata amd_iommu_detected;
+static int __initdata amd_iommu_disable;
 
 u16 amd_iommu_last_bdf;			/* largest PCI device id we have
 					   to handle */
@@ -1037,7 +1038,7 @@ int __init amd_iommu_init(void)
 	int i, ret = 0;
 
 
-	if (no_iommu) {
+	if (no_iommu || amd_iommu_disable) {
 		printk(KERN_INFO "AMD IOMMU disabled by kernel command line\n");
 		return 0;
 	}
@@ -1189,7 +1190,8 @@ static int __init early_amd_iommu_detect(struct acpi_table_header *table)
 
 void __init amd_iommu_detect(void)
 {
-	if (swiotlb || no_iommu || (iommu_detected && !gart_iommu_aperture))
+	if (swiotlb || no_iommu || (iommu_detected && !gart_iommu_aperture) ||
+		amd_iommu_disable)
 		return;
 
 	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
@@ -1212,6 +1214,8 @@ void __init amd_iommu_detect(void)
 static int __init parse_amd_iommu_options(char *str)
 {
 	for (; *str; ++str) {
+		if (!strncmp(str, "off", 3))
+			amd_iommu_disable = 1;
 		if (strncmp(str, "isolate", 7) == 0)
 			amd_iommu_isolate = 1;
 	}
-- 
1.5.4.2

