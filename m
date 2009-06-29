Return-Path: <linux-kernel-owner+w=401wt.eu-S1759096AbZF2Ndb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096AbZF2Ndb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZF2NdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:33:24 -0400
Received: from recombinator.qemfd.net ([216.27.165.184]:51797 "EHLO qemfd.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752582AbZF2NdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:33:23 -0400
Date: Mon, 29 Jun 2009 09:33:26 -0400
From: nick black <dank@qemfd.net>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       man-pages <mtk.manpages@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] janitorial/manpages: kill off duplication of constants
Message-ID: <20090629133326.GA3149@qemfd.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Seize back constants duplicated in smack_lsm.c, exporting them via
linux/magic.h. The removals expose no new interfaces, but moving
SOCKFD_MAGIC and DEVPTS_SUPER_MAGIC to magic.h does expose to userspace what
had not been previously exposed; I'm not sure this is desirable. If it is,
the statfs(2) man page ought probably be updated to reflect the change. If
not, #ifdef __KERNEL__ wrappers would work, but that might not be the best
choice.

Either way, the statfs(2) page references a DEVFS_SUPER_MAGIC [shudder],
which was, if memory serves, unceremoniously purged some time ago? There's
no instance of DEVFS_SUPER_MAGIC in 2.6.31-rc1. I'd be happy to send man
page patches in if that's desirable.

This is against 2.6.31-rc1. Thanks for feedback, Pekka Enberg!

--rigorously, nick

Signed-off-by: Nick Black <dank@qemfd.net>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31=
-rc1-pristine/fs/devpts/inode.c linux-2.6.31-rc1/fs/devpts/inode.c
--- linux-2.6.31-rc1-pristine/fs/devpts/inode.c	2009-06-24 19:25:37.0000000=
00 -0400
+++ linux-2.6.31-rc1/fs/devpts/inode.c	2009-06-29 08:56:14.000000000 -0400
@@ -18,14 +18,13 @@
 #include <linux/mount.h>
 #include <linux/tty.h>
 #include <linux/mutex.h>
+#include <linux/magic.h>
 #include <linux/idr.h>
 #include <linux/devpts_fs.h>
 #include <linux/parser.h>
 #include <linux/fsnotify.h>
 #include <linux/seq_file.h>
=20
-#define DEVPTS_SUPER_MAGIC 0x1cd1
-
 #define DEVPTS_DEFAULT_MODE 0600
 /*
  * ptmx is a new node in /dev/pts and will be unused in legacy (single-
diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31=
-rc1-pristine/include/linux/magic.h linux-2.6.31-rc1/include/linux/magic.h
--- linux-2.6.31-rc1-pristine/include/linux/magic.h	2009-06-24 19:25:37.000=
000000 -0400
+++ linux-2.6.31-rc1/include/linux/magic.h	2009-06-29 08:55:57.000000000 -0=
400
@@ -53,4 +54,8 @@
 #define INOTIFYFS_SUPER_MAGIC	0x2BAD1DEA
=20
 #define STACK_END_MAGIC		0x57AC6E9D
+
+#define DEVPTS_SUPER_MAGIC	0x1cd1
+#define SOCKFS_MAGIC		0x534F434B
+
 #endif /* __LINUX_MAGIC_H__ */
diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31=
-rc1-pristine/net/socket.c linux-2.6.31-rc1/net/socket.c
--- linux-2.6.31-rc1-pristine/net/socket.c	2009-06-24 19:25:37.000000000 -0=
400
+++ linux-2.6.31-rc1/net/socket.c	2009-06-29 08:55:49.000000000 -0400
@@ -86,6 +86,7 @@
 #include <linux/audit.h>
 #include <linux/wireless.h>
 #include <linux/nsproxy.h>
+#include <linux/magic.h>
=20
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -235,8 +236,6 @@ int move_addr_to_user(struct sockaddr *k
 	return __put_user(klen, ulen);
 }
=20
-#define SOCKFS_MAGIC 0x534F434B
-
 static struct kmem_cache *sock_inode_cachep __read_mostly;
=20
 static struct inode *sock_alloc_inode(struct super_block *sb)
diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31=
-rc1-pristine/security/smack/smack_lsm.c linux-2.6.31-rc1/security/smack/sm=
ack_lsm.c
--- linux-2.6.31-rc1-pristine/security/smack/smack_lsm.c	2009-06-24 19:25:3=
7.000000000 -0400
+++ linux-2.6.31-rc1/security/smack/smack_lsm.c	2009-06-29 08:54:50.0000000=
00 -0400
@@ -30,17 +30,11 @@
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
 #include <linux/audit.h>
+#include <linux/magic.h>
 #include "smack.h"
=20
 #define task_security(task)	(task_cred_xxx((task), security))
=20
-/*
- * I hope these are the hokeyist lines of code in the module. Casey.
- */
-#define DEVPTS_SUPER_MAGIC	0x1cd1
-#define SOCKFS_MAGIC		0x534F434B
-#define TMPFS_MAGIC		0x01021994
-
 /**
  * smk_fetch - Fetch the smack label from a file.
  * @ip: a pointer to the inode

--=20
                                      Nick Black <dankamongmen@acm.org>
                                             Principal Engineer, McAfee
                                  Grad student, GT College of Computing
                    "np: the class of dashed hopes, and idle dreams..."

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpIwqYACgkQzjCRTpolKGvjcACgoAY0UxJ7N0BKDuIMeiZmFLBU
qH4AoKShOQkWSKfb4LpOwFNyNnM/gkkK
=Aq9F
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
