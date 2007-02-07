Return-Path: <linux-kernel-owner+w=401wt.eu-S1422786AbXBGVVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422786AbXBGVVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 16:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422794AbXBGVVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 16:21:33 -0500
Received: from lx1.pxnet.com ([195.227.45.3]:60862 "EHLO lx1.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422786AbXBGVVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 16:21:32 -0500
Date: Wed, 7 Feb 2007 22:21:07 +0100
Message-Id: <200702072121.l17LL7Wn000193@lx1.pxnet.com>
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH] drivers/isdn/gigaset: reduce mutex scope
To: Andrew Morton <akpm@osdl.org>, Karsten Keil <kkeil@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i4ldeveloper@listserv.isdn4linux.de
CC: Hansjoerg Lipp <hjlipp@web.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do not lock the cardstate structure mutex earlier than necessary.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>

---

 drivers/isdn/gigaset/common.c    |    4 +---
 drivers/isdn/gigaset/interface.c |    3 +++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff -rupX dont-diff linux-2.6.20-rc6-mm3-orig/drivers/isdn/gigaset/common.c local/drivers/isdn/gigaset/common.c
--- linux-2.6.20-rc6-mm3-orig/drivers/isdn/gigaset/common.c	2007-02-01 01:24:38.000000000 +0100
+++ local/drivers/isdn/gigaset/common.c	2007-02-01 01:09:51.000000000 +0100
@@ -640,7 +640,6 @@ struct cardstate *gigaset_initcs(struct 
 		return NULL;
 	}
 	mutex_init(&cs->mutex);
-	mutex_lock(&cs->mutex);
 
 	gig_dbg(DEBUG_INIT, "allocating bcs[0..%d]", channels - 1);
 	cs->bcs = kmalloc(channels * sizeof(struct bc_state), GFP_KERNEL);
@@ -738,6 +737,7 @@ struct cardstate *gigaset_initcs(struct 
 
 	++cs->cs_init;
 
+	/* set up character device */
 	gigaset_if_init(cs);
 
 	/* set up device sysfs */
@@ -753,11 +753,9 @@ struct cardstate *gigaset_initcs(struct 
 	add_timer(&cs->timer);
 
 	gig_dbg(DEBUG_INIT, "cs initialized");
-	mutex_unlock(&cs->mutex);
 	return cs;
 
 error:
-	mutex_unlock(&cs->mutex);
 	gig_dbg(DEBUG_INIT, "failed");
 	gigaset_freecs(cs);
 	return NULL;
diff -rupX dont-diff linux-2.6.20-rc6-mm3-orig/drivers/isdn/gigaset/interface.c local/drivers/isdn/gigaset/interface.c
--- linux-2.6.20-rc6-mm3-orig/drivers/isdn/gigaset/interface.c	2007-02-01 01:24:38.000000000 +0100
+++ local/drivers/isdn/gigaset/interface.c	2007-02-01 01:10:47.000000000 +0100
@@ -615,6 +615,8 @@ void gigaset_if_init(struct cardstate *c
 		return;
 
 	tasklet_init(&cs->if_wake_tasklet, &if_wake, (unsigned long) cs);
+
+	mutex_lock(&cs->mutex);
 	cs->tty_dev = tty_register_device(drv->tty, cs->minor_index, NULL);
 
 	if (!IS_ERR(cs->tty_dev))
@@ -623,6 +625,7 @@ void gigaset_if_init(struct cardstate *c
 		warn("could not register device to the tty subsystem");
 		cs->tty_dev = NULL;
 	}
+	mutex_unlock(&cs->mutex);
 }
 
 void gigaset_if_free(struct cardstate *cs)
