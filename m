Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833Ab0AVVtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0AVVtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 16:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712Ab0AVVtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 16:49:12 -0500
Received: from server78.greatnet.de ([83.133.96.102]:48991 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab0AVVtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 16:49:10 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: jonathan@buzzard.org.uk
Cc: alan@linux.intel.com, tlinux-users@tce.toshiba-dme.co.jp,
       linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 4/4] [DRIVERS] add a register dumper for debugging
Date: Fri, 22 Jan 2010 22:41:12 +0100
Message-Id: <1264196472-5387-4-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1264196472-5387-3-git-send-email-henne@nachtwindheim.de>
References: <1264196472-5387-1-git-send-email-henne@nachtwindheim.de>
 <1264196472-5387-2-git-send-email-henne@nachtwindheim.de>
 <1264196472-5387-3-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dumper to examine the changes of the registers before and after
calling the Toshiba SMM.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/char/toshiba.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index 111baba..626d281 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -75,6 +75,20 @@
 #define DRV_NAME "toshiba"
 #define TOSH_MINOR_DEV 181
 
+#if TOSH_DEBUG == 1
+static void pr_smmregs(SMMRegisters *regs)
+{
+	printk(KERN_DEBUG DRV_NAME " EAX: 0x%08x EBX: 0x%08x ECX: 0x%08x\n",
+	       regs->eax, regs->ebx, regs->ecx);
+	printk(KERN_DEBUG DRV_NAME " EDX: 0x%08x ESI: 0x%08x EDI: 0x%08x\n",
+	       regs->edx, regs->esi, regs->edi);
+}
+#else
+static inline void pr_smmregs(SMMRegisters *regs)
+{
+}
+#endif
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jonathan Buzzard <jonathan@buzzard.org.uk>");
 MODULE_DESCRIPTION("Toshiba laptop SMM driver");
@@ -220,6 +234,9 @@ int tosh_smm(SMMRegisters *regs)
 {
 	int eax;
 
+	printk(KERN_DEBUG DRV_NAME " %s start\n", __func__);
+	pr_smmregs(regs);
+
 	asm ("# load the values into the registers\n\t" \
 		"pushl %%eax\n\t" \
 		"movl 0(%%eax),%%edx\n\t" \
@@ -249,6 +266,9 @@ int tosh_smm(SMMRegisters *regs)
 		: "a" (regs)
 		: "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 
+	pr_smmregs(regs);
+	printk(KERN_DEBUG DRV_NAME " %s done\n", __func__);
+
 	return eax;
 }
 EXPORT_SYMBOL(tosh_smm);
-- 
1.6.5

