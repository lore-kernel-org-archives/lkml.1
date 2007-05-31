Return-Path: <linux-kernel-owner+w=401wt.eu-S1759863AbXEaHZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863AbXEaHZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 03:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbXEaHZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 03:25:30 -0400
Received: from ozlabs.org ([203.10.76.45]:49513 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbXEaHZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 03:25:29 -0400
Subject: [PATCH 3/3] lguest: faster tls switching
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <1180596254.11133.24.camel@localhost.localdomain>
References: <1180596191.11133.22.camel@localhost.localdomain>
	 <1180596254.11133.24.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 31 May 2007 17:25:16 +1000
Message-Id: <1180596316.11133.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1) When the Guest sets the new TLS entries, we don't need to re-verify
   the whole GDT.
2) We also don't need to copy all the GDT entries if only the TLS
   entries have changed.

Before:
Time for one context switch via pipe: 5406 (5170 - 7467)

After:
Time for one context switch via pipe: 4916 (4661 - 7004)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/core.c     |    5 ++++-
 drivers/lguest/lg.h       |    2 ++
 drivers/lguest/segments.c |   30 ++++++++++++++++++------------
 3 files changed, 24 insertions(+), 13 deletions(-)

diff -r e5e8dfc0fda2 drivers/lguest/core.c
--- a/drivers/lguest/core.c	Thu May 31 17:04:16 2007 +1000
+++ b/drivers/lguest/core.c	Thu May 31 17:12:24 2007 +1000
@@ -278,6 +278,9 @@ static void copy_in_guest_info(struct lg
 	/* Copy all GDT entries but the TSS. */
 	if (lg->changed & CHANGED_GDT)
 		copy_gdt(lg, pages->state.guest_gdt);
+	/* If only the TLS entries have changed, copy them. */
+	else if (lg->changed & CHANGED_GDT_TLS)
+		copy_gdt_tls(lg, pages->state.guest_gdt);
 
 	lg->changed = 0;
 }
diff -r e5e8dfc0fda2 drivers/lguest/lg.h
--- a/drivers/lguest/lg.h	Thu May 31 17:04:16 2007 +1000
+++ b/drivers/lguest/lg.h	Thu May 31 17:10:20 2007 +1000
@@ -115,6 +115,7 @@ struct lguest_pages
 
 #define CHANGED_IDT		1
 #define CHANGED_GDT		2
+#define CHANGED_GDT_TLS		4 /* Actually a subset of CHANGED_GDT */
 #define CHANGED_ALL	        3
 
 /* The private info the thread maintains about the guest. */
@@ -202,6 +203,7 @@ void load_guest_gdt(struct lguest *lg, u
 void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num);
 void guest_load_tls(struct lguest *lg, unsigned long tls_array);
 void copy_gdt(const struct lguest *lg, struct desc_struct *gdt);
+void copy_gdt_tls(const struct lguest *lg, struct desc_struct *gdt);
 
 /* page_tables.c: */
 int init_guest_pagetable(struct lguest *lg, unsigned long pgtable);
diff -r e5e8dfc0fda2 drivers/lguest/segments.c
--- a/drivers/lguest/segments.c	Thu May 31 17:04:16 2007 +1000
+++ b/drivers/lguest/segments.c	Thu May 31 17:11:46 2007 +1000
@@ -34,11 +34,11 @@ static void check_segment_use(struct lgu
 		kill_guest(lg, "Removed live GDT entry %u", desc);
 }
 
-static void fixup_gdt_table(struct lguest *lg)
+static void fixup_gdt_table(struct lguest *lg, unsigned start, unsigned end)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(lg->gdt); i++) {
+	for (i = start; i < end; i++) {
 		/* We never copy these ones to real gdt */
 		if (ignored_gdt(i))
 			continue;
@@ -86,6 +86,16 @@ void setup_guest_gdt(struct lguest *lg)
 	lg->gdt[GDT_ENTRY_KERNEL_DS].b |= (GUEST_PL << 13);
 }
 
+/* This is a fast version for the common case where only the three TLS entries
+ * have changed. */
+void copy_gdt_tls(const struct lguest *lg, struct desc_struct *gdt)
+{
+	unsigned int i;
+
+	for (i = GDT_ENTRY_TLS_MIN; i <= GDT_ENTRY_TLS_MAX; i++)
+		gdt[i] = lg->gdt[i];
+}
+
 void copy_gdt(const struct lguest *lg, struct desc_struct *gdt)
 {
 	unsigned int i;
@@ -101,7 +111,7 @@ void load_guest_gdt(struct lguest *lg, u
 		kill_guest(lg, "too many gdt entries %i", num);
 
 	lgread(lg, lg->gdt, table, num * sizeof(lg->gdt[0]));
-	fixup_gdt_table(lg);
+	fixup_gdt_table(lg, 0, ARRAY_SIZE(lg->gdt));
 	lg->changed |= CHANGED_GDT;
 }
 
@@ -110,6 +120,6 @@ void guest_load_tls(struct lguest *lg, u
 	struct desc_struct *tls = &lg->gdt[GDT_ENTRY_TLS_MIN];
 
 	lgread(lg, tls, gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
-	fixup_gdt_table(lg);
-	lg->changed |= CHANGED_GDT;
+	fixup_gdt_table(lg, GDT_ENTRY_TLS_MIN, GDT_ENTRY_TLS_MAX+1);
+	lg->changed |= CHANGED_GDT_TLS;
 }


