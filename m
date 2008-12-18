Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753660AbYLRLtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbYLRLtV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYLRLsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:48:55 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:49900 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYLRLsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:48:54 -0500
Date: Thu, 18 Dec 2008 12:48:51 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Joel Becker <Joel.Becker@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
	configfs_depend_item()
Message-ID: <20081218114851.GT19128@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: Steven Whitehouse <swhiteho@redhat.com>,
	Joel Becker <Joel.Becker@oracle.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, cluster-devel@redhat.com
References: <20081212100615.GD19128@hawkmoon.kerlabs.com> <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com> <20081217134020.42da55fc.akpm@linux-foundation.org> <1229585208.9487.112.camel@twins> <20081218092744.GB30789@mail.oracle.com> <1229599618.3538.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-18453-1229600774-0001-2"
Content-Disposition: inline
In-Reply-To: <1229599618.3538.21.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-18453-1229600774-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18/12/08 11:26 +0000, Steven Whitehouse wrote:
> On Thu, 2008-12-18 at 01:27 -0800, Joel Becker wrote:
> >=20
> > 	It's about the default_groups and how they build up and tear
> > down small bits of tree.
> > 	A simple creation of a config_item, a mkdir(2), is a normal VFS
> > lock set and doesn't make lockdep unhappy.  But if the new config_item
> > has a default_group or two, they need locking too.  Not so much on
> > mkdir(2), but on rmdir(2).
> >=20
> So if I've understood this correctly, the dentries created upon mkdir
> live until such time as they are removed at some later date, presumably
> with rmdir?
>=20
> When creating the tree, would it be possible to build it starting from
> the bottom and working towards the point of attachment and then to not
> actually attach it until the last moment? That way it would not be
> visible from userland until it was linked into the existing dir and that
> solves the locking issue for mkdir I think.
>=20
> As you say, rmdir seems the harder problem, but again, is it possible to
> separate the unlink operation from the destruction of the tree by
> keeping the tree, after its been unlinked, until the last userland
> reference has gone away? At least I assume that is why the locking is
> there. I may be a bit off the mark, but it seems like this is quite
> similar to how the VFS does umount, so maybe there are some hints in
> that code which may help us solve this issue?

I second this kind of rework and even think that it is doable. This would a=
void
exposing things to userspace before they are created for sure. I even had to
include dirty hacks in configfs to avoid exposing too much of such temporary
things, and I'm definitely not proud of this.
Unfortunately I don't have time to rework configfs this way at all.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-18453-1229600774-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJSjijVKcRuvQ9Q1QRAiwSAKChGQYBM/fkoT6RiRBccSqi5d5ZmwCgy2lk
kNFhbvq5s1XIGZWutcaFTNc=
=uBWe
-----END PGP SIGNATURE-----

--=_bohort-18453-1229600774-0001-2--
