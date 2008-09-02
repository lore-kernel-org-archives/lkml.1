Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbYIBLGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbYIBLGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 07:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYIBLGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 07:06:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:15604 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYIBLGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 07:06:32 -0400
Date: Tue, 2 Sep 2008 14:06:52 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Richard Henderson <rth@twiddle.net>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] Allow recursion in binfmt_script and binfmt_misc
Message-ID: <20080902110648.GA5027@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

binfmt_script and binfmt_misc disallow recursion to avoid stack overflow
using sh_bang and misc_bang. It causes problem in some cases:

$ echo '#!/bin/ls' > /tmp/t0
$ echo '#!/tmp/t0' > /tmp/t1
$ echo '#!/tmp/t1' > /tmp/t2
$ chmod +x /tmp/t*
$ /tmp/t2
zsh: exec format error: /tmp/t2

Similar problem with binfmt_misc.=20

I propose allow recursion, but limit its deep.

There is one more problem: on Alpha sh_bang used to remember if the=20
application is TASO. I have no experience with Alpha. Is it possible to
use separate flag in struct linux_binprm for it?

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

diff --git a/fs/binfmt_em86.c b/fs/binfmt_em86.c
index f9c88d0..f95ae97 100644
--- a/fs/binfmt_em86.c
+++ b/fs/binfmt_em86.c
@@ -43,7 +43,7 @@ static int load_em86(struct linux_binprm *bprm,struct pt_=
regs *regs)
 			return -ENOEXEC;
 	}
=20
-	bprm->sh_bang =3D 1;	/* Well, the bang-shell is implicit... */
+	bprm->sh_bang++;	/* Well, the bang-shell is implicit... */
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file =3D NULL;
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 8d7e88e..50c665f 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -43,6 +43,8 @@ enum {Enabled, Magic};
 #define MISC_FMT_OPEN_BINARY (1<<30)
 #define MISC_FMT_CREDENTIALS (1<<29)
=20
+#define MISC_FMT_MAX_RECURSION 4
+
 typedef struct {
 	struct list_head list;
 	unsigned long flags;		/* type, status, etc. */
@@ -117,7 +119,7 @@ static int load_misc_binary(struct linux_binprm *bprm, =
struct pt_regs *regs)
 		goto _ret;
=20
 	retval =3D -ENOEXEC;
-	if (bprm->misc_bang)
+	if (bprm->misc_bang >=3D MISC_FMT_MAX_RECURSION)
 		goto _ret;
=20
 	/* to keep locking time low, we copy the interpreter string */
@@ -197,7 +199,7 @@ static int load_misc_binary(struct linux_binprm *bprm, =
struct pt_regs *regs)
 	if (retval < 0)
 		goto _error;
=20
-	bprm->misc_bang =3D 1;
+	bprm->misc_bang++;
=20
 	retval =3D search_binary_handler (bprm, regs);
 	if (retval < 0)
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 9e3963f..172c954 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -15,6 +15,8 @@
 #include <linux/err.h>
 #include <linux/fs.h>
=20
+#define SCRIPT_FMT_MAX_RECURSION 4
+
 static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 {
 	char *cp, *i_name, *i_arg;
@@ -22,14 +24,15 @@ static int load_script(struct linux_binprm *bprm,struct=
 pt_regs *regs)
 	char interp[BINPRM_BUF_SIZE];
 	int retval;
=20
-	if ((bprm->buf[0] !=3D '#') || (bprm->buf[1] !=3D '!') || (bprm->sh_bang)=
)=20
+	if ((bprm->buf[0] !=3D '#') || (bprm->buf[1] !=3D '!') ||
+	    (bprm->sh_bang >=3D SCRIPT_FMT_MAX_RECURSION))
 		return -ENOEXEC;
 	/*
 	 * This section does the #! interpretation.
 	 * Sorta complicated, but hopefully it will work.  -TYT
 	 */
=20
-	bprm->sh_bang =3D 1;
+	bprm->sh_bang++;
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file =3D NULL;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 826f623..1e21ff0 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -34,8 +34,8 @@ struct linux_binprm{
 #endif
 	struct mm_struct *mm;
 	unsigned long p; /* current top of mem */
-	unsigned int sh_bang:1,
-		     misc_bang:1;
+	unsigned char sh_bang;
+	unsigned char misc_bang;
 	struct file * file;
 	int e_uid, e_gid;
 	kernel_cap_t cap_post_exec_permitted;

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAki9HkgACgkQbWYnhzC5v6pcOwCfbWJchM7L5Ds7DybEpe2U6C1W
j3UAmwSbgBviyiEGSZKqdjaaCuGoiwqw
=sA+S
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
