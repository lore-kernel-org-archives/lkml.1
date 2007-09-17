Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbXIQIrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbXIQIrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbXIQIdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:08 -0400
Received: from il.qumranet.com ([82.166.9.18]:45259 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbXIQIcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 063/104] KVM: VMX: Split segments reload in vmx_load_host_state()
Date: Mon, 17 Sep 2007 10:31:45 +0200
Message-Id: <11900179483059-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

vmx_load_host_state() bundles fs, gs, ldt, and tss reloading into
one in the hope that it is infrequent. With smp guests, fs reloading is
frequent due to fs being used by threads.

Unbundle the reloads so reduce expensive gs reloads.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index b400668..d63e82e 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -54,7 +54,8 @@ struct vcpu_vmx {
 	struct {
 		int           loaded;
 		u16           fs_sel, gs_sel, ldt_sel;
-		int           fs_gs_ldt_reload_needed;
+		int           gs_ldt_reload_needed;
+		int           fs_reload_needed;
 	}host_state;
 
 };
@@ -353,20 +354,21 @@ static void vmx_save_host_state(struct vcpu_vmx *vmx)
 	 * allow segment selectors with cpl > 0 or ti == 1.
 	 */
 	vmx->host_state.ldt_sel = read_ldt();
-	vmx->host_state.fs_gs_ldt_reload_needed = vmx->host_state.ldt_sel;
+	vmx->host_state.gs_ldt_reload_needed = vmx->host_state.ldt_sel;
 	vmx->host_state.fs_sel = read_fs();
-	if (!(vmx->host_state.fs_sel & 7))
+	if (!(vmx->host_state.fs_sel & 7)) {
 		vmcs_write16(HOST_FS_SELECTOR, vmx->host_state.fs_sel);
-	else {
+		vmx->host_state.fs_reload_needed = 0;
+	} else {
 		vmcs_write16(HOST_FS_SELECTOR, 0);
-		vmx->host_state.fs_gs_ldt_reload_needed = 1;
+		vmx->host_state.fs_reload_needed = 1;
 	}
 	vmx->host_state.gs_sel = read_gs();
 	if (!(vmx->host_state.gs_sel & 7))
 		vmcs_write16(HOST_GS_SELECTOR, vmx->host_state.gs_sel);
 	else {
 		vmcs_write16(HOST_GS_SELECTOR, 0);
-		vmx->host_state.fs_gs_ldt_reload_needed = 1;
+		vmx->host_state.gs_ldt_reload_needed = 1;
 	}
 
 #ifdef CONFIG_X86_64
@@ -396,9 +398,10 @@ static void vmx_load_host_state(struct vcpu_vmx *vmx)
 		return;
 
 	vmx->host_state.loaded = 0;
-	if (vmx->host_state.fs_gs_ldt_reload_needed) {
-		load_ldt(vmx->host_state.ldt_sel);
+	if (vmx->host_state.fs_reload_needed)
 		load_fs(vmx->host_state.fs_sel);
+	if (vmx->host_state.gs_ldt_reload_needed) {
+		load_ldt(vmx->host_state.ldt_sel);
 		/*
 		 * If we have to reload gs, we must take care to
 		 * preserve our gs base.
@@ -409,9 +412,8 @@ static void vmx_load_host_state(struct vcpu_vmx *vmx)
 		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
 #endif
 		local_irq_restore(flags);
-
-		reload_tss();
 	}
+	reload_tss();
 	save_msrs(vmx->guest_msrs, vmx->save_nmsrs);
 	load_msrs(vmx->host_msrs, vmx->save_nmsrs);
 	if (msr_efer_need_save_restore(vmx))
-- 
1.5.3

