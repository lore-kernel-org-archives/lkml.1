Return-Path: <linux-kernel-owner+w=401wt.eu-S1765622AbYJMKCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765622AbYJMKCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762957AbYJMJos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:44:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51034 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762949AbYJMJoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:44:46 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 72/80] tty: fix up gigaset a bit
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:44:43 +0100
Message-ID: <20081013094438.21645.30934.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Stephen's fixes reminded me that gigaset is still rather broken so fix it up
a bit

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/isdn/gigaset/ser-gigaset.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)


diff --git a/drivers/isdn/gigaset/ser-gigaset.c b/drivers/isdn/gigaset/ser-gigaset.c
index cc4f4e4..07052ed 100644
--- a/drivers/isdn/gigaset/ser-gigaset.c
+++ b/drivers/isdn/gigaset/ser-gigaset.c
@@ -571,6 +571,7 @@ gigaset_tty_close(struct tty_struct *tty)
 	}
 
 	/* prevent other callers from entering ldisc methods */
+	/* FIXME: should use the tty state flags */
 	tty->disc_data = NULL;
 
 	if (!cs->hw.ser)
@@ -642,10 +643,11 @@ gigaset_tty_ioctl(struct tty_struct *tty, struct file *file,
 		return -ENXIO;
 
 	switch (cmd) {
-	case TCGETS:
-	case TCGETA:
-		/* pass through to underlying serial device */
-		rc = n_tty_ioctl_helper(tty, file, cmd, arg);
+
+	case FIONREAD:
+		/* unused, always return zero */
+		val = 0;
+		rc = put_user(val, p);
 		break;
 
 	case TCFLSH:
@@ -659,20 +661,13 @@ gigaset_tty_ioctl(struct tty_struct *tty, struct file *file,
 			flush_send_queue(cs);
 			break;
 		}
-		/* flush the serial port's buffer */
-		rc = n_tty_ioctl_helper(tty, file, cmd, arg);
-		break;
-
-	case FIONREAD:
-		/* unused, always return zero */
-		val = 0;
-		rc = put_user(val, p);
-		break;
+		/* Pass through */
 
 	default:
-		rc = -ENOIOCTLCMD;
+		/* pass through to underlying serial device */
+		rc = n_tty_ioctl_helper(tty, file, cmd, arg);
+		break;
 	}
-
 	cs_put(cs);
 	return rc;
 }
@@ -680,6 +675,8 @@ gigaset_tty_ioctl(struct tty_struct *tty, struct file *file,
 /*
  * Poll on the tty.
  * Unused, always return zero.
+ *
+ * FIXME: should probably return an exception - especially on hangup
  */
 static unsigned int
 gigaset_tty_poll(struct tty_struct *tty, struct file *file, poll_table *wait)

