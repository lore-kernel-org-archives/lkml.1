Return-Path: <linux-kernel-owner+w=401wt.eu-S936122AbZLQBs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936122AbZLQBs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763264AbZLQBqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:46:24 -0500
Received: from kroah.org ([198.145.64.141]:47809 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763522AbZLQBT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:19:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:15:59 2009
Message-Id: <20091217011559.807451173@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Carsten Otte <cotte@de.ibm.com>, Avi Kivity <avi@redhat.com>
Subject: [15/90] KVM: s390: Make psw available on all exits, not just a subset
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Carsten Otte <carsteno@de.ibm.com>

commit d7b0b5eb3000c6fb902f08c619fcd673a23d8fab upstream.

This patch moves s390 processor status word into the base kvm_run
struct and keeps it up-to date on all userspace exits.

The userspace ABI is broken by this, however there are no applications
in the wild using this.  A capability check is provided so users can
verify the updated API exists.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/include/asm/kvm.h |    3 ++-
 arch/s390/kvm/kvm-s390.c    |   25 +++++++++++++++++--------
 include/linux/kvm.h         |    8 ++++++--
 3 files changed, 25 insertions(+), 11 deletions(-)

--- a/arch/s390/include/asm/kvm.h
+++ b/arch/s390/include/asm/kvm.h
@@ -1,6 +1,5 @@
 #ifndef __LINUX_KVM_S390_H
 #define __LINUX_KVM_S390_H
-
 /*
  * asm-s390/kvm.h - KVM s390 specific structures and definitions
  *
@@ -24,6 +23,8 @@ struct kvm_ioapic_state {
 	/* no IOAPIC for s390 */
 };
 
+#define __KVM_S390
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 	/* general purpose regs for s390 */
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -115,10 +115,16 @@ long kvm_arch_dev_ioctl(struct file *fil
 
 int kvm_dev_ioctl_check_extension(long ext)
 {
+	int r;
+
 	switch (ext) {
+	case KVM_CAP_S390_PSW:
+		r = 1;
+		break;
 	default:
-		return 0;
+		r = 0;
 	}
+	return r;
 }
 
 /* Section: vm related */
@@ -422,8 +428,10 @@ static int kvm_arch_vcpu_ioctl_set_initi
 	vcpu_load(vcpu);
 	if (atomic_read(&vcpu->arch.sie_block->cpuflags) & CPUSTAT_RUNNING)
 		rc = -EBUSY;
-	else
-		vcpu->arch.sie_block->gpsw = psw;
+	else {
+		vcpu->run->psw_mask = psw.mask;
+		vcpu->run->psw_addr = psw.addr;
+	}
 	vcpu_put(vcpu);
 	return rc;
 }
@@ -505,9 +513,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 
 	switch (kvm_run->exit_reason) {
 	case KVM_EXIT_S390_SIEIC:
-		vcpu->arch.sie_block->gpsw.mask = kvm_run->s390_sieic.mask;
-		vcpu->arch.sie_block->gpsw.addr = kvm_run->s390_sieic.addr;
-		break;
 	case KVM_EXIT_UNKNOWN:
 	case KVM_EXIT_S390_RESET:
 		break;
@@ -515,6 +520,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		BUG();
 	}
 
+	vcpu->arch.sie_block->gpsw.mask = kvm_run->psw_mask;
+	vcpu->arch.sie_block->gpsw.addr = kvm_run->psw_addr;
+
 	might_fault();
 
 	do {
@@ -529,8 +537,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		/* intercept cannot be handled in-kernel, prepare kvm-run */
 		kvm_run->exit_reason         = KVM_EXIT_S390_SIEIC;
 		kvm_run->s390_sieic.icptcode = vcpu->arch.sie_block->icptcode;
-		kvm_run->s390_sieic.mask     = vcpu->arch.sie_block->gpsw.mask;
-		kvm_run->s390_sieic.addr     = vcpu->arch.sie_block->gpsw.addr;
 		kvm_run->s390_sieic.ipa      = vcpu->arch.sie_block->ipa;
 		kvm_run->s390_sieic.ipb      = vcpu->arch.sie_block->ipb;
 		rc = 0;
@@ -542,6 +548,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		rc = 0;
 	}
 
+	kvm_run->psw_mask     = vcpu->arch.sie_block->gpsw.mask;
+	kvm_run->psw_addr     = vcpu->arch.sie_block->gpsw.addr;
+
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -104,6 +104,11 @@ struct kvm_run {
 	__u64 cr8;
 	__u64 apic_base;
 
+#ifdef __KVM_S390
+	/* the processor status word for s390 */
+	__u64 psw_mask; /* psw upper half */
+	__u64 psw_addr; /* psw lower half */
+#endif
 	union {
 		/* KVM_EXIT_UNKNOWN */
 		struct {
@@ -155,8 +160,6 @@ struct kvm_run {
 		/* KVM_EXIT_S390_SIEIC */
 		struct {
 			__u8 icptcode;
-			__u64 mask; /* psw upper half */
-			__u64 addr; /* psw lower half */
 			__u16 ipa;
 			__u32 ipb;
 		} s390_sieic;
@@ -453,6 +456,7 @@ struct kvm_irq_routing {
 };
 
 #endif
+#define KVM_CAP_S390_PSW 42
 
 /*
  * ioctls for VM fds


