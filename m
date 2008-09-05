Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYIEDJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYIEDJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYIEDJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:52408 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYIEDJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=h2oSY4AFMy0NIYypblumdSoEW8cYMqevS4XNnIznuQ9YYCcvbUg7E7K6xBRND88kDo
         uXxPeXR3FYhL/i2pYyp/i6J9tmKwrfXSm9n7r1ggvHP/FIYPsePJmGWrRpCHQCqKZZ8l
         mTpSR+xIfBWK9C6wuBY7RrnATKU1irtR6ns8o=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 03/16] x86: same gdt_page with marco
Date: Thu,  4 Sep 2008 20:09:01 -0700
Message-Id: <1220584154-32497-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |   17 +++++++++++++++++
 arch/x86/kernel/cpu/common_64.c |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6bbdbc2..e0ca51f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -40,6 +40,22 @@
 
 static struct cpu_dev *this_cpu __cpuinitdata;
 
+#ifdef CONFIG_X86_64
+/* We need valid kernel segments for data and code in long mode too
+ * IRET will check the segment types  kkeil 2000/10/28
+ * Also sysret mandates a special GDT layout
+ */
+/* The TLS descriptors are currently at a different place compared to i386.
+   Hopefully nobody expects them at a fixed place (Wine?) */
+DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
+	[GDT_ENTRY_KERNEL32_CS] = { { { 0x0000ffff, 0x00cf9b00 } } },
+	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00af9b00 } } },
+	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9300 } } },
+	[GDT_ENTRY_DEFAULT_USER32_CS] = { { { 0x0000ffff, 0x00cffb00 } } },
+	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff300 } } },
+	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00affb00 } } },
+} };
+#else
 DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00cf9a00 } } },
 	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9200 } } },
@@ -74,6 +90,7 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_ESPFIX_SS] = { { { 0x00000000, 0x00c09200 } } },
 	[GDT_ENTRY_PERCPU] = { { { 0x00000000, 0x00000000 } } },
 } };
+#endif
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
 static int cachesize_override __cpuinitdata = -1;
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 5daec69..b489050 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -39,6 +39,7 @@
 
 static struct cpu_dev *this_cpu __cpuinitdata;
 
+#ifdef CONFIG_X86_64
 /* We need valid kernel segments for data and code in long mode too
  * IRET will check the segment types  kkeil 2000/10/28
  * Also sysret mandates a special GDT layout
@@ -53,6 +54,42 @@ DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff300 } } },
 	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00affb00 } } },
 } };
+#else
+DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
+	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00cf9a00 } } },
+	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9200 } } },
+	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00cffa00 } } },
+	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff200 } } },
+	/*
+	 * Segments used for calling PnP BIOS have byte granularity.
+	 * They code segments and data segments have fixed 64k limits,
+	 * the transfer segment sizes are set at run time.
+	 */
+	/* 32-bit code */
+	[GDT_ENTRY_PNPBIOS_CS32] = { { { 0x0000ffff, 0x00409a00 } } },
+	/* 16-bit code */
+	[GDT_ENTRY_PNPBIOS_CS16] = { { { 0x0000ffff, 0x00009a00 } } },
+	/* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_DS] = { { { 0x0000ffff, 0x00009200 } } },
+	/* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_TS1] = { { { 0x00000000, 0x00009200 } } },
+	/* 16-bit data */
+	[GDT_ENTRY_PNPBIOS_TS2] = { { { 0x00000000, 0x00009200 } } },
+	/*
+	 * The APM segments have byte granularity and their bases
+	 * are set at run time.  All have 64k limits.
+	 */
+	/* 32-bit code */
+	[GDT_ENTRY_APMBIOS_BASE] = { { { 0x0000ffff, 0x00409a00 } } },
+	/* 16-bit code */
+	[GDT_ENTRY_APMBIOS_BASE+1] = { { { 0x0000ffff, 0x00009a00 } } },
+	/* data */
+	[GDT_ENTRY_APMBIOS_BASE+2] = { { { 0x0000ffff, 0x00409200 } } },
+
+	[GDT_ENTRY_ESPFIX_SS] = { { { 0x00000000, 0x00c09200 } } },
+	[GDT_ENTRY_PERCPU] = { { { 0x00000000, 0x00000000 } } },
+} };
+#endif
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
 __u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
-- 
1.5.4.5

