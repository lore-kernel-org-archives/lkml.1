Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbYITQ0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbYITQ0D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 12:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbYITQZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 12:25:53 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:43676 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYITQZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 12:25:52 -0400
Message-ID: <48D5240D.7070701@skyrush.com>
Date: Sat, 20 Sep 2008 10:25:49 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix backspace on wrapped lines in console (virtual terminal)
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------020008010103000002070301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020008010103000002070301
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Attached is a patch that fixes virtual terminal problems when backspace
is used on wrapped lines (see patch text for the specific issues).  The
issues can be demonstrated by trying two things in the console (vt):

#1

1) issue the "cat" command
2) type characters until you have wrapped cursor to next line
3) hit backspace (nothing happens visually, but char(s) are erased
   in buf, as seen when enter is hit and line is printed to display)

#2

1) issue the "cat" command
2) type characters until you are at the very end of the line
   (cursor now on last char - i.e. in "need_wrap" state)
3) hit backspace (it moves back and visually erases 2nd to last char,
   but hitting enter shows that last char was actually erased in buffer)

							-Joe

--------------020008010103000002070301
Content-Type: text/plain;
 name="vt-fix-wrapped-backspace.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vt-fix-wrapped-backspace.patch"

Fix backspace in the virtual terminal when line is wrapped:

1) Enable backspace to work when wrapped to next line.

2) Correct backspace behavior when most recently typed
   character is in the rightmost column (i.e. in need_wrap state).

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

--- linux-2.6.27-rc6-git5/drivers/char/vt.c.orig	2008-09-20 09:04:55.000000000 -0600
+++ linux-2.6.27-rc6-git5/drivers/char/vt.c	2008-09-20 09:49:22.000000000 -0600
@@ -1130,12 +1130,36 @@ static inline void cr(struct vc_data *vc
 
 static inline void bs(struct vc_data *vc)
 {
-	if (vc->vc_x) {
-		vc->vc_pos -= 2;
-		vc->vc_x--;
+	if (vc->vc_need_wrap) {
+		/*
+		 * If in need_wrap state, do not move cursor,
+		 * but unset need_wrap.
+		 */
 		vc->vc_need_wrap = 0;
-		notify_write(vc, '\b');
+	} else {
+		if (vc->vc_x == 0) {
+			/*
+			 * If at leftmost column, move cursor to end
+			 * of previous line (only if autowrap is on).
+			 */
+			if (vc->vc_decawm) {
+				vc->vc_x = vc->vc_cols - 1;
+				if (vc->vc_y == vc->vc_top) {
+					scrdown(vc,
+						vc->vc_top, vc->vc_bottom, 1);
+					vc->vc_pos += vc->vc_size_row - 2;
+				} else if (vc->vc_y > 0) {
+					vc->vc_y--;
+					vc->vc_pos -= 2;
+				}
+			}
+		} else {
+			/* Normal case: just move cursor back */
+			vc->vc_x--;
+			vc->vc_pos -= 2;
+		}
 	}
+	notify_write(vc, '\b');
 }
 
 static inline void del(struct vc_data *vc)

--------------020008010103000002070301--
