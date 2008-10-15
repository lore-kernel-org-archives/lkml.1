Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYJOMdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYJOMdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 08:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYJOMde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 08:33:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:59761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbYJOMdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 08:33:33 -0400
Date: Wed, 15 Oct 2008 11:27:36 +0200
From: Kurt Garloff <garloff@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nick Piggin <NPiggin@suse.de>
Subject: [PATCH 1/1] default mlock limit 32k->64k
Message-ID: <20081015092736.GZ5286@tpkurt2.garloff.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wUMz9o/vfMbinXcu"
Content-Disposition: inline
X-Operating-System: Linux 2.6.25.16-0.1-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
Organization: SUSE Linux Products GmbH (a Novell company), Nuernberg, GF:
	Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wUMz9o/vfMbinXcu
Content-Type: multipart/mixed; boundary="8ZMYqwT4qqBjIaog"
Content-Disposition: inline


--8ZMYqwT4qqBjIaog
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

normal users can mlock memory up to the value defined in RLIMIT_MLOCK.
The number used to 0 for a long time and has been changed to 8 pages
(32k on 4k page systems) a number of years ago to accommodate the needs
of gpg, which is one of the few programs that a normal user runs and
which needs mlock (to prevent passphrase and key from leaking into
swap).=20

Nowadays, we have gpg2, and the need has increased to 64k.
Attached patch does change the default to 64k, independent of the
PAGE_SIZE. (Unless PAGE_SIZE is larger than 64k, then we allow one
page.)

Please apply.
--=20
Kurt Garloff, VP Business Development -- OPS, Novell Inc.

--8ZMYqwT4qqBjIaog
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="rlimit-memlock-64k.patch"
Content-Transfer-Encoding: quoted-printable

=46rom: Kurt Garloff <garloff@suse.de>
Subject: Increase default RLIMIT_MEMLOCK to 64k
References: bnc#329675
Patch-Mainline: no (should be submitted)

By default, non-privileged tasks can only mlock() a small amount of
memory to avoid a DoS attack by ordinary users. The Linux kernel
defaulted to 32k (on a 4k page size system) to accommodate the
needs of gpg.
However, newer gpg2 needs 64k in various circumstances and otherwise
fails miserably, see bnc#329675.

Change the default to 64k, and make it more agnostic to PAGE_SIZE.

Signed-off-by: Kurt Garloff <garloff@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6.27/include/linux/resource.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27.orig/include/linux/resource.h
+++ linux-2.6.27/include/linux/resource.h
@@ -59,10 +59,10 @@ struct rlimit {
 #define _STK_LIM	(8*1024*1024)
=20
 /*
- * GPG wants 32kB of mlocked memory, to make sure pass phrases
+ * GPG2 wants 64kB of mlocked memory, to make sure pass phrases
  * and other sensitive information are never written to disk.
  */
-#define MLOCK_LIMIT	(8 * PAGE_SIZE)
+#define MLOCK_LIMIT	((PAGE_SIZE > 64*1024) ? PAGE_SIZE : 64*1024)
=20
 /*
  * Due to binary compatibility, the actual resource numbers

--8ZMYqwT4qqBjIaog--

--wUMz9o/vfMbinXcu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQFI9beIxmLh6hyYd04RAmJWAKCo5TALOE1yqX2TQLJgjLA1o8ZFwgCgtc/T
4D8IZRJSwHza+1UGNNdG7bQ=
=R4xw
-----END PGP SIGNATURE-----

--wUMz9o/vfMbinXcu--
