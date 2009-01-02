Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbZABKwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbZABKwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZABKwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:52:07 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53284 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZABKwG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:52:06 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: 2.6.28-mmotm1230 - include/media/v4l2-ioctl.h prototype mismatch
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1230893486_3417P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Jan 2009 05:51:26 -0500
Message-ID: <33812.1230893486@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1230893486_3417P
Content-Type: text/plain; charset=us-ascii

I'm seeing the following warning message during a kernel build:

  CC [M]  drivers/media/video/gspca/gspca.o
drivers/media/video/gspca/gspca.c:1811: warning: initialization from incompatible pointer type

The root cause appears to be a missed prototype change in a conversion from
ioctl to unlocked_ioctl - in struct file_operations, the former is an int,
but the latter is a long.  So we clean it up.

I have to admit not having checked deeply for second-order effects, but the
kernel builds without warnings and the result works for me.  The only other
use of __video_ioctl2 I can see is in drivers/media/video/ivtv/ivtv-ioctl.c,
and there it's used as a return value from a function already defined to return
a long, so we save an int->long cast...

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- linux-2.6.28-mmotm1230/include/media/v4l2-ioctl.h.dist	2009-01-01 17:23:00.000000000 -0500
+++ linux-2.6.28-mmotm1230/include/media/v4l2-ioctl.h	2009-01-02 05:40:45.000000000 -0500
@@ -297,7 +297,7 @@ extern int video_usercopy(struct file *f
 /* Standard handlers for V4L ioctl's */
 
 /* This prototype is used on fops.unlocked_ioctl */
-extern int __video_ioctl2(struct file *file,
+extern long __video_ioctl2(struct file *file,
 			unsigned int cmd, unsigned long arg);
 
 /* This prototype is used on fops.ioctl
--- linux-2.6.28-mmotm1230/drivers/media/video/v4l2-ioctl.c.dist	2009-01-01 17:22:50.000000000 -0500
+++ linux-2.6.28-mmotm1230/drivers/media/video/v4l2-ioctl.c	2009-01-02 05:45:39.000000000 -0500
@@ -1852,7 +1852,7 @@ static int __video_do_ioctl(struct file 
 	return ret;
 }
 
-int __video_ioctl2(struct file *file,
+long __video_ioctl2(struct file *file,
 	       unsigned int cmd, unsigned long arg)
 {
 	char	sbuf[128];




--==_Exmh_1230893486_3417P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJXfGucC3lWbTT17ARAqdTAKC+ZPg/BV/b/uQzH7R1Y6pCQA8rTQCghLJA
P8gEdpHZca4bKbOt+eYH/Ck=
=QN9V
-----END PGP SIGNATURE-----

--==_Exmh_1230893486_3417P--
