Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZDTBXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZDTBXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZDTBXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:23:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:60450 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbZDTBXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:23:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,214,1239001200"; 
   d="asc'?scan'208";a="133211195"
Subject: Re: [PATCH -v2 2/2] kvm userspace: Add MCE simulation to kvm
From: Huang Ying <ying.huang@intel.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20090417144908.GA24261@amt.cnet>
References: <1239953925.6842.21.camel@yhuang-dev.sh.intel.com>
	 <20090417144908.GA24261@amt.cnet>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tK/eZYIJmbR44ltXggXB"
Date: Mon, 20 Apr 2009 09:22:59 +0800
Message-Id: <1240190579.6842.48.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tK/eZYIJmbR44ltXggXB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-17 at 22:49 +0800, Marcelo Tosatti wrote:
> Hi Huang,
>=20
> On Fri, Apr 17, 2009 at 03:38:45PM +0800, Huang Ying wrote:
> > - MCE features are initialized when VCPU is initialized according to CP=
UID.
> > - A monitor command "mce" is added to inject a MCE.
> >=20
> >=20
> > ChangeLog:
> >=20
> > v2:
> >=20
> > - Use new kernel MCE capability exportion interface.
> >=20
> >=20
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> >=20
> > ---
> >  libkvm/libkvm-x86.c    |   33 +++++++++++++++++++++++++++++++++
> >  libkvm/libkvm.h        |    4 ++++
> >  qemu/monitor.c         |   26 ++++++++++++++++++++++++++
> >  qemu/qemu-kvm-x86.c    |   33 +++++++++++++++++++++++++++++++++
> >  qemu/qemu-kvm.c        |   26 ++++++++++++++++++++++++++
> >  qemu/qemu-kvm.h        |    4 ++++
> >  qemu/target-i386/cpu.h |    3 +++
> >  7 files changed, 129 insertions(+)
> >=20
> > --- a/qemu/monitor.c
> > +++ b/qemu/monitor.c
> > @@ -1557,6 +1557,31 @@ static void do_info_status(Monitor *mon)
> >  }
> > =20
> > =20
> > +#if defined(TARGET_I386) || defined(TARGET_X86_64)
> > +static void do_inject_mce(Monitor *mon,
> > +			  int cpu_index, int bank,
> > +			  unsigned status_hi, unsigned status_lo,
> > +			  unsigned mcg_status_hi, unsigned mcg_status_lo,
> > +			  unsigned addr_hi, unsigned addr_lo,
> > +			  unsigned misc_hi, unsigned misc_lo)
> > +{
> > +    CPUState *env;
> > +    struct kvm_x86_mce mce =3D {
> > +	.bank =3D bank,
> > +	.status =3D ((uint64_t)status_hi << 32) | status_lo,
> > +	.mcg_status =3D ((uint64_t)mcg_status_hi << 32) | mcg_status_lo,
> > +	.addr =3D ((uint64_t)addr_hi << 32) | addr_lo,
> > +	.misc =3D ((uint64_t)misc_hi << 32) | misc_lo,
> > +    };
> > +
> > +    for (env =3D first_cpu; env !=3D NULL; env =3D env->next_cpu)
> > +	if (env->cpu_index =3D=3D cpu_index && env->mcg_cap) {
> > +	    kvm_inject_x86_mce(env, &mce);
> > +	    break;
> > +	}
> > +}
> > +#endif
>=20
> This will break compilation on hosts with older kernel headers. To ease
> the merge with QEMU, do_inject_mce should call qemu_inject_x86_mce,
> which does nothing for the case where KVM is disabled, or call KVM
> specific function otherwise (knowledge about struct kvm_x86_mce should
> be contained within KVM code).

Yes. I will fix this.

> > +
> >  static void do_balloon(Monitor *mon, int value)
> >  {
> >      ram_addr_t target =3D value;
> > @@ -1758,6 +1783,7 @@ static const mon_cmd_t mon_cmds[] =3D {
> >        "[tap,user,socket,vde] options", "add host VLAN client" },
> >      { "host_net_remove", "is", net_host_device_remove,
> >        "vlan_id name", "remove host VLAN client" },
> > +    { "mce", "iillll", do_inject_mce, "cpu bank status mcgstatus addr =
misc", "inject a MCE on the given CPU"},
> >  #endif
> >      { "balloon", "i", do_balloon,
> >        "target", "request VM to change it's memory allocation (in MB)" =
},
> > --- a/libkvm/libkvm-x86.c
> > +++ b/libkvm/libkvm-x86.c
> > @@ -379,6 +379,39 @@ int kvm_set_msrs(kvm_context_t kvm, int=20
> >      return r;
> >  }
> > =20
> >
> > +int kvm_get_mce_cap_supported(kvm_context_t kvm, uint64_t *mce_cap,
> > +			      int *max_banks)
> > +{
> > +    int r;
> > +
> > +    r =3D ioctl(kvm->fd, KVM_CHECK_EXTENSION, KVM_CAP_MCE);
> > +    if (r > 0) {
> > +	*max_banks =3D r;
> > +	return ioctl(kvm->fd, KVM_X86_GET_MCE_CAP_SUPPORTED, mce_cap);
> > +    }
> > +    return -ENOSYS;
> > +}
> > +
> > +int kvm_setup_mce(kvm_context_t kvm, int vcpu, uint64_t *mcg_cap)
> > +{
> > +    int r;
> > +
> > +    r =3D ioctl(kvm->fd, KVM_CHECK_EXTENSION, KVM_CAP_MCE);
> > +    if (r > 0)
> > +	return ioctl(kvm->vcpu_fd[vcpu], KVM_X86_SETUP_MCE, mcg_cap);
> > +    return -ENOSYS;
> > +}
> > +
> > +int kvm_set_mce(kvm_context_t kvm, int vcpu, struct kvm_x86_mce *m)
> > +{
> > +    int r;
> > +
> > +    r =3D ioctl(kvm->fd, KVM_CHECK_EXTENSION, KVM_CAP_MCE);
> > +    if (r > 0)
> > +	return ioctl(kvm->vcpu_fd[vcpu], KVM_X86_SET_MCE, m);
> > +    return -ENOSYS;
> > +}
>=20
> Have to #ifdef KVM_CAP_MCE where appropriate, otherwise compilation=20
> on hosts with older kernel headers fail.

Yes. I will fix this.

Best Regards,
Huang Ying


--=-tK/eZYIJmbR44ltXggXB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknrznAACgkQKhFGF+eHlpjn+QCfVUSjyyT4dyg5PCcxO5vREr26
BHIAoJoOJyKbrK8D632xdXok6iAHQ7nd
=N2SY
-----END PGP SIGNATURE-----

--=-tK/eZYIJmbR44ltXggXB--

