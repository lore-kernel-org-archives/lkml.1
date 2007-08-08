Return-Path: <linux-kernel-owner+w=401wt.eu-S1764629AbXHHHSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764629AbXHHHSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759650AbXHHHJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:09:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758204AbXHHHJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:09:02 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 17/25] [PATCH] turn page operations into native versions
Date: Wed,  8 Aug 2007 01:19:04 -0300
Message-Id: <1186546820708-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11865468162812-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com> <1186546789356-git-send-email-gcosta@redhat.com> <11865467931543-git-send-email-gcosta@redhat.com> <11865467973510-git-send-email-gcosta@redhat.com> <11865468003673-git-send-email-gcosta@redhat.com> <11865468043920-git-send-email-gcosta@redhat.com> <118654680831-git-send-email-gcosta@redhat.com> <11865468122642-git-send-email-gcosta@redhat.com> <11865468162812-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch turns the page operations (set and make a page table)
into native_ versions. The operations itself will be later
overriden by paravirt.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-x86_64/page.h |   36 +++++++++++++++++++++++++++++++-----
 1 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/include/asm-x86_64/page.h b/include/asm-x86_64/page.h
index 88adf1a..ec8b245 100644
--- a/include/asm-x86_64/page.h
+++ b/include/asm-x86_64/page.h
@@ -64,16 +64,42 @@ typedef struct { unsigned long pgprot; } pgprot_t;
 
 extern unsigned long phys_base;
 
-#define pte_val(x)	((x).pte)
-#define pmd_val(x)	((x).pmd)
-#define pud_val(x)	((x).pud)
-#define pgd_val(x)	((x).pgd)
-#define pgprot_val(x)	((x).pgprot)
+static inline unsigned long native_pte_val(pte_t pte)
+{
+	return pte.pte;
+}
+
+static inline unsigned long native_pud_val(pud_t pud)
+{
+	return pud.pud;
+}
+
+
+static inline unsigned long native_pmd_val(pmd_t pmd)
+{
+	return pmd.pmd;
+}
+
+static inline unsigned long native_pgd_val(pgd_t pgd)
+{
+	return pgd.pgd;
+}
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define pte_val(x)	native_pte_val(x)
+#define pmd_val(x)	native_pmd_val(x)
+#define pud_val(x)	native_pud_val(x)
+#define pgd_val(x)	native_pgd_val(x)
 
 #define __pte(x) ((pte_t) { (x) } )
 #define __pmd(x) ((pmd_t) { (x) } )
 #define __pud(x) ((pud_t) { (x) } )
 #define __pgd(x) ((pgd_t) { (x) } )
+#endif /* CONFIG_PARAVIRT */
+
+#define pgprot_val(x)	((x).pgprot)
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
 #endif /* !__ASSEMBLY__ */
-- 
1.4.4.2

