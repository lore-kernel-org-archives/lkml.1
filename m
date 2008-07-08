Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYGHXVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYGHXVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757642AbYGHXOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:51 -0400
Received: from gw.goop.org ([64.81.55.164]:51205 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394AbYGHXOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:44 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 33 of 55] xen64: use arbitrary_virt_to_machine for xen_set_pmd
X-Mercurial-Node: 985907b145a455344299eaea078e359b538acd7c
Message-Id: <985907b145a455344299.1215554815@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building initial pagetables in 64-bit kernel the pud/pmd pointer may
be in ioremap/fixmap space, so we need to walk the pagetable to look up the
physical address.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c         |    9 ++++++---
 include/asm-x86/xen/page.h |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -178,8 +178,9 @@
 	p2m_top[topidx][idx] = mfn;
 }
 
-xmaddr_t arbitrary_virt_to_machine(unsigned long address)
+xmaddr_t arbitrary_virt_to_machine(void *vaddr)
 {
+	unsigned long address = (unsigned long)vaddr;
 	unsigned int level;
 	pte_t *pte = lookup_address(address, &level);
 	unsigned offset = address & ~PAGE_MASK;
@@ -253,7 +254,8 @@
 
 	xen_mc_batch();
 
-	u.ptr = virt_to_machine(ptr).maddr;
+	/* ptr may be ioremapped for 64-bit pagetable setup */
+	u.ptr = arbitrary_virt_to_machine(ptr).maddr;
 	u.val = pmd_val_ma(val);
 	extend_mmu_update(&u);
 
@@ -415,7 +417,8 @@
 
 	xen_mc_batch();
 
-	u.ptr = virt_to_machine(ptr).maddr;
+	/* ptr may be ioremapped for 64-bit pagetable setup */
+	u.ptr = arbitrary_virt_to_machine(ptr).maddr;
 	u.val = pud_val_ma(val);
 	extend_mmu_update(&u);
 
diff --git a/include/asm-x86/xen/page.h b/include/asm-x86/xen/page.h
--- a/include/asm-x86/xen/page.h
+++ b/include/asm-x86/xen/page.h
@@ -158,7 +158,7 @@
 #define pgd_val_ma(x)	((x).pgd)
 
 
-xmaddr_t arbitrary_virt_to_machine(unsigned long address);
+xmaddr_t arbitrary_virt_to_machine(void *address);
 void make_lowmem_page_readonly(void *vaddr);
 void make_lowmem_page_readwrite(void *vaddr);
 


