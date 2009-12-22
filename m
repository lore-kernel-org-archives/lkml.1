Return-Path: <linux-kernel-owner+w=401wt.eu-S1752981AbZLVDPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbZLVDPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 22:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbZLVDPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 22:15:49 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57251 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZLVDPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 22:15:48 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [PATCH v2] kmsg_dump: Dump on crash_kexec as well
Cc: kosaki.motohiro@jp.fujitsu.com,
       Anders Grafstrom <anders.grafstrom@netinsight.net>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091222085508.1410.A69D9226@jp.fujitsu.com>
References: <20091221153341.2bece1d3@marrow.netinsight.se> <20091222085508.1410.A69D9226@jp.fujitsu.com>
Message-Id: <20091222121024.1429.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 22 Dec 2009 12:15:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, can you please pick this patch into your tree?

======================
crash_kexec gets called before kmsg_dump(KMSG_DUMP_OOPS) if
panic_on_oops is set, so the kernel log buffer is not stored
for this case.

This patch adds a KMSG_DUMP_KEXEC dump type which gets called
when crash_kexec() is invoked. To avoid getting double dumps,
the old KMSG_DUMP_PANIC is moved below crash_kexec(). The
mtdoops driver is modified to handle KMSG_DUMP_KEXEC in the
same way as a panic.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Anders Grafstrom <anders.grafstrom@netinsight.net>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/mtd/mtdoops.c     |    2 +-
 include/linux/kmsg_dump.h |    1 +
 kernel/kexec.c            |    4 ++++
 kernel/panic.c            |    3 ++-
 kernel/printk.c           |    1 +
 5 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
index a714ec4..92e12df 100644
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -322,7 +322,7 @@ static void mtdoops_do_dump(struct kmsg_dumper *dumper,
 	memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
 
 	/* Panics must be written immediately */
-	if (reason == KMSG_DUMP_PANIC) {
+	if (reason != KMSG_DUMP_OOPS) {
 		if (!cxt->mtd->panic_write)
 			printk(KERN_ERR "mtdoops: Cannot write from panic without panic_write\n");
 		else
diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
index e32aa26..24b4414 100644
--- a/include/linux/kmsg_dump.h
+++ b/include/linux/kmsg_dump.h
@@ -17,6 +17,7 @@
 enum kmsg_dump_reason {
 	KMSG_DUMP_OOPS,
 	KMSG_DUMP_PANIC,
+	KMSG_DUMP_KEXEC,
 };
 
 /**
diff --git a/kernel/kexec.c b/kernel/kexec.c
index a9a93d9..ef077fb 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -32,6 +32,7 @@
 #include <linux/console.h>
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
+#include <linux/kmsg_dump.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1074,6 +1075,9 @@ void crash_kexec(struct pt_regs *regs)
 	if (mutex_trylock(&kexec_mutex)) {
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
+
+			kmsg_dump(KMSG_DUMP_KEXEC);
+
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
diff --git a/kernel/panic.c b/kernel/panic.c
index 5827f7b..c787333 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -75,7 +75,6 @@ NORET_TYPE void panic(const char * fmt, ...)
 	dump_stack();
 #endif
 
-	kmsg_dump(KMSG_DUMP_PANIC);
 	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
 	 * everything else.
@@ -83,6 +82,8 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	crash_kexec(NULL);
 
+	kmsg_dump(KMSG_DUMP_PANIC);
+
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
 	 * unfortunately means it may not be hardened to work in a panic
diff --git a/kernel/printk.c b/kernel/printk.c
index 17463ca..1751c45 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1467,6 +1467,7 @@ EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
 static const char const *kmsg_reasons[] = {
 	[KMSG_DUMP_OOPS]	= "oops",
 	[KMSG_DUMP_PANIC]	= "panic",
+	[KMSG_DUMP_KEXEC]	= "kexec",
 };
 
 static const char *kmsg_to_str(enum kmsg_dump_reason reason)
-- 
1.6.5.2





