Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbYLINPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbYLINPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 08:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYLINPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 08:15:36 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:63796 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751914AbYLINPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 08:15:35 -0500
Date: Tue, 9 Dec 2008 14:15:33 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Debian GNU/Linux PPC <debian-powerpc@lists.debian.org>
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fbdev/logo: Check compatibility of main and extra logos
Message-ID: <Pine.LNX.4.64.0812091413200.30985@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [PATCH] fbdev/logo: Check compatibility of main and extra logos

The code to draw penguin logos always uses some properties of the main logo.
This is incorrect if additional logos (CONFIG_FB_LOGO_EXTRA=y) have different
types than the main logo, which causes corrupted logo images.

http://bugzilla.kernel.org/show_bug.cgi?id=12181

Hence skip additional logos that are not compatible with the main logo.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
Technically, it's possible to draw multiple logos of different types on
truecolor displays, but this would complicate the (already quite complicated)
logo drawing code even more.

This patch fixes a problem with Debian's linux-image-2.6.26-1-powerpc64
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=508173

 drivers/video/fbmem.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -510,6 +510,10 @@ static int fb_prepare_extra_logos(struct
 		fb_logo_ex_num = 0;
 
 	for (i = 0; i < fb_logo_ex_num; i++) {
+		if (fb_logo_ex[i].logo->type != fb_logo.logo->type) {
+			fb_logo_ex[i].logo = NULL;
+			continue;
+		}
 		height += fb_logo_ex[i].logo->height;
 		if (height > yres) {
 			height -= fb_logo_ex[i].logo->height;

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
