Return-Path: <linux-kernel-owner+w=401wt.eu-S932164AbYGHX0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbYGHX0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbYGHXPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:05 -0400
Received: from gw.goop.org ([64.81.55.164]:51215 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757415AbYGHXOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 40 of 55] xen64: register callbacks in arch-independent way
X-Mercurial-Node: c11987394efc36450b9489d7f572f49d0f465890
Message-Id: <c11987394efc36450b94.1215554822@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use callback_op hypercall to register callbacks in a 32/64-bit
independent way (64-bit doesn't need a code segment, but that detail
is hidden in XEN_CALLBACK).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/setup.c            |   27 +++++++++++++++++----------
 include/asm-x86/xen/hypercall.h |   12 ++++++++++++
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -91,19 +91,25 @@
 	*mask |= 1 << VDSO_NOTE_NONEGSEG_BIT;
 }
 
-void xen_enable_sysenter(void)
+static __cpuinit int register_callback(unsigned type, const void *func)
+{
+	struct callback_register callback = {
+		.type = type,
+		.address = XEN_CALLBACK(__KERNEL_CS, func),
+		.flags = CALLBACKF_mask_events,
+	};
+
+	return HYPERVISOR_callback_op(CALLBACKOP_register, &callback);
+}
+
+void __cpuinit xen_enable_sysenter(void)
 {
 	int cpu = smp_processor_id();
 	extern void xen_sysenter_target(void);
-	/* Mask events on entry, even though they get enabled immediately */
-	static struct callback_register sysenter = {
-		.type = CALLBACKTYPE_sysenter,
-		.address = XEN_CALLBACK(__KERNEL_CS, xen_sysenter_target),
-		.flags = CALLBACKF_mask_events,
-	};
 
 	if (!boot_cpu_has(X86_FEATURE_SEP) ||
-	    HYPERVISOR_callback_op(CALLBACKOP_register, &sysenter) != 0) {
+	    register_callback(CALLBACKTYPE_sysenter,
+			      xen_sysenter_target) != 0) {
 		clear_cpu_cap(&cpu_data(cpu), X86_FEATURE_SEP);
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_SEP);
 	}
@@ -120,8 +126,9 @@
 	if (!xen_feature(XENFEAT_auto_translated_physmap))
 		HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_pae_extended_cr3);
 
-	HYPERVISOR_set_callbacks(__KERNEL_CS, (unsigned long)xen_hypervisor_callback,
-				 __KERNEL_CS, (unsigned long)xen_failsafe_callback);
+	if (register_callback(CALLBACKTYPE_event, xen_hypervisor_callback) ||
+	    register_callback(CALLBACKTYPE_failsafe, xen_failsafe_callback))
+		BUG();
 
 	xen_enable_sysenter();
 
diff --git a/include/asm-x86/xen/hypercall.h b/include/asm-x86/xen/hypercall.h
--- a/include/asm-x86/xen/hypercall.h
+++ b/include/asm-x86/xen/hypercall.h
@@ -226,6 +226,7 @@
 	return _hypercall2(int, stack_switch, ss, esp);
 }
 
+#ifdef CONFIG_X86_32
 static inline int
 HYPERVISOR_set_callbacks(unsigned long event_selector,
 			 unsigned long event_address,
@@ -236,6 +237,17 @@
 			   event_selector, event_address,
 			   failsafe_selector, failsafe_address);
 }
+#else  /* CONFIG_X86_64 */
+static inline int
+HYPERVISOR_set_callbacks(unsigned long event_address,
+			unsigned long failsafe_address,
+			unsigned long syscall_address)
+{
+	return _hypercall3(int, set_callbacks,
+			   event_address, failsafe_address,
+			   syscall_address);
+}
+#endif  /* CONFIG_X86_{32,64} */
 
 static inline int
 HYPERVISOR_callback_op(int cmd, void *arg)


