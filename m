Return-Path: <linux-kernel-owner+w=401wt.eu-S1946359AbXBQBdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946359AbXBQBdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 20:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946362AbXBQBdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 20:33:36 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:42735 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946359AbXBQBdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 20:33:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=sMBndypaMBR/J7nZ5PNKjxwGdxwSIA8TAxlr0YkaeFztpvFKNzt+ajdVFfEgehE64iO2MskPt7CUJZ1lU2P7pzgpy91OLFgblwcjpq6zlAXLsE84D3nvAh+Blfa+56lc;
Message-ID: <45D65B68.7040406@simon.arlott.org.uk>
Date: Sat, 17 Feb 2007 01:33:28 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: CAP_NET_BIND_SERVICE checking in inet_bind vs socket_bind
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig7A9D00014FF94037598CA803"
Reply-To: Simon Arlott <0c1ab235b3b331046f1hiesd0005gitv@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7A9D00014FF94037598CA803
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Why does inet_bind (instead of socket_bind) check that ports below 1024 r=
equire CAP_NET_BIND_SERVICE?
Couldn't this check be moved to the dummy socket_bind so that the behavio=
ur can be changed by a security module?

---

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index cf358c8..d75a2c5 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -431,9 +431,11 @@ int inet_bind(struct socket *sock, struc
 		goto out;
=20
 	snum =3D ntohs(addr->sin_port);
+#ifndef CONFIG_SECURITY_NETWORK
 	err =3D -EACCES;
 	if (snum && snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
 		goto out;
+#endif
=20
 	/*      We keep a pair of addresses. rcv_saddr is the one
 	 *      used by hash lookups, and saddr is used for transmit.
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 3585d8f..768989d 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -262,8 +262,10 @@ int inet6_bind(struct socket *sock, stru
 		return -EINVAL;
=20
 	snum =3D ntohs(addr->sin6_port);
+#ifndef CONFIG_SECURITY_NETWORK
 	if (snum && snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
 		return -EACCES;
+#endif
=20
 	lock_sock(sk);
=20
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
diff --git a/security/dummy.c b/security/dummy.c
index 558795b..1315b19 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -29,6 +29,8 @@ #include <linux/hugetlb.h>
 #include <linux/ptrace.h>
 #include <linux/file.h>
=20
+#include <linux/in.h>
+
 static int dummy_ptrace (struct task_struct *parent, struct task_struct =
*child)
 {
 	return 0;
@@ -718,6 +720,26 @@ static int dummy_socket_post_create (str
 static int dummy_socket_bind (struct socket *sock, struct sockaddr *addr=
ess,
 			      int addrlen)
 {
+	switch (address->sa_family) {
+#ifdef INET
+	case PF_INET: {
+			struct sockaddr_in *addr =3D (struct sockaddr_in *)address;
+			unsigned short snum;
+			snum =3D ntohs((addr->sin_port));
+			if (snum && snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
+				return -EACCES;
+			break;
+		}
+	case PF_INET6: {
+			struct sockaddr_in6 *addr =3D (struct sockaddr_in6 *)address;
+			unsigned short snum;
+			snum =3D ntohs(addr->sin6_port);
+			if (snum && snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
+				return -EACCES;
+			break;
+		}
+#endif
+	}
 	return 0;
 }
=20

--=20
Simon Arlott


--------------enig7A9D00014FF94037598CA803
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRdZbbKRtx1WjQ8ihAQqaEA/9HXDWxUvgRnyN//V/9PMpDhmwm1U+0qxP
s+vDFZh/RLqSvnAc4rkt4NkV5bCFjssIX5fhSCUwd8Q6WON5QCMzGAfB+ZTK/772
cZvelQpnSt0v5NreC/HbMNR21b4BlsyuPd2Kez7OQ+m7f8J+xeA0Dw2yjIAEP5+t
NLEeSRBass5sqmSet/rWPb5Xfyi7gKs00fDIY888ktZDZDjM4Qu1ZReb3so22QAD
1ZlL+wnBVOFdmJylqwSbO2mAHV/50HcBedoGSWsffrMM0Hq3td5B/NCxld8gEeoe
4K2ZHfQ+cq5yqZxTWZzPmt2VVuvgv1SNZG3ObkVTXWQlx+WsI6StMNPKY+q7RmMJ
GxM5PQrUgr/JNWADksCtldT3qADlQkPmnOBXLUPhwJM7U17+PKarHymP4vhN9SAo
E2w446UzsI/411mxy3RYz107iPVi7psFFSDMicOO8mEy0G4roTje+vdFSBF9ArxB
x6cqm9yiH2JdAsTcqhZlFBM+9ZfWi6QfB7BeKtyfuX2jv8abKK3Qt7pztfMfvr7N
1R7ZcxS1YsKFsDd5IW9gWiz76HjgUcAzZtqqiSh3cU9cDC8Jyqa9NxP30PdMDl+D
WvewrtzMhPR+UyniO6ZEDG3SLT0fOLWwIXBhkvSk8jvQJFWZAn3IiaZdOl2xxQQm
z8lMd8FaGbI=
=U4em
-----END PGP SIGNATURE-----

--------------enig7A9D00014FF94037598CA803--
