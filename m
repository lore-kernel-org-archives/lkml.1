Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbXLGTHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbXLGTHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 14:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbXLGTG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 14:06:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494AbXLGTG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 14:06:58 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 2/3] [PATCH] unify common parts of segment.h
Date: Fri,  7 Dec 2007 14:22:41 -0200
Message-Id: <1197044582338-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11970445742522-git-send-email-gcosta@redhat.com>
References: <119704456265-git-send-email-gcosta@redhat.com> <11970445742522-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although segment handling in i386 and x86_64 are very different,
there's a common part. Put them in segment.h instead of arch specific
headers

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/segment.h    |   16 ++++++++++++++++
 include/asm-x86/segment_32.h |   22 ----------------------
 include/asm-x86/segment_64.h |   17 -----------------
 3 files changed, 16 insertions(+), 39 deletions(-)

diff --git a/include/asm-x86/segment.h b/include/asm-x86/segment.h
index b3a7a3e..3c9b306 100644
--- a/include/asm-x86/segment.h
+++ b/include/asm-x86/segment.h
@@ -11,4 +11,20 @@
 #define get_kernel_rpl()  0
 #endif
 
+/* User mode is privilege level 3 */
+#define USER_RPL		0x3
+/* LDT segment has TI set, GDT has it cleared */
+#define SEGMENT_LDT		0x4
+#define SEGMENT_GDT		0x0
+
+/* Bottom two bits of selector give the ring privilege level */
+#define SEGMENT_RPL_MASK	0x3
+/* Bit 2 is table indicator (LDT/GDT) */
+#define SEGMENT_TI_MASK		0x4
+
+#define IDT_ENTRIES 256
+#define GDT_SIZE (GDT_ENTRIES * 8)
+#define GDT_ENTRY_TLS_ENTRIES 3
+#define TLS_SIZE (GDT_ENTRY_TLS_ENTRIES * 8)
+
 #endif
diff --git a/include/asm-x86/segment_32.h b/include/asm-x86/segment_32.h
index ff186e3..3e133ad 100644
--- a/include/asm-x86/segment_32.h
+++ b/include/asm-x86/segment_32.h
@@ -45,12 +45,9 @@
  *  30 - unused
  *  31 - TSS for double fault handler
  */
-#define GDT_ENTRY_TLS_ENTRIES	3
 #define GDT_ENTRY_TLS_MIN	6
 #define GDT_ENTRY_TLS_MAX 	(GDT_ENTRY_TLS_MIN + GDT_ENTRY_TLS_ENTRIES - 1)
 
-#define TLS_SIZE (GDT_ENTRY_TLS_ENTRIES * 8)
-
 #define GDT_ENTRY_DEFAULT_USER_CS	14
 #define __USER_CS (GDT_ENTRY_DEFAULT_USER_CS * 8 + 3)
 
@@ -87,7 +84,6 @@
  * The GDT has 32 entries
  */
 #define GDT_ENTRIES 32
-#define GDT_SIZE (GDT_ENTRIES * 8)
 
 /* Simple and small GDT entries for booting only */
 
@@ -112,24 +108,6 @@
 #define PNP_TS2    (GDT_ENTRY_PNPBIOS_TS2 * 8)	/* another data segment */
 
 /*
- * The interrupt descriptor table has room for 256 idt's,
- * the global descriptor table is dependent on the number
- * of tasks we can have..
- */
-#define IDT_ENTRIES 256
-
-/* Bottom two bits of selector give the ring privilege level */
-#define SEGMENT_RPL_MASK	0x3
-/* Bit 2 is table indicator (LDT/GDT) */
-#define SEGMENT_TI_MASK		0x4
-
-/* User mode is privilege level 3 */
-#define USER_RPL		0x3
-/* LDT segment has TI set, GDT has it cleared */
-#define SEGMENT_LDT		0x4
-#define SEGMENT_GDT		0x0
-
-/*
  * Matching rules for certain types of segments.
  */
 
diff --git a/include/asm-x86/segment_64.h b/include/asm-x86/segment_64.h
index dce7421..5cc7deb 100644
--- a/include/asm-x86/segment_64.h
+++ b/include/asm-x86/segment_64.h
@@ -33,8 +33,6 @@
 #define GDT_ENTRY_TLS_MIN 12
 #define GDT_ENTRY_TLS_MAX 14
 
-#define GDT_ENTRY_TLS_ENTRIES 3
-
 #define GDT_ENTRY_PER_CPU 15	/* Abused to load per CPU data from limit */
 #define __PER_CPU_SEG	(GDT_ENTRY_PER_CPU * 8 + 3)
 
@@ -45,20 +43,5 @@
 #define GS_TLS_SEL ((GDT_ENTRY_TLS_MIN+GS_TLS)*8 + 3)
 #define FS_TLS_SEL ((GDT_ENTRY_TLS_MIN+FS_TLS)*8 + 3)
 
-#define IDT_ENTRIES 256
 #define GDT_ENTRIES 16
-#define GDT_SIZE (GDT_ENTRIES * 8)
-#define TLS_SIZE (GDT_ENTRY_TLS_ENTRIES * 8) 
-
-/* Bottom two bits of selector give the ring privilege level */
-#define SEGMENT_RPL_MASK	0x3
-/* Bit 2 is table indicator (LDT/GDT) */
-#define SEGMENT_TI_MASK		0x4
-
-/* User mode is privilege level 3 */
-#define USER_RPL		0x3
-/* LDT segment has TI set, GDT has it cleared */
-#define SEGMENT_LDT		0x4
-#define SEGMENT_GDT		0x0
-
 #endif
-- 
1.4.4.2

