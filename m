Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbZHJJNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbZHJJNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZHJJNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:13:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:42888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbZHJJNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:13:10 -0400
Date: Mon, 10 Aug 2009 09:12:35 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <20090809080350.GA4765@localhost.localdomain>
References: <20090809080350.GA4765@localhost.localdomain>
Subject: [tip:x86/asm] x86: Introduce GDT_ENTRY_INIT(), initialize bad_bios_desc statically
Message-ID: <tip-c7425314c755d5f94da7c978205c85a7c6201212@git.kernel.org>
Git-Commit-ID: c7425314c755d5f94da7c978205c85a7c6201212
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 09:12:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7425314c755d5f94da7c978205c85a7c6201212
Gitweb:     http://git.kernel.org/tip/c7425314c755d5f94da7c978205c85a7c6201212
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Sun, 9 Aug 2009 17:03:52 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 11:10:52 +0200

x86: Introduce GDT_ENTRY_INIT(), initialize bad_bios_desc statically

Fully initialize bad_bios_desc statically instead of doing some
fields statically and some dynamically.

Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
LKML-Reference: <20090809080350.GA4765@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apm_32.c        |   19 +++++++++----------
 drivers/pnp/pnpbios/bioscalls.c |    5 ++---
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index febb2da..39a4462 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -403,7 +403,15 @@ static DECLARE_WAIT_QUEUE_HEAD(apm_waitqueue);
 static DECLARE_WAIT_QUEUE_HEAD(apm_suspend_waitqueue);
 static struct apm_user *user_list;
 static DEFINE_SPINLOCK(user_list_lock);
-static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092, 0, 0);
+
+/*
+ * Set up a segment that references the real mode segment 0x40
+ * that extends up to the end of page zero (that we have reserved).
+ * This is for buggy BIOS's that refer to (real mode) segment 0x40
+ * even though they are called in protected mode.
+ */
+static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092,
+			(unsigned long)__va(0x400UL), PAGE_SIZE - 0x400 - 1);
 
 static const char driver_version[] = "1.16ac";	/* no spaces */
 
@@ -2332,15 +2340,6 @@ static int __init apm_init(void)
 	pm_flags |= PM_APM;
 
 	/*
-	 * Set up a segment that references the real mode segment 0x40
-	 * that extends up to the end of page zero (that we have reserved).
-	 * This is for buggy BIOS's that refer to (real mode) segment 0x40
-	 * even though they are called in protected mode.
-	 */
-	set_desc_base(&bad_bios_desc, (unsigned long)__va(0x40UL << 4));
-	set_desc_limit(&bad_bios_desc, 4095 - (0x40 << 4));
-
-	/*
 	 * Set up the long jump entry point to the APM BIOS, which is called
 	 * from inline assembly.
 	 */
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index bd035e3..fc83783 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -60,7 +60,8 @@ do { \
 	set_desc_limit(&gdt[(selname) >> 3], (size) - 1); \
 } while(0)
 
-static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092, 0, 0);
+static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092,
+			(unsigned long)__va(0x400UL), PAGE_SIZE - 0x400 - 1);
 
 /*
  * At some point we want to use this stack frame pointer to unwind
@@ -476,8 +477,6 @@ void pnpbios_calls_init(union pnp_bios_install_struct *header)
 	pnp_bios_callpoint.offset = header->fields.pm16offset;
 	pnp_bios_callpoint.segment = PNP_CS16;
 
-	set_desc_base(&bad_bios_desc, (unsigned long)__va(0x40UL << 4));
-	set_desc_limit(&bad_bios_desc, 4095 - (0x40 << 4));
 	for_each_possible_cpu(i) {
 		struct desc_struct *gdt = get_cpu_gdt_table(i);
 		if (!gdt)
