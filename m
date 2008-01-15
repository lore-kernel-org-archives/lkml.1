Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbYAOVmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbYAOVmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYAOVme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:42:34 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:13198 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbYAOVmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:42:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EzoDLHAjmRvdWCVKvSLa6wTXKmn4PZKrztp6DPEozYlPThgxhoIr6rW9TcXJGvOdnuocJx8aMBazpN2eKoLw01wlExW8S6ELxAmkJ52ZtRT16Sv39zouOgHZFqCo60aagVmGVFhJIFJLG8UhDnNjlYKU42g0nHjwQRnGWdbYa8A=
Subject: [PATCH] x86: Unify pte_exec helper
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 13:42:36 -0800
Message-Id: <1200433356.16794.52.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Rename it to pte_exec() from pte_exec_kernel(). There is nothing
kernel specific in there.
- Move it into the common file because _PAGE_NX is 0 on !PAE and then
pte_exec() will be always evaluate to true.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Taken from Patch 31/31 in Andi's CPA queue, added the init_32 change
as well.  Against x86.git

 arch/x86/mm/fault_32.c           |    2 +-
 arch/x86/mm/init_32.c            |    2 +-
 include/asm-x86/pgtable-2level.h |    8 --------
 include/asm-x86/pgtable-3level.h |    8 --------
 include/asm-x86/pgtable.h        |    1 +
 5 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 977904c..936bb0c 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -615,7 +615,7 @@ no_context:
 		if (error_code & PF_INSTR) {
 			pte_t *pte = lookup_address(address);
 
-			if (pte && pte_present(*pte) && !pte_exec_kernel(*pte))
+			if (pte && pte_present(*pte) && !pte_exec(*pte))
 				printk(KERN_CRIT "kernel tried to execute "
 					"NX-protected page - exploit attempt? "
 					"(uid: %d)\n", current->uid);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index b8ba6a7..2456968 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -613,7 +613,7 @@ int __init set_kernel_exec(unsigned long vaddr, int enable)
 	pte = lookup_address(vaddr);
 	BUG_ON(!pte);
 
-	if (!pte_exec_kernel(*pte))
+	if (!pte_exec(*pte))
 		ret = 0;
 
 	if (enable)
diff --git a/include/asm-x86/pgtable-2level.h b/include/asm-x86/pgtable-2level.h
index ce486bd..701404f 100644
--- a/include/asm-x86/pgtable-2level.h
+++ b/include/asm-x86/pgtable-2level.h
@@ -56,14 +56,6 @@ static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 #define pte_pfn(x)		(pte_val(x) >> PAGE_SHIFT)
 
 /*
- * All present pages are kernel-executable:
- */
-static inline int pte_exec_kernel(pte_t pte)
-{
-	return 1;
-}
-
-/*
  * Bits 0, 6 and 7 are taken, split up the 29 bits of offset
  * into this range:
  */
diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
index bfafa9b..20fc120 100644
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -19,14 +19,6 @@
 #define pud_bad(pud)				0
 #define pud_present(pud)			1
 
-/*
- * All present pages with !NX bit are kernel-executable:
- */
-static inline int pte_exec_kernel(pte_t pte)
-{
-	return !(pte_val(pte) & _PAGE_NX);
-}
-
 /* Rules for using set_pte: the pte being assigned *must* be
  * either not present or in a state where the hardware will
  * not attempt to update the pte.  In places where this is
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index bae9648..dce27bb 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -142,6 +142,7 @@ static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED;
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_huge(pte_t pte)		{ return pte_val(pte) & _PAGE_PSE; }
+static inline int pte_exec(pte_t pte)		{ return !(pte_val(pte) & _PAGE_NX); }
 
 static inline int pmd_large(pmd_t pte) {
 	return (pmd_val(pte) & (_PAGE_PSE|_PAGE_PRESENT)) ==
-- 
1.5.4.rc2.1164.g6451

