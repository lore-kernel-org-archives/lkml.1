Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbXLLPoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbXLLPoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758539AbXLLPkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:40:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759058AbXLLPkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:40:08 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 16/19] modify get_desc_base
Date: Wed, 12 Dec 2007 10:54:01 -0200
Message-Id: <1197464145737-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1197464139284-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11974640441088-git-send-email-gcosta@redhat.com> <11974640522688-git-send-email-gcosta@redhat.com> <1197464057242-git-send-email-gcosta@redhat.com> <11974640653022-git-send-email-gcosta@redhat.com> <1197464070228-git-send-email-gcosta@redhat.com> <11974640752137-git-send-email-gcosta@redhat.com> <11974640813511-git-send-email-gcosta@redhat.com> <11974640872474-git-send-email-gcosta@redhat.com> <11974640932406-git-send-email-gcosta@redhat.com> <11974640983333-git-send-email-gcosta@redhat.com> <11974641042757-git-send-email-gcosta@redhat.com> <11974641102691-git-send-email-gcosta@redhat.com> <11974641172402-git-send-email-gcosta@redhat.com> <11974641243264-git-send-email-gcosta@redhat.com> <11974641314148-git-send-email-gcosta@redhat.com> <1197464139284-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes get_desc_base() receive a struct desc_struct,
and then uses its internal fields to compute the base address.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/tls.c  |    2 +-
 arch/x86/mm/fault_32.c |    2 +-
 include/asm-x86/desc.h |    8 ++------
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 74d2b65..98f428b 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -112,7 +112,7 @@ int do_get_thread_area(struct task_struct *p, int idx,
 
 	memset(&info, 0, sizeof(struct user_desc));
 	info.entry_number = idx;
-	info.base_addr = get_desc_base((void *)desc);
+	info.base_addr = get_desc_base((struct desc_struct *)desc);
 	info.limit = GET_LIMIT(desc);
 	info.seg_32bit = GET_32BIT(desc);
 	info.contents = GET_CONTENTS(desc);
diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 6056c6d..ef5ab2b 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -115,7 +115,7 @@ static inline unsigned long get_segment_eip(struct pt_regs *regs,
 	}
 
 	/* Decode the code segment base from the descriptor */
-	base = get_desc_base((unsigned long *)desc);
+	base = get_desc_base((struct desc_struct *)desc);
 
 	if (seg & (1<<2)) { 
 		mutex_unlock(&current->mm->context.lock);
diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index 926d6f8..3480cb1 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -55,13 +55,9 @@ static inline void load_LDT(mm_context_t *pc)
 	preempt_enable();
 }
 
-static inline unsigned long get_desc_base(unsigned long *desc)
+static inline unsigned long get_desc_base(struct desc_struct *desc)
 {
-	unsigned long base;
-	base = ((desc[0] >> 16)  & 0x0000ffff) |
-		((desc[1] << 16) & 0x00ff0000) |
-		(desc[1] & 0xff000000);
-	return base;
+	return desc->base0 | ((desc->base1) << 16) | ((desc->base2) << 24);
 }
 
 #else
-- 
1.5.0.6

