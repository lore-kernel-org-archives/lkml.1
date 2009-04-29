Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbZD2BcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbZD2BcC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 21:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758826AbZD2Bbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 21:31:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:65192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758211AbZD2Bbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 21:31:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,263,1239001200"; 
   d="asc'?scan'208";a="510791914"
Subject: Re: [PATCH -v2] x86: MCE: Re-implement MCE log ring buffer as
 per-CPU ring buffer
From: Huang Ying <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <87eivdqdsq.fsf@basil.nowhere.org>
References: <1240910841.6842.1163.camel@yhuang-dev.sh.intel.com>
	 <87eivdqdsq.fsf@basil.nowhere.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-E5QJUR8RKy/Ee6Mbv28O"
Date: Wed, 29 Apr 2009 09:31:49 +0800
Message-Id: <1240968709.6842.1175.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E5QJUR8RKy/Ee6Mbv28O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-28 at 18:21 +0800, Andi Kleen wrote:
> Huang Ying <ying.huang@intel.com> writes:
> >
> > ChangeLog:
> >
> > v2:
> >
> > - Use alloc_percpu() to allocate per_cpu mcelog buffer
>=20
> Sorry, why didn't you just use DEFINE_PER_CPU ? That should work
> as well and will be shorter.

OK. I can do that.

> Another thing I noticed. the "MACHINECHECK" signature was originally
> for crash dump tools to find the log. If you change the format
> you should change it to MACHINECHEC2 or so.

Oh, thanks, I will change this.

> > +	size_t usize_limit;
> > +
> > +	/* Too large user buffer size may cause system not response */
> > +	usize_limit =3D num_possible_cpus() * MCE_LOG_LEN * sizeof(struct mce=
);
> > +	if (usize > usize_limit)
> > +		usize =3D usize_limit;
>=20
> Did you ever track down what happens here? I still find it worrying

Maybe the comment is a little confusing. What we do is limit the size of
user buffer size to prevent system from not response. If the user buffer
size is limited, the time taken by mce_read() can be reasonable, and
will not cause system not to response.

But maybe num_possible_cpus() * MCE_LOG_LEN is not a good upper limit,
because possible cpus can be fairly large. Maybe we can add another
limit, something as follow:

#define MCE_READ_RECORD_LIMIT	512

/*
 * Too large user buffer size may cause system not response, so constrain
 * the effective size of user buffer
 */
usize_limit =3D num_possible_cpus() * MCE_LOG_LEN * sizeof(struct mce);
if (usize_limit > MCE_RECOARD_LIMIT * sizeof(struct mce))
	usize_limit =3D MCE_RECOARD_LIMIT * sizeof(struct mce);
if (usize > usize_limit)
	usize =3D usize_limit;

Best Regards,
Huang Ying


--=-E5QJUR8RKy/Ee6Mbv28O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn3rf0ACgkQKhFGF+eHlpiZdACePchNYcmeyUca2rYK6GWagsz5
RyIAn2bvyuVOGK1Tfvn5ZJlhL3QgsqYL
=VYau
-----END PGP SIGNATURE-----

--=-E5QJUR8RKy/Ee6Mbv28O--

