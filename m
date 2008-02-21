Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbYBUOur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbYBUOur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 09:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYBUOui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 09:50:38 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:19142 "EHLO
	outbound2-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbYBUOuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 09:50:37 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JWLFVR-04-6N3-01
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
cc: linux-kernel@vger.kernel.org, "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH] X86: don't print a warning when MTRR are blank and
 running in KVM
Date: Thu, 21 Feb 2008 15:50:14 +0100
Message-ID: <1203605414-4958-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 21 Feb 2008 14:50:14.0179 (UTC)
 FILETIME=[10DCE730:01C87499]
MIME-Version: 1.0
X-WSS-ID: 6BA350230QK12088112-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inside a KVM virtual machine the MTRRs are usually blank. This confuses Linux
and causes a warning message at boot. This patch removes that warning message
when running Linux as a KVM guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index b6e136f..47e624c 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -43,6 +43,7 @@
 #include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
+#include <asm/kvm_para.h>
 #include "mtrr.h"
 
 u32 num_var_ranges = 0;
@@ -687,12 +688,14 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 	}
 
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
-	if (!highest_pfn) {
+	if (!highest_pfn && !kvm_para_available()) {
 		printk(KERN_WARNING "WARNING: strange, CPU MTRRs all blank?\n");
 		WARN_ON(1);
-		return 0;
 	}
 
+	if (!highest_pfn)
+		return 0;
+
 	if (highest_pfn < end_pfn) {
 		printk(KERN_WARNING "WARNING: BIOS bug: CPU MTRRs don't cover"
 			" all of memory, losing %luMB of RAM.\n",
-- 
1.5.3.7



