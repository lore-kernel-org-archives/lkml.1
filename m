Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbYJNPCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbYJNPCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 11:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYJNPCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 11:02:15 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:41124 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYJNPCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 11:02:14 -0400
Date: Tue, 14 Oct 2008 17:02:09 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC PATCH 4/5] hvc_console: Add tty window resizing
Message-ID: <20081014150209.GB5318@cetus.boeblingen.de.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Linux PPC devel <linuxppc-dev@ozlabs.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"Ryan S. Arnold" <rsa@us.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20081014091247.433079967@linux.vnet.ibm.com> <20081014091413.306993844@linux.vnet.ibm.com> <20081014104428.698b750b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014104428.698b750b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 10:44:28AM +0100, Alan Cox wrote:
> > +	hp = container_of(work, struct hvc_struct, tty_resize);
> > +	if (!hp || !hp->tty)
> > +		return;
> What locks hp->tty here, it can go NULL after the test on a hangup it
> seems ?
You are right. Thanks.

> See tty_do_resize() for all of this stuff in the latest git. If you can't
> use tty_do_resize from your work queue then please let me know why as I'd
> like everyone to be using one abstraction.
I have looked at it  and I have corrected my patch to use tty_do_resize().
Since tty_do_resize() cannot be called holding the hp spinlock; the code uses
now tty_kref_get/put to keep track of the tty object. I am not sure if the
use of the kref's is correct here, so please let me know if there is a better
solution.

Thanks.

Regards,
Hendrik

[RFC PATCH 4/5 v2] hvc_console: Add tty window resizing using tty_do_resize()

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

The patch provides the hvc_resize() function to update the terminal
window dimensions (struct winsize) for a specified hvc console.
The function stores the new window size and schedules a function
that finally updates the tty winsize and signals the change to
user space (SIGWINCH).
Because the winsize update must acquire a mutex and might sleep,
the function is scheduled instead of being called from hvc_poll()
or khvcd.

This patch uses the tty_do_resize() routine from the tty layer.
A pending resize work is canceled in hvc_close() and hvc_hangup().

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 drivers/char/hvc_console.c |   58 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/char/hvc_console.h |    6 ++++
 2 files changed, 64 insertions(+)

--- a/drivers/char/hvc_console.c	2008-10-14 16:13:12.000000000 +0200
+++ b/drivers/char/hvc_console.c	2008-10-14 16:43:03.000000000 +0200
@@ -374,6 +374,9 @@ static void hvc_close(struct tty_struct 
 		hp->tty = NULL;
 		spin_unlock_irqrestore(&hp->lock, flags);
 
+		/* cancel pending tty resize work */
+		cancel_work_sync(&hp->tty_resize);
+
 		/*
 		 * Chain calls chars_in_buffer() and returns immediately if
 		 * there is no buffered data otherwise sleeps on a wait queue
@@ -399,6 +402,9 @@ static void hvc_hangup(struct tty_struct
 	if (!hp)
 		return;
 
+	/* cancel pending tty resize work */
+	cancel_work_sync(&hp->tty_resize);
+
 	spin_lock_irqsave(&hp->lock, flags);
 
 	/*
@@ -494,6 +500,39 @@ static int hvc_write(struct tty_struct *
 	return written;
 }
 
+/**
+ * hvc_set_winsz() - Resize the hvc tty terminal window.
+ * @work:	work structure.
+ *
+ * The routine shall not be called within an atomic context because it
+ * might sleep.
+ *
+ * Locking:	hp->lock
+ */
+static void hvc_set_winsz(struct work_struct *work)
+{
+	struct hvc_struct *hp;
+	unsigned long hvc_flags;
+	struct tty_struct *tty;
+	struct winsize ws;
+
+	hp = container_of(work, struct hvc_struct, tty_resize);
+	if (!hp)
+		return;
+
+	spin_lock_irqsave(&hp->lock, hvc_flags);
+	if (!hp->tty) {
+		spin_unlock_irqrestore(&hp->lock, hvc_flags);
+		return;
+	}
+	ws  = hp->ws;
+	tty = tty_kref_get(hp->tty);
+	spin_unlock_irqrestore(&hp->lock, hvc_flags);
+
+	tty_do_resize(tty, tty, &ws);
+	tty_kref_put(tty);
+}
+
 /*
  * This is actually a contract between the driver and the tty layer outlining
  * how much write room the driver can guarantee will be sent OR BUFFERED.  This
@@ -638,6 +677,24 @@ int hvc_poll(struct hvc_struct *hp)
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
@@ -720,6 +777,7 @@ struct hvc_struct __devinit *hvc_alloc(u
 
 	kref_init(&hp->kref);
 
+	INIT_WORK(&hp->tty_resize, hvc_set_winsz);
 	spin_lock_init(&hp->lock);
 	spin_lock(&hvc_structs_lock);
 
--- a/drivers/char/hvc_console.h	2008-10-14 16:13:11.000000000 +0200
+++ b/drivers/char/hvc_console.h	2008-10-14 16:13:13.000000000 +0200
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
