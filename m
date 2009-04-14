Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZDNCFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZDNCFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 22:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZDNCFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 22:05:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:17945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbZDNCE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 22:04:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,182,1239001200"; 
   d="asc'?scan'208";a="402873565"
Subject: Re: [PATCH] Add MCE support to KVM
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <49E337D7.5050502@redhat.com>
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>
	 <49DE195D.1020303@redhat.com>
	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>
	 <49E08762.1010206@redhat.com>
	 <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com>
	 <49E337D7.5050502@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SBYsoJm52/LpF2uk2Q2q"
Date: Tue, 14 Apr 2009 10:04:57 +0800
Message-Id: <1239674697.20762.34.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SBYsoJm52/LpF2uk2Q2q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-04-13 at 21:02 +0800, Avi Kivity wrote:
> Huang Ying wrote:
> > On Sat, 2009-04-11 at 20:04 +0800, Avi Kivity wrote:
> >  =20
> >>>> Why not always allocate it on vcpu setup?
> >>>>    =20
> >>>>        =20
> >>> Because the MCE bank number is not fixed, it is based on mcg_cap from
> >>> user space.
> >>>  =20
> >>>      =20
> >> Right, but we can allocate the maximum number, no?  it's a fairly smal=
l=20
> >> amount of memory.
> >>    =20
> >
> > OK. If you are OK with 8k extra memory usage.
> >  =20
>=20
> Let's make it 64 banks like Andi suggests.  Return the number in the=20
> KVM_CHECK_EXTENSION call (we do the same for memory slots) so userspace=20
> can adjust.

OK. I will change this.

> >>
> >> kvm does feature negotiation (really, feature advertising) using=20
> >> KVM_CAP_... and KVM_CHECK_EXTENSION.  So there's no need for this.
> >>    =20
> >
> > It is not only feature advertising, but also something like CPUID. Base=
d
> > on CPU type specified in command line (qemu -cpu ?), different mcg_cap
> > can be used to determine number of MCE banks and various features of MC=
E
> > (MCG_CTL_P, MCG_TES_P, MCG_CMCI, etc) for specified CPU type. With KVM
> > feature advertising, we can only check whether MCE simulation is
> > supported, but can not set parameters of MCE simulation.
> >
> > Maybe this interface can be changed to KVM_SET_MSRS, with
> > MSR_IA32_MCG_CAP be set by kvm-qemu. But MSR_IA32_MCG_CAP is read-only
> > by spec, and current interface can not distinguishes between MSR set
> > from guest system and MSR setup from kvm-qemu. I think there should be
> > other read-only MSRs need to be setup during guest system
> > creation/setup. How about add a interface such as KVM_SETUP_MSRS to
> > setup the value of read-only MSRs?
> >  =20
>=20
> Then we would need to tell which read-only MSRs are setup writeable and=20
> which aren't...

Maybe something like only if KVM_CAP_MCE is advertised, the MCE related
read-only RO-MSRs can be setup. Other RO-MSRs setup code can be added
following the similar rules.

And interface is something like follow?

long kvm_arch_vcpu_ioctl(...)
{
    ...
    case KVM_SETUP_RO_MSRS:
        r =3D msr_io(vcpu, argp, kvm_setup_ro_msr, 0);
    ...
}

int kvm_setup_ro_msr(...)
{
    /* return 1 for setup un-writable MSR, otherwise 0 */
}

> I'm okay with an ioctl to setup MCE, but just make sure userspace has=20
> all the information to know what the kernel can do rather than the=20
> try-and-see-if-it-works approach.  We can publish this information via=20
> KVM_CAP things, or via another ioctl (see KVM_GET_SUPPORTED_CPUID2 for=20
> an example).

Yes. MCE support should be published by KVM_CAP_MCE and other features
can be published via reading the default value of MSR_IA32_MCG_CAP.

Best Regards,
Huang Ying


--=-SBYsoJm52/LpF2uk2Q2q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknj70YACgkQKhFGF+eHlpgQmgCgjc/qMe4wMFJeTPkUoShIdRow
DKAAn2/021c0ekISPuhfyvKEBsMzqdM+
=gU5u
-----END PGP SIGNATURE-----

--=-SBYsoJm52/LpF2uk2Q2q--

