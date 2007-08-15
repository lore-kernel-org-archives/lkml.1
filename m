Return-Path: <linux-kernel-owner+w=401wt.eu-S1762090AbXHOM5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbXHOM5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 08:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761881AbXHOMyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:54:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761871AbXHOMyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:54:05 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 15/25][V3] introducing paravirt_activate_mm
Date: Wed, 15 Aug 2007 09:49:35 -0300
Message-Id: <11871823673236-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11871823373106-git-send-email-gcosta@redhat.com>
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com> <11871822244170-git-send-email-gcosta@redhat.com> <11871822342754-git-send-email-gcosta@redhat.com> <11871822421713-git-send-email-gcosta@redhat.com> <1187182253740-git-send-email-gcosta@redhat.com> <1187182268408-git-send-email-gcosta@redhat.com> <1187182282913-git-send-email-gcosta@redhat.com> <11871822951747-git-send-email-gcosta@redhat.com> <11871823042011-git-send-email-gcosta@redhat.com> <11871823151789-git-send-email-gcosta@redhat.com> <11871823273810-git-send-email-gcosta@redhat.com> <11871823373106-git-send-email-gcosta@redhat.com>
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

