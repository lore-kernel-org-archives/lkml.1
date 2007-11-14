Return-Path: <linux-kernel-owner+w=401wt.eu-S1761597AbXKNXVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597AbXKNXVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbXKNXU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:20:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48709 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbXKNXU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:20:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH] Freezer: Make freezing failures less verbose by default
Date: Thu, 15 Nov 2007 00:38:06 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711150038.07538.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently freezing failures are extremely verbose which sometimes is
unnecessary and prevents the user from seeing which task could not be frozen.

Make them less verbose by default (ie. if CONFIG_PM_VERBOSE is unset).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/process.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/power/process.c
===================================================================
--- linux-2.6.orig/kernel/power/process.c
+++ linux-2.6/kernel/power/process.c
@@ -163,6 +163,15 @@ static void cancel_freezing(struct task_
 	}
 }
 
+#ifdef CONFIG_PM_VERBOSE
+static inline void freezer_show_state(void)
+{
+	show_state();
+}
+#else /* !CONFIG_PM_VERBOSE */
+static inline void freezer_show_state(void) {}
+#endif /* !CONFIG_PM_VERBOSE */
+
 static int try_to_freeze_tasks(int freeze_user_space)
 {
 	struct task_struct *g, *p;
@@ -214,7 +223,7 @@ static int try_to_freeze_tasks(int freez
 		printk(KERN_ERR "Freezing of tasks failed after %d.%02d seconds "
 				"(%d tasks refusing to freeze):\n",
 				elapsed_csecs / 100, elapsed_csecs % 100, todo);
-		show_state();
+		freezer_show_state();
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
 			task_lock(p);
