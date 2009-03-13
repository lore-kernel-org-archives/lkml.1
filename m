Return-Path: <linux-kernel-owner+w=401wt.eu-S1761085AbZCMRHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761085AbZCMRHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759917AbZCMRB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:29 -0400
Received: from gw.goop.org ([64.81.55.164]:57444 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759847AbZCMRB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:28 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 23/27] xen mtrr: Add xen_{get,set}_mtrr() implementations
Date: Fri, 13 Mar 2009 10:00:08 -0700
Message-Id: <1236963612-14287-24-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

Straightforward apart from the hack to turn mtrr_ops->set()
into a no-op on all but one CPU.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/kernel/cpu/mtrr/xen.c |   52 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
index 1ffb93c..184066d 100644
--- a/arch/x86/kernel/cpu/mtrr/xen.c
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -15,6 +15,52 @@
 
 static int __init xen_num_var_ranges(void);
 
+static void xen_set_mtrr(unsigned int reg, unsigned long base,
+			 unsigned long size, mtrr_type type)
+{
+	struct xen_platform_op op;
+	int error;
+
+	/* mtrr_ops->set() is called once per CPU,
+	 * but Xen's ops apply to all CPUs.
+	 */
+	if (smp_processor_id())
+		return;
+
+	if (size == 0) {
+		op.cmd = XENPF_del_memtype;
+		op.u.del_memtype.handle = 0;
+		op.u.del_memtype.reg    = reg;
+	} else {
+		op.cmd = XENPF_add_memtype;
+		op.u.add_memtype.mfn     = base;
+		op.u.add_memtype.nr_mfns = size;
+		op.u.add_memtype.type    = type;
+	}
+
+	error = HYPERVISOR_dom0_op(&op);
+	BUG_ON(error != 0);
+}
+
+static void xen_get_mtrr(unsigned int reg, unsigned long *base,
+			 unsigned long *size, mtrr_type *type)
+{
+	struct xen_platform_op op;
+
+	op.cmd = XENPF_read_memtype;
+	op.u.read_memtype.reg = reg;
+	if (HYPERVISOR_dom0_op(&op) != 0) {
+		*base = 0;
+		*size = 0;
+		*type = 0;
+		return;
+	}
+
+	*size = op.u.read_memtype.nr_mfns;
+	*base = op.u.read_memtype.mfn;
+	*type = op.u.read_memtype.type;
+}
+
 static int xen_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 {
 	struct xen_platform_op op;
@@ -40,12 +86,10 @@ static int xen_get_free_region(unsigned long base, unsigned long size, int repla
 	return replace_reg;
 }
 
-/* DOM0 TODO: Need to fill in the remaining mtrr methods to have full
- * working userland mtrr support. */
 static struct mtrr_ops xen_mtrr_ops = {
 	.vendor            = X86_VENDOR_UNKNOWN,
-//	.set               = xen_set_mtrr,
-//	.get               = xen_get_mtrr,
+	.set               = xen_set_mtrr,
+	.get               = xen_get_mtrr,
 	.get_free_region   = xen_get_free_region,
 	.validate_add_page = generic_validate_add_page,
 	.have_wrcomb       = positive_have_wrcomb,
-- 
1.6.0.6

