Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbYEWNNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbYEWNNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbYEWNNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:13:14 -0400
Received: from gw.goop.org ([64.81.55.164]:33948 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148AbYEWNNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:13:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 5] xen: use hypercall rather than clts
X-Mercurial-Node: 9fc73591d78e1adfc7859f131ea3308af477c9eb
Message-Id: <9fc73591d78e1adfc785.1211548254@localhost>
In-Reply-To: <patchbomb.1211548253@localhost>
Date: Fri, 23 May 2008 14:10:54 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen will trap and emulate clts, but its better to use a hypercall.
Also, xenner doesn't handle clts.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c        |   28 ++++++++++++++++++++++++++--
 include/asm-x86/xen/hypercall.h |    7 +++++++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -607,6 +607,30 @@
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
 
+static void xen_clts(void)
+{
+	struct multicall_space mcs;
+
+	mcs = xen_mc_entry(0);
+
+	MULTI_fpu_taskswitch(mcs.mc, 0);
+
+	xen_mc_issue(PARAVIRT_LAZY_CPU);
+}
+
+static void xen_write_cr0(unsigned long cr0)
+{
+	struct multicall_space mcs;
+
+	/* Only pay attention to cr0.TS; everything else is
+	   ignored. */
+	mcs = xen_mc_entry(0);
+
+	MULTI_fpu_taskswitch(mcs.mc, (cr0 & X86_CR0_TS) != 0);
+
+	xen_mc_issue(PARAVIRT_LAZY_CPU);
+}
+
 static void xen_write_cr2(unsigned long cr2)
 {
 	x86_read_percpu(xen_vcpu)->arch.cr2 = cr2;
@@ -978,10 +1002,10 @@
 	.set_debugreg = xen_set_debugreg,
 	.get_debugreg = xen_get_debugreg,
 
-	.clts = native_clts,
+	.clts = xen_clts,
 
 	.read_cr0 = native_read_cr0,
-	.write_cr0 = native_write_cr0,
+	.write_cr0 = xen_write_cr0,
 
 	.read_cr4 = native_read_cr4,
 	.read_cr4_safe = native_read_cr4_safe,
diff --git a/include/asm-x86/xen/hypercall.h b/include/asm-x86/xen/hypercall.h
--- a/include/asm-x86/xen/hypercall.h
+++ b/include/asm-x86/xen/hypercall.h
@@ -315,6 +315,13 @@
 }
 
 static inline void
+MULTI_fpu_taskswitch(struct multicall_entry *mcl, int set)
+{
+	mcl->op = __HYPERVISOR_fpu_taskswitch;
+	mcl->args[0] = set;
+}
+
+static inline void
 MULTI_update_va_mapping(struct multicall_entry *mcl, unsigned long va,
 			pte_t new_val, unsigned long flags)
 {


