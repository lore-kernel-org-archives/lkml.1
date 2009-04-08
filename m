Return-Path: <linux-kernel-owner+w=401wt.eu-S1758457AbZDHBxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457AbZDHBxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 21:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbZDHBx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 21:53:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:15177 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbZDHBxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 21:53:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,340,1235980800"; 
   d="asc'?scan'208";a="401283912"
Subject: [PATCH] Add MCE support to KVM
From: Huang Ying <ying.huang@intel.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JDiceHMC83uxYMRC5NDI"
Date: Wed, 08 Apr 2009 09:53:21 +0800
Message-Id: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JDiceHMC83uxYMRC5NDI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Add MCE support to KVM. The related MSRs are emulated. A new vcpu
ioctl command KVM_X86_SETUP_MCE is used to setup MCE emulation such as
the mcg_cap. MCE is injected via vcpu ioctl command
KVM_X86_SET_MCE. Extended machine-check state (MCG_EXT_P) and CMCI are
not implemented.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/include/asm/kvm_host.h |    5=20
 arch/x86/include/asm/mce.h      |    1=20
 arch/x86/kvm/x86.c              |  202 +++++++++++++++++++++++++++++++++++=
-----
 include/linux/kvm.h             |   15 ++
 4 files changed, 199 insertions(+), 24 deletions(-)

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
@@ -734,23 +735,43 @@ static int set_msr_mtrr(struct kvm_vcpu=20
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
@@ -807,6 +828,8 @@ int kvm_set_msr_common(struct kvm_vcpu *
 		break;
 	}
 	default:
+		if (!set_msr_mce(vcpu, msr, data))
+		    break;
 		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x data %llx\n", msr, data);
 		return 1;
 	}
@@ -861,26 +884,49 @@ static int get_msr_mtrr(struct kvm_vcpu=20
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
@@ -921,6 +967,8 @@ int kvm_get_msr_common(struct kvm_vcpu *
 		data =3D vcpu->arch.time;
 		break;
 	default:
+		if (!get_msr_mce(vcpu, msr, &data))
+			break;
 		pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
 		return 1;
 	}
@@ -1443,6 +1491,87 @@ static int vcpu_ioctl_tpr_access_reporti
 	return 0;
 }
=20
+static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
+					u64 mcg_cap)
+{
+	int r;
+	unsigned bank_num =3D mcg_cap & 0xff, bank;
+	u64 *banks;
+
+	r =3D -EINVAL;
+	if (!bank_num)
+		goto out;
+	r =3D -ENOMEM;
+	banks =3D kzalloc(bank_num * sizeof(u64) * 4, GFP_KERNEL);
+	if (!banks)
+		goto out;
+	r =3D 0;
+	vcpu->arch.mce_banks =3D banks;
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
+		u64 status =3D mce->status;
+		if ((vcpu->arch.mcg_status & MCG_STATUS_MCIP) ||
+		    !(vcpu->arch.cr4 & X86_CR4_MCE)) {
+			printk(KERN_DEBUG "kvm: set_mce: "
+			       "injects mce exception while "
+			       "previous one is in progress!\n");
+			set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
+			return 0;
+		}
+		if (banks[1] & MCI_STATUS_VAL)
+			status |=3D MCI_STATUS_OVER;
+		banks[1] =3D mce->status;
+		banks[2] =3D mce->addr;
+		banks[3] =3D mce->misc;
+		vcpu->arch.mcg_status =3D mce->mcg_status;
+		kvm_queue_exception(vcpu, MC_VECTOR);
+	} else if (!(banks[1] & MCI_STATUS_VAL) ||
+		   (!(banks[1] & MCI_STATUS_UC) &&
+		    !((mcg_cap & MCG_TES_P) && ((banks[1]>>53) & 0x3) < 2))) {
+		u64 status =3D mce->status;
+		if (banks[1] & MCI_STATUS_VAL)
+			status |=3D MCI_STATUS_OVER;
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
@@ -1576,6 +1705,31 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 		kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
 		break;
 	}
+	case KVM_X86_SETUP_MCE: {
+		u64 mcg_cap;
+
+		r =3D -EFAULT;
+		if (copy_from_user(&mcg_cap, argp, sizeof mcg_cap))
+			goto out;
+		/*
+		 * extended machine-check state registers and CMCI are
+		 * not supported.
+		 */
+		mcg_cap &=3D ~(MCG_EXT_P|MCG_CMCI_P);
+		if (copy_to_user(argp, &mcg_cap, sizeof mcg_cap))
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
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -371,6 +371,11 @@ struct kvm_vcpu_arch {
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
@@ -528,6 +540,9 @@ struct kvm_irq_routing {
 #define KVM_NMI                   _IO(KVMIO,  0x9a)
 /* Available with KVM_CAP_SET_GUEST_DEBUG */
 #define KVM_SET_GUEST_DEBUG       _IOW(KVMIO,  0x9b, struct kvm_guest_debu=
g)
+/* MCE for x86 */
+#define KVM_X86_SETUP_MCE           _IOWR(KVMIO,  0x9a, __u64)
+#define KVM_X86_SET_MCE           _IOW(KVMIO,  0x9b, struct kvm_x86_mce)
=20
 /*
  * Deprecated interfaces
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -13,6 +13,7 @@
 #define MCG_CTL_P	 (1UL<<8)   /* MCG_CAP register available */
 #define MCG_EXT_P	 (1ULL<<9)   /* Extended registers available */
 #define MCG_CMCI_P	 (1ULL<<10)  /* CMCI supported */
+#define MCG_TES_P	 (1ULL<<11)  /* Threshold-based error status */
=20
 #define MCG_STATUS_RIPV  (1UL<<0)   /* restart ip valid */
 #define MCG_STATUS_EIPV  (1UL<<1)   /* ip points to correct instruction */


--=-JDiceHMC83uxYMRC5NDI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkncA40ACgkQKhFGF+eHlpgqgACfY+crxwULzcsT98di7+Buq38q
MZsAn1CChEADdG8V7+cjxDBDwiyYXrO2
=O5JZ
-----END PGP SIGNATURE-----

--=-JDiceHMC83uxYMRC5NDI--

