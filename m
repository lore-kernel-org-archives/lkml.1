Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbYIDU0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbYIDU0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757510AbYIDUYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:24:46 -0400
Received: from mail.work.de ([212.12.32.20]:34100 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757962AbYIDUYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:24:45 -0400
Message-ID: <48C04408.9020404@gmail.com>
Date: Fri, 05 Sep 2008 00:24:40 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: Marco Schluessler <marco@lordzodiac.de>
Subject: DVB Update [PATCH 10/31] fix DVBFE_GET_EVENT backward compat
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------030503010108040507030600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030503010108040507030600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 15f5071d056f457609153d2c707bf0fe18909bd6 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:37:31 +0200
Subject: [PATCH] DVB Fix DVBFE_GET_EVENT backward compatibility

* DVBFE_GET_EVENT ioctl's backward compatibility was broken due
to a size difference of the data structure.

The patch fixes the backward compatibility for this ioctl.

From: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 drivers/media/dvb/dvb-core/dvb_frontend.c |   29
+++++++++++++++++++++++------
 drivers/media/dvb/dvb-core/dvb_frontend.h |    9 ++++++++-
 include/linux/dvb/frontend.h              |    6 +++++-
 3 files changed, 36 insertions(+), 8 deletions(-)


--------------030503010108040507030600
Content-Type: text/x-patch;
 name="10.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="10.patch"

>From 15f5071d056f457609153d2c707bf0fe18909bd6 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:37:31 +0200
Subject: [PATCH] DVB Fix DVBFE_GET_EVENT backward compatibility

* DVBFE_GET_EVENT ioctl's backward compatibility was broken due
to a size difference of the data structure.

The patch fixes the backward compatibility for this ioctl.

From: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index ac224db..202a0de 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -569,7 +569,7 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dvb_fe_events *events = &fepriv->events;
-	struct dvb_frontend_event *e;
+	struct dvb_frontend_event_int *e;
 	int wp;
 
 	dprintk ("%s\n", __func__);
@@ -679,7 +679,7 @@ static int dvbfe_sanity_check(struct dvb_frontend *fe)
 }
 
 static int dvb_frontend_get_event(struct dvb_frontend *fe,
-			    struct dvb_frontend_event *event, int flags)
+			    struct dvb_frontend_event_int *event, int flags)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dvb_fe_events *events = &fepriv->events;
@@ -713,7 +713,7 @@ static int dvb_frontend_get_event(struct dvb_frontend *fe,
 		return -ERESTARTSYS;
 
 	memcpy (event, &events->events[events->eventr],
-		sizeof(struct dvb_frontend_event));
+		sizeof(struct dvb_frontend_event_int));
 
 	events->eventr = (events->eventr + 1) % MAX_EVENT;
 
@@ -1436,7 +1436,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		return -ENODEV;
 
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY &&
-	    (_IOC_DIR(cmd) != _IOC_READ || cmd == FE_GET_EVENT ||
+	    (_IOC_DIR(cmd) != _IOC_READ || cmd == FE_GET_EVENT || cmd == DVBFE_GET_EVENT ||
 	     cmd == FE_DISEQC_RECV_SLAVE_REPLY))
 		return -EPERM;
 
@@ -1675,9 +1675,16 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		break;
 	}
 
-	case FE_GET_EVENT:
-		err = dvb_frontend_get_event (fe, parg, file->f_flags);
+	case FE_GET_EVENT: {
+		struct dvb_frontend_event_int event;
+		struct dvb_frontend_event *out_event = parg;
+
+		if (!(err = dvb_frontend_get_event(fe, &event, file->f_flags))) {
+			out_event->status = event.status;
+			memcpy(&out_event->parameters, &event.parameters, sizeof (struct dvb_frontend_event));
+		}
 		break;
+	}
 
 	case FE_GET_FRONTEND:
 		fe->legacy = 1;
@@ -1692,6 +1699,16 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		err = 0;
 		break;
 
+	case DVBFE_GET_EVENT: {
+		struct dvb_frontend_event_int event;
+		struct dvbfe_event *out_event = parg;
+
+		if (!(err = dvb_frontend_get_event(fe, &event, file->f_flags))) {
+			memcpy(&out_event->fe_events, &event.fe_events, sizeof (struct dvbfe_events));
+			memcpy(&out_event->fe_params, &event.fe_params, sizeof (struct dvb_frontend_event));
+		}
+		break;
+	}
 	case DVBFE_SET_PARAMS: {
 		struct dvb_frontend_tune_settings fetunesettings;
 		enum dvbfe_delsys delsys = fepriv->fe_info.delivery;
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 8066ff0..6358ddd 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -309,8 +309,15 @@ struct dvb_frontend_ops {
 
 #define MAX_EVENT 8
 
+struct dvb_frontend_event_int {
+	fe_status_t status;
+	struct dvb_frontend_parameters parameters;
+	struct dvbfe_events fe_events;
+	struct dvbfe_params fe_params;
+};
+
 struct dvb_fe_events {
-	struct dvb_frontend_event events[MAX_EVENT];
+	struct dvb_frontend_event_int events[MAX_EVENT];
 	int			  eventw;
 	int			  eventr;
 	int			  overflow;
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index b17c218..73f391d 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -641,9 +641,13 @@ struct dvbfe_events {
 struct dvb_frontend_event {
 	fe_status_t status;
 	struct dvb_frontend_parameters parameters;
+};
+#define FE_GET_EVENT		   _IOR('o', 78, struct dvb_frontend_event)
+
+struct dvbfe_event {
 	struct dvbfe_events fe_events;
 	struct dvbfe_params fe_params;
 };
-#define FE_GET_EVENT		   _IOR('o', 78, struct dvb_frontend_event)
+#define DVBFE_GET_EVENT			_IOR('o', 86, struct dvbfe_event)
 
 #endif /*_DVBFRONTEND_H_*/


--------------030503010108040507030600--
