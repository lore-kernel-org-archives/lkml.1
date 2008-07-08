Return-Path: <linux-kernel-owner+w=401wt.eu-S1759806AbYGHXVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806AbYGHXVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbYGHXOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:52 -0400
Received: from gw.goop.org ([64.81.55.164]:51206 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411AbYGHXOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:44 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 35 of 55] xen64: defer setting pagetable alloc/release ops
X-Mercurial-Node: 6db4456f5ddb04a189f4fd8930560215733fb5a8
Message-Id: <6db4456f5ddb04a189f4.1215554817@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to wait until the page structure is available to use the
proper pagetable page alloc/release operations, since they use struct
page to determine if a pagetable is pinned.

This happened to work in 32bit because nobody allocated new pagetable
pages in the interim between xen_pagetable_setup_done and
xen_post_allocator_init, but the 64-bit kenrel needs to allocate more
pagetable levels.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -878,6 +878,18 @@
 
 static __init void xen_pagetable_setup_done(pgd_t *base)
 {
+	xen_setup_shared_info();
+}
+
+static __init void xen_post_allocator_init(void)
+{
+	pv_mmu_ops.set_pte = xen_set_pte;
+	pv_mmu_ops.set_pmd = xen_set_pmd;
+	pv_mmu_ops.set_pud = xen_set_pud;
+#if PAGETABLE_LEVELS == 4
+	pv_mmu_ops.set_pgd = xen_set_pgd;
+#endif
+
 	/* This will work as long as patching hasn't happened yet
 	   (which it hasn't) */
 	pv_mmu_ops.alloc_pte = xen_alloc_pte;
@@ -887,19 +899,6 @@
 #if PAGETABLE_LEVELS == 4
 	pv_mmu_ops.alloc_pud = xen_alloc_pud;
 	pv_mmu_ops.release_pud = xen_release_pud;
-#endif
-
-	pv_mmu_ops.set_pte = xen_set_pte;
-
-	xen_setup_shared_info();
-}
-
-static __init void xen_post_allocator_init(void)
-{
-	pv_mmu_ops.set_pmd = xen_set_pmd;
-	pv_mmu_ops.set_pud = xen_set_pud;
-#if PAGETABLE_LEVELS == 4
-	pv_mmu_ops.set_pgd = xen_set_pgd;
 #endif
 
 	xen_mark_init_mm_pinned();


