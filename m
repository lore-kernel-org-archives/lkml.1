Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbXHHHLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbXHHHLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbXHHHIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:08:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610AbXHHHIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:08:10 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 16/25] [PATCH] introducing paravirt_activate_mm
Date: Wed,  8 Aug 2007 01:19:03 -0300
Message-Id: <11865468162812-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11865468122642-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com> <1186546789356-git-send-email-gcosta@redhat.com> <11865467931543-git-send-email-gcosta@redhat.com> <11865467973510-git-send-email-gcosta@redhat.com> <11865468003673-git-send-email-gcosta@redhat.com> <11865468043920-git-send-email-gcosta@redhat.com> <118654680831-git-send-email-gcosta@redhat.com> <11865468122642-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This function/macro will allow a paravirt guest to be notified we changed
the current task cr3, and act upon it. It's up to them

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-x86_64/mmu_context.h |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86_64/mmu_context.h b/include/asm-x86_64/mmu_context.h
index 9592698..77ce047 100644
--- a/include/asm-x86_64/mmu_context.h
+++ b/include/asm-x86_64/mmu_context.h
@@ -7,7 +7,16 @@
 #include <asm/pda.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
 #include <asm-generic/mm_hooks.h>
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
+{
+}
+#endif /* CONFIG_PARAVIRT */
 
 /*
  * possibly do the LDT unload here?
@@ -67,8 +76,10 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	asm volatile("movl %0,%%fs"::"r"(0));  \
 } while(0)
 
-#define activate_mm(prev, next) \
-	switch_mm((prev),(next),NULL)
-
+#define activate_mm(prev, next) 		\
+do {						\
+	paravirt_activate_mm(prev, next);	\
+	switch_mm((prev),(next),NULL);		\
+} while (0)
 
 #endif
-- 
1.4.4.2

