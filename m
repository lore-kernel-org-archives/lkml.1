Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbXD3LRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbXD3LRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbXD3LRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:17:50 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:49025 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbXD3LRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:17:49 -0400
Message-ID: <4635D01A.40806@web.de>
Date: Mon, 30 Apr 2007 13:16:42 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <ak@suse.de>
Subject: [PATCH] i386: avoid redundant preempt_disable in __unlazy_fpu
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB199D9DB81BCF5426021FFB0"
X-Provags-ID: V01U2FsdGVkX18EM1fBo194x6mtgNda7z42pFcMCHLMG99TOTUr
	kihNuUh79RIwNDVlBidDT2Gz2JrJIgBcgXnSBBKLHM8ZGh4Vgy
	O+mLd8v/s=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB199D9DB81BCF5426021FFB0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

There are two callers of __unlazy_fpu, unlazy_fpu and __switch_to, and
none of them appear to require additional preempt_disable/enable here.
Let's open-code save_init_fpu in __unlazy_fpu to save a few ops.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 include/asm-i386/i387.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6/include/asm-i386/i387.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/include/asm-i386/i387.h
+++ linux-2.6/include/asm-i386/i387.h
@@ -74,11 +74,12 @@ static inline void __save_init_fpu( stru
 	task_thread_info(tsk)->status &=3D ~TS_USEDFPU;
 }
=20
-#define __unlazy_fpu( tsk ) do { \
-	if (task_thread_info(tsk)->status & TS_USEDFPU) \
-		save_init_fpu( tsk ); 			\
-	else						\
-		tsk->fpu_counter =3D 0;			\
+#define __unlazy_fpu( tsk ) do {				\
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {	\
+		__save_init_fpu(tsk);				\
+		stts();						\
+	} else							\
+		tsk->fpu_counter =3D 0;				\
 } while (0)
=20
 #define __clear_fpu( tsk )					\


--------------enigB199D9DB81BCF5426021FFB0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGNdAbniDOoMHTA+kRAmg9AJ9ra0veYkEh6RWVdtTH0BZXUSOe+gCeMROq
y8tNOcJyaeZ5kHfHgdwCJ7U=
=CCWM
-----END PGP SIGNATURE-----

--------------enigB199D9DB81BCF5426021FFB0--
