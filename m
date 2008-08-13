Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbYHMTY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbYHMTY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYHMTYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:24:41 -0400
Received: from mail.queued.net ([207.210.101.209]:1726 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbYHMTYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:24:40 -0400
Date: Wed, 13 Aug 2008 15:24:50 -0400
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] psmouse: add psmouse_queue_work() for ps/2 extension to
 make use of
Message-ID: <20080813152450.3eb3872b@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


psmouse_queue_work is passed a delayed_work struct, and queues up the work
with kpsmouse_wq.  Since we're dealing with delayed_work stuff, this
also switches resync_work to a delayed_work struct as well, and makes
use of psmouse_queue_work when doing a resync within psmouse-base.

Dmitry, is this what you had in mind?

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/input/mouse/psmouse-base.c |   14 ++++++++++----
 drivers/input/mouse/psmouse.h      |    4 +++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 960f2da..488ba95 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -201,6 +201,12 @@ static psmouse_ret_t psmouse_process_byte(struct psmouse *psmouse)
 	return PSMOUSE_FULL_PACKET;
 }
 
+void psmouse_queue_work(struct psmouse *psmouse, struct delayed_work *work,
+		unsigned long delay)
+{
+	queue_delayed_work(kpsmoused_wq, work, delay);
+}
+
 /*
  * __psmouse_set_state() sets new psmouse state and resets all flags.
  */
@@ -305,7 +311,7 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
 		       psmouse->name, psmouse->phys, psmouse->pktcnt);
 		psmouse->badbyte = psmouse->packet[0];
 		__psmouse_set_state(psmouse, PSMOUSE_RESYNCING);
-		queue_work(kpsmoused_wq, &psmouse->resync_work);
+		psmouse_queue_work(psmouse, &psmouse->resync_work, 0);
 		goto out;
 	}
 
@@ -342,7 +348,7 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
 	    time_after(jiffies, psmouse->last + psmouse->resync_time * HZ)) {
 		psmouse->badbyte = psmouse->packet[0];
 		__psmouse_set_state(psmouse, PSMOUSE_RESYNCING);
-		queue_work(kpsmoused_wq, &psmouse->resync_work);
+		psmouse_queue_work(psmouse, &psmouse->resync_work, 0);
 		goto out;
 	}
 
@@ -935,7 +941,7 @@ static int psmouse_poll(struct psmouse *psmouse)
 static void psmouse_resync(struct work_struct *work)
 {
 	struct psmouse *parent = NULL, *psmouse =
-		container_of(work, struct psmouse, resync_work);
+		container_of(work, struct psmouse, resync_work.work);
 	struct serio *serio = psmouse->ps2dev.serio;
 	psmouse_ret_t rc = PSMOUSE_GOOD_DATA;
 	int failed = 0, enabled = 0;
@@ -1194,7 +1200,7 @@ static int psmouse_connect(struct serio *serio, struct serio_driver *drv)
 		goto err_free;
 
 	ps2_init(&psmouse->ps2dev, serio);
-	INIT_WORK(&psmouse->resync_work, psmouse_resync);
+	INIT_DELAYED_WORK(&psmouse->resync_work, psmouse_resync);
 	psmouse->dev = input_dev;
 	snprintf(psmouse->phys, sizeof(psmouse->phys), "%s/input0", serio->phys);
 
diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
index ed40415..48e0112 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -39,7 +39,7 @@ struct psmouse {
 	void *private;
 	struct input_dev *dev;
 	struct ps2dev ps2dev;
-	struct work_struct resync_work;
+	struct delayed_work resync_work;
 	char *vendor;
 	char *name;
 	unsigned char packet[8];
@@ -92,6 +92,8 @@ enum psmouse_type {
 	PSMOUSE_AUTO		/* This one should always be last */
 };
 
+void psmouse_queue_work(struct psmouse *psmouse, struct delayed_work *work,
+		unsigned long delay);
 int psmouse_sliced_command(struct psmouse *psmouse, unsigned char command);
 int psmouse_reset(struct psmouse *psmouse);
 void psmouse_set_state(struct psmouse *psmouse, enum psmouse_state new_state);
-- 
1.5.6.3

