Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbZBPXvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbZBPXvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbZBPXq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:46:29 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:50810
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753866AbZBPXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:46:21 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 19/19] xen mtrr: Add xen_{get,set}_mtrr() implementations
Date: Mon, 16 Feb 2009 15:46:13 -0800
Message-Id: <bb6ad37a5d2b6c503a339ac2be34f6a39f7dc125.1234826723.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <b5910989a46777b9857061db2cd59b6150c6fade.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <edde7fdd064390d321bdafcfb993b28b4d2588b1.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <9fbd402b72d6c494f453ff86e071ac1b2658ece9.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f47f399029ba9035a14ae381b6ae504a5c5bd445.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f1402ed2345e1d654faa823afefa53fc4745e368.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f0d2b3f946de1b3398c278c7a33069f670b78268.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <83b1377d81029933b769798dbe1ca134f6d365ae.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <630b678d3259163fc237f673b6f2a4a5fa76ac25.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <8349825a016bec5b8712940ad6f8c3f18f8003fb.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f156acbfffc23cccd71b71d36e6668c6c246f3b4.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f156acbfffc23cccd71b71d36e6668c6c246f3b4.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <e59d440a548af3d4e4bb483c73e24614a5b3af63.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <2fe9663efa1686898ebf9d28e911daac3185b6b7.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <0b79be113b42a033f3b3ca4d4f3ca4035c8a7bf5.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <b4adea5f3e4c3ebba175f2344d138f85aa48dd57.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <0dda0d4d9cf8e5aebba5d370def8c268e93e9800.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <4215664baba2d7e72862150a9d0e8aa77241668d.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <0cd342b898fbbc8ec6a02591a7848dc29140c6ed.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <657b1146c2154ffb82456a954ba645a1c229c887.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <b5910989a46777b9857061db2cd59b6150c6fade.1234826723.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
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
index d715843..50a45db 100644
--- a/arch/x86/kernel/cpu/mtrr/xen.c
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -9,6 +9,52 @@
 
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
@@ -34,12 +80,10 @@ static int xen_get_free_region(unsigned long base, unsigned long size, int repla
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

