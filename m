Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbXKLPqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbXKLPqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbXKLPqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:46:24 -0500
Received: from [198.99.130.12] ([198.99.130.12]:58080 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbXKLPqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:46:23 -0500
Date: Mon, 12 Nov 2007 10:45:44 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/2] UML - Update address space affected by pud_clear
Message-ID: <20071112154544.GA5576@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pud_clear wasn't setting the _PAGE_NEWPAGE bit, fooling tlb_flush into
thinking that this area of the address space was up-to-date and not
unmapping whatever was covered by the pud.

This manifested itself as ldconfig on x86_64 complaining about the
first library it looked at not being a valid ELF file.  A config file
is mapped at 0x4000000, as the only thing mapped under its pud, and
unmapped.  The unmapping caused a pud_clear, which, due to this bug,
didn't actually unmap the config file data on the host.  The first
library is then mapped at the same location, but is not actually
mapped on the host because accesses to it cause no page faults.  As a
result, ldconfig sees the old config file data.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 include/asm-um/pgtable-3level.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/include/asm-um/pgtable-3level.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/pgtable-3level.h	2007-10-12 12:09:08.000000000 -0400
+++ linux-2.6.22/include/asm-um/pgtable-3level.h	2007-11-07 12:20:02.000000000 -0500
@@ -71,7 +71,7 @@ static inline pmd_t *pmd_alloc_one(struc
 
 static inline void pud_clear (pud_t *pud)
 {
-        set_pud(pud, __pud(0));
+        set_pud(pud, __pud(_PAGE_NEWPAGE));
 }
 
 #define pud_page(pud) phys_to_page(pud_val(pud) & PAGE_MASK)
