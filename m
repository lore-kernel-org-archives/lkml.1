Return-Path: <linux-kernel-owner+w=401wt.eu-S1759932AbZFTSvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932AbZFTSvY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758552AbZFTSrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:47:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48218 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758457AbZFTSrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:47:40 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 24/25] Blackfin: fix early crash when booting on wrong cpu
Date: Sat, 20 Jun 2009 14:44:47 -0400
Message-Id: <1245523488-26536-25-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Make sure we process the kernel command line before poking the hardware,
so that we can process early printk.  This helps ensure that if you boot
a kernel configured for a different processor, something will be left in
the log buffer.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/setup.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 8d78928..298f023 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -477,9 +477,11 @@ static __init void parse_cmdline_early(char *cmdline_p)
 			} else if (!memcmp(to, "clkin_hz=", 9)) {
 				to += 9;
 				early_init_clkin_hz(to);
+#ifdef CONFIG_EARLY_PRINTK
 			} else if (!memcmp(to, "earlyprintk=", 12)) {
 				to += 12;
 				setup_early_printk(to);
+#endif
 			} else if (!memcmp(to, "memmap=", 7)) {
 				to += 7;
 				parse_memmap(to);
@@ -798,6 +800,11 @@ void __init setup_arch(char **cmdline_p)
 {
 	unsigned long sclk, cclk;
 
+	/* Check to make sure we are running on the right processor */
+	if (unlikely(CPUID != bfin_cpuid()))
+		printk(KERN_ERR "ERROR: Not running on ADSP-%s: unknown CPUID 0x%04x Rev 0.%d\n",
+			CPU, bfin_cpuid(), bfin_revid());
+
 #ifdef CONFIG_DUMMY_CONSOLE
 	conswitchp = &dummy_con;
 #endif
@@ -812,14 +819,17 @@ void __init setup_arch(char **cmdline_p)
 	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	boot_command_line[COMMAND_LINE_SIZE - 1] = '\0';
 
-	/* setup memory defaults from the user config */
-	physical_mem_end = 0;
-	_ramend = get_mem_size() * 1024 * 1024;
-
 	memset(&bfin_memmap, 0, sizeof(bfin_memmap));
 
+	/* If the user does not specify things on the command line, use
+	 * what the bootloader set things up as
+	 */
+	physical_mem_end = 0;
 	parse_cmdline_early(&command_line[0]);
 
+	if (_ramend == 0)
+		_ramend = get_mem_size() * 1024 * 1024;
+
 	if (physical_mem_end == 0)
 		physical_mem_end = _ramend;
 
@@ -910,10 +920,7 @@ void __init setup_arch(char **cmdline_p)
 	else
 		printk(KERN_INFO "Compiled for ADSP-%s Rev 0.%d\n", CPU, bfin_compiled_revid());
 
-	if (unlikely(CPUID != bfin_cpuid()))
-		printk(KERN_ERR "ERROR: Not running on ADSP-%s: unknown CPUID 0x%04x Rev 0.%d\n",
-			CPU, bfin_cpuid(), bfin_revid());
-	else {
+	if (likely(CPUID == bfin_cpuid())) {
 		if (bfin_revid() != bfin_compiled_revid()) {
 			if (bfin_compiled_revid() == -1)
 				printk(KERN_ERR "Warning: Compiled for Rev none, but running on Rev %d\n",
-- 
1.6.3.1

