Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbZLGTh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbZLGTh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 14:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbZLGTh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 14:37:26 -0500
Received: from mail-fx0-f166.google.com ([209.85.220.166]:49852 "EHLO
	mail-fx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbZLGThZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 14:37:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=K+qr9G9iyId7NM+VvfARyZQKFuvLPtrzyDZ7hy14UPhf2lW4up1+PUAMZWriL/FSem
         S8Ifjy5c43aItTh5El0kbjH/SnDnuud6tA4tZxEb6YNohkoRexT+NwXp107JVmgoUCRU
         va/G//mUh+jdU3HjHDlHK1Q3Cd7hGbnLYZjGo=
MIME-Version: 1.0
Date: Mon, 7 Dec 2009 14:37:30 -0500
Message-ID: <fce72f9b0912071137i1f2d7952tf70b83d4ba5686f8@mail.gmail.com>
Subject: [PATCH] driver/input/ff-memless.c
From: Gary Stein <lordcnidarian@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was experiencing force feedback joystick issues in my Force 3D Pro and
when developing a new driver for the new Logitech G940 after I
recompiled my kernel.

I was able to track it down to a signed vs unsigned problem in
ff-memless.c and gcc 4.4.2.
The code in question did not seem to give a problem with gcc 4.2.4.

According to gitweb, a signed vs unsigned was changed on May 8th by
Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Input: ff-memless - fix signed to unsigned bit overflow

to change the gain from a signed to an unsigned int to fix a rumble
issue, but it appears to broke a the
constant force section of the code.

It is a simple, cast to fix and should not have any ill effects.

gary


--- linux-2.6.31.orig/drivers/input/ff-memless.c	2009-09-09
17:13:59.000000000 -0500
+++ linux-2.6.31.int/drivers/input/ff-memless.c	2009-12-07
15:09:22.000000000 -0500
@@ -239,8 +239,8 @@
 		level = fixp_new16(apply_envelope(state,
 					new->u.constant.level,
 					&new->u.constant.envelope));
-		x = fixp_mult(fixp_sin(i), level) * gain / 0xffff;
-		y = fixp_mult(-fixp_cos(i), level) * gain / 0xffff;
+		x = (int)(fixp_mult(fixp_sin(i), level) * gain) / 0xffff;
+		y = (int)(fixp_mult(-fixp_cos(i), level) * gain) / 0xffff;
 		/*
 		 * here we abuse ff_ramp to hold x and y of constant force
 		 * If in future any driver wants something else than x and y
