Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYEJIRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYEJIRq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 04:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYEJIRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 04:17:35 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48510 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYEJIRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 04:17:33 -0400
Date: Sat, 10 May 2008 10:17:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: vt/fbcon: fix background color on line feed
Message-ID: <alpine.LNX.1.10.0805101015110.19952@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 181afd9c4e2168f59761fd3d153b46a0c32810a3
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat May 10 10:16:56 2008 +0200

vt/fbcon: fix background color on line feed

Addendum to commit c9e587ab.
fbcon still was not doing the right thing (read: continued to do old
behavior). fbcon_clear() seems to clear the new line (e.g. where your
new prompt appears after doing echo -en "\e[42mfoo\n"), while
scr_memsetw clears the previous one only (where "foo" appears). So
just temporarily set the video_erase_char to the scrl_erase_char so
that fbcon_clear does the right thing.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 drivers/video/console/fbcon.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 774f803..c77c2fd 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1854,6 +1854,8 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
 	struct display *p = &fb_display[vc->vc_num];
 	int scroll_partial = info->flags & FBINFO_PARTIAL_PAN_OK;
+	unsigned short saved_ec;
+	int ret;
 
 	if (fbcon_is_inactive(vc, info))
 		return -EINVAL;
@@ -1866,6 +1868,11 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 	 *           whole screen (prevents flicker).
 	 */
 
+	saved_ec = vc->vc_video_erase_char;
+	vc->vc_video_erase_char = vc->vc_scrl_erase_char;
+
+	ret = 0;
+
 	switch (dir) {
 	case SM_UP:
 		if (count > vc->vc_rows)	/* Maximum realistic size */
@@ -1884,7 +1891,7 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 							(b - count)),
 				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
-			return 1;
+			ret = 1;
 			break;
 
 		case SCROLL_WRAP_MOVE:
@@ -1956,7 +1963,8 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 							(b - count)),
 				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
-			return 1;
+			ret = 1;
+			break;
 		}
 		break;
 
@@ -1975,7 +1983,7 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 							t),
 				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
-			return 1;
+			ret = 1;
 			break;
 
 		case SCROLL_WRAP_MOVE:
@@ -2045,10 +2053,13 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 							t),
 				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
-			return 1;
+			ret = 1;
+			break;
 		}
+		break;
 	}
-	return 0;
+	vc->vc_video_erase_char = saved_ec;
+	return ret;
 }
 
 
