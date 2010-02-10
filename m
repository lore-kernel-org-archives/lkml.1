Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab0BJJZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:25:58 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39162 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab0BJJV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:21:59 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 10 Feb 2010 01:20:23 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 19/35] x86: move bios page reserve early to head32/64.c
In-reply-to: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265793639-15071-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so prepare to make one more clean early_res.c

-v2: don't need to reserve first page in early_res
     because we already mark that in e820 as reserved already.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/e820.c   |   22 ++--------------------
 arch/x86/kernel/head32.c |   10 ++++++++++
 2 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 90a8529..4004f10 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -743,29 +743,11 @@ struct early_res {
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
index 5051b94..adedeef 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -29,6 +29,16 @@ static void __init i386_default_early_setup(void)
 
 void __init i386_start_kernel(void)
 {
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
-- 
1.6.4.2

