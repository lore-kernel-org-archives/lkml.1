Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbYHON1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbYHON1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYHON1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:27:18 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52611 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677AbYHON1R (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:27:17 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Marcin Obara <marcin_obara@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Marcel Selhorst <tpm@selhorst.net>,
       Kylene Jo Hall <kjhall@us.ibm.com>, tpmdd-devel@lists.sourceforge.net
Subject: [PATCH v2] 2.6.27-rc3-mmotm  tpm-correct-tpm-timeouts-to-jiffies-conversion-d820-fix.patch
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1218794163_6209P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Aug 2008 05:56:03 -0400
Message-ID: <11547.1218794163@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1218794163_6209P
Content-Type: text/plain; charset=us-ascii

Patch tpm-correct-tpm-timeouts-to-jiffies-conversion reveals a bug in the
Broadcom BCM0102 TPM chipset used in the Dell Latitude D820 - although most of
the timeouts are returned in usecs as per the spec, one is apparently returned
in msecs, which results in a too-small value leading to a timeout when the code
treats it as usecs.  To prevent a regression, we check for the known too-short
value and adjust it to a value that makes things work.

Version 2: Clarify comment somewhat, fix if statement to properly deal with
variant HZ values.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
cc: Marcin Obara <marcin_obara@users.sourceforge.net>

Index: linux-2.6.27-rc3-mmotm0814/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.27-rc3-mmotm0814.orig/drivers/char/tpm/tpm.c	2008-08-15 02:19:58.000000000 -0400
+++ linux-2.6.27-rc3-mmotm0814/drivers/char/tpm/tpm.c	2008-08-15 05:44:48.000000000 -0400
@@ -557,6 +557,13 @@
 	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +
 					    TPM_GET_CAP_RET_UINT32_1_IDX))));
+	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
+	 * value wrong and apparently reports msecs rather than usecs. So we
+	 * fix up the resulting too-small TPM_SHORT value to make things work.
+	 */
+	if (chip->vendor.duration[TPM_SHORT] < (HZ/100))
+		chip->vendor.duration[TPM_SHORT] = HZ;
+
 	chip->vendor.duration[TPM_MEDIUM] =
 	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +


--==_Exmh_1218794163_6209P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIpVKzcC3lWbTT17ARAmYzAKD0oQRew4taCDC0SxKzHe+1qLm2wgCghSHz
5mByzJslPQYCV5jlNmt5RYc=
=/YD6
-----END PGP SIGNATURE-----

--==_Exmh_1218794163_6209P--
