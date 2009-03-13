Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZCMRI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZCMRI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759968AbZCMRBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:36 -0400
Received: from gw.goop.org ([64.81.55.164]:57450 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759869AbZCMRBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:35 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 22/27] xen mtrr: Implement xen_get_free_region()
Date: Fri, 13 Mar 2009 10:00:07 -0700
Message-Id: <1236963612-14287-23-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

When an already set MTRR is being changed, we need to
first unset, since Xen also maintains a usage count.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/kernel/cpu/mtrr/mtrr.h |    2 ++
 arch/x86/kernel/cpu/mtrr/xen.c  |   27 ++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index eb23ca2..6142d6e 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -5,6 +5,8 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 
+#include <asm/mtrr.h>
+
 #define MTRRcap_MSR     0x0fe
 #define MTRRdefType_MSR 0x2ff
 
diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
index 622d075..1ffb93c 100644
--- a/arch/x86/kernel/cpu/mtrr/xen.c
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -15,13 +15,38 @@
 
 static int __init xen_num_var_ranges(void);
 
+static int xen_get_free_region(unsigned long base, unsigned long size, int replace_reg)
+{
+	struct xen_platform_op op;
+	int error;
+
+	if (replace_reg < 0)
+		return generic_get_free_region(base, size, -1);
+
+	/* If we're replacing the contents of a register,
+	 * we need to first unset it since Xen also keeps
+	 * a usage count.
+	 */
+	op.cmd = XENPF_del_memtype;
+	op.u.del_memtype.handle = 0;
+	op.u.del_memtype.reg    = replace_reg;
+
+	error = HYPERVISOR_dom0_op(&op);
+	if (error) {
+		BUG_ON(error > 0);
+		return error;
+	}
+
+	return replace_reg;
+}
+
 /* DOM0 TODO: Need to fill in the remaining mtrr methods to have full
  * working userland mtrr support. */
 static struct mtrr_ops xen_mtrr_ops = {
 	.vendor            = X86_VENDOR_UNKNOWN,
 //	.set               = xen_set_mtrr,
 //	.get               = xen_get_mtrr,
-	.get_free_region   = generic_get_free_region,
+	.get_free_region   = xen_get_free_region,
 	.validate_add_page = generic_validate_add_page,
 	.have_wrcomb       = positive_have_wrcomb,
 	.use_intel_if	   = 0,
-- 
1.6.0.6

