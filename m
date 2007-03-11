Return-Path: <linux-kernel-owner+w=401wt.eu-S933575AbXCKMwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbXCKMwn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 08:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933566AbXCKMwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 08:52:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36813 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933574AbXCKMwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 08:52:42 -0400
Date: Sun, 11 Mar 2007 13:52:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org
Subject: [patch] KVM: always reload segment selectors
Message-ID: <20070311125233.GA17328@elte.hu>
References: <20070311122441.GA10774@elte.hu> <45F3F85D.7000509@qumranet.com> <20070311124146.GA15115@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311124146.GA15115@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] KVM: always reload segment selectors
From: Ingo Molnar <mingo@elte.hu>

failed VM entry on VMX might still change %fs or %gs, thus make sure 
that KVM always reloads the segment selectors. This is crutial on both 
x86 and x86_64: x86 has __KERNEL_PDA in %fs on which things like 
'current' depends and x86_64 has 0 there and needs MSR_GS_BASE to work.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/kvm/vmx.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

Index: linux/drivers/kvm/vmx.c
===================================================================
--- linux.orig/drivers/kvm/vmx.c
+++ linux/drivers/kvm/vmx.c
@@ -1896,6 +1896,27 @@ again:
 		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
 	      : "cc", "memory" );
 
+	/*
+	 * Reload segment selectors ASAP. (it's needed for a functional
+	 * kernel: x86 relies on having __KERNEL_PDA in %fs and x86_64
+	 * relies on having 0 in %gs for the CPU PDA to work.)
+	 */
+	if (fs_gs_ldt_reload_needed) {
+		load_ldt(ldt_sel);
+		load_fs(fs_sel);
+		/*
+		 * If we have to reload gs, we must take care to
+		 * preserve our gs base.
+		 */
+		local_irq_disable();
+		load_gs(gs_sel);
+#ifdef CONFIG_X86_64
+		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
+#endif
+		local_irq_enable();
+
+		reload_tss();
+	}
 	++kvm_stat.exits;
 
 	save_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
@@ -1913,22 +1934,6 @@ again:
 		kvm_run->exit_reason = vmcs_read32(VM_INSTRUCTION_ERROR);
 		r = 0;
 	} else {
-		if (fs_gs_ldt_reload_needed) {
-			load_ldt(ldt_sel);
-			load_fs(fs_sel);
-			/*
-			 * If we have to reload gs, we must take care to
-			 * preserve our gs base.
-			 */
-			local_irq_disable();
-			load_gs(gs_sel);
-#ifdef CONFIG_X86_64
-			wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
-#endif
-			local_irq_enable();
-
-			reload_tss();
-		}
 		/*
 		 * Profile KVM exit RIPs:
 		 */
