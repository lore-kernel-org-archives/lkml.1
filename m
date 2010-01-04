Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293Ab0ADDK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0ADDK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038Ab0ADDJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:09:45 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:65118 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab0ADDH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:07:28 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sun, 03 Jan 2010 19:04:59 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 21/29] x86: move bios page reserve early to head32/64.c
In-reply-to: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1262574307-17040-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so prepare to make one more clean early_res.c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/e820.c   |   22 ++--------------------
 arch/x86/kernel/head32.c |   12 ++++++++++++
 arch/x86/kernel/head64.c |    2 ++
 3 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index bd6a361..b7681e3 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -735,29 +735,11 @@ struct early_res {
 	char name[15];
 	char overlap_ok;
 };
-static struct early_res early_res_x[MAX_EARLY_RES_X] __initdata = {
-	{ 0, PAGE_SIZE, "BIOS data page", 1 },	/* BIOS data page */
-#if defined(CONFIG_X86_32) && defined(CONFIG_X86_TRAMPOLINE)
-	/*
-	 * But first pinch a few for the stack/trampoline stuff
-	 * FIXME: Don't need the extra page at 4K, but need to fix
-	 * trampoline before removing it. (see the GDT stuff)
-	 */
-	{ PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE", 1 },
-#endif
-
-	{}
-};
+static struct early_res early_res_x[MAX_EARLY_RES_X] __initdata;
 
 static int max_early_res __initdata = MAX_EARLY_RES_X;
 static struct early_res *early_res __initdata = &early_res_x[0];
-static int early_res_count __initdata =
-#ifdef CONFIG_X86_32
-	2
-#else
-	1
-#endif
-	;
+static int early_res_count __initdata;
 
 static int __init find_overlapped_early(u64 start, u64 end)
 {
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 5051b94..2e13544 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -29,6 +29,18 @@ static void __init i386_default_early_setup(void)
 
 void __init i386_start_kernel(void)
 {
+	reserve_early_overlap_ok(0, PAGE_SIZE, "BIOS data page");
+
+#ifdef CONFIG_X86_TRAMPOLINE
+	/*
+	 * But first pinch a few for the stack/trampoline stuff
+	 * FIXME: Don't need the extra page at 4K, but need to fix
+	 * trampoline before removing it. (see the GDT stuff)
+	 */
+	reserve_early_overlap_ok(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE,
+					 "EX TRAMPOLINE");
+#endif
+
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index b5a9896..452b7c4 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -98,6 +98,8 @@ void __init x86_64_start_reservations(char *real_mode_data)
 {
 	copy_bootdata(__va(real_mode_data));
 
+	reserve_early_overlap_ok(0, PAGE_SIZE, "BIOS data page");
+
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
-- 
1.6.4.2

