Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbXKBACQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbXKBACQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 20:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbXKBACB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 20:02:01 -0400
Received: from smtp.rutgers.edu ([128.6.72.243]:34675 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754432AbXKBACA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 20:02:00 -0400
X-Greylist: delayed 1914 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 20:02:00 EDT
From: Michael Wu <flamingice@sourmilk.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: RFC: Reproducible oops with lockdep on count_matching_names()
Date: Thu, 1 Nov 2007 19:26:02 -0400
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org
References: <20071101191716.GA3201@pogo>
In-Reply-To: <20071101191716.GA3201@pogo>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1410679.FUXCYl33qI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711011926.07641.flamingice@sourmilk.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1410679.FUXCYl33qI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 01 November 2007 15:17:16 Luis R. Rodriguez wrote:
> mcgrof@pogo:~/devel/wireless-2.6$ git-describe
> v2.6.24-rc1-146-g2280253
>
> So I hit segfault with lockdep on count_matching_names() on the
> strcmp() multiple times now. This is reproducible and with different
> wireless drivers.
>
I've found the problem. It appears to be in lockdep. struct lock_class has =
a=20
const char *name field which points to a statically allocated string that=20
comes from the code which uses the lock. If that code/string is in a module=
=20
and gets unloaded, the pointer in |name| is no longer valid. Next time this=
=20
field is dereferenced (count_matching_names, in this case), we crash.

The following patch fixes the issue but there's probably a better way.

=2DMichael Wu

=2D--

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 4c4d236..2aa0d35 100644
=2D-- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -114,7 +114,7 @@ struct lock_class {
 	 */
 	unsigned long			ops;
=20
=2D	const char			*name;
+	char				name[128];
 	int				name_version;
=20
 #ifdef CONFIG_LOCK_STAT
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 55fe0c7..63c4d8f 100644
=2D-- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -768,7 +768,7 @@ register_lock_class(struct lockdep_map *lock, unsigned =
int=20
subclass, int force)
 	class =3D lock_classes + nr_lock_classes++;
 	debug_atomic_inc(&nr_unused_locks);
 	class->key =3D key;
=2D	class->name =3D lock->name;
+	strcpy(class->name, lock->name);
 	class->subclass =3D subclass;
 	INIT_LIST_HEAD(&class->lock_entry);
 	INIT_LIST_HEAD(&class->locks_before);

--nextPart1410679.FUXCYl33qI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHKmCPT3Oqt9AH4aERAojZAJ9fZgCMsLbx/nVbSVAAwiDSYyQ6sQCgirAp
8B7fJx4HHkFFWt5QD/zIuDA=
=MGF6
-----END PGP SIGNATURE-----

--nextPart1410679.FUXCYl33qI--
