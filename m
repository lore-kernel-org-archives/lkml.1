Return-Path: <linux-kernel-owner+w=401wt.eu-S1422906AbXCGR1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422906AbXCGR1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422903AbXCGRR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:17:56 -0500
Received: from ns1.suse.de ([195.135.220.2]:44270 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422889AbXCGRR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:17:28 -0500
Message-Id: <20070307171548.971856222@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>, Thomas Renninger <trenn@suse.de>
Subject: [patch 077/101] Backport of psmouse suspend/shutdown cleanups
Content-Disposition: inline; filename=backport-of-psmouse-suspend-shutdown-cleanups.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>

This patch works back to 2.6.17 (earlier kernels seem to
need up/down operations on mutex/semaphore).

psmouse - properly reset mouse on shutdown/suspend

Some people report that they need psmouse module unloaded
for suspend to ram/disk to work properly. Let's make port
cleanup behave the same way as driver unload.

This fixes "bad state" problem on various HP laptops, such
as nx7400.


Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/mouse/psmouse-base.c |   28 ++++++++++++++++++++++++++++
 drivers/input/mouse/psmouse.h      |    1 +
 drivers/input/mouse/synaptics.c    |    1 +
 3 files changed, 30 insertions(+)

--- linux-2.6.20.1.orig/drivers/input/mouse/psmouse-base.c
+++ linux-2.6.20.1/drivers/input/mouse/psmouse-base.c
@@ -987,8 +987,36 @@ static void psmouse_resync(struct work_s
 static void psmouse_cleanup(struct serio *serio)
 {
 	struct psmouse *psmouse = serio_get_drvdata(serio);
+	struct psmouse *parent = NULL;
+
+	mutex_lock(&psmouse_mutex);
+
+	if (serio->parent && serio->id.type == SERIO_PS_PSTHRU) {
+		parent = serio_get_drvdata(serio->parent);
+		psmouse_deactivate(parent);
+	}
+
+	psmouse_deactivate(psmouse);
+
+	if (psmouse->cleanup)
+		psmouse->cleanup(psmouse);
 
 	psmouse_reset(psmouse);
+
+/*
+ * Some boxes, such as HP nx7400, get terribly confused if mouse
+ * is not fully enabled before suspending/shutting down.
+ */
+	ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE);
+
+	if (parent) {
+		if (parent->pt_deactivate)
+			parent->pt_deactivate(parent);
+
+		psmouse_activate(parent);
+	}
+
+	mutex_unlock(&psmouse_mutex);
 }
 
 /*
--- linux-2.6.20.1.orig/drivers/input/mouse/psmouse.h
+++ linux-2.6.20.1/drivers/input/mouse/psmouse.h
@@ -68,6 +68,7 @@ struct psmouse {
 
 	int (*reconnect)(struct psmouse *psmouse);
 	void (*disconnect)(struct psmouse *psmouse);
+	void (*cleanup)(struct psmouse *psmouse);
 	int (*poll)(struct psmouse *psmouse);
 
 	void (*pt_activate)(struct psmouse *psmouse);
--- linux-2.6.20.1.orig/drivers/input/mouse/synaptics.c
+++ linux-2.6.20.1/drivers/input/mouse/synaptics.c
@@ -652,6 +652,7 @@ int synaptics_init(struct psmouse *psmou
 	psmouse->set_rate = synaptics_set_rate;
 	psmouse->disconnect = synaptics_disconnect;
 	psmouse->reconnect = synaptics_reconnect;
+	psmouse->cleanup = synaptics_reset;
 	psmouse->pktsize = 6;
 	/* Synaptics can usually stay in sync without extra help */
 	psmouse->resync_time = 0;

--
