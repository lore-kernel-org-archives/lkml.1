Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbYJEQYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbYJEQYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbYJEQVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:21:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57955 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757557AbYJEQVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:21:11 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 55/76] Move tty lookup/reopen to caller
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:21:11 +0100
Message-ID: <20081005162109.1997.26345.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Move tty_driver_lookup_tty() and tty_reopen() from tty_init_dev()
into tty_open() (one of the two callers of tty_init_dev()).  These
calls are not really required in ptmx_open(), the other caller,
since ptmx_open() would be setting up a new tty.

Changelog[v2]:
	- remove the lookup and reopen calls from ptmx_open
	- merge with recent changes to ttydev tree

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index e881e9e..36098ee 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1376,19 +1376,6 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 	struct tty_struct *tty;
 	int retval;
 
-	/* check whether we're reopening an existing tty */
-	tty = tty_driver_lookup_tty(driver, idx);
-
-	if (IS_ERR(tty))
-		return tty;
-
-	if (tty) {
-		retval = tty_reopen(tty);
-		if (retval)
-			return ERR_PTR(retval);
-		return tty;
-	}
-
 	/* Check if pty master is being opened multiple times */
 	if (driver->subtype == PTY_TYPE_MASTER &&
 		(driver->flags & TTY_DRIVER_DEVPTS_MEM) && !first_ok)
@@ -1790,7 +1777,7 @@ void tty_release_dev(struct file *filp)
 
 static int __tty_open(struct inode *inode, struct file *filp)
 {
-	struct tty_struct *tty;
+	struct tty_struct *tty = NULL;
 	int noctty, retval;
 	struct tty_driver *driver;
 	int index;
@@ -1847,7 +1834,21 @@ retry_open:
 		return -ENODEV;
 	}
 got_driver:
-	tty = tty_init_dev(driver, index, 0);
+	if (!tty) {
+		/* check whether we're reopening an existing tty */
+		tty = tty_driver_lookup_tty(driver, index);
+
+		if (IS_ERR(tty))
+			return PTR_ERR(tty);
+	}
+
+	if (tty) {
+		retval = tty_reopen(tty);
+		if (retval)
+			tty = ERR_PTR(retval);
+	} else
+		tty = tty_init_dev(driver, index, 0);
+
 	mutex_unlock(&tty_mutex);
 	tty_driver_kref_put(driver);
 	if (IS_ERR(tty))

