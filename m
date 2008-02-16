Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYBPOt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYBPOt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 09:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYBPOtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 09:49:45 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:34107 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbYBPOtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 09:49:43 -0500
Date: Sat, 16 Feb 2008 15:49:39 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] : More use DIV_ROUND_UP or roundup
Message-ID: <Pine.LNX.4.58.0802161549110.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/video/atafb.c b/drivers/video/atafb.c
--- a/drivers/video/atafb.c 2007-11-08 18:33:49.000000000 +0100
+++ b/drivers/video/atafb.c 2008-02-15 22:31:30.000000000 +0100
@@ -1270,7 +1270,7 @@ again:

 	gstart = (prescale / 2 + plen * left_margin) / prescale;
 	/* gend1 is for hde (gend-gstart multiple of align), shifter's xres */
-	gend1 = gstart + ((xres + align - 1) / align) * align * plen / prescale;
+	gend1 = gstart + roundup(xres, align) * plen / prescale;
 	/* gend2 is for hbb, visible xres (rest to gend1 is cut off by hblank) */
 	gend2 = gstart + xres * plen / prescale;
 	par->HHT = plen * (left_margin + xres + right_margin) /
diff -u -p a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c 2007-11-08 18:33:49.000000000 +0100
+++ b/drivers/video/cirrusfb.c 2008-02-15 22:31:35.000000000 +0100
@@ -3117,7 +3117,7 @@ static void bestclock(long freq, long *b
 				}
 			}
 		}
-		d = ((143181 * n) + f - 1) / f;
+		d = DIV_ROUND_UP(143181 * n, f);
 		if ((d >= 7) && (d <= 63)) {
 			if (d > 31)
 				d = (d / 2) * 2;
diff -u -p a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c 2008-02-08 08:58:16.000000000 +0100
+++ b/drivers/video/console/fbcon.c 2008-02-15 22:31:36.000000000 +0100
@@ -620,8 +620,7 @@ static void fbcon_prepare_logo(struct vc
 	if (fb_get_color_depth(&info->var, &info->fix) == 1)
 		erase &= ~0x400;
 	logo_height = fb_prepare_logo(info, ops->rotate);
-	logo_lines = (logo_height + vc->vc_font.height - 1) /
-		vc->vc_font.height;
+	logo_lines = DIV_ROUND_UP(logo_height, vc->vc_font.height);
 	q = (unsigned short *) (vc->vc_origin +
 				vc->vc_size_row * rows);
 	step = logo_lines * cols;
diff -u -p a/drivers/video/gxt4500.c b/drivers/video/gxt4500.c
--- a/drivers/video/gxt4500.c 2007-11-08 18:33:50.000000000 +0100
+++ b/drivers/video/gxt4500.c 2008-02-15 22:31:41.000000000 +0100
@@ -238,7 +238,7 @@ static int calc_pll(int period_ps, struc
 	for (pdiv1 = 1; pdiv1 <= 8; ++pdiv1) {
 		for (pdiv2 = 1; pdiv2 <= pdiv1; ++pdiv2) {
 			postdiv = pdiv1 * pdiv2;
-			pll_period = (period_ps + postdiv - 1) / postdiv;
+			pll_period = DIV_ROUND_UP(period_ps, postdiv);
 			/* keep pll in range 350..600 MHz */
 			if (pll_period < 1666 || pll_period > 2857)
 				continue;
