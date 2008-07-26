Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbYGZEEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbYGZEEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 00:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYGZEEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 00:04:34 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49268 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYGZEEd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 00:04:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Marcel Selhorst <tpm@selhorst.net>,
       Kylene Jo Hall <kjhall@us.ibm.com>, tpmdd-devel@lists.sourceforge.net
Subject: [PATCH] 2.6.26-mmotm tpm-correct-tpm-timeouts-to-jiffies-conversion-d820-fix.patch
In-Reply-To: Your message of "Fri, 25 Jul 2008 18:51:15 PDT."
             <20080725185115.5d1a107d.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080725164614.044a526e.akpm@linux-foundation.org> <50684.1217035060@turing-police.cc.vt.edu>
            <20080725185115.5d1a107d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1217045033_5151P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 26 Jul 2008 00:03:53 -0400
Message-ID: <15114.1217045033@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1217045033_5151P
Content-Type: text/plain; charset=us-ascii

Patch tpm-correct-tpm-timeouts-to-jiffies-conversion reveals a bug in the
Broadcom BCM0102 TPM chipset used in the Dell Latitude D820 - although most of
the timeouts are returned in usecs as per the spec, one is apparently returned
in msecs, which results in a timeout when the code treats it as usecs.  To
prevent a regression, we check for the known too-short value and adjust it to a
value that makes things work.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
cc: Marcin Obara <marcin_obara@users.sourceforge.net>

--- linux-2.6.26-mmotm-0724/drivers/char/tpm/tpm.c.broadcom	2008-07-25 22:13:47.000000000 -0400
+++ linux-2.6.26-mmotm-0724/drivers/char/tpm/tpm.c	2008-07-25 23:30:38.000000000 -0400
@@ -557,6 +557,13 @@ duration:
 	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +
 					    TPM_GET_CAP_RET_UINT32_1_IDX))));
+	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
+	 * value wrong and apparently reports msecs rather than usecs. Test
+	 * for the specific buggy value and adjust it to prevent a regression.
+	 */
+	if (chip->vendor.duration[TPM_SHORT] == 1)
+		chip->vendor.duration[TPM_SHORT] *= 1000;
+
 	chip->vendor.duration[TPM_MEDIUM] =
 	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +


--==_Exmh_1217045033_5151P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIiqIpcC3lWbTT17ARAgTEAKCry4838wyiYEYgBDceUzzxi9bN+gCeLAdb
pdvDEIMIivH6CKobAxw9qlE=
=1wMd
-----END PGP SIGNATURE-----

--==_Exmh_1217045033_5151P--
