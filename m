Return-Path: <linux-kernel-owner+w=401wt.eu-S1760663AbYGBBDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663AbYGBBDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760399AbYGBBCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:02:35 -0400
Received: from gw.goop.org ([64.81.55.164]:58675 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889AbYGBBBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:01:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 8 of 8] x86/cpa: use an undefined PTE bit for testing CPA
X-Mercurial-Node: abddb8b25c08f0d28b8ca662354569e575fc274b
Message-Id: <abddb8b25c08f0d28b8c.1214955997@localhost>
In-Reply-To: <patchbomb.1214955989@localhost>
Date: Tue, 01 Jul 2008 16:46:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than using _PAGE_GLOBAL - which not all CPUs support - to test
CPA, use one of the reserved-for-software-use PTE flags instead.  This
allows CPA testing to work on CPUs which don't support PGD.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/pageattr-test.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -1,8 +1,8 @@
 /*
  * self test for change_page_attr.
  *
- * Clears the global bit on random pages in the direct mapping, then reverts
- * and compares page tables forwards and afterwards.
+ * Clears the a test pte bit on random pages in the direct mapping,
+ * then reverts and compares page tables forwards and afterwards.
  */
 #include <linux/bootmem.h>
 #include <linux/kthread.h>
@@ -31,6 +31,13 @@
 #endif
 	GPS			= (1<<30)
 };
+
+#define PAGE_TESTBIT	__pgprot(_PAGE_UNUSED1)
+
+static int pte_testbit(pte_t pte)
+{
+	return pte_flags(pte) & _PAGE_UNUSED1;
+}
 
 struct split_state {
 	long lpg, gpg, spg, exec;
@@ -165,15 +172,14 @@
 			continue;
 		}
 
-		err = change_page_attr_clear(addr[i], len[i],
-					       __pgprot(_PAGE_GLOBAL));
+		err = change_page_attr_set(addr[i], len[i], PAGE_TESTBIT);
 		if (err < 0) {
 			printk(KERN_ERR "CPA %d failed %d\n", i, err);
 			failed++;
 		}
 
 		pte = lookup_address(addr[i], &level);
-		if (!pte || pte_global(*pte) || pte_huge(*pte)) {
+		if (!pte || !pte_testbit(*pte) || pte_huge(*pte)) {
 			printk(KERN_ERR "CPA %lx: bad pte %Lx\n", addr[i],
 				pte ? (u64)pte_val(*pte) : 0ULL);
 			failed++;
@@ -198,14 +204,13 @@
 			failed++;
 			continue;
 		}
-		err = change_page_attr_set(addr[i], len[i],
-					     __pgprot(_PAGE_GLOBAL));
+		err = change_page_attr_clear(addr[i], len[i], PAGE_TESTBIT);
 		if (err < 0) {
 			printk(KERN_ERR "CPA reverting failed: %d\n", err);
 			failed++;
 		}
 		pte = lookup_address(addr[i], &level);
-		if (!pte || !pte_global(*pte)) {
+		if (!pte || pte_testbit(*pte)) {
 			printk(KERN_ERR "CPA %lx: bad pte after revert %Lx\n",
 				addr[i], pte ? (u64)pte_val(*pte) : 0ULL);
 			failed++;


