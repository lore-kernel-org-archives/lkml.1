Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYBYGko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYBYGko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYBYGkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:40:33 -0500
Received: from shadow.wildlava.net ([67.40.138.81]:58404 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbYBYGkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:40:33 -0500
X-Greylist: delayed 690 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2008 01:40:32 EST
Message-ID: <47C2602B.7010108@skyrush.com>
Date: Sun, 24 Feb 2008 23:28:59 -0700
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071127)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       alan@lxorguk.ukuu.org.uk
Subject: [PATCH] Resume TTY on SUSP and fix CRNL order in N_TTY line discipline
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------000401050100080307040606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000401050100080307040606
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Here is a small patch to further refine behavior in n_tty.c.  It
addresses two fine points in how received characters are treated - one
to handle the signal chars in stopped TTYs more consistently, and the
other to make the order of cr/nl translations more logical and
consistent with other Unixes when unusual stty settings are used (e.g.
if someone were to set intr to ^J).

						-Joe

--------------000401050100080307040606
Content-Type: text/plain;
 name="resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipli";
 filename*1="ne.patch"

Refine these behaviors in the N_TTY line discipline:

1) Handle the signal characters consistently when received in
   a stopped TTY so that SUSP (typically ctrl-Z) behaves like
   INTR and QUIT in resuming a stopped TTY.

2) Adjust the order in which the IGNCR/ICRNL/INLCR processing
   is applied to be more logical and consistent with the behavior
   of other Unix systems.

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -puN drivers/char/n_tty.c~resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline	2008-02-24 08:36:24.000000000 -0700
+++ a/drivers/char/n_tty.c	2008-02-24 21:08:15.000000000 -0700
@@ -701,7 +701,7 @@ static inline void n_tty_receive_char(st
 
 	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) &&
 	    ((I_IXANY(tty) && c != START_CHAR(tty) && c != STOP_CHAR(tty)) ||
-	     c == INTR_CHAR(tty) || c == QUIT_CHAR(tty)))
+	     c == INTR_CHAR(tty) || c == QUIT_CHAR(tty) || c == SUSP_CHAR(tty)))
 		start_tty(tty);
 
 	if (tty->closing) {
@@ -739,13 +739,6 @@ static inline void n_tty_receive_char(st
 		return;
 	}
 
-	if (c == '\r') {
-		if (I_IGNCR(tty))
-			return;
-		if (I_ICRNL(tty))
-			c = '\n';
-	} else if (c == '\n' && I_INLCR(tty))
-		c = '\r';
 	if (I_IXON(tty)) {
 		if (c == START_CHAR(tty)) {
 			start_tty(tty);
@@ -756,6 +749,7 @@ static inline void n_tty_receive_char(st
 			return;
 		}
 	}
+
 	if (L_ISIG(tty)) {
 		int signal;
 		signal = SIGINT;
@@ -785,6 +779,15 @@ send_signal:
 			return;
 		}
 	}
+
+	if (c == '\r') {
+		if (I_IGNCR(tty))
+			return;
+		if (I_ICRNL(tty))
+			c = '\n';
+	} else if (c == '\n' && I_INLCR(tty))
+		c = '\r';
+
 	if (tty->icanon) {
 		if (c == ERASE_CHAR(tty) || c == KILL_CHAR(tty) ||
 		    (c == WERASE_CHAR(tty) && L_IEXTEN(tty))) {

--------------000401050100080307040606--
