Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYEZLyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYEZLyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 07:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbYEZLyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 07:54:14 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:55204 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754341AbYEZLyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 07:54:13 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/1] Char: vt, make sysfs operations atomic
Date: Mon, 26 May 2008 13:53:32 +0200
Message-Id: <1211802812-13658-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hold console sem while creating/destroying sysfs files. Serialisation is
so far done by BKL held in tty release_dev and chrdev_open, but no other
locks are held in open path.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/vt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index fa1ffbf..0043cff 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2746,8 +2746,8 @@ static int con_open(struct tty_struct *tty, struct file *filp)
 				tty->termios->c_iflag |= IUTF8;
 			else
 				tty->termios->c_iflag &= ~IUTF8;
-			release_console_sem();
 			vcs_make_sysfs(tty);
+			release_console_sem();
 			return ret;
 		}
 	}
@@ -2772,8 +2772,8 @@ static void con_close(struct tty_struct *tty, struct file *filp)
 		if (vc)
 			vc->vc_tty = NULL;
 		tty->driver_data = NULL;
-		release_console_sem();
 		vcs_remove_sysfs(tty);
+		release_console_sem();
 		mutex_unlock(&tty_mutex);
 		/*
 		 * tty_mutex is released, but we still hold BKL, so there is
-- 
1.5.4.5

