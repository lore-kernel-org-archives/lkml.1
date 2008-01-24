Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbYAXQ4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbYAXQ4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbYAXQxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:17 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64218 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbYAXQxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:06 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 16/17] [MIPS] Malta: remaining bits of the board support code cleanup
Date: Thu, 24 Jan 2008 19:52:56 +0300
Message-Id: <1201193577-4261-17-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch factors out the code, which handles the Bonito system
controller. The case of not supporting the DMA coherency is handled
separately to make the logic obvious. Besides, a couple of empty
lines added to beautify the code even further.

No functional changes introduced.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_setup.c |   80 +++++++++++++++--------------
 1 files changed, 42 insertions(+), 38 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_setup.c b/arch/mips/mips-boards/malta/malta_setup.c
index 541f4e7..2cd8f57 100644
--- a/arch/mips/mips-boards/malta/malta_setup.c
+++ b/arch/mips/mips-boards/malta/malta_setup.c
@@ -1,6 +1,7 @@
 /*
  * Carsten Langgaard, carstenl@mips.com
  * Copyright (C) 2000 MIPS Technologies, Inc.  All rights reserved.
+ * Copyright (C) Dmitri Vorobiev
  *
  *  This program is free software; you can distribute it and/or modify it
  *  under the terms of the GNU General Public License (Version 2) as
@@ -145,6 +146,41 @@ static void __init screen_info_setup(void)
 }
 #endif
 
+static void __init bonito_quirks_setup(void)
+{
+	char *argptr;
+
+	argptr = prom_getcmdline();
+	if (strstr(argptr, "debug")) {
+		BONITO_BONGENCFG |= BONITO_BONGENCFG_DEBUGMODE;
+		printk(KERN_INFO "Enabled Bonito debug mode\n");
+	} else
+		BONITO_BONGENCFG &= ~BONITO_BONGENCFG_DEBUGMODE;
+
+#ifdef CONFIG_DMA_COHERENT
+	if (BONITO_PCICACHECTRL & BONITO_PCICACHECTRL_CPUCOH_PRES) {
+		BONITO_PCICACHECTRL |= BONITO_PCICACHECTRL_CPUCOH_EN;
+		printk(KERN_INFO "Enabled Bonito CPU coherency\n");
+
+		argptr = prom_getcmdline();
+		if (strstr(argptr, "iobcuncached")) {
+			BONITO_PCICACHECTRL &= ~BONITO_PCICACHECTRL_IOBCCOH_EN;
+			BONITO_PCIMEMBASECFG = BONITO_PCIMEMBASECFG &
+				~(BONITO_PCIMEMBASECFG_MEMBASE0_CACHED |
+					BONITO_PCIMEMBASECFG_MEMBASE1_CACHED);
+			printk(KERN_INFO "Disabled Bonito IOBC coherency\n");
+		} else {
+			BONITO_PCICACHECTRL |= BONITO_PCICACHECTRL_IOBCCOH_EN;
+			BONITO_PCIMEMBASECFG |=
+				(BONITO_PCIMEMBASECFG_MEMBASE0_CACHED |
+					BONITO_PCIMEMBASECFG_MEMBASE1_CACHED);
+			printk(KERN_INFO "Enabled Bonito IOBC coherency\n");
+		}
+	} else
+		panic("Hardware DMA cache coherency not supported");
+#endif
+}
+
 void __init plat_mem_setup(void)
 {
 	unsigned int i;
@@ -164,54 +200,22 @@ void __init plat_mem_setup(void)
 	kgdb_config();
 #endif
 
-	if (mips_revision_sconid == MIPS_REVISION_SCON_BONITO) {
-		char *argptr;
-
-		argptr = prom_getcmdline();
-		if (strstr(argptr, "debug")) {
-			BONITO_BONGENCFG |= BONITO_BONGENCFG_DEBUGMODE;
-			printk("Enabled Bonito debug mode\n");
-		}
-		else
-			BONITO_BONGENCFG &= ~BONITO_BONGENCFG_DEBUGMODE;
-
 #ifdef CONFIG_DMA_COHERENT
-		if (BONITO_PCICACHECTRL & BONITO_PCICACHECTRL_CPUCOH_PRES) {
-			BONITO_PCICACHECTRL |= BONITO_PCICACHECTRL_CPUCOH_EN;
-			printk("Enabled Bonito CPU coherency\n");
-
-			argptr = prom_getcmdline();
-			if (strstr(argptr, "iobcuncached")) {
-				BONITO_PCICACHECTRL &= ~BONITO_PCICACHECTRL_IOBCCOH_EN;
-				BONITO_PCIMEMBASECFG = BONITO_PCIMEMBASECFG &
-					~(BONITO_PCIMEMBASECFG_MEMBASE0_CACHED |
-					  BONITO_PCIMEMBASECFG_MEMBASE1_CACHED);
-				printk("Disabled Bonito IOBC coherency\n");
-			}
-			else {
-				BONITO_PCICACHECTRL |= BONITO_PCICACHECTRL_IOBCCOH_EN;
-				BONITO_PCIMEMBASECFG |=
-					(BONITO_PCIMEMBASECFG_MEMBASE0_CACHED |
-					 BONITO_PCIMEMBASECFG_MEMBASE1_CACHED);
-				printk("Enabled Bonito IOBC coherency\n");
-			}
-		}
-		else
-			panic("Hardware DMA cache coherency not supported");
-
-#endif
-	}
-#ifdef CONFIG_DMA_COHERENT
-	else
+	if (mips_revision_sconid != MIPS_REVISION_SCON_BONITO)
 		panic("Hardware DMA cache coherency not supported");
 #endif
 
+	if (mips_revision_sconid == MIPS_REVISION_SCON_BONITO)
+		bonito_quirks_setup();
+
 #ifdef CONFIG_BLK_DEV_IDE
 	pci_clock_check();
 #endif
+
 #ifdef CONFIG_BLK_DEV_FD
 	fd_activate();
 #endif
+
 #if defined(CONFIG_VT) && defined(CONFIG_VGA_CONSOLE)
 	screen_info_setup();
 #endif
-- 
1.5.3

