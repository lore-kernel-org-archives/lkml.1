Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbYGHX2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbYGHX2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbYGHXPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:13 -0400
Received: from gw.goop.org ([64.81.55.164]:51224 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525AbYGHXOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:47 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 54 of 55] xen: implement Xen write_msr operation
X-Mercurial-Node: a200ebf7d1c498236bbe3532c9523d381a8e25f7
Message-Id: <a200ebf7d1c498236bbe.1215554836@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64-bit uses MSRs for important things like the base for fs and
gs-prefixed addresses.  It's more efficient to use a hypercall to
update these, rather than go via the trap and emulate path.

Other MSR writes are just passed through; in an unprivileged domain
they do nothing, but it might be useful later.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -41,6 +41,7 @@
 #include <asm/xen/hypervisor.h>
 #include <asm/fixmap.h>
 #include <asm/processor.h>
+#include <asm/msr-index.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
 #include <asm/pgtable.h>
@@ -777,6 +778,34 @@
 	xen_mc_issue(PARAVIRT_LAZY_CPU);  /* interrupts restored */
 }
 
+static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
+{
+	int ret;
+
+	ret = 0;
+
+	switch(msr) {
+#ifdef CONFIG_X86_64
+		unsigned which;
+		u64 base;
+
+	case MSR_FS_BASE:		which = SEGBASE_FS; goto set;
+	case MSR_KERNEL_GS_BASE:	which = SEGBASE_GS_USER; goto set;
+	case MSR_GS_BASE:		which = SEGBASE_GS_KERNEL; goto set;
+
+	set:
+		base = ((u64)high << 32) | low;
+		if (HYPERVISOR_set_segment_base(which, base) != 0)
+			ret = -EFAULT;
+		break;
+#endif
+	default:
+		ret = native_write_msr_safe(msr, low, high);
+	}
+
+	return ret;
+}
+
 /* Early in boot, while setting up the initial pagetable, assume
    everything is pinned. */
 static __init void xen_alloc_pte_init(struct mm_struct *mm, u32 pfn)
@@ -1165,7 +1194,7 @@
 	.wbinvd = native_wbinvd,
 
 	.read_msr = native_read_msr_safe,
-	.write_msr = native_write_msr_safe,
+	.write_msr = xen_write_msr_safe,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 


