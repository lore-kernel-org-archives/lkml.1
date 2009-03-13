Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZCMIPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZCMIPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZCMIMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:17 -0400
Received: from gw.goop.org ([64.81.55.164]:34807 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753156AbZCMIMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:13 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/24] xen: make xen_load_gdt simpler
Date: Fri, 13 Mar 2009 01:11:42 -0700
Message-Id: <1236931920-6861-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Remove use of multicall machinery which is unused (gdt loading
is never performance critical).  This removes the implicit use
of percpu variables, which simplifies understanding how
the percpu code's use of load_gdt interacts with this code.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 5776dc2..48b399b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -284,12 +284,11 @@ static void xen_set_ldt(const void *addr, unsigned entries)
 
 static void xen_load_gdt(const struct desc_ptr *dtr)
 {
-	unsigned long *frames;
 	unsigned long va = dtr->address;
 	unsigned int size = dtr->size + 1;
 	unsigned pages = (size + PAGE_SIZE - 1) / PAGE_SIZE;
+	unsigned long frames[pages];
 	int f;
-	struct multicall_space mcs;
 
 	/* A GDT can be up to 64k in size, which corresponds to 8192
 	   8-byte entries, or 16 4k pages.. */
@@ -297,9 +296,6 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
 	BUG_ON(size > 65536);
 	BUG_ON(va & ~PAGE_MASK);
 
-	mcs = xen_mc_entry(sizeof(*frames) * pages);
-	frames = mcs.args;
-
 	for (f = 0; va < dtr->address + size; va += PAGE_SIZE, f++) {
 		int level;
 		pte_t *ptep = lookup_address(va, &level);
@@ -314,13 +310,15 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
 
 		frames[f] = mfn;
 
+		printk("xen_load_gdt: %d va=%p mfn=%lx pfn=%lx va'=%p\n",
+		       f, (void *)va, mfn, pfn, virt);
+
 		make_lowmem_page_readonly((void *)va);
 		make_lowmem_page_readonly(virt);
 	}
 
-	MULTI_set_gdt(mcs.mc, frames, size / sizeof(struct desc_struct));
-
-	xen_mc_issue(PARAVIRT_LAZY_CPU);
+	if (HYPERVISOR_set_gdt(frames, size / sizeof(struct desc_struct)))
+		BUG();
 }
 
 static void load_TLS_descriptor(struct thread_struct *t,
-- 
1.6.0.6

