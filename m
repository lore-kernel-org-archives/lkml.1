Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbYJEQOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbYJEQOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbYJEQIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:08:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48466 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756431AbYJEQIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:08:23 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 27/76] tty: use krefs to protect driver module counts
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:08:23 +0100
Message-ID: <20081005160820.1997.76436.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty layer keeps driver module counts that are used so the driver knows
when it can be unloaded. For obvious reasons we want to tie that to the
refcounting properly.

At this point the driver side itself isn't refcounted nicely but we can do
that later and kref the drivers.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 310e070..fa162c9 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1293,6 +1293,12 @@ static int init_dev(struct tty_driver *driver, int idx,
 		o_tty = alloc_tty_struct();
 		if (!o_tty)
 			goto free_mem_out;
+		if (!try_module_get(driver->other->owner)) {
+			/* This cannot in fact currently happen */
+			free_tty_struct(o_tty);
+			o_tty = NULL;
+			goto free_mem_out;
+		}
 		initialize_tty_struct(o_tty);
 		o_tty->driver = driver->other;
 		o_tty->ops = driver->ops;
@@ -1411,8 +1417,10 @@ end_init:
 	/* Release locally allocated memory ... nothing placed in slots */
 free_mem_out:
 	kfree(o_tp);
-	if (o_tty)
+	if (o_tty) {
+		module_put(o_tty->driver->owner);
 		free_tty_struct(o_tty);
+	}
 	kfree(ltp);
 	kfree(tp);
 	free_tty_struct(tty);
@@ -1447,6 +1455,7 @@ release_mem_out:
 static void release_one_tty(struct kref *kref)
 {
 	struct tty_struct *tty = container_of(kref, struct tty_struct, kref);
+	struct tty_driver *driver = tty->driver;
 	int devpts = tty->driver->flags & TTY_DRIVER_DEVPTS_MEM;
 	struct ktermios *tp;
 	int idx = tty->index;
@@ -1471,6 +1480,7 @@ static void release_one_tty(struct kref *kref)
 	tty->magic = 0;
 	/* FIXME: locking on tty->driver->refcount */
 	tty->driver->refcount--;
+	module_put(driver->owner);
 
 	file_list_lock();
 	list_del_init(&tty->tty_files);
@@ -1506,20 +1516,15 @@ EXPORT_SYMBOL(tty_kref_put);
  *	of ttys that the driver keeps.
  *		FIXME: should we require tty_mutex is held here ??
  *
- *	FIXME: We want to defer the module put of the driver to the
- *	destructor.
  */
 static void release_tty(struct tty_struct *tty, int idx)
 {
-	struct tty_driver *driver = tty->driver;
-
 	/* This should always be true but check for the moment */
 	WARN_ON(tty->index != idx);
 
 	if (tty->link)
 		tty_kref_put(tty->link);
 	tty_kref_put(tty);
-	module_put(driver->owner);
 }
 
 /*

