Return-Path: <linux-kernel-owner+w=401wt.eu-S1765017AbYA2Ac2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765017AbYA2Ac2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbYA2AcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:32:20 -0500
Received: from zrnetservice.com ([209.133.52.163]:50288 "EHLO
	www.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752949AbYA2AcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:32:19 -0500
X-Greylist: delayed 2553 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 19:32:19 EST
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 4] x86: pud_clear: only reload cr3 if necessary
X-Mercurial-Node: 6c5c4139cb6939f5b0c3e495630f47c3f70179ac
Message-Id: <6c5c4139cb6939f5b0c3.1201564123@localhost>
In-Reply-To: <patchbomb.1201564120@localhost>
Date: Mon, 28 Jan 2008 15:48:43 -0800
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
@@ -93,17 +93,20 @@ static inline void native_pmd_clear(pmd_
 
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


