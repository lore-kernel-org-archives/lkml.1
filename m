Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYIGJhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYIGJhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 05:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYIGJhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 05:37:35 -0400
Received: from gw.goop.org ([64.81.55.164]:32894 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506AbYIGJhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 05:37:34 -0400
Message-ID: <48C3A0DC.8000206@goop.org>
Date: Sun, 07 Sep 2008 02:37:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Hugh Dickens <hugh@veritas.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       =?ISO-8859-1?Q?Rafa=3F_Mi=3F?= =?ISO-8859-1?Q?ecki?= 
	<zajec5@gmail.com>
Subject: [PATCH 4/3] x86: default corruption check to off, but put parameter
 default in Kconfig
References: <patchbomb.1220777491@localhost> <72081a970effa1a32861.1220777494@localhost> <20080907091112.GA5574@elte.hu>
In-Reply-To: <20080907091112.GA5574@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Default the low memory corruption check to off, but make the default setting of
the memory_corruption_check kernel parameter a config parameter.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/Kconfig        |    9 ++++++++-
 arch/x86/kernel/setup.c |   13 ++++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1139,7 +1139,6 @@
 
 config X86_CHECK_BIOS_CORRUPTION
         bool "Check for low memory corruption"
-	default y
 	help
 	 Periodically check for memory corruption in low memory, which
 	 is suspected to be caused by BIOS.  Even when enabled in the
@@ -1159,6 +1158,14 @@
 	 BIOS-originated corruption always affects the same memory,
 	 you can use memmap= to prevent the kernel from using that
 	 memory.
+
+config X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
+        bool "Set the default setting of memory_corruption_check"
+	depends on X86_CHECK_BIOS_CORRUPTION
+	default y
+	help
+	 Set whether the default state of memory_corruption_check is
+	 on or off.
 
 config MATH_EMULATION
 	bool
===================================================================
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -590,7 +590,8 @@
 #ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
 #define MAX_SCAN_AREAS	8
 
-static int __read_mostly memory_corruption_check = 0;
+static int __read_mostly memory_corruption_check = -1;
+
 static unsigned __read_mostly corruption_check_size = 64*1024;
 static unsigned __read_mostly corruption_check_period = 60; /* seconds */
 
@@ -636,6 +637,16 @@
 static void __init setup_bios_corruption_check(void)
 {
 	u64 addr = PAGE_SIZE;	/* assume first page is reserved anyway */
+
+	if (memory_corruption_check == -1) {
+		memory_corruption_check =
+#ifdef CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
+			1
+#else
+			0
+#endif
+			;
+	}
 
 	if (corruption_check_size == 0)
 		memory_corruption_check = 0;


