Return-Path: <linux-kernel-owner+w=401wt.eu-S1765255AbYBZUny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765255AbYBZUny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762065AbYBZUnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:43:42 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:57018 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758598AbYBZUnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:43:40 -0500
Date: Tue, 26 Feb 2008 21:43:29 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/9] drivers/isdn: Correct use of ! and &
Message-ID: <Pine.LNX.4.64.0802262143050.18200@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/isdn/i4l/isdn_ttyfax.c   |    3 ++-
 drivers/isdn/isdnloop/isdnloop.c |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)
 2 files changed, 4 insertions(+), 4 deletions(-)
=================================================
diff -u -p a/drivers/isdn/i4l/isdn_ttyfax.c b/drivers/isdn/i4l/isdn_ttyfax.c
--- a/drivers/isdn/i4l/isdn_ttyfax.c 2008-02-10 22:34:07.000000000 +0100
+++ b/drivers/isdn/i4l/isdn_ttyfax.c 2008-02-26 08:04:25.000000000 +0100
@@ -906,7 +906,8 @@ isdn_tty_cmd_FCLASS2(char **p, modem_inf
 			sprintf(rs, "\r\n0-2");
 			isdn_tty_at_cout(rs, info);
 		} else {
-			if ((f->phase != ISDN_FAX_PHASE_D) || (!info->faxonline & 1))
+			if ((f->phase != ISDN_FAX_PHASE_D) ||
+			    (!(info->faxonline & 1)))
 				PARSE_ERROR1;
 			par = isdn_getnum(p);
 			if ((par < 0) || (par > 2))
diff -u -p a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
--- a/drivers/isdn/isdnloop/isdnloop.c 2008-02-10 22:34:07.000000000 +0100
+++ b/drivers/isdn/isdnloop/isdnloop.c 2008-02-26 08:04:26.000000000 +0100
@@ -1289,7 +1289,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop
 				}
 				break;
 		case ISDN_CMD_CLREAZ:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				if (card->leased)
 					break;
@@ -1333,7 +1333,7 @@ isdnloop_command(isdn_ctrl * c, isdnloop
 				}
 				break;
 		case ISDN_CMD_SETL3:
-				if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+				if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 					return -ENODEV;
 				return 0;
 		default:
@@ -1380,7 +1380,7 @@ if_writecmd(const u_char __user *buf, in
 	isdnloop_card *card = isdnloop_findcard(id);
 
 	if (card) {
-		if (!card->flags & ISDNLOOP_FLAGS_RUNNING)
+		if (!(card->flags & ISDNLOOP_FLAGS_RUNNING))
 			return -ENODEV;
 		return (isdnloop_writecmd(buf, len, 1, card));
 	}
