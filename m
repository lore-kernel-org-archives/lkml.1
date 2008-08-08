Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbYHHK6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbYHHK6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbYHHK6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:58:07 -0400
Received: from msr4.hinet.net ([168.95.4.104]:47948 "EHLO msr4.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212AbYHHK6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:58:06 -0400
X-Greylist: delayed 1296 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2008 06:58:05 EDT
From: Kanru Chen <koster@debian.org.tw>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, Kanru Chen <koster@debian.org.tw>
Subject: [PATCH] tty_io: fix tiocswinsz, tiocgwinsz races.
Date: Fri,  8 Aug 2008 18:36:18 +0800
Message-Id: <1218191778-5781-1-git-send-email-koster@debian.org.tw>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

real_tty may receive SIGWINCH before the new winsize is setted.

Signed-off-by: Kanru Chen <koster@debian.org.tw>
---
 drivers/char/tty_io.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index e1b46bc..63703ea 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2523,6 +2523,8 @@ static int tiocswinsz(struct tty_struct *tty, struct tty_struct *real_tty,
 		return -EFAULT;
 
 	mutex_lock(&tty->termios_mutex);
+	if (real_tty != tty)
+		mutex_lock(&real_tty->termios_mutex);
 	if (!memcmp(&tmp_ws, &tty->winsize, sizeof(*arg)))
 		goto done;
 
@@ -2553,6 +2555,8 @@ static int tiocswinsz(struct tty_struct *tty, struct tty_struct *real_tty,
 	tty->winsize = tmp_ws;
 	real_tty->winsize = tmp_ws;
 done:
+	if (real_tty != tty)
+		mutex_unlock(&real_tty->termios_mutex);
 	mutex_unlock(&tty->termios_mutex);
 	return 0;
 }
-- 
1.5.6.3

