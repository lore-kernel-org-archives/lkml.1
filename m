Return-Path: <linux-kernel-owner+w=401wt.eu-S934691AbZLKXbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691AbZLKXbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934631AbZLKXb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:31:28 -0500
Received: from kroah.org ([198.145.64.141]:50537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934485AbZLKX3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:36 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 53/58] tty: moxa: split open lock
Date: Fri, 11 Dec 2009 15:28:37 -0800
Message-Id: <1260574122-10676-53-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

moxa_openlock is used for several situations where we want to handle the
case of an ioctl that crosses many ports (not just the open tty), and also
cases where an open races a deinit (eg a pci unplug) and we hangup a port
before we can cope with that.

The non open race cases can use the moxa_lock spinlock. This simplifies sorting
out the remaining mess.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/moxa.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index d53fac5..63ee3bb 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -163,6 +163,7 @@ static struct mon_str moxaLog;
 static unsigned int moxaFuncTout = HZ / 2;
 static unsigned int moxaLowWaterChk;
 static DEFINE_MUTEX(moxa_openlock);
+static DEFINE_SPINLOCK(moxa_lock);
 /* Variables for insmod */
 #ifdef MODULE
 static unsigned long baseaddr[MAX_BOARDS];
@@ -313,22 +314,20 @@ static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 		struct moxa_port *p;
 		unsigned int i, j;
 
-		mutex_lock(&moxa_openlock);
 		for (i = 0; i < MAX_BOARDS; i++) {
 			p = moxa_boards[i].ports;
 			for (j = 0; j < MAX_PORTS_PER_BOARD; j++, p++, argm++) {
 				memset(&tmp, 0, sizeof(tmp));
+				spin_lock_bh(&moxa_lock);
 				if (moxa_boards[i].ready) {
 					tmp.inq = MoxaPortRxQueue(p);
 					tmp.outq = MoxaPortTxQueue(p);
 				}
-				if (copy_to_user(argm, &tmp, sizeof(tmp))) {
-					mutex_unlock(&moxa_openlock);
+				spin_unlock_bh(&moxa_lock);
+				if (copy_to_user(argm, &tmp, sizeof(tmp)))
 					return -EFAULT;
-				}
 			}
 		}
-		mutex_unlock(&moxa_openlock);
 		break;
 	} case MOXA_GET_OQUEUE:
 		status = MoxaPortTxQueue(ch);
@@ -344,16 +343,20 @@ static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 		struct moxa_port *p;
 		unsigned int i, j;
 
-		mutex_lock(&moxa_openlock);
 		for (i = 0; i < MAX_BOARDS; i++) {
 			p = moxa_boards[i].ports;
 			for (j = 0; j < MAX_PORTS_PER_BOARD; j++, p++, argm++) {
 				struct tty_struct *ttyp;
 				memset(&tmp, 0, sizeof(tmp));
-				if (!moxa_boards[i].ready)
+				spin_lock_bh(&moxa_lock);
+				if (!moxa_boards[i].ready) {
+				        spin_unlock_bh(&moxa_lock);
 					goto copy;
+                                }
 
 				status = MoxaPortLineStatus(p);
+				spin_unlock_bh(&moxa_lock);
+
 				if (status & 1)
 					tmp.cts = 1;
 				if (status & 2)
@@ -368,13 +371,10 @@ static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 					tmp.cflag = ttyp->termios->c_cflag;
 				tty_kref_put(tty);
 copy:
-				if (copy_to_user(argm, &tmp, sizeof(tmp))) {
-					mutex_unlock(&moxa_openlock);
+				if (copy_to_user(argm, &tmp, sizeof(tmp)))
 					return -EFAULT;
-				}
 			}
 		}
-		mutex_unlock(&moxa_openlock);
 		break;
 	}
 	case TIOCGSERIAL:
@@ -427,7 +427,6 @@ static const struct tty_port_operations moxa_port_ops = {
 
 static struct tty_driver *moxaDriver;
 static DEFINE_TIMER(moxaTimer, moxa_poll, 0, 0);
-static DEFINE_SPINLOCK(moxa_lock);
 
 /*
  * HW init
-- 
1.6.5.5

