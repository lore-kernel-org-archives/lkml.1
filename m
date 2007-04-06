Return-Path: <linux-kernel-owner+w=401wt.eu-S932738AbXDFTyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbXDFTyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXDFTxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:53:53 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:47673 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932738AbXDFTxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:53:45 -0400
Date: Fri, 6 Apr 2007 12:51:42 -0700
Message-Id: <200704061951.l36JpgEG008390@zach-dev.vmware.com>
Subject: [PATCH 3/3] [PREVIEW] Resurrect the VMI lazy mode fixes.
From: Zachary Amsden <zach@vmware.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>
Subject: [PREVIEW] Resurrect the VMI lazy mode fixes.
X-OriginalArrivalTime: 06 Apr 2007 19:53:43.0804 (UTC) FILETIME=[480B6BC0:01C77885]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Code changes and cleanup in the paravirt-ops queue caused the original
fix for this in 2.6.21 to create conflicts.  The easiest thing to do was
back it out before applying the queue.  In that case, this fix brings it
back with the newly tidied up paravirt-ops code.

PREVIEW-ONLY: Do not apply.  This is dependent on changes which have not
yet been merged.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r ecb571084874 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Fri Apr 06 12:31:06 2007 -0700
+++ b/arch/i386/kernel/vmi.c	Fri Apr 06 12:31:06 2007 -0700
@@ -69,6 +69,7 @@ static struct {
 	void (*flush_tlb)(int);
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
+  	void (*set_lazy_mode)(int mode);
 } vmi_ops;
 
 /*
@@ -545,6 +546,26 @@ vmi_startup_ipi_hook(int phys_apicid, un
 }
 #endif
 
+static void vmi_set_lazy_mode(int mode)
+{
+	static DEFINE_PER_CPU(int, lazy_mode);
+
+	if (!vmi_ops.set_lazy_mode)
+		return;
+
+	/* Modes should never nest or overlap */
+	BUG_ON(__get_cpu_var(lazy_mode) && !(mode == PARAVIRT_LAZY_NONE ||
+					     mode == PARAVIRT_LAZY_FLUSH));
+	
+	if (mode == PARAVIRT_LAZY_FLUSH) {
+		vmi_ops.set_lazy_mode(0);
+		vmi_ops.set_lazy_mode(__get_cpu_var(lazy_mode));
+	} else {
+		vmi_ops.set_lazy_mode(new_mode);
+		per_cpu(mode, cpu) = new_mode;
+	}
+}
+
 static inline int __init check_vmi_rom(struct vrom_header *rom)
 {
 	struct pci_header *pci;
@@ -769,7 +790,7 @@ static inline int __init activate_vmi(vo
 	para_wrap(load_esp0, vmi_load_esp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(set_iopl_mask, SetIOPLMask);
 	para_fill(io_delay, IODelay);
-	para_fill(set_lazy_mode, SetLazyMode);
+	para_wrap(set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
 	para_wrap(flush_tlb_user, vmi_flush_tlb_user, flush_tlb, FlushTLB);
