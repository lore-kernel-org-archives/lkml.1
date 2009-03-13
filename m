Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZCMIQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZCMIQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbZCMIMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:19 -0400
Received: from gw.goop.org ([64.81.55.164]:34815 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753449AbZCMIMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:16 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 05/24] xen: clean up xen_load_gdt
Date: Fri, 13 Mar 2009 01:11:41 -0700
Message-Id: <1236931920-6861-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Makes the logic a bit clearer.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 70b355d..5776dc2 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -301,10 +301,21 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
 	frames = mcs.args;
 
 	for (f = 0; va < dtr->address + size; va += PAGE_SIZE, f++) {
-		frames[f] = arbitrary_virt_to_mfn((void *)va);
+		int level;
+		pte_t *ptep = lookup_address(va, &level);
+		unsigned long pfn, mfn;
+		void *virt;
+
+		BUG_ON(ptep == NULL);
+
+		pfn = pte_pfn(*ptep);
+		mfn = pfn_to_mfn(pfn);
+		virt = __va(PFN_PHYS(pfn));
+
+		frames[f] = mfn;
 
 		make_lowmem_page_readonly((void *)va);
-		make_lowmem_page_readonly(mfn_to_virt(frames[f]));
+		make_lowmem_page_readonly(virt);
 	}
 
 	MULTI_set_gdt(mcs.mc, frames, size / sizeof(struct desc_struct));
-- 
1.6.0.6

