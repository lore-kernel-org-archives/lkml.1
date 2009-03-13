Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbZCMIM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbZCMIM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZCMIMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:10 -0400
Received: from gw.goop.org ([64.81.55.164]:34784 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752156AbZCMIMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:08 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 04/24] xen: split construction of p2m mfn tables from registration
Date: Fri, 13 Mar 2009 01:11:40 -0700
Message-Id: <1236931920-6861-5-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Build the p2m_mfn_list_list early with the rest of the p2m table, but
register it later when the real shared_info structure is in place.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 05280b4..2d30b74 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -187,7 +187,7 @@ RESERVE_BRK(xen_top_mfn, SIZE_TOP_MFN);
 RESERVE_BRK(xen_top_mfn_list, SIZE_TOP_MFN_LIST);
 
 /* Build the parallel p2m_top_mfn structures */
-void xen_setup_mfn_list_list(void)
+static void __init xen_build_mfn_list_list(void)
 {
 	unsigned pfn, idx;
 
@@ -204,7 +204,10 @@ void xen_setup_mfn_list_list(void)
 		unsigned topidx = idx * P2M_ENTRIES_PER_PAGE;
 		p2m_top_mfn_list[idx] = virt_to_mfn(&p2m_top_mfn[topidx]);
 	}
+}
 
+void xen_setup_mfn_list_list(void)
+{
 	BUG_ON(HYPERVISOR_shared_info == &xen_dummy_shared_info);
 
 	HYPERVISOR_shared_info->arch.pfn_to_mfn_frame_list_list =
@@ -238,6 +241,8 @@ void __init xen_build_dynamic_phys_to_machine(void)
 
 		p2m_top[topidx] = &mfn_list[pfn];
 	}
+
+	xen_build_mfn_list_list();
 }
 
 unsigned long get_phys_to_machine(unsigned long pfn)
-- 
1.6.0.6

