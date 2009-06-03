Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZFCQBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZFCQBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZFCQBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:01:04 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:42047 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbZFCQBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:01:04 -0400
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ying.huang@intel.com, W.Li@Sun.COM, mingo@elte.hu,
       heicars2@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com
In-Reply-To: <4A26961E.7040207@linux.vnet.ibm.com>
References: <20090602114359.129247921@linux.vnet.ibm.com>
	 <20090602114402.951631599@linux.vnet.ibm.com>
	 <20090602150324.c706b1d2.akpm@linux-foundation.org>
	 <4A266546.5080601@linux.vnet.ibm.com> <4A26961E.7040207@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3ZbG0NcC6nRL2Hh65ofy"
Date: Thu, 04 Jun 2009 02:01:03 +1000
Message-Id: <1244044863.2998.10.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3ZbG0NcC6nRL2Hh65ofy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-03 at 17:26 +0200, Peter Oberparleiter wrote:
> Peter Oberparleiter wrote:
> > Andrew Morton wrote:
> >> On Tue, 02 Jun 2009 13:44:02 +0200
> >> Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
> >>> +	/* Duplicate gcov_info. */
> >>> +	active =3D num_counter_active(info);
> >>> +	dup =3D kzalloc(sizeof(struct gcov_info) +
> >>> +		      sizeof(struct gcov_ctr_info) * active, GFP_KERNEL);
> >>=20
> >> How large can this allocation be?
> >=20
> > Hm, good question. Having a look at my test system, I see coverage data=
=20
> > files of up to 60kb size. With counters making up the largest part of=20
> > those, I'd guess the allocation size can be around ~55kb. I assume that=
=20
> > makes it a candidate for vmalloc?
>=20
> A further run with debug output showed that the maximum size is
> actually around 4k, so in my opinion, there is no need to switch
> to vmalloc.

The real question is how big can active be, and it looks like <=3D 5 is
the answer:

+/* Determine number of active counters. Based on gcc magic. */
+static unsigned int num_counter_active(struct gcov_info *info)
+{
+	unsigned int i;
+	unsigned int result =3D 0;
+
+	for (i =3D 0; i < GCOV_COUNTERS; i++) {
+		if (counter_active(info, i))
+			result++;
+	}
+	return result;
+}

+#define GCOV_COUNTERS		5

So that seems reasonable.

I assumed these were the per BB counters, but it seems they're counter
_types_. Where are the BB counters, in the values array? If so perhaps
that is the candidate for vmalloc.

cheers

--=-3ZbG0NcC6nRL2Hh65ofy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkomnjoACgkQdSjSd0sB4dLdCACgx14+TZy9AJU97y2NgJ97FRrR
vB8An37mRHYIC02aM7mu/juuyd2tyORa
=DqVP
-----END PGP SIGNATURE-----

--=-3ZbG0NcC6nRL2Hh65ofy--

