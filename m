Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbZAZOAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbZAZOAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 09:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZAZOAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 09:00:37 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:59027 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZAZOAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 09:00:35 -0500
Date: Mon, 26 Jan 2009 15:00:32 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joel Becker <Joel.Becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, swhiteho <swhiteho@redhat.com>
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
	configfs_depend_item()
Message-ID: <20090126140032.GE7532@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Joel Becker <Joel.Becker@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
	swhiteho <swhiteho@redhat.com>
References: <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com> <20081217134020.42da55fc.akpm@linux-foundation.org> <1229585208.9487.112.camel@twins> <20081218092744.GB30789@mail.oracle.com> <1229601399.9487.218.camel@twins> <1229603308.9487.227.camel@twins> <20081218225837.GB21870@mail.oracle.com> <1232973009.4863.76.camel@laptop> <20090126132453.GD7532@hawkmoon.kerlabs.com> <1232977283.4863.79.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-9141-1232978271-0001-2"
Content-Disposition: inline
In-Reply-To: <1232977283.4863.79.camel@laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-9141-1232978271-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26/01/09 14:41 +0100, Peter Zijlstra wrote:
> On Mon, 2009-01-26 at 14:24 +0100, Louis Rilling wrote:
>=20
> > However configfs_rmdir() and configfs_mkdir() (recursively) lock inodes=
 because
> > this is how the VFS works when removing/adding entries under a director=
y which
> > has already lived in the dcache.
>=20
> Ok, so then I'm not understanding things correctly.

You may understand the VFS better than I do actually.

>=20
> Its not a locking correctness thing, but simply not being able to do it
> from the vfs calls because those assume locks held?
>=20
> Can't you simply punt the work to a worklet once you've created/removed
> the non-default group, which can be done from within the vfs callback ?

I'm not sure to understand your suggestion. Is this:
1) for mkdir(), create the non-default group, but without its default group=
s,
and defer their creation to a worker which won't have constraints on locks =
held
by any caller;
2) for rmdir(), unlink the non-default group, but without unlinking its def=
ault
groups, and defer the recursive work to a lock-free context?

For mkdir(), this may work. Maybe a bit confusing for userspace, since mkdi=
r(A)
returns as soon as A is created, but A may be populated later and userspace=
 may
rely on A being populated as soon as it is created (current behavior). As a
configfs user, this makes my life harder...

For rmdir(), is this safe to unlink a non-empty directory, and to empty it
afterwards? This looks like going back to the unmount problem.

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-9141-1232978271-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJfcIAVKcRuvQ9Q1QRAmIQAKC7v2UIwltnV0JKt1Hdbz+h3ZEvcwCfV+fh
hPwDJY1JEuCMyWiOXixqUoY=
=SK05
-----END PGP SIGNATURE-----

--=_bohort-9141-1232978271-0001-2--
