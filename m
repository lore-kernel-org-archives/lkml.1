Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbZHIT4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbZHIT4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZHITyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:54:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:23922 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbZHITyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:54:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gciTUV9643ihhrP93gRpw3K8ajnQIJ21YiVAE2BRT+SLKUXuVegj/f6smXDQMOZwfv
         6+GuluFaLru8seJTY4DYZNQ3M2lapkqTF8AfdxMnsPC6kaG9BlgK8YAyPGXQ7kp6NiD0
         bNXXcgTWZAEenY9JTip9XnnsPqvHgV/+mArQo=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: [PATCH 02/14] ia64: use printk_once
Date: Sun,  9 Aug 2009 21:53:57 +0200
Message-Id: <1249847649-11631-3-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/kernel/unaligned.c    |    6 ++----
 arch/ia64/sn/kernel/io_common.c |    8 ++------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/ia64/kernel/unaligned.c b/arch/ia64/kernel/unaligned.c
index 6db0859..776dd40 100644
--- a/arch/ia64/kernel/unaligned.c
+++ b/arch/ia64/kernel/unaligned.c
@@ -60,7 +60,6 @@ dump (const char *str, void *vp, size_t len)
  */
 int no_unaligned_warning;
 int unaligned_dump_stack;
-static int noprint_warning;
 
 /*
  * For M-unit:
@@ -1357,9 +1356,8 @@ ia64_handle_unaligned (unsigned long ifa, struct pt_regs *regs)
 			/* watch for command names containing %s */
 			printk(KERN_WARNING "%s", buf);
 		} else {
-			if (no_unaligned_warning && !noprint_warning) {
-				noprint_warning = 1;
-				printk(KERN_WARNING "%s(%d) encountered an "
+			if (no_unaligned_warning) {
+				printk_once(KERN_WARNING "%s(%d) encountered an "
 				       "unaligned exception which required\n"
 				       "kernel assistance, which degrades "
 				       "the performance of the application.\n"
diff --git a/arch/ia64/sn/kernel/io_common.c b/arch/ia64/sn/kernel/io_common.c
index 25831c4..308e659 100644
--- a/arch/ia64/sn/kernel/io_common.c
+++ b/arch/ia64/sn/kernel/io_common.c
@@ -119,7 +119,6 @@ sn_pcidev_info_get(struct pci_dev *dev)
  * Additionally note that the struct sn_flush_device_war also has to be
  * removed from arch/ia64/sn/include/xtalk/hubdev.h
  */
-static u8 war_implemented = 0;
 
 static s64 sn_device_fixup_war(u64 nasid, u64 widget, int device,
 			       struct sn_flush_device_common *common)
@@ -128,11 +127,8 @@ static s64 sn_device_fixup_war(u64 nasid, u64 widget, int device,
 	struct sn_flush_device_war *dev_entry;
 	struct ia64_sal_retval isrv = {0,0,0,0};
 
-	if (!war_implemented) {
-		printk(KERN_WARNING "PROM version < 4.50 -- implementing old "
-		       "PROM flush WAR\n");
-		war_implemented = 1;
-	}
+	printk_once(KERN_WARNING
+		"PROM version < 4.50 -- implementing old PROM flush WAR\n");
 
 	war_list = kzalloc(DEV_PER_WIDGET * sizeof(*war_list), GFP_KERNEL);
 	BUG_ON(!war_list);
-- 
1.6.3.3

