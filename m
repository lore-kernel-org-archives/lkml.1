Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbYBAQki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbYBAQki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbYBAQkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:40:04 -0500
Received: from gw.goop.org ([64.81.55.164]:59586 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728AbYBAQkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:40:01 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 4] x86: pud_clear: only reload cr3 if necessary
X-Mercurial-Node: fcc09891be6e8c78011401cfff9c5947d5fd200c
Message-Id: <fcc09891be6e8c780114.1201883963@localhost>
In-Reply-To: <patchbomb.1201883960@localhost>
Date: Fri, 01 Feb 2008 08:39:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than unconditionally reloading cr3, only do so if the pud we're
updating is within the active pgd.

This eliminates TLB flushes most of the time.  The
performance-critical uses of pud_clear are during execve and exit, but
in those cases cr3 is referring to some other pagetable.  The only
other use of pud_clear is during a large (1Gbyte+) munmap, and those
are sufficiently rare that a couple of cr3 reloads won't hurt.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/pgtable-3level.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -93,17 +93,20 @@
 
 static inline void pud_clear(pud_t *pudp)
 {
+	unsigned long pgd;
+
 	set_pud(pudp, __pud(0));
 
 	/*
 	 * Pentium-II erratum A13: in PAE mode we explicitly have to flush
 	 * the TLB via cr3 if the top-level pgd is changed...
 	 *
-	 * XXX I don't think we need to worry about this here, since
-	 * when clearing the pud, the calling code needs to flush the
-	 * tlb anyway.  But do it now for safety's sake. - jsgf
+	 * Make sure the pud entry we're updating is within the
+	 * current pgd to avoid unnecessary TLB flushes.
 	 */
-	write_cr3(read_cr3());
+	pgd = read_cr3();
+	if (__pa(pudp) >= pgd && __pa(pudp) < (pgd + sizeof(pgd_t)*PTRS_PER_PGD))
+		write_cr3(pgd);
 }
 
 #define pud_page(pud) \


