Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbZC1NZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbZC1NZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 09:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbZC1NY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 09:24:27 -0400
Received: from ozlabs.org ([203.10.76.45]:52801 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757515AbZC1NY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 09:24:26 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 28 Mar 2009 23:54:22 +1030
Subject: [PATCH 5/5] uvesafb: improve parameter handling.
Cc: Michal Januszewski <spock@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903282354.22331.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Now module_param(..., invbool, ...) requires a bool, and similarly
   module_param(..., bool, ...) allows it, change pmi_setpal to a bool.
2) #define param_get_scroll to NULL, since it can never be called (perm
   argument to module_param_named is 0).
3) Return -EINVAL from param_set_scroll if the value is bad, so it's
   reported.

Note that I don't think the old fb_get_options() is required for new
drivers: the parameters automatically work as uvesafb.XXX=... anyway.

Cc: Michal Januszewski <spock@gentoo.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/video/uvesafb.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -45,7 +45,7 @@ static int mtrr		__devinitdata = 3; /* e
 static int mtrr		__devinitdata = 3; /* enable mtrr by default */
 static int blank	= 1;		   /* enable blanking by default */
 static int ypan		= 1; 		 /* 0: scroll, 1: ypan, 2: ywrap */
-static int pmi_setpal	__devinitdata = 1; /* use PMI for palette changes */
+static bool pmi_setpal	__devinitdata = true; /* use PMI for palette changes */
 static int nocrtc	__devinitdata; /* ignore CRTC settings */
 static int noedid	__devinitdata; /* don't try DDC transfers */
 static int vram_remap	__devinitdata; /* set amt. of memory to be used */
@@ -2009,11 +2009,7 @@ static void __devexit uvesafb_exit(void)
 
 module_exit(uvesafb_exit);
 
-static int param_get_scroll(char *buffer, struct kernel_param *kp)
-{
-	return 0;
-}
-
+#define param_get_scroll NULL
 static int param_set_scroll(const char *val, struct kernel_param *kp)
 {
 	ypan = 0;
@@ -2024,6 +2020,8 @@ static int param_set_scroll(const char *
 		ypan = 1;
 	else if (!strcmp(val, "ywrap"))
 		ypan = 2;
+	else
+		return -EINVAL;
 
 	return 0;
 }

