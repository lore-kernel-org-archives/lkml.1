Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbYFRGHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbYFRGHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 02:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758356AbYFRGG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 02:06:56 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47082 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757524AbYFRGGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 02:06:55 -0400
Date: Tue, 17 Jun 2008 23:06:51 -0700
From: Eric B Munson <ebmunson@us.ibm.com>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] Keep 3 high personality bytes across exec
Message-ID: <20080618060651.GA8251@us.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Currently when a 32 bit process is exec'd on a powerpc 64 bit host the valu=
es
of the top three bytes of the personality are clobbered.  This patch adds a
check in the SET_PERSONALITY macro that will carry all the values in the top
three bytes across the exec.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>

---

Based on 2.6.26-rc6

 include/asm-powerpc/elf.h   |    3 ++-
 include/linux/personality.h |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/asm-powerpc/elf.h b/include/asm-powerpc/elf.h
index 9080d85..2f11a0e 100644
--- a/include/asm-powerpc/elf.h
+++ b/include/asm-powerpc/elf.h
@@ -257,7 +257,8 @@ do {								\
 	else							\
 		clear_thread_flag(TIF_ABI_PENDING);		\
 	if (personality(current->personality) !=3D PER_LINUX32)	\
-		set_personality(PER_LINUX);			\
+		set_personality(PER_LINUX |			\
+			(current->personality & PER_INHERIT));	\
 } while (0)
 /*
  * An executable for which elf_read_implies_exec() returns TRUE will
diff --git a/include/linux/personality.h b/include/linux/personality.h
index a84e9ff..362eb90 100644
--- a/include/linux/personality.h
+++ b/include/linux/personality.h
@@ -36,6 +36,12 @@ enum {
 	ADDR_LIMIT_3GB =3D 	0x8000000,
 };
=20
+/* Mask for the above personality values */
+#define PER_INHERIT (ADDR_NO_RANDOMIZE|FDPIC_FUNCPTRS|MMAP_PAGE_ZERO| \
+			ADDR_COMPAT_LAYOUT|READ_IMPLIES_EXEC|ADDR_LIMIT_32BIT| \
+			SHORT_INODE|WHOLE_SECONDS|STICKY_TIMEOUTS| \
+			ADDR_LIMIT_3GB)
+
 /*
  * Security-relevant compatibility flags that must be
  * cleared upon setuid or setgid exec:


--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIWKX7snv9E83jkzoRAi9lAKDZZre2ksNhC3llJrNF7vzLVJFXNwCgo2k/
NNHS5lCbE/ZKJtm3UfjS1do=
=wIy8
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
