Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYJNJQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYJNJQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbYJNJPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:15:22 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:41269 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443AbYJNJPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:15:16 -0400
Message-Id: <20081014091413.306993844@linux.vnet.ibm.com>
References: <20081014091247.433079967@linux.vnet.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Oct 2008 11:12:51 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: [RFC PATCH 4/5] hvc_console: Add tty window resizing
Content-Disposition: inline; filename=hvc/common/04_hvc_setwinsz.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

The patch provides the hvc_resize() function to update the terminal
window dimensions (struct winsize) for a specified hvc console.
The function stores the new window size and schedules a function
that finally updates the tty winsize and signals the change to
user space (SIGWINCH).
Because the winsize update must acquire a mutex and might sleep,
the function is scheduled instead of being called from hvc_poll()
or khvcd.

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 drivers/char/hvc_console.c |   61 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/char/hvc_console.h |    6 ++++
 2 files changed, 67 insertions(+)

--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -494,6 +494,48 @@ static int hvc_write(struct tty_struct *
 	return written;
 }
 
+/**
+ * hvc_set_winsz() - Resize the hvc tty terminal window.
+ * @work:	work structure.
+ *
+ * The routine shall not be called within an atomic context because it
+ * acquires the tty termios mutex and might sleep.
+ *
+ * Locking:	hp->lock, tty->termios_mutex and tty->ctrl_lock
+ */
+static void hvc_set_winsz(struct work_struct *work)
+{
+	struct hvc_struct *hp;
+	struct pid *pgrp;
+	unsigned long hvc_flags;
+	unsigned long ctrl_flags;
+
+	hp = container_of(work, struct hvc_struct, tty_resize);
+	if (!hp || !hp->tty)
+		return;
+
+	mutex_lock(&hp->tty->termios_mutex);
+	spin_lock_irqsave(&hp->lock, hvc_flags);
+
+	if ((hp->ws.ws_row == hp->tty->winsize.ws_row) &&
+	    (hp->ws.ws_col == hp->tty->winsize.ws_col))
+		goto out_mutex_unlock;
+
+	spin_lock_irqsave(&hp->tty->ctrl_lock, ctrl_flags);
+	pgrp = get_pid(hp->tty->pgrp);
+	spin_unlock_irqrestore(&hp->tty->ctrl_lock, ctrl_flags);
+
+	if (pgrp)
+		kill_pgrp(pgrp, SIGWINCH, 1);
+	put_pid(pgrp);
+
+	hp->tty->winsize = hp->ws;
+
+out_mutex_unlock:
+	spin_unlock_irqrestore(&hp->lock, hvc_flags);
+	mutex_unlock(&hp->tty->termios_mutex);
+}
+
 /*
  * This is actually a contract between the driver and the tty layer outlining
  * how much write room the driver can guarantee will be sent OR BUFFERED.  This
@@ -638,6 +680,24 @@ int hvc_poll(struct hvc_struct *hp)
 }
 EXPORT_SYMBOL_GPL(hvc_poll);
 
+/**
+ * hvc_resize() - Update terminal window size information.
+ * @hp:		HVC console pointer
+ * @ws:		Terminal window size structure
+ *
+ * Stores the specified window size information in the hvc structure of @hp.
+ * The function schedule the tty resize update.
+ *
+ * Locking:	Locking free; the function MUST be called holding hp->lock
+ */
+void hvc_resize(struct hvc_struct *hp, struct winsize ws)
+{
+	if ((hp->ws.ws_row != ws.ws_row) || (hp->ws.ws_col != ws.ws_col)) {
+		hp->ws = ws;
+		schedule_work(&hp->tty_resize);
+	}
+}
+
 /*
  * This kthread is either polling or interrupt driven.  This is determined by
  * calling hvc_poll() who determines whether a console adapter support
@@ -720,6 +780,7 @@ struct hvc_struct __devinit *hvc_alloc(u
 
 	kref_init(&hp->kref);
 
+	INIT_WORK(&hp->tty_resize, hvc_set_winsz);
 	spin_lock_init(&hp->lock);
 	spin_lock(&hvc_structs_lock);
 
--- a/drivers/char/hvc_console.h
+++ b/drivers/char/hvc_console.h
@@ -27,6 +27,7 @@
 #ifndef HVC_CONSOLE_H
 #define HVC_CONSOLE_H
 #include <linux/kref.h>
+#include <linux/tty.h>
 
 /*
  * This is the max number of console adapters that can/will be found as
@@ -56,6 +57,8 @@ struct hvc_struct {
 	struct hv_ops *ops;
 	int irq_requested;
 	int data;
+	struct winsize ws;
+	struct work_struct tty_resize;
 	struct list_head next;
 	struct kref kref; /* ref count & hvc_struct lifetime */
 };
@@ -84,6 +87,9 @@ extern int __devexit hvc_remove(struct h
 int hvc_poll(struct hvc_struct *hp);
 void hvc_kick(void);
 
+/* Resize hvc tty terminal window */
+extern void hvc_resize(struct hvc_struct *hp, struct winsize ws);
+
 /* default notifier for irq based notification */
 extern int notifier_add_irq(struct hvc_struct *hp, int data);
 extern void notifier_del_irq(struct hvc_struct *hp, int data);

-- 
Hendrik Brueckner
D/3303 Linux on System z Development
Tel: +49 7031 16-1073
Fax: +49 7031 16-3456
eMail: brueckner@linux.vnet.ibm.com
IBM Deutschland Research & Development GmbH, Schoenaicher Str. 220, 71032 Boeblingen

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschaeftsfuehrung: Erich Baier
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

