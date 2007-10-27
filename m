Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbXJ0Val@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbXJ0Val (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 17:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXJ0Vab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 17:30:31 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:47955 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511AbXJ0Vaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 17:30:30 -0400
Subject: Re: Networked filesystems vs backing_dev_info
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steve French <smfrench@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, sfrench@samba.org,
       jaharkes@cs.cmu.edu, Andrew Morton <akpm@linux-foundation.org>,
       vandrove@vc.cvut.cz
In-Reply-To: <524f69650710271402g65a9ec1cqcc7bc3a964097e39@mail.gmail.com>
References: <1193477666.5648.61.camel@lappy>
	 <524f69650710271402g65a9ec1cqcc7bc3a964097e39@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ejXzy2nRMorkPk2KvdHr"
Date: Sat, 27 Oct 2007 23:30:25 +0200
Message-Id: <1193520625.27652.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ejXzy2nRMorkPk2KvdHr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-27 at 16:02 -0500, Steve French wrote:
> On 10/27/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Hi,
> >
> > I had me a little look at bdi usage in networked filesystems.
> >
> >  NFS, CIFS, (smbfs), AFS, CODA and NCP
> >
> > And of those, NFS is the only one that I could find that creates
> > backing_dev_info structures. The rest seems to fall back to
> > default_backing_dev_info.
> >
> > With my recent per bdi dirty limit patches the bdi has become more
> > important than it has been in the past. While falling back to the
> > default_backing_dev_info isn't wrong per-se, it isn't right either.
> >
> > Could I implore the various maintainers to look into this issue for
> > their respective filesystem. I'll try and come up with some patches to
> > address this, but feel free to beat me to it.
>=20
> I would like to understand more about your patches to see what bdi
> values makes sense for CIFS and how to report possible congestion back
> to the page manager.=20

So, what my recent patches do is carve up the total writeback cache
size, or dirty page limit as we call it, proportionally to a BDIs
writeout speed. So a fast device gets more than a slow device, but will
not starve it.

However, for this to work, each device, or remote backing store in the
case of networked filesystems, need to have a BDI.

>   I had been thinking about setting bdi->ra_pages
> so that we do more sensible readahead and writebehind - better
> matching what is possible over the network and what the server
> prefers. =20

Well, you'd first have to create backing_dev_info instances before
setting that value :-)

>   SMB/CIFS Servers typically allow a maximum of 50 requests
> in parallel at one time from one client (although this is adjustable
> for some).

That seems like a perfect point to set congestion.

So in short, stick a struct backing_dev_info into whatever represents a
client, initialize it using bdi_init(), destroy using bdi_destroy().

Mark it congested once you have 50 (or more) outstanding requests, clear
congestion when you drop below 50.

and you should be set.


--=-ejXzy2nRMorkPk2KvdHr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHI63xXA2jU0ANEf4RAm1HAJ9As7hCKXXSFOiD3ZanT/jdHyd7kQCbBy++
klTaneEvly5Q0zaBZPHaFwk=
=wUi5
-----END PGP SIGNATURE-----

--=-ejXzy2nRMorkPk2KvdHr--

