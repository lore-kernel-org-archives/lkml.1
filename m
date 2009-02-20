Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbZBTBPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbZBTBPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZBTBPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:15:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62301 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbZBTBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:15:22 -0500
Message-Id: <20090220011520.536476635@goodmis.org>
References: <20090220011316.379904625@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 19 Feb 2009 20:13:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/6] x86: keep pmd rw bit set when creating 4K level pages
Content-Disposition: inline; filename=0002-x86-keep-pmd-rw-bit-set-when-creating-4K-level-page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to set_memory_rw

I was hitting a hard lock up when I would set a page range to
read-write, and then write to it. The lock up happened because
the PTE was set to RW but its PMD was not. This would take a page
fault, but the page fault handler mistaken it for a spurious fault
caused by lazy TLB transactions. This was because it only checked
the permission bits of the PTE, which were correct. The PMD
was not. The fault handler would return only to take the page
fault again.

 fault -> PTE OK must be spurious -> return -> fault -> etc.

What caused this anomaly was this:

1) The kernel pages were set at the end of boot up to read-only.
2) Since the change could keep the large 2M page tables it just
   changed the PTE bit for the 2M section.
3) The 2M section needed to be split up for NX bit being set.
4) The break up made the original PTE into a PMD and moved the
   protection bits to the smaller 4K PTEs. The PMD kept its
   RW bit off.
5) Now to set the range of pages for RW. Only the PTEs were
   modified (already split up), and not the PMD that contained
   them.

After that, we were in a state where the PTEs allowed the write but the
PMD did not.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/mm/pageattr.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 84ba748..79c700d 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -513,11 +513,13 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	 * On Intel the NX bit of all levels must be cleared to make a
 	 * page executable. See section 4.13.2 of Intel 64 and IA-32
 	 * Architectures Software Developer's Manual).
+	 * The same is true for RW. Let the PTE determine the
+	 * the RW protection, and keep the PMD RW set.
 	 *
 	 * Mark the entry present. The current mapping might be
 	 * set to not present, which we preserved above.
 	 */
-	ref_prot = pte_pgprot(pte_mkexec(pte_clrhuge(*kpte)));
+	ref_prot = pte_pgprot(pte_mkwrite(pte_mkexec(pte_clrhuge(*kpte))));
 	pgprot_val(ref_prot) |= _PAGE_PRESENT;
 	__set_pmd_pte(kpte, address, mk_pte(base, ref_prot));
 	base = NULL;
-- 
1.5.6.5

-- 
