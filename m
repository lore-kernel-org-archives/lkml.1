Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbZCBHqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbZCBHqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 02:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZCBHqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 02:46:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:23222 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZCBHqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 02:46:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,288,1233561600"; 
   d="asc'?scan'208";a="115678024"
Subject: Re: [PATCH] Fix e820 end address with EFI
From: Huang Ying <ying.huang@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Maly <bmaly@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440903011851t17e240eu9dc25116a40ca85e@mail.gmail.com>
References: <49A965AD.10701@redhat.com>
	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>
	 <49AAEC79.3000808@redhat.com>
	 <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>
	 <49AB38E7.60305@redhat.com>
	 <1235960016.6204.170.camel@yhuang-dev.sh.intel.com>
	 <49AB4171.7000508@kernel.org>
	 <1235960708.6204.176.camel@yhuang-dev.sh.intel.com>
	 <49AB4521.8010909@kernel.org>
	 <1235961428.6204.190.camel@yhuang-dev.sh.intel.com>
	 <86802c440903011851t17e240eu9dc25116a40ca85e@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hVyPen/HKT8MB5faZiIs"
Date: Mon, 02 Mar 2009 15:45:59 +0800
Message-Id: <1235979959.6204.212.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hVyPen/HKT8MB5faZiIs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-02 at 10:51 +0800, Yinghai Lu wrote:
> On Sun, Mar 1, 2009 at 6:37 PM, Huang Ying <ying.huang@intel.com> wrote:
> >> so 64bit could use ioremap_cache() too?
> >> we may keep 32bit and 64bit a bit consistent.
> >
> > If we use ioremap_cache(), kexec runtime service will not work in kexec
> > situation, which needs EFI runtime memory area to be mapped at exact
> > same location across kexec. I think we should support kexec if possible=
.
>=20
>=20
> sure.
>=20
> please don't touch max_low_pfn_mapped, because some range may not
> directly mapped under those efi run-time code

Find an issue to use init_memory_mapping() here.

If the memory range to be mapped is less than 2M, the last mapped
address may be next 2M aligned position, this may lead mapping
overlapping between memory range. Such as:

0x3f388000 - 0x3f488000: real mapped	0x3f388000 - 0x3f600000
0x3f590000 - 0x3f5bb000: real mapped	0x3f590000 - 0x3f600000

The problem is that the memory range 0x3f400000 - 0x3f590000 is left not
mapped!

Two way to fix the issue:

a) Make init_memory_mapping stopped at specified end page exactly! Even
for memory range smaller than 2M.

b) init_memory_mapping maps all underlying pages when split large
mapping.

What do you think about that?

Best Regards,
Huang Ying


--=-hVyPen/HKT8MB5faZiIs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmrjrEACgkQKhFGF+eHlpgQWgCfaQW68O8AGjTPvDm9qaqXPeHH
YZQAn1BuXjT20ZJNuqAogJNEbj3Er20i
=fmOk
-----END PGP SIGNATURE-----

--=-hVyPen/HKT8MB5faZiIs--

