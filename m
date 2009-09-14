Return-Path: <linux-kernel-owner+w=401wt.eu-S933527AbZINUId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbZINUId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933502AbZINUIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54025 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052AbZINUI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:26 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 15/72] Blackfin: cleanup traps decode_address() a bit
Date: Mon, 14 Sep 2009 16:07:19 -0400
Message-Id: <1252958896-25150-16-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify the address display to shrink the code, and add missing decoding of
a few special Blackfin-specific regions (L1 ROM and MMRs).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |   48 ++++++++++++++++++++++++++---------------
 1 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 5994597..519acca 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -100,7 +100,11 @@ static void decode_address(char *buf, unsigned long address)
 	char *modname;
 	char *delim = ":";
 	char namebuf[128];
+#endif
+
+	buf += sprintf(buf, "<0x%08lx> ", address);
 
+#ifdef CONFIG_KALLSYMS
 	/* look up the address and see if we are in kernel space */
 	symname = kallsyms_lookup(address, &symsize, &offset, &modname, namebuf);
 
@@ -108,23 +112,33 @@ static void decode_address(char *buf, unsigned long address)
 		/* yeah! kernel space! */
 		if (!modname)
 			modname = delim = "";
-		sprintf(buf, "<0x%p> { %s%s%s%s + 0x%lx }",
-		              (void *)address, delim, modname, delim, symname,
-		              (unsigned long)offset);
+		sprintf(buf, "{ %s%s%s%s + 0x%lx }",
+		        delim, modname, delim, symname,
+		        (unsigned long)offset);
 		return;
-
 	}
 #endif
 
-	/* Problem in fixed code section? */
 	if (address >= FIXED_CODE_START && address < FIXED_CODE_END) {
-		sprintf(buf, "<0x%p> /* Maybe fixed code section */", (void *)address);
+		/* Problem in fixed code section? */
+		strcat(buf, "/* Maybe fixed code section */");
+		return;
+
+	} else if (address < CONFIG_BOOT_LOAD) {
+		/* Problem somewhere before the kernel start address */
+		strcat(buf, "/* Maybe null pointer? */");
+		return;
+
+	} else if (address >= COREMMR_BASE) {
+		strcat(buf, "/* core mmrs */");
+		return;
+
+	} else if (address >= SYSMMR_BASE) {
+		strcat(buf, "/* system mmrs */");
 		return;
-	}
 
-	/* Problem somewhere before the kernel start address */
-	if (address < CONFIG_BOOT_LOAD) {
-		sprintf(buf, "<0x%p> /* Maybe null pointer? */", (void *)address);
+	} else if (address >= L1_ROM_START && address < L1_ROM_START + L1_ROM_LENGTH) {
+		strcat(buf, "/* on-chip L1 ROM */");
 		return;
 	}
 
@@ -172,18 +186,16 @@ static void decode_address(char *buf, unsigned long address)
 						offset = (address - vma->vm_start) +
 							 (vma->vm_pgoff << PAGE_SHIFT);
 
-					sprintf(buf, "<0x%p> [ %s + 0x%lx ]",
-						(void *)address, name, offset);
+					sprintf(buf, "[ %s + 0x%lx ]", name, offset);
 				} else
-					sprintf(buf, "<0x%p> [ %s vma:0x%lx-0x%lx]",
-						(void *)address, name,
-						vma->vm_start, vma->vm_end);
+					sprintf(buf, "[ %s vma:0x%lx-0x%lx]",
+						name, vma->vm_start, vma->vm_end);
 
 				if (!in_atomic)
 					mmput(mm);
 
-				if (!strlen(buf))
-					sprintf(buf, "<0x%p> [ %s ] dynamic memory", (void *)address, name);
+				if (buf[0] == '\0')
+					sprintf(buf, "[ %s ] dynamic memory", name);
 
 				goto done;
 			}
@@ -193,7 +205,7 @@ static void decode_address(char *buf, unsigned long address)
 	}
 
 	/* we were unable to find this address anywhere */
-	sprintf(buf, "<0x%p> /* kernel dynamic memory */", (void *)address);
+	sprintf(buf, "/* kernel dynamic memory */");
 
 done:
 	write_unlock_irqrestore(&tasklist_lock, flags);
-- 
1.6.4.2

