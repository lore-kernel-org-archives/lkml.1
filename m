Return-Path: <linux-kernel-owner+w=401wt.eu-S932719AbZDJDBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbZDJDBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 23:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbZDJDA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 23:00:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:58888 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758534AbZDJDA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 23:00:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,164,1239001200"; 
   d="asc'?scan'208";a="505212627"
Subject: Re: [PATCH] Add MCE support to KVM
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <49DE195D.1020303@redhat.com>
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>
	 <49DE195D.1020303@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OXxpdHdZIqJTk3I3oXib"
Date: Fri, 10 Apr 2009 11:00:55 +0800
Message-Id: <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OXxpdHdZIqJTk3I3oXib
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-09 at 23:50 +0800, Avi Kivity wrote:
> Huang Ying wrote:
> > +int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
> > +{
> > +	switch (msr) {
> > +	case MSR_EFER:
> > +		set_efer(vcpu, data);
> >  		break;
> >  	case MSR_IA32_DEBUGCTLMSR:
> >  		if (!data) {
> > @@ -807,6 +828,8 @@ int kvm_set_msr_common(struct kvm_vcpu *
> >  		break;
> >  	}
> >  	default:
> > +		if (!set_msr_mce(vcpu, msr, data))
> > +		    break;
> >  		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x data %llx\n", msr, data);
> >  		return 1;
> >  	}
> >  =20
>=20
> Is there any reason you split kvm_set_msr_common() into two functions?

I want to group MCE related MSR together. And most MCE MSR read/write
need to access vcpu->arch.mcg_xxx or vcpu->arch_mce_banks, So I think
use a MCE specific function would be cleaner.

But It seems that something as follow would be better.

kvm_set_msr_comm()
{
	switch (msr) {
	case MSR_IA32_P5_MC_ADDR:
	case MSR_IA32_P5_MC_TYPE:
	case MSR_IA32_MCG_CAP:
	case MSR_IA32_MCG_CTL:
	case MSR_IA32_MCG_STATUS:
	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_MISC + 4 * KVM_MCE_MAX_BANK:
		set_msr_mce();
		break;
	...
	}
	...
}

> > +
> > +int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
> > +{
> > +	u64 data;
> > +
> > +	switch (msr) {
> > +	case 0xc0010010: /* SYSCFG */
> > +	case 0xc0010015: /* HWCR */
> >  =20
>=20
> Please use MSR_ constants (add them if they don't exist yet).

In fact, this is not added by me. But I can change this by the way.

> > =20
> > +static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
> > +					u64 mcg_cap)
> > +{
> > +	int r;
> > +	unsigned bank_num =3D mcg_cap & 0xff, bank;
> > +	u64 *banks;
> > +
> > +	r =3D -EINVAL;
> > +	if (!bank_num)
> > +		goto out;
> > +	r =3D -ENOMEM;
> > +	banks =3D kzalloc(bank_num * sizeof(u64) * 4, GFP_KERNEL);
> >  =20
>=20
> If banks is already allocated, you'll leak it.

Yes. I will fix this.

> Why not always allocate it on vcpu setup?

Because the MCE bank number is not fixed, it is based on mcg_cap from
user space.

> > +static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
> > +				      struct kvm_x86_mce *mce)
> > +{
> > +	u64 mcg_cap =3D vcpu->arch.mcg_cap;
> > +	unsigned bank_num =3D mcg_cap & 0xff;
> > +	u64 *banks =3D vcpu->arch.mce_banks;
> > +
> > +	if (mce->bank >=3D bank_num || !(mce->status & MCI_STATUS_VAL))
> > +		return -EINVAL;
> > +	/*
> > +	 * if IA32_MCG_CTL is not all 1s, the uncorrected error
> > +	 * reporting is disabled
> > +	 */
> > +	if ((mce->status & MCI_STATUS_UC) && (mcg_cap & MCG_CTL_P) &&
> > +	    vcpu->arch.mcg_ctl !=3D ~(u64)0)
> > +		return 0;
> > +	banks +=3D 4 * mce->bank;
> > +	/*
> > +	 * if IA32_MCi_CTL is not all 1s, the uncorrected error
> > +	 * reporting is disabled for the bank
> > +	 */
> > +	if ((mce->status & MCI_STATUS_UC) && banks[0] !=3D ~(u64)0)
> > +		return 0;
> > +	if (mce->status & MCI_STATUS_UC) {
> > +		u64 status =3D mce->status;
> > +		if ((vcpu->arch.mcg_status & MCG_STATUS_MCIP) ||
> > +		    !(vcpu->arch.cr4 & X86_CR4_MCE)) {
> > +			printk(KERN_DEBUG "kvm: set_mce: "
> > +			       "injects mce exception while "
> > +			       "previous one is in progress!\n");
> > +			set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
> > +			return 0;
> > +		}
> > +		if (banks[1] & MCI_STATUS_VAL)
> > +			status |=3D MCI_STATUS_OVER;
> > +		banks[1] =3D mce->status;
> > +		banks[2] =3D mce->addr;
> > +		banks[3] =3D mce->misc;
> > +		vcpu->arch.mcg_status =3D mce->mcg_status;
> > +		kvm_queue_exception(vcpu, MC_VECTOR);
> > +	} else if (!(banks[1] & MCI_STATUS_VAL) ||
> > +		   (!(banks[1] & MCI_STATUS_UC) &&
> > +		    !((mcg_cap & MCG_TES_P) && ((banks[1]>>53) & 0x3) < 2))) {
> > +		u64 status =3D mce->status;
> > +		if (banks[1] & MCI_STATUS_VAL)
> > +			status |=3D MCI_STATUS_OVER;
> > +		banks[1] =3D mce->status;
> > +		banks[2] =3D mce->addr;
> > +		banks[3] =3D mce->misc;
> > +	} else
> > +		banks[1] |=3D MCI_STATUS_OVER;
> > +	return 0;
> > +}
> >  =20
>=20
> Can userspace just use KVM_SET_MSR for this?

In addition to assigning MSR, we have some other logic for MCE, such as
BANK reporting disabling, overwriting rules, triple fault for UC MCE
during MCIP. So I think we need some dedicate interface.

> > +	case KVM_X86_SETUP_MCE: {
> > +		u64 mcg_cap;
> > +
> > +		r =3D -EFAULT;
> > +		if (copy_from_user(&mcg_cap, argp, sizeof mcg_cap))
> > +			goto out;
> > +		/*
> > +		 * extended machine-check state registers and CMCI are
> > +		 * not supported.
> > +		 */
> > +		mcg_cap &=3D ~(MCG_EXT_P|MCG_CMCI_P);
> >  =20
>=20
> Instead of silently dropping, should return an error.
>=20
> > +		if (copy_to_user(argp, &mcg_cap, sizeof mcg_cap))
> > +			goto out;
> >  =20
>=20
> And not copy.

This is designed as some kind of feature negotiating. Use space request
MCE features via mcg_cap, kernel space remove un-supported features and
return the resulting mcg_cap.

>=20
> >  #define KVM_TRC_SHIFT           16
> >  /*
> >   * kvm trace categories
> > @@ -528,6 +540,9 @@ struct kvm_irq_routing {
> >  #define KVM_NMI                   _IO(KVMIO,  0x9a)
> >  /* Available with KVM_CAP_SET_GUEST_DEBUG */
> >  #define KVM_SET_GUEST_DEBUG       _IOW(KVMIO,  0x9b, struct kvm_guest_=
debug)
> > +/* MCE for x86 */
> > +#define KVM_X86_SETUP_MCE           _IOWR(KVMIO,  0x9a, __u64)
> > +#define KVM_X86_SET_MCE           _IOW(KVMIO,  0x9b, struct kvm_x86_mc=
e)
> >  =20
>=20
> Please add a KVM_CAP_ to advertise this capability.

Yes. I will do this.

Best Regards,
Huang Ying


--=-OXxpdHdZIqJTk3I3oXib
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknetmUACgkQKhFGF+eHlphcaQCaAviSZW/zLNSJSDvnVAdeTpHL
XYIAn0z05eAdXPnhCo9ljTGYvP6bzXd1
=oTJT
-----END PGP SIGNATURE-----

--=-OXxpdHdZIqJTk3I3oXib--

