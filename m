Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYIDUal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYIDUal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758526AbYIDU0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:26:37 -0400
Received: from mail.work.de ([212.12.32.20]:42125 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758522AbYIDU0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:26:36 -0400
Message-ID: <48C04477.4070207@gmail.com>
Date: Fri, 05 Sep 2008 00:26:31 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: o.endriss@gmx.de
Subject: DVB Update [PATCH 21/31] do not toggle legacy mode within ioctls
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------000608080405000809080803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000608080405000809080803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 669f91b5633422296284e9a9a967a6b0fadbda74 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:21:09 +0200
Subject: [PATCH] DVB Code review: Do not toggle legacy mode within ioctls

Code review #2: Thanks to Oliver Endriss <o.endriss@gmx.de> for
pointing out a bug in certain circumstances.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)


--------------000608080405000809080803
Content-Type: text/x-patch;
 name="21.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="21.patch"

>From 669f91b5633422296284e9a9a967a6b0fadbda74 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:21:09 +0200
Subject: [PATCH] DVB Code review: Do not toggle legacy mode within ioctls

Code review #2: Thanks to Oliver Endriss <o.endriss@gmx.de> for
pointing out a bug in certain circumstances.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 037199a..2b28bd1 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1630,7 +1630,6 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 			break;
 		}
 
-		fe->legacy = 1;
 		memcpy(&fepriv->parameters, parg, sizeof (struct dvb_frontend_parameters));
 		memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
 		memcpy(&fetunesettings.parameters, parg, sizeof (struct dvb_frontend_parameters));
@@ -1703,7 +1702,6 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 	}
 
 	case FE_GET_FRONTEND:
-		fe->legacy = 1;
 		if (fe->ops.get_frontend) {
 			memcpy (parg, &fepriv->parameters, sizeof (struct dvb_frontend_parameters));
 			err = fe->ops.get_frontend(fe, (struct dvb_frontend_parameters*) parg);
@@ -1729,10 +1727,6 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		struct dvb_frontend_tune_settings fetunesettings;
 		enum dvbfe_delsys delsys = fepriv->fe_info.delivery;
 
-		fe->legacy = 0;
-		if (!(fe->ops.set_params || fe->ops.search))
-			fe->legacy = 1;
-
 		memcpy(&fepriv->fe_params, parg, sizeof (struct dvbfe_params));
 		memset(&fetunesettings, 0, sizeof (struct dvb_frontend_tune_settings));
 		memcpy(&fetunesettings.fe_params, parg, sizeof (struct dvbfe_params));
@@ -1818,7 +1812,6 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 	}
 
 	case DVBFE_GET_PARAMS:
-		fe->legacy = 0;
 		if (fe->ops.get_params) {
 			memcpy(parg, &fepriv->fe_params, sizeof (struct dvbfe_params));
 			err = fe->ops.get_params(fe, (struct dvbfe_params *) parg);
@@ -1832,7 +1825,6 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		}
 		break;
 	case DVBFE_GET_DELSYS:
-		fe->legacy = 0;
 		if (fe->ops.get_delsys) {
 			err = fe->ops.get_delsys(fe, (enum dvbfe_delsys *) parg);
 		} else {
@@ -1855,7 +1847,6 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		break;
 	case DVBFE_GET_INFO:
 		printk("%s: DVBFE_GET_INFO\n", __func__);
-		fe->legacy = 0;
 		if (fe->ops.get_info) {
 			memcpy(&fepriv->fe_info, (struct dvbfe_info *) parg, sizeof (struct dvbfe_info));
 			err = fe->ops.get_info(fe, &fepriv->fe_info);
@@ -2063,6 +2054,11 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 	dvb_register_device (fe->dvb, &fepriv->dvbdev, &dvbdev_template,
 			     fe, DVB_DEVICE_FRONTEND);
 
+	if (fe->ops.set_frontend || fe->ops.get_frontend)
+		fe->legacy = 1;
+	else
+		fe->legacy = 0;
+
 	mutex_unlock(&frontend_mutex);
 	return 0;
 }


--------------000608080405000809080803--
