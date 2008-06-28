Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbYF1AIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbYF1AIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 20:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbYF1AIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 20:08:42 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54357 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbYF1AIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 20:08:41 -0400
Date: Fri, 27 Jun 2008 17:08:13 -0700
From: Eric B Munson <ebmunson@us.ibm.com>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V2] Keep 3 high personality bytes across exec
Message-ID: <20080628000813.GA19960@us.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Currently when a 32 bit process is exec'd on a powerpc 64 bit host the value
in the top three bytes of the personality is clobbered.  This patch adds a
check in the SET_PERSONALITY macro that will carry all the values in the top
three bytes across the exec.

These three bytes currently carry flags to disable address randomisation,
limit the address space, force zeroing of an mmapped page, etc.  Should an
application set any of these bits they will be maintained and honoured on
homogeneous environment but discarded and ignored on a heterogeneous
environment.  So if an application requires all mmapped pages to be initial=
ised
to zero and a wrapper is used to setup the personality and exec the target,
these flags will remain set on an all 32 or all 64 bit envrionment, but they
will be lost in the exec on a mixed 32/64 bit environment.  Losing these bi=
ts
means that the same application would behave differently in different
environments.  Tested on a POWER5+ machine with 64bit kernel and a mixed
64/32 bit user space.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>

---
V2

Changes from V1:
Updated changelog with a better description of why this change is useful

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


--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIZYDtsnv9E83jkzoRAu98AKDB62YlUFX951qoC8PItG1iOu0akACgijgX
5HmGq6MTB19tIiQGbCJOfjU=
=BpRd
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
