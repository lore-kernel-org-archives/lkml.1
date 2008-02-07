Return-Path: <linux-kernel-owner+w=401wt.eu-S933620AbYBGTRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620AbYBGTRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762075AbYBGTQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:16:51 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:39240 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762065AbYBGTQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:16:50 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: "Oyvind Aabling" <Oyvind.Aabling@uni-c.dk>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [RFT 9/9] Char: moxa, fix ioctl race
Date: Thu,  7 Feb 2008 20:11:25 +0100
Message-Id: <1202411485-16022-9-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1202411485-16022-1-git-send-email-jirislaby@gmail.com>
References: <1202411485-16022-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lock fixes window between board->ready test and its port access.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/moxa.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index fd9c946..6e170a4 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -299,6 +299,7 @@ static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 		struct moxa_port *p;
 		unsigned int i, j;
 
+		mutex_lock(&moxa_openlock);
 		for (i = 0; i < MAX_BOARDS; i++) {
 			p = moxa_boards[i].ports;
 			for (j = 0; j < MAX_PORTS_PER_BOARD; j++, p++, argm++) {
@@ -307,10 +308,13 @@ static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 					tmp.inq = MoxaPortRxQueue(p);
 					tmp.outq = MoxaPortTxQueue(p);
 				}
-				if (copy_to_user(argm, &tmp, sizeof(tmp)))
+				if (copy_to_user(argm, &tmp, sizeof(tmp))) {
+					mutex_unlock(&moxa_openlock);
 					return -EFAULT;
+				}
 			}
 		}
+		mutex_unlock(&moxa_openlock);
 		return 0;
 	} case MOXA_GET_OQUEUE:
 		status = MoxaPortTxQueue(ch);
@@ -324,6 +328,7 @@ static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 		struct moxa_port *p;
 		unsigned int i, j;
 
+		mutex_lock(&moxa_openlock);
 		for (i = 0; i < MAX_BOARDS; i++) {
 			p = moxa_boards[i].ports;
 			for (j = 0; j < MAX_PORTS_PER_BOARD; j++, p++, argm++) {
@@ -344,10 +349,13 @@ static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 				else
 					tmp.cflag = p->tty->termios->c_cflag;
 copy:
-				if (copy_to_user(argm, &tmp, sizeof(tmp)))
+				if (copy_to_user(argm, &tmp, sizeof(tmp))) {
+					mutex_unlock(&moxa_openlock);
 					return -EFAULT;
+				}
 			}
 		}
+		mutex_unlock(&moxa_openlock);
 		return 0;
 	}
 	case TIOCGSERIAL:
-- 
1.5.3.8

