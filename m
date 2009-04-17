Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbZDQH3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbZDQH3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbZDQH3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:29:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:25027 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbZDQH3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:29:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,203,1239001200"; 
   d="asc'?scan'208";a="132535636"
Subject: [PATCH -v2] Add MCE support to KVM
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MZ4UIgAkWluARlyyjkcS"
Date: Fri, 17 Apr 2009 15:29:05 +0800
Message-Id: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MZ4UIgAkWluARlyyjkcS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The related MSRs are emulated. MCE capability is exported via
extension KVM_CAP_MCE and ioctl KVM_X86_GET_MCE_CAP_SUPPORTED. A new
vcpu ioctl command KVM_X86_SETUP_MCE is used to setup MCE emulation
such as the mcg_cap. MCE is injected via vcpu ioctl command
KVM_X86_SET_MCE. Extended machine-check state (MCG_EXT_P) and CMCI are
not simulated.


ChangeLog:

v2:

- Add MCE capability exportation support.
- Allocate MCE banks registers simulation backing memory during VCPU
  initialization.


Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/kvm_host.h |    5=20
 arch/x86/kvm/x86.c              |  220 +++++++++++++++++++++++++++++++++++=
-----
 include/linux/kvm.h             |   17 +++
 3 files changed, 218 insertions(+), 24 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -42,6 +42,7 @@
 #include <asm/msr.h>
 #include <asm/desc.h>
 #include <asm/mtrr.h>
