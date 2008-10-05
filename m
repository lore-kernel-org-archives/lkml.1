Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbYJEQVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbYJEQVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYJEQRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:17:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49653 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757507AbYJEQRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:17:14 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 45/76] pty: If the administrator creates a device for a ptmx
	slave we should not error
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:17:14 +0100
Message-ID: <20081005161644.1997.26914.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The open path for ptmx slaves is via the ptmx device. Opening them any
other way is not allowed. Vegard Nossum found that previously this was not
the case and mknod foo c 128 42; cat foo would produce nasty diagnostics

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index f40298e..2e96ce0 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1227,7 +1227,8 @@ static void tty_line_name(struct tty_driver *driver, int index, char *p)
  *	init_dev		-	initialise a tty device
  *	@driver: tty driver we are opening a device on
  *	@idx: device index
- *	@tty: returned tty structure
+ *	@ret_tty: returned tty structure
+ *	@first_ok: ok to open a new device (used by ptmx)
  *
  *	Prepare a tty device. This may not be a "new" clean device but
  *	could also be an active device. The pty drivers require special
@@ -1248,7 +1249,7 @@ static void tty_line_name(struct tty_driver *driver, int index, char *p)
  */
 
 static int init_dev(struct tty_driver *driver, int idx,
-	struct tty_struct **ret_tty)
+	struct tty_struct **ret_tty, int first_ok)
 {
 	struct tty_struct *tty, *o_tty;
 	struct ktermios *tp, **tp_loc, *o_tp, **o_tp_loc;
@@ -1279,6 +1280,11 @@ static int init_dev(struct tty_driver *driver, int idx,
 	}
 	if (tty) goto fast_track;
 
+	if (driver->subtype == PTY_TYPE_MASTER &&
+		(driver->flags & TTY_DRIVER_DEVPTS_MEM) && !first_ok) {
+		retval = -EIO;
+		goto end_init;
+	}
 	/*
 	 * First time open is complex, especially for PTY devices.
 	 * This code guarantees that either everything succeeds and the
@@ -1413,7 +1419,7 @@ static int init_dev(struct tty_driver *driver, int idx,
 
 	if (retval)
 		goto release_mem_out;
-	 goto success;
+	goto success;
 
 	/*
 	 * This fast open can be used if the tty is already open.
@@ -1795,7 +1801,7 @@ static void release_dev(struct file *filp)
 }
 
 /**
- *	tty_open		-	open a tty device
+ *	__tty_open		-	open a tty device
  *	@inode: inode of device file
  *	@filp: file pointer to tty
  *
@@ -1874,7 +1880,7 @@ retry_open:
 		return -ENODEV;
 	}
 got_driver:
-	retval = init_dev(driver, index, &tty);
+	retval = init_dev(driver, index, &tty, 0);
 	mutex_unlock(&tty_mutex);
 	if (retval)
 		return retval;
@@ -1971,7 +1977,7 @@ static int __ptmx_open(struct inode *inode, struct file *filp)
 		return index;
 
 	mutex_lock(&tty_mutex);
-	retval = init_dev(ptm_driver, index, &tty);
+	retval = init_dev(ptm_driver, index, &tty, 1);
 	mutex_unlock(&tty_mutex);
 
 	if (retval)

