Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYFZMcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYFZMcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYFZM2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:46 -0400
Received: from il.qumranet.com ([212.179.150.194]:32377 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYFZM2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:38 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/50] KVM: Handle virtualization instruction #UD faults during reboot
Date: Thu, 26 Jun 2008 15:27:56 +0300
Message-Id: <1214483312-9265-15-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM turns off hardware virtualization extensions during reboot, in order
to disassociate the memory used by the virtualization extensions from the
processor, and in order to have the system in a consistent state.
Unfortunately virtual machines may still be running while this goes on,
and once virtualization extensions are turned off, any virtulization
instruction will #UD on execution.

Fix by adding an exception handler to virtualization instructions; if we get
an exception during reboot, we simply spin waiting for the reset to complete.
If it's a true exception, BUG() so we can have our stack trace.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c         |   20 +++++++++++---------
 arch/x86/kvm/vmx.c         |   25 ++++++++++++++-----------
 include/asm-x86/kvm_host.h |   24 ++++++++++++++++++++++++
 virt/kvm/kvm_main.c        |   15 +++++++++++++++
 4 files changed, 64 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 992ab71..9390a31 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -27,6 +27,8 @@
 
 #include <asm/desc.h>
 
+#define __ex(x) __kvm_handle_fault_on_reboot(x)
+
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
@@ -129,17 +131,17 @@ static inline void push_irq(struct kvm_vcpu *vcpu, u8 irq)
 
 static inline void clgi(void)
 {
-	asm volatile (SVM_CLGI);
+	asm volatile (__ex(SVM_CLGI));
 }
 
 static inline void stgi(void)
 {
-	asm volatile (SVM_STGI);
+	asm volatile (__ex(SVM_STGI));
 }
 
 static inline void invlpga(unsigned long addr, u32 asid)
 {
-	asm volatile (SVM_INVLPGA :: "a"(addr), "c"(asid));
+	asm volatile (__ex(SVM_INVLPGA) :: "a"(addr), "c"(asid));
 }
 
 static inline unsigned long kvm_read_cr2(void)
@@ -1758,17 +1760,17 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		/* Enter guest mode */
 		"push %%rax \n\t"
 		"mov %c[vmcb](%[svm]), %%rax \n\t"
-		SVM_VMLOAD "\n\t"
-		SVM_VMRUN "\n\t"
-		SVM_VMSAVE "\n\t"
+		__ex(SVM_VMLOAD) "\n\t"
+		__ex(SVM_VMRUN) "\n\t"
+		__ex(SVM_VMSAVE) "\n\t"
 		"pop %%rax \n\t"
 #else
 		/* Enter guest mode */
 		"push %%eax \n\t"
 		"mov %c[vmcb](%[svm]), %%eax \n\t"
-		SVM_VMLOAD "\n\t"
-		SVM_VMRUN "\n\t"
-		SVM_VMSAVE "\n\t"
+		__ex(SVM_VMLOAD) "\n\t"
+		__ex(SVM_VMRUN) "\n\t"
+		__ex(SVM_VMSAVE) "\n\t"
 		"pop %%eax \n\t"
 #endif
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1b286fa..fa4ea2e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -30,6 +30,8 @@
 #include <asm/io.h>
 #include <asm/desc.h>
 
+#define __ex(x) __kvm_handle_fault_on_reboot(x)
+
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
@@ -278,7 +280,7 @@ static inline void __invvpid(int ext, u16 vpid, gva_t gva)
 	u64 gva;
     } operand = { vpid, 0, gva };
 
-    asm volatile (ASM_VMX_INVVPID
+    asm volatile (__ex(ASM_VMX_INVVPID)
 		  /* CF==1 or ZF==1 --> rc = -1 */
 		  "; ja 1f ; ud2 ; 1:"
 		  : : "a"(&operand), "c"(ext) : "cc", "memory");
@@ -290,7 +292,7 @@ static inline void __invept(int ext, u64 eptp, gpa_t gpa)
 		u64 eptp, gpa;
 	} operand = {eptp, gpa};
 
