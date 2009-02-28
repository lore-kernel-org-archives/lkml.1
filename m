Return-Path: <linux-kernel-owner+w=401wt.eu-S932557AbZB1CIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbZB1CIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761242AbZB1B7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:59:46 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:59181
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757592AbZB1B7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:59:34 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH] xen mtrr: Implement xen_get_free_region()
Date: Fri, 27 Feb 2009 17:59:24 -0800
Message-Id: <1235786365-17744-19-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235786365-17744-1-git-send-email-jeremy@goop.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

When an already set MTRR is being changed, we need to
first unset, since Xen also maintains a usage count.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/kernel/cpu/mtrr/xen.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
index f226044..d715843 100644
--- a/arch/x86/kernel/cpu/mtrr/xen.c
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -9,13 +9,38 @@
 
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

