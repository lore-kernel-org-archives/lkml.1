Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZKROdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZKROdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbZKROdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:33:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40627 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757206AbZKROde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:33:34 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 12/12] moxa: split open lock
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:17:10 +0000
Message-ID: <20091118141700.3346.53298.stgit@localhost.localdomain>
In-Reply-To: <20091118141354.3346.16910.stgit@localhost.localdomain>
References: <20091118141354.3346.16910.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

moxa_openlock is used for several situations where we want to handle the
case of an ioctl that crosses many ports (not just the open tty), and also
cases where an open races a deinit (eg a pci unplug) and we hangup a port
before we can cope with that.

The non open race cases can use the moxa_lock spinlock. This simplifies sorting
out the remaining mess.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/moxa.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)


diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index f8e673a..16b8aed 100644
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