-	asm volatile (ASM_VMX_INVEPT
+	asm volatile (__ex(ASM_VMX_INVEPT)
 			/* CF==1 or ZF==1 --> rc = -1 */
 			"; ja 1f ; ud2 ; 1:\n"
 			: : "a" (&operand), "c" (ext) : "cc", "memory");
@@ -311,7 +313,7 @@ static void vmcs_clear(struct vmcs *vmcs)
 	u64 phys_addr = __pa(vmcs);
 	u8 error;
 
-	asm volatile (ASM_VMX_VMCLEAR_RAX "; setna %0"
+	asm volatile (__ex(ASM_VMX_VMCLEAR_RAX) "; setna %0"
 		      : "=g"(error) : "a"(&phys_addr), "m"(phys_addr)
 		      : "cc", "memory");
 	if (error)
@@ -378,7 +380,7 @@ static unsigned long vmcs_readl(unsigned long field)
 {
 	unsigned long value;
 
-	asm volatile (ASM_VMX_VMREAD_RDX_RAX
+	asm volatile (__ex(ASM_VMX_VMREAD_RDX_RAX)
 		      : "=a"(value) : "d"(field) : "cc");
 	return value;
 }
@@ -413,7 +415,7 @@ static void vmcs_writel(unsigned long field, unsigned long value)
 {
 	u8 error;
 
-	asm volatile (ASM_VMX_VMWRITE_RAX_RDX "; setna %0"
+	asm volatile (__ex(ASM_VMX_VMWRITE_RAX_RDX) "; setna %0"
 		       : "=q"(error) : "a"(value), "d"(field) : "cc");
 	if (unlikely(error))
 		vmwrite_error(field, value);
@@ -621,7 +623,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		u8 error;
 
 		per_cpu(current_vmcs, cpu) = vmx->vmcs;
-		asm volatile (ASM_VMX_VMPTRLD_RAX "; setna %0"
+		asm volatile (__ex(ASM_VMX_VMPTRLD_RAX) "; setna %0"
 			      : "=g"(error) : "a"(&phys_addr), "m"(phys_addr)
 			      : "cc");
 		if (error)
@@ -1030,13 +1032,14 @@ static void hardware_enable(void *garbage)
 		       MSR_IA32_FEATURE_CONTROL_LOCKED |
 		       MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED);
 	write_cr4(read_cr4() | X86_CR4_VMXE); /* FIXME: not cpu hotplug safe */
-	asm volatile (ASM_VMX_VMXON_RAX : : "a"(&phys_addr), "m"(phys_addr)
+	asm volatile (ASM_VMX_VMXON_RAX
+		      : : "a"(&phys_addr), "m"(phys_addr)
 		      : "memory", "cc");
 }
 
 static void hardware_disable(void *garbage)
 {
-	asm volatile (ASM_VMX_VMXOFF : : : "cc");
+	asm volatile (__ex(ASM_VMX_VMXOFF) : : : "cc");
 	write_cr4(read_cr4() & ~X86_CR4_VMXE);
 }
 
@@ -2834,7 +2837,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		"push %%edx; push %%ebp;"
 		"push %%ecx \n\t"
 #endif
-		ASM_VMX_VMWRITE_RSP_RDX "\n\t"
+		__ex(ASM_VMX_VMWRITE_RSP_RDX) "\n\t"
 		/* Check if vmlaunch of vmresume is needed */
 		"cmpl $0, %c[launched](%0) \n\t"
 		/* Load guest registers.  Don't clobber flags. */
@@ -2869,9 +2872,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 #endif
 		/* Enter guest mode */
 		"jne .Llaunched \n\t"
-		ASM_VMX_VMLAUNCH "\n\t"
+		__ex(ASM_VMX_VMLAUNCH) "\n\t"
 		"jmp .Lkvm_vmx_return \n\t"
-		".Llaunched: " ASM_VMX_VMRESUME "\n\t"
+		".Llaunched: " __ex(ASM_VMX_VMRESUME) "\n\t"
 		".Lkvm_vmx_return: "
 		/* Save guest registers, load host registers, keep flags */
 #ifdef CONFIG_X86_64
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index c2d066e..0df9d5f 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -692,4 +692,28 @@ enum {
 	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
 						vcpu, 0, 0, 0, 0, 0, 0)
 
+#ifdef CONFIG_64BIT
+#define KVM_EX_ENTRY ".quad"
+#else
+#define KVM_EX_ENTRY ".long"
+#endif
+
+/*
+ * Hardware virtualization extension instructions may fault if a
+ * reboot turns off virtualization while processes are running.
+ * Trap the fault and ignore the instruction if that happens.
+ */
+asmlinkage void kvm_handle_fault_on_reboot(void);
+
+#define __kvm_handle_fault_on_reboot(insn) \
+	"666: " insn "\n\t" \
+	".pushsection .text.fixup, \"ax\" \n" \
+	"667: \n\t" \
+	"push $666b \n\t" \
+	"jmp kvm_handle_fault_on_reboot \n\t" \
+	".popsection \n\t" \
+	".pushsection __ex_table, \"a\" \n\t" \
+	KVM_EX_ENTRY " 666b, 667b \n\t" \
+	".popsection"
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4d30ac5..67af90c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -65,6 +65,8 @@ struct dentry *kvm_debugfs_dir;
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 
+bool kvm_rebooting;
+
 static inline int valid_vcpu(int n)
 {
 	return likely(n >= 0 && n < KVM_MAX_VCPUS);
@@ -1301,6 +1303,18 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	return NOTIFY_OK;
 }
 
+
+asmlinkage void kvm_handle_fault_on_reboot(void)
+{
+	if (kvm_rebooting)
+		/* spin while reset goes on */
+		while (true)
+			;
+	/* Fault while not rebooting.  We want the trace. */
+	BUG();
+}
+EXPORT_SYMBOL_GPL(kvm_handle_fault_on_reboot);
+
 static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 		      void *v)
 {
@@ -1310,6 +1324,7 @@ static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 		 * in vmx root mode.
 		 */
 		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
+		kvm_rebooting = true;
 		on_each_cpu(hardware_disable, NULL, 0, 1);
 	}
 	return NOTIFY_OK;
-- 
1.5.6

