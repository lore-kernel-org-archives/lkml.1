Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbYFYEmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbYFYEmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbYFYEhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:24 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37438 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753256AbYFYEhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:16 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 24 of 36] x86_64: create small vmemmap mappings if PSE not
	available
X-Mercurial-Node: 2f96ae0c2f1ef7268128f33d5cd88aae5ba2299d
Message-Id: <2f96ae0c2f1ef7268128.1214367560@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:20 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If PSE is not available, then fall back to 4k page mappings for the
vmemmap area.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/init_64.c |   62 +++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -997,7 +997,7 @@
 	pmd_t *pmd;
 
 	for (; addr < end; addr = next) {
-		next = pmd_addr_end(addr, end);
+		void *p = NULL;
 
 		pgd = vmemmap_pgd_populate(addr, node);
 		if (!pgd)
@@ -1007,33 +1007,51 @@
 		if (!pud)
 			return -ENOMEM;
 
-		pmd = pmd_offset(pud, addr);
-		if (pmd_none(*pmd)) {
-			pte_t entry;
-			void *p;
+		if (!cpu_has_pse) {
+			next = (addr + PAGE_SIZE) & PAGE_MASK;
+			pmd = vmemmap_pmd_populate(pud, addr, node);
 
-			p = vmemmap_alloc_block(PMD_SIZE, node);
+			if (!pmd)
+				return -ENOMEM;
+
+			p = vmemmap_pte_populate(pmd, addr, node);
+
 			if (!p)
 				return -ENOMEM;
 
-			entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
-							PAGE_KERNEL_LARGE);
-			set_pmd(pmd, __pmd(pte_val(entry)));
+			addr_end = addr + PAGE_SIZE;
+			p_end = p + PAGE_SIZE;
+		} else {
+			next = pmd_addr_end(addr, end);
 
-			/* check to see if we have contiguous blocks */
-			if (p_end != p || node_start != node) {
-				if (p_start)
-					printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
-						addr_start, addr_end-1, p_start, p_end-1, node_start);
-				addr_start = addr;
-				node_start = node;
-				p_start = p;
-			}
-			addr_end = addr + PMD_SIZE;
-			p_end = p + PMD_SIZE;
-		} else {
-			vmemmap_verify((pte_t *)pmd, node, addr, next);
+			pmd = pmd_offset(pud, addr);
+			if (pmd_none(*pmd)) {
+				pte_t entry;
+
+				p = vmemmap_alloc_block(PMD_SIZE, node);
+				if (!p)
+					return -ENOMEM;
+
+				entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
+						PAGE_KERNEL_LARGE);
+				set_pmd(pmd, __pmd(pte_val(entry)));
+
+				addr_end = addr + PMD_SIZE;
+				p_end = p + PMD_SIZE;
+
+				/* check to see if we have contiguous blocks */
+				if (p_end != p || node_start != node) {
+					if (p_start)
+						printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
+						       addr_start, addr_end-1, p_start, p_end-1, node_start);
+					addr_start = addr;
+					node_start = node;
+					p_start = p;
+				}
+			} else
+				vmemmap_verify((pte_t *)pmd, node, addr, next);
 		}
+
 	}
 	return 0;
 }


