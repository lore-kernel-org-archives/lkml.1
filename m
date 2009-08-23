Return-Path: <linux-kernel-owner+w=401wt.eu-S933625AbZHWSWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625AbZHWSWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 14:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933611AbZHWSWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 14:22:49 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46895 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933468AbZHWSWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 14:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=nD8HES6rn8/ENHcAET9kgrj0cQLwMgkM3SnKE0absvptIC+2nYVwq0d4NLowZVDoO8
         jVxnzLq1kMCbuYwcrsAiKD97aQSkqLInB03ygyJo1UIqJbAbBU20o80DY5m0M34rrpvf
         G6ZSJYK/XG2b7+MN5ZTQAcZQYystmoYP7gYLU=
Message-ID: <4A9188F0.3030603@gmail.com>
Date: Sun, 23 Aug 2009 20:22:40 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH resend] ia64: use printk_once
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org

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