+#include <asm/mce.h>
=20
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
@@ -55,6 +56,10 @@
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_VMXE))
=20
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
+
+#define KVM_MAX_MCE_BANKS 32
+#define KVM_MCE_CAP_SUPPORTED MCG_CTL_P
+
 /* EFER defaults:
  * - enable syscall per default because its emulated by KVM
  * - enable LME and LMA per default on 64 bit KVM
@@ -740,23 +745,43 @@ static int set_msr_mtrr(struct kvm_vcpu=20
 	return 0;
 }
=20
-int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+static int set_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
+	u64 mcg_cap =3D vcpu->arch.mcg_cap;
+	unsigned bank_num =3D mcg_cap & 0xff;
+
 	switch (msr) {
-	case MSR_EFER:
-		set_efer(vcpu, data);
-		break;
-	case MSR_IA32_MC0_STATUS:
-		pr_unimpl(vcpu, "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n",
-		       __func__, data);
-		break;
 	case MSR_IA32_MCG_STATUS:
-		pr_unimpl(vcpu, "%s: MSR_IA32_MCG_STATUS 0x%llx, nop\n",
-			__func__, data);
+		vcpu->arch.mcg_status =3D data;
 		break;
 	case MSR_IA32_MCG_CTL:
-		pr_unimpl(vcpu, "%s: MSR_IA32_MCG_CTL 0x%llx, nop\n",
-			__func__, data);
+		if (!(mcg_cap & MCG_CTL_P))
+			return 1;
+		if (data !=3D 0 && data !=3D ~(u64)0)
+			return -1;
+		vcpu->arch.mcg_ctl =3D data;
+		break;
+	default:
+		if (msr >=3D MSR_IA32_MC0_CTL &&
+		    msr < MSR_IA32_MC0_CTL + 4 * bank_num) {
+			u32 offset =3D msr - MSR_IA32_MC0_CTL;
+			/* only 0 or all 1s can be written to IA32_MCi_CTL */
+			if ((offset & 0x3) =3D=3D 0 &&
+			    data !=3D 0 && data !=3D ~(u64)0)
+				return -1;
+			vcpu->arch.mce_banks[offset] =3D data;
+			break;
+		}
+		return 1;
+	}
+	return 0;
+}
+
+int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+{
+	switch (msr) {
+	case MSR_EFER:
+		set_efer(vcpu, data);
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!data) {
@@ -812,6 +837,10 @@ int kvm_set_msr_common(struct kvm_vcpu *
 		kvm_request_guest_time_update(vcpu);
 		break;
 	}
+	case MSR_IA32_MCG_CTL:
+	case MSR_IA32_MCG_STATUS:
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
+		return set_msr_mce(vcpu, msr, data);
 	default:
 		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x data %llx\n", msr, data);
 		return 1;
@@ -867,26 +896,49 @@ static int get_msr_mtrr(struct kvm_vcpu=20
 	return 0;
 }
=20
-int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
+static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 {
 	u64 data;
+	u64 mcg_cap =3D vcpu->arch.mcg_cap;
+	unsigned bank_num =3D mcg_cap & 0xff;
=20
 	switch (msr) {
-	case 0xc0010010: /* SYSCFG */
-	case 0xc0010015: /* HWCR */
-	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
-	case MSR_IA32_MC0_CTL:
-	case MSR_IA32_MCG_STATUS:
+		data =3D 0;
+		break;
 	case MSR_IA32_MCG_CAP:
+		data =3D vcpu->arch.mcg_cap;
+		break;
 	case MSR_IA32_MCG_CTL:
-	case MSR_IA32_MC0_MISC:
-	case MSR_IA32_MC0_MISC+4:
-	case MSR_IA32_MC0_MISC+8:
-	case MSR_IA32_MC0_MISC+12:
-	case MSR_IA32_MC0_MISC+16:
-	case MSR_IA32_MC0_MISC+20:
+		if (!(mcg_cap & MCG_CTL_P))
+			return 1;
+		data =3D vcpu->arch.mcg_ctl;
+		break;
+	case MSR_IA32_MCG_STATUS:
+		data =3D vcpu->arch.mcg_status;
+		break;
+	default:
+		if (msr >=3D MSR_IA32_MC0_CTL &&
+		    msr < MSR_IA32_MC0_CTL + 4 * bank_num) {
+			u32 offset =3D msr - MSR_IA32_MC0_CTL;
+			data =3D vcpu->arch.mce_banks[offset];
+			break;
+		}
+		return 1;
+	}
+	*pdata =3D data;
+	return 0;
+}
+
+int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
+{
+	u64 data;
+
+	switch (msr) {
+	case 0xc0010010: /* SYSCFG */
+	case 0xc0010015: /* HWCR */
+	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_EBL_CR_POWERON:
 	case MSR_IA32_DEBUGCTLMSR:
@@ -928,6 +980,13 @@ int kvm_get_msr_common(struct kvm_vcpu *
 	case MSR_KVM_SYSTEM_TIME:
 		data =3D vcpu->arch.time;
 		break;
+	case MSR_IA32_P5_MC_ADDR:
+	case MSR_IA32_P5_MC_TYPE:
+	case MSR_IA32_MCG_CAP:
+	case MSR_IA32_MCG_CTL:
+	case MSR_IA32_MCG_STATUS:
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
+		return get_msr_mce(vcpu, msr, pdata);
 	default:
 		pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
 		return 1;
@@ -1049,6 +1108,9 @@ int kvm_dev_ioctl_check_extension(long e
 	case KVM_CAP_IOMMU:
 		r =3D iommu_found();
 		break;
+	case KVM_CAP_MCE:
+		r =3D KVM_MAX_MCE_BANKS;
+		break;
 	default:
 		r =3D 0;
 		break;
@@ -1109,6 +1171,16 @@ long kvm_arch_dev_ioctl(struct file *fil
 		r =3D 0;
 		break;
 	}
+	case KVM_X86_GET_MCE_CAP_SUPPORTED: {
+		u64 mce_cap;
+
+		mce_cap =3D KVM_MCE_CAP_SUPPORTED;
+		r =3D -EFAULT;
+		if (copy_to_user(argp, &mce_cap, sizeof mce_cap))
+			goto out;
+		r =3D 0;
+		break;
+	}
 	default:
 		r =3D -EINVAL;
 	}
@@ -1452,6 +1524,80 @@ static int vcpu_ioctl_tpr_access_reporti
 	return 0;
 }
=20
+static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
+					u64 mcg_cap)
+{
+	int r;
+	unsigned bank_num =3D mcg_cap & 0xff, bank;
+
+	r =3D -EINVAL;
+	if (!bank_num)
+		goto out;
+	if (mcg_cap & ~(KVM_MCE_CAP_SUPPORTED | 0xff | 0xff0000))
+		goto out;
+	r =3D 0;
+	vcpu->arch.mcg_cap =3D mcg_cap;
+	/* Init IA32_MCG_CTL to all 1s */
+	if (mcg_cap & MCG_CTL_P)
+		vcpu->arch.mcg_ctl =3D ~(u64)0;
+	/* Init IA32_MCi_CTL to all 1s */
+	for (bank =3D 0; bank < bank_num; bank++)
+		vcpu->arch.mce_banks[bank*4] =3D ~(u64)0;
+out:
+	return r;
+}
+
+static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
+				      struct kvm_x86_mce *mce)
+{
+	u64 mcg_cap =3D vcpu->arch.mcg_cap;
+	unsigned bank_num =3D mcg_cap & 0xff;
+	u64 *banks =3D vcpu->arch.mce_banks;
+
+	if (mce->bank >=3D bank_num || !(mce->status & MCI_STATUS_VAL))
+		return -EINVAL;
+	/*
+	 * if IA32_MCG_CTL is not all 1s, the uncorrected error
+	 * reporting is disabled
+	 */
+	if ((mce->status & MCI_STATUS_UC) && (mcg_cap & MCG_CTL_P) &&
+	    vcpu->arch.mcg_ctl !=3D ~(u64)0)
+		return 0;
+	banks +=3D 4 * mce->bank;
+	/*
+	 * if IA32_MCi_CTL is not all 1s, the uncorrected error
+	 * reporting is disabled for the bank
+	 */
+	if ((mce->status & MCI_STATUS_UC) && banks[0] !=3D ~(u64)0)
+		return 0;
+	if (mce->status & MCI_STATUS_UC) {
+		if ((vcpu->arch.mcg_status & MCG_STATUS_MCIP) ||
+		    !(vcpu->arch.cr4 & X86_CR4_MCE)) {
+			printk(KERN_DEBUG "kvm: set_mce: "
+			       "injects mce exception while "
+			       "previous one is in progress!\n");
+			set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
+			return 0;
+		}
+		if (banks[1] & MCI_STATUS_VAL)
+			mce->status |=3D MCI_STATUS_OVER;
+		banks[1] =3D mce->status;
+		banks[2] =3D mce->addr;
+		banks[3] =3D mce->misc;
+		vcpu->arch.mcg_status =3D mce->mcg_status;
+		kvm_queue_exception(vcpu, MC_VECTOR);
+	} else if (!(banks[1] & MCI_STATUS_VAL)
+		   || !(banks[1] & MCI_STATUS_UC)) {
+		if (banks[1] & MCI_STATUS_VAL)
+			mce->status |=3D MCI_STATUS_OVER;
+		banks[1] =3D mce->status;
+		banks[2] =3D mce->addr;
+		banks[3] =3D mce->misc;
+	} else
+		banks[1] |=3D MCI_STATUS_OVER;
+	return 0;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -1585,6 +1731,24 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 		kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
 		break;
 	}
+	case KVM_X86_SETUP_MCE: {
+		u64 mcg_cap;
+
+		r =3D -EFAULT;
+		if (copy_from_user(&mcg_cap, argp, sizeof mcg_cap))
+			goto out;
+		r =3D kvm_vcpu_ioctl_x86_setup_mce(vcpu, mcg_cap);
+		break;
+	}
+	case KVM_X86_SET_MCE: {
+		struct kvm_x86_mce mce;
+
+		r =3D -EFAULT;
+		if (copy_from_user(&mce, argp, sizeof mce))
+			goto out;
+		r =3D kvm_vcpu_ioctl_x86_set_mce(vcpu, &mce);
+		break;
+	}
 	default:
 		r =3D -EINVAL;
 	}
@@ -4330,6 +4494,14 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *
 			goto fail_mmu_destroy;
 	}
