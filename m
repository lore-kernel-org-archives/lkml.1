Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbZIPInn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbZIPInn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757788AbZIPInb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:43:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:54298 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757648AbZIPInV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:43:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,396,1249282800"; 
   d="scan'208";a="551023853"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jun Nakajima <jun.nakajima@intel.com>, Eddie Dong <eddie.dong@intel.com>,
       linux-kernel@vger.kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [RFC][PATCH 06/10] xen/hybrid: Add shared_info page for xen
Date: Wed, 16 Sep 2009 16:42:27 +0800
Message-Id: <1253090551-7969-7-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reserved shared_info page in xen-head.S, as hypercall page

Notice that we would modify the shared_info page, so put it in the data
section.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/xen/enlighten.c |   25 +++++++++++++++++++++++++
 arch/x86/xen/xen-head.S  |    6 ++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index b95c696..b6751ed 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -31,6 +31,7 @@
 #include <xen/interface/version.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/vcpu.h>
+#include <xen/interface/memory.h>
 #include <xen/interface/hvm/hvm_op.h>
 #include <xen/features.h>
 #include <xen/page.h>
@@ -1112,6 +1113,28 @@ static int init_hybrid_info(void)
 	return 0;
 }
 
+extern struct shared_info shared_info_page;
+
+static int __init init_shared_info(void)
+{
+	struct xen_add_to_physmap xatp;
+
+	xatp.domid = DOMID_SELF;
+	xatp.idx = 0;
+	xatp.space = XENMAPSPACE_shared_info;
+	xatp.gpfn = __pa(&shared_info_page) >> PAGE_SHIFT;
+	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
+		BUG();
+
+	HYPERVISOR_shared_info = (struct shared_info *)&shared_info_page;
+
+	/* Don't do the full vcpu_info placement stuff until we have a
+	   possible map and a non-dummy shared_info. */
+	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
+
+	return 0;
+}
+
 void __init xen_start_hybrid(void)
 {
 	int r;
@@ -1124,5 +1147,7 @@ void __init xen_start_hybrid(void)
 		return;
 
 	xen_hybrid_init_irq_ops();
+
+	init_shared_info();
 }
 
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 1a5ff24..26041ce 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -33,6 +33,12 @@ ENTRY(hypercall_page)
 	.skip PAGE_SIZE_asm
 .popsection
 
+.pushsection .data
+	.align PAGE_SIZE_asm
+ENTRY(shared_info_page)
+	.skip PAGE_SIZE_asm
+.popsection
+
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_VERSION,  .asciz "2.6")
 	ELFNOTE(Xen, XEN_ELFNOTE_XEN_VERSION,    .asciz "xen-3.0")
-- 
1.5.4.5

