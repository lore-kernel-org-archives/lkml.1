Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbZELXe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbZELXe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758053AbZELX1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:27:50 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36288
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758118AbZELX1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:27:46 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Mark McLoughlin <markmc@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 5/6] xen mtrr: Add xen_{get,set}_mtrr() implementations
Date: Tue, 12 May 2009 16:27:43 -0700
Message-Id: <1242170864-13560-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170864-13560-1-git-send-email-jeremy@goop.org>
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

Straightforward apart from the hack to turn mtrr_ops->set()
into a no-op on all but one CPU.

[ Impact: complete Xen mtrr implementation ]

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/cpu/mtrr/xen.c |   50 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
index f99fa15..5e0aa2b 100644
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
 static int xen_get_free_region(unsigned long base, unsigned long size,
 			       int replace_reg)
 {
@@ -41,10 +87,10 @@ static int xen_get_free_region(unsigned long base, unsigned long size,
 	return replace_reg;
 }
 
-/* DOM0 TODO: Need to fill in the remaining mtrr methods to have full
- * working userland mtrr support. */
 static struct mtrr_ops xen_mtrr_ops = {
 	.vendor            = X86_VENDOR_UNKNOWN,
+	.set               = xen_set_mtrr,
+	.get               = xen_get_mtrr,
 	.get_free_region   = xen_get_free_region,
 	.validate_add_page = generic_validate_add_page,
 	.have_wrcomb       = positive_have_wrcomb,
-- 
1.6.0.6

