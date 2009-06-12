Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbZFLIAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbZFLIAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932762AbZFLIAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:00:40 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:42923 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbZFLIAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:00:39 -0400
Date: Fri, 12 Jun 2009 09:59:52 +0200
From: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
To: Christian Kujau <lists@nerdbynature.de>, Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       nico-linuxsetlocalversion@schottelius.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/setlocalversion on readonly source
Message-ID: <20090612075952.GA22436@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>,
	Christian Kujau <lists@nerdbynature.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20090611153332.d168e58e.akpm@linux-foundation.org> <20090612043922.GA13001@uranus.ravnborg.org> <alpine.DEB.2.01.0906091323520.6439@bogon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20090612043922.GA13001@uranus.ravnborg.org> <alpine.DEB.2.01.0906091323520.6439@bogon>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc5-next-20090515-05297-g9bbe396 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello everybody,

Christian Kujau [Tue, Jun 09, 2009 at 01:30:18PM -0700]:
> [...]=20
>   + git update-index --refresh --unmerged
>   fatal: Unable to create '.git/index.lock': Read-only file system
>=20
> [...] throw this error [...] takes quite a long time to run,=20
> [...] on a read-only NFS mount.

Agreed, one can spent time better.

But

> The following patch makes the error go away:
> [...]=20
> +	touch . 2>/dev/null && git update-index --refresh --unmerged > /dev/null

changing stuff (mtime here) where it is not necessary is maybe not
the best thing todo. I suggest instead checking for a writable directory
(which is what you want todo anyway):

[ -w . ] && git update-index --refresh --unmerged > /dev/null

Full patch including comment cleanup is attached below.

Sincerly,

Nico


Do not update index on read only media.
Idea published by Christian Kujau <lists@nerdbynature.de>.

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 0079047..46989b8 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -39,8 +39,10 @@ if head=3D`git rev-parse --verify --short HEAD 2>/dev/nu=
ll`; then
 	        printf -- '-svn%s' "`git svn find-rev $head`"
 	fi
=20
-	# Are there uncommitted changes?
-	git update-index --refresh --unmerged > /dev/null
+	# Update index only on r/w media
+	[ -w . ] && git update-index --refresh --unmerged > /dev/null
+
+	# Check for uncommitted changes
 	if git diff-index --name-only HEAD | grep -v "^scripts/package" \
 	    | read dummy; then
 		printf '%s' -dirty

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoyCvgACgkQuL75KpiFGIzpdACgzScrN48jGhpuhFZuGBz4Fcgp
a+MAnirAJfVColvkNsTSzwyhsGf63LWU
=xFY/
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
