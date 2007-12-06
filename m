Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbXLFTF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbXLFTF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbXLFTCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:02:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbXLFTCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:02:00 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 15/19] modify get_desc_base
Date: Thu,  6 Dec 2007 14:16:36 -0200
Message-Id: <11969578773678-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <119695787262-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11969578092869-git-send-email-gcosta@redhat.com> <11969578142514-git-send-email-gcosta@redhat.com> <11969578193406-git-send-email-gcosta@redhat.com> <11969578242463-git-send-email-gcosta@redhat.com> <11969578292944-git-send-email-gcosta@redhat.com> <11969578343061-git-send-email-gcosta@redhat.com> <11969578383955-git-send-email-gcosta@redhat.com> <11969578431489-git-send-email-gcosta@redhat.com> <11969578483552-git-send-email-gcosta@redhat.com> <11969578534185-git-send-email-gcosta@redhat.com> <11969578581299-git-send-email-gcosta@redhat.com> <1196957863723-git-send-email-gcosta@redhat.com> <11969578671479-git-send-email-gcosta@redhat.com> <119695787262-git-send-email-gcosta@redhat.com>
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
1.4.4.2

