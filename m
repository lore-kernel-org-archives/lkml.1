Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbZELXdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbZELXdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757961AbZELX1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:27:47 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36269
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758108AbZELX1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:27:45 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Mark McLoughlin <markmc@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 4/6] xen mtrr: Implement xen_get_free_region()
Date: Tue, 12 May 2009 16:27:42 -0700
Message-Id: <1242170864-13560-5-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170864-13560-1-git-send-email-jeremy@goop.org>
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

When an already set MTRR is being changed, we need to
first unset, since Xen also maintains a usage count.

[ Impact: complete xen mtrr implementation ]

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/cpu/mtrr/mtrr.h |    2 ++
 arch/x86/kernel/cpu/mtrr/xen.c  |   28 +++++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 3502f6c..52bd87d 100644
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
index 3077bb3..f99fa15 100644
--- a/arch/x86/kernel/cpu/mtrr/xen.c
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -15,11 +15,37 @@
 
 static int __init xen_num_var_ranges(void);
 
+static int xen_get_free_region(unsigned long base, unsigned long size,
+			       int replace_reg)
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
-	.get_free_region   = generic_get_free_region,
+	.get_free_region   = xen_get_free_region,
 	.validate_add_page = generic_validate_add_page,
 	.have_wrcomb       = positive_have_wrcomb,
 	.use_intel_if	   = 0,
-- 
1.6.0.6

