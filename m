Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbZISVlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbZISVlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZISVlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:41:17 -0400
Received: from kroah.org ([198.145.64.141]:40456 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945AbZISVlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:41:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/79] tty: make the kref destructor occur asynchronously
Date: Sat, 19 Sep 2009 14:36:40 -0700
Message-Id: <1253396244-7885-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We want to be able to sleep in the destructor for USB at least. It isn't a
hot path so just pushing it to a work queue doesn't really cause any
difficulty.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_io.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 9384480..385cca7 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1386,10 +1386,14 @@ EXPORT_SYMBOL(tty_shutdown);
  *		tty_mutex - sometimes only
  *		takes the file list lock internally when working on the list
  *	of ttys that the driver keeps.
+ *
+ *	This method gets called from a work queue so that the driver private
+ *	shutdown ops can sleep (needed for USB at least)
  */
-static void release_one_tty(struct kref *kref)
+static void release_one_tty(struct work_struct *work)
 {
-	struct tty_struct *tty = container_of(kref, struct tty_struct, kref);
+	struct tty_struct *tty =
+		container_of(work, struct tty_struct, hangup_work);
 	struct tty_driver *driver = tty->driver;
 
 	if (tty->ops->shutdown)
@@ -1407,6 +1411,15 @@ static void release_one_tty(struct kref *kref)
 	free_tty_struct(tty);
 }
 
+static void queue_release_one_tty(struct kref *kref)
+{
+	struct tty_struct *tty = container_of(kref, struct tty_struct, kref);
+	/* The hangup queue is now free so we can reuse it rather than
+	   waste a chunk of memory for each port */
+	INIT_WORK(&tty->hangup_work, release_one_tty);
+	schedule_work(&tty->hangup_work);
+}
+
 /**
  *	tty_kref_put		-	release a tty kref
  *	@tty: tty device
@@ -1418,7 +1431,7 @@ static void release_one_tty(struct kref *kref)
 void tty_kref_put(struct tty_struct *tty)
 {
 	if (tty)
-		kref_put(&tty->kref, release_one_tty);
+		kref_put(&tty->kref, queue_release_one_tty);
 }
 EXPORT_SYMBOL(tty_kref_put);
 
-- 
1.6.4.2

