Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZAVWYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZAVWYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZAVWY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:24:29 -0500
Received: from gw.goop.org ([64.81.55.164]:32849 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZAVWY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:24:28 -0500
Message-ID: <4978F216.5040803@goop.org>
Date: Thu, 22 Jan 2009 14:24:22 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 2/2] x86: add pte_set_flags/clear_flags for pte flag manipulation
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not necessary to deconstruct and reconstruct a pte every time its
flags are being updated.  Introduce pte_set_flags and pte_clear_flags
to set and clear flags in a pte.  This allows the flag manipulation
code to be inlined, and avoids calls via paravirt-ops.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

===================================================================
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -240,64 +240,78 @@
 		(_PAGE_PSE | _PAGE_PRESENT);
 }
 
+static inline pte_t pte_set_flags(pte_t pte, pteval_t set)
+{
+	pteval_t v = native_pte_val(pte);
+
+	return native_make_pte(v | set);
+}
+
+static inline pte_t pte_clear_flags(pte_t pte, pteval_t clear)
+{
+	pteval_t v = native_pte_val(pte);
+
+	return native_make_pte(v & ~clear);
+}
+
 static inline pte_t pte_mkclean(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~_PAGE_DIRTY);
+	return pte_clear_flags(pte, _PAGE_DIRTY);
 }
 
 static inline pte_t pte_mkold(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~_PAGE_ACCESSED);
+	return pte_clear_flags(pte, _PAGE_ACCESSED);
 }
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~_PAGE_RW);
+	return pte_clear_flags(pte, _PAGE_RW);
 }
 
 static inline pte_t pte_mkexec(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~_PAGE_NX);
+	return pte_clear_flags(pte, _PAGE_NX);
 }
 
 static inline pte_t pte_mkdirty(pte_t pte)
 {
-	return __pte(pte_val(pte) | _PAGE_DIRTY);
+	return pte_set_flags(pte, _PAGE_DIRTY);
 }
 
 static inline pte_t pte_mkyoung(pte_t pte)
 {
-	return __pte(pte_val(pte) | _PAGE_ACCESSED);
+	return pte_set_flags(pte, _PAGE_ACCESSED);
 }
 
 static inline pte_t pte_mkwrite(pte_t pte)
 {
-	return __pte(pte_val(pte) | _PAGE_RW);
+	return pte_set_flags(pte, _PAGE_RW);
 }
 
 static inline pte_t pte_mkhuge(pte_t pte)
 {
-	return __pte(pte_val(pte) | _PAGE_PSE);
+	return pte_set_flags(pte, _PAGE_PSE);
 }
 
 static inline pte_t pte_clrhuge(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~_PAGE_PSE);
+	return pte_clear_flags(pte, _PAGE_PSE);
 }
 
 static inline pte_t pte_mkglobal(pte_t pte)
 {
-	return __pte(pte_val(pte) | _PAGE_GLOBAL);
+	return pte_set_flags(pte, _PAGE_GLOBAL);
 }
 
 static inline pte_t pte_clrglobal(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~_PAGE_GLOBAL);
+	return pte_clear_flags(pte, _PAGE_GLOBAL);
 }
 
 static inline pte_t pte_mkspecial(pte_t pte)
 {
-	return __pte(pte_val(pte) | _PAGE_SPECIAL);
+	return pte_set_flags(pte, _PAGE_SPECIAL);
 }
 
 extern pteval_t __supported_pte_mask;


