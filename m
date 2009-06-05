Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbZFEIZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbZFEIZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbZFEIHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:07:11 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37591 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692AbZFEIGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 54/62] Blackfin: convert early_printk EVT init to a loop
Date: Fri,  5 Jun 2009 04:05:03 -0400
Message-Id: <1244189111-19639-55-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EVT registers are all contiguous in the memory map, so using a loop to
initialize them all rather than hardcoding the list results in much better
generated code (a hardware loop rather than a whole bunch of individual
loads).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/early_printk.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/blackfin/kernel/early_printk.c b/arch/blackfin/kernel/early_printk.c
index c8ad051..3302719 100644
--- a/arch/blackfin/kernel/early_printk.c
+++ b/arch/blackfin/kernel/early_printk.c
@@ -178,25 +178,15 @@ int __init setup_early_printk(char *buf)
 
 asmlinkage void __init init_early_exception_vectors(void)
 {
+	u32 evt;
 	SSYNC();
 
 	/* cannot program in software:
 	 * evt0 - emulation (jtag)
 	 * evt1 - reset
 	 */
-	bfin_write_EVT2(early_trap);
-	bfin_write_EVT3(early_trap);
-	bfin_write_EVT5(early_trap);
-	bfin_write_EVT6(early_trap);
-	bfin_write_EVT7(early_trap);
-	bfin_write_EVT8(early_trap);
-	bfin_write_EVT9(early_trap);
-	bfin_write_EVT10(early_trap);
-	bfin_write_EVT11(early_trap);
-	bfin_write_EVT12(early_trap);
-	bfin_write_EVT13(early_trap);
-	bfin_write_EVT14(early_trap);
-	bfin_write_EVT15(early_trap);
+	for (evt = EVT2; evt <= EVT15; evt += 4)
+		bfin_write32(evt, early_trap);
 	CSYNC();
 
 	/* Set all the return from interrupt, exception, NMI to a known place
-- 
1.6.3.1

