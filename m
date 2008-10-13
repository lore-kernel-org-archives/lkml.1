Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbYJMJyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbYJMJyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761390AbYJMJl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:41:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50983 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758763AbYJMJlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:41:55 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 55/80] tty: Move parts of tty_init_dev into new functions
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:41:51 +0100
Message-ID: <20081013094147.21645.83999.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Move the 'find-tty' and 'fast-track-open' parts of init_dev() to
separate functions.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |  139 +++++++++++++++++++++++++++++++------------------
 1 files changed, 87 insertions(+), 52 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index fdcc43c..a540849 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1204,6 +1204,80 @@ static void tty_line_name(struct tty_driver *driver, int index, char *p)
 	sprintf(p, "%s%d", driver->name, index + driver->name_base);
 }
 
+/*
+ * 	find_tty() - find an existing tty, if any
+ * 	@driver: the driver for the tty
+ * 	@idx:	 the minor number
+ *
+ * 	Return the tty, if found or ERR_PTR() otherwise.
+ *
+ * 	Locking: tty_mutex must be held. If tty is found, the mutex must
+ * 		 be held until the 'fast-open' is also done.
+ */
+struct tty_struct *find_tty(struct tty_driver *driver, int idx)
+{
+	struct tty_struct *tty;
+
+	/* check whether we're reopening an existing tty */
+	if (driver->flags & TTY_DRIVER_DEVPTS_MEM) {
+		tty = devpts_get_tty(idx);
+		/*
+		 * If we don't have a tty here on a slave open, it's because
+		 * the master already started the close process and there's
+		 * no relation between devpts file and tty anymore.
+		 */
+		if (!tty && driver->subtype == PTY_TYPE_SLAVE)
+			return ERR_PTR(-EIO);
+
+		/*
+		 * tty is safe on because we are called with tty_mutex held
+		 * and release_dev() won't change tty->count or tty->flags
+		 * without grabbing tty_mutex.
+		 */
+		if (tty && driver->subtype == PTY_TYPE_MASTER)
+			tty = tty->link;
+	} else
+		tty = driver->ttys[idx];
+	return tty;
+}
+
+/*
+ * 	fast_tty_open()	- fast re-open of an open tty
+ * 	@tty	- the tty to open
+ *
+ * 	Return 0 on success, -errno on error.
+ *
+ * 	Locking: tty_mutex must be held from the time the tty was found
+ * 		 till this open completes.
+ */
+static int fast_tty_open(struct tty_struct *tty)
+{
+	struct tty_driver *driver = tty->driver;
+
+	if (test_bit(TTY_CLOSING, &tty->flags))
+		return -EIO;
+
+	if (driver->type == TTY_DRIVER_TYPE_PTY &&
+	    driver->subtype == PTY_TYPE_MASTER) {
+		/*
+		 * special case for PTY masters: only one open permitted,
+		 * and the slave side open count is incremented as well.
+		 */
+		if (tty->count)
+			return -EIO;
+
+		tty->link->count++;
+	}
+	tty->count++;
+	tty->driver = driver; /* N.B. why do this every time?? */
+
+	/* FIXME */
+	if (!test_bit(TTY_LDISC, &tty->flags))
+		printk(KERN_ERR "fast_tty_open: no ldisc\n");
+
+	return 0;
+}
+
 /**
  *	tty_init_dev		-	initialise a tty device
  *	@driver: tty driver we are opening a device on
@@ -1238,29 +1312,21 @@ int tty_init_dev(struct tty_driver *driver, int idx,
 	int retval = 0;
 
 	/* check whether we're reopening an existing tty */
-	if (driver->flags & TTY_DRIVER_DEVPTS_MEM) {
-		tty = devpts_get_tty(idx);
-		/*
-		 * If we don't have a tty here on a slave open, it's because
-		 * the master already started the close process and there's
-		 * no relation between devpts file and tty anymore.
-		 */
-		if (!tty && driver->subtype == PTY_TYPE_SLAVE) {
-			retval = -EIO;
-			goto end_init;
-		}
-		/*
-		 * It's safe from now on because tty_init_dev() is called with
-		 * tty_mutex held and tty_release_dev() won't change tty->count
-		 * or tty->flags without having to grab tty_mutex
-		 */
-		if (tty && driver->subtype == PTY_TYPE_MASTER)
-			tty = tty->link;
-	} else {
-		tty = driver->ttys[idx];
+	tty = find_tty(driver, idx);
+	if (IS_ERR(tty)) {
+		retval = PTR_ERR(tty);
+		goto end_init;
+	}
+
+	if (tty) {
+		retval = fast_tty_open(tty);
+		if (retval)
+			return retval;
+		*ret_tty = tty;
+		return 0;
 	}
-	if (tty) goto fast_track;
 
+	/* Check if pty master is being opened multiple times */
 	if (driver->subtype == PTY_TYPE_MASTER &&
 		(driver->flags & TTY_DRIVER_DEVPTS_MEM) && !first_ok) {
 		retval = -EIO;
@@ -1400,37 +1466,6 @@ int tty_init_dev(struct tty_driver *driver, int idx,
 
 	if (retval)
 		goto release_mem_out;
-	goto success;
-
-	/*
-	 * This fast open can be used if the tty is already open.
-	 * No memory is allocated, and the only failures are from
-	 * attempting to open a closing tty or attempting multiple
-	 * opens on a pty master.
-	 */
-fast_track:
-	if (test_bit(TTY_CLOSING, &tty->flags)) {
-		retval = -EIO;
-		goto end_init;
-	}
-	if (driver->type == TTY_DRIVER_TYPE_PTY &&
-	    driver->subtype == PTY_TYPE_MASTER) {
-		/*
-		 * special case for PTY masters: only one open permitted,
-		 * and the slave side open count is incremented as well.
-		 */
-		if (tty->count) {
-			retval = -EIO;
-			goto end_init;
-		}
-		tty->link->count++;
-	}
-	tty->count++;
-	tty->driver = driver; /* N.B. why do this every time?? */
-
-	/* FIXME */
-	if (!test_bit(TTY_LDISC, &tty->flags))
-		printk(KERN_ERR "tty_init_dev but no ldisc\n");
 success:
 	*ret_tty = tty;
 