=20
+	vcpu->arch.mce_banks =3D kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
+				       GFP_KERNEL);
+	if (!vcpu->arch.mce_banks) {
+		r =3D -ENOMEM;
+		goto fail_mmu_destroy;
+	}
+	vcpu->arch.mcg_cap =3D KVM_MAX_MCE_BANKS;
+
 	return 0;
=20
 fail_mmu_destroy:
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -374,6 +374,11 @@ struct kvm_vcpu_arch {
 	unsigned long dr6;
 	unsigned long dr7;
 	unsigned long eff_db[KVM_NR_DB_REGS];
+
+	u64 mcg_cap;
+	u64 mcg_status;
+	u64 mcg_ctl;
+	u64 *mce_banks;
 };
=20
 struct kvm_mem_alias {
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -292,6 +292,18 @@ struct kvm_guest_debug {
 	struct kvm_guest_debug_arch arch;
 };
=20
+/* x86 MCE */
+struct kvm_x86_mce {
+	__u64 status;
+	__u64 addr;
+	__u64 misc;
+	__u64 mcg_status;
+	__u8 bank;
+	__u8 pad1;
+	__u16 pad2;
+	__u32 pad3;
+};
+
 #define KVM_TRC_SHIFT           16
 /*
  * kvm trace categories
@@ -451,6 +463,7 @@ struct kvm_irq_routing {
 };
=20
 #endif
+#define KVM_CAP_MCE 28
=20
 /*
  * ioctls for VM fds
@@ -539,6 +552,10 @@ struct kvm_irq_routing {
 #define KVM_NMI                   _IO(KVMIO,  0x9a)
 /* Available with KVM_CAP_SET_GUEST_DEBUG */
 #define KVM_SET_GUEST_DEBUG       _IOW(KVMIO,  0x9b, struct kvm_guest_debu=
g)
+/* MCE for x86 */
+#define KVM_X86_SETUP_MCE         _IOW(KVMIO,  0x9c, __u64)
+#define KVM_X86_GET_MCE_CAP_SUPPORTED _IOR(KVMIO,  0x9d, __u64)
+#define KVM_X86_SET_MCE           _IOW(KVMIO,  0x9e, struct kvm_x86_mce)
=20
 /*
  * Deprecated interfaces


--=-MZ4UIgAkWluARlyyjkcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknoL74ACgkQKhFGF+eHlpiRYACdFW0BZ8gCoJ5SIcUXs6o/R7vo
W8MAoKL8+jZtZdPKSDAvWFr2ETltPtiI
=8r+h
-----END PGP SIGNATURE-----

--=-MZ4UIgAkWluARlyyjkcS--

