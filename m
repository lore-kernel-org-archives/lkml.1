Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbYIDUck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbYIDUck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbYIDU1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:27:20 -0400
Received: from mail.work.de ([212.12.32.20]:42153 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386AbYIDU1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:27:18 -0400
Message-ID: <48C044A1.9040908@gmail.com>
Date: Fri, 05 Sep 2008 00:27:13 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 26/31] make delivery system standalone
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------050905080600080303020601"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050905080600080303020601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From def9af723ae3b50e4f5f4acd8451d033085bb0fc Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:46:31 +0200
Subject: [PATCH] DVB API update: make delivery system standalone

Eventhough the delivery system is made standalone, DVBFE_SET_DELSYS
needs to be set as the very first operation, for a multistandard frontend.

Splitting delivery system out as a new ioctl, makes things a bit more
easier to understand.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 drivers/media/dvb/dvb-core/dvb_frontend.c |   20 +++++++++++++-------
 drivers/media/dvb/dvb-core/dvb_frontend.h |    1 +
 include/linux/dvb/frontend.h              |    8 ++------
 3 files changed, 16 insertions(+), 13 deletions(-)



--------------050905080600080303020601
Content-Type: text/x-patch;
 name="26.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="26.patch"

>From def9af723ae3b50e4f5f4acd8451d033085bb0fc Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:46:31 +0200
Subject: [PATCH] DVB API update: make delivery system standalone

Eventhough the delivery system is made standalone, DVBFE_SET_DELSYS
needs to be set as the very first operation, for a multistandard frontend.

Splitting delivery system out as a new ioctl, makes things a bit more
easier to understand.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index e2d929e..70b6ca0 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -134,6 +134,7 @@ struct dvb_frontend_private {
 	unsigned int check_wrapped;
 
 	enum dvbfe_search	algo_status;
+	enum dvbfe_delsys	delsys;
 };
 
 static void dvb_frontend_wakeup(struct dvb_frontend *fe);
@@ -1728,7 +1729,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 	}
 	case DVBFE_SET_PARAMS: {
 		struct dvb_frontend_tune_settings fetunesettings;
-		enum dvbfe_delsys delsys = fepriv->fe_info.delivery;
+		enum dvbfe_delsys delsys = fepriv->delsys;
 
 		memcpy(&fepriv->fe_params, parg, sizeof (struct dvbfe_params));
 		memset(&fetunesettings, 0, sizeof (struct dvb_frontend_tune_settings));
@@ -1739,7 +1740,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		    (delsys & DVBFE_DELSYS_DVBT) ||
 		    (delsys & DVBFE_DELSYS_ATSC)) {
 
-			if (newapi_to_olddrv(&fepriv->fe_params, &fepriv->parameters, fepriv->fe_info.delivery)  == -EINVAL)
+			if (newapi_to_olddrv(&fepriv->fe_params, &fepriv->parameters, fepriv->delsys)  == -EINVAL)
 				printk("%s: ERROR !!! Converting New parameters --> Old parameters\n", __func__);
 		}
 		/* Request the search algorithm to search	*/
@@ -1773,7 +1774,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 			fepriv->step_size = fetunesettings.step_size;
 		} else {
 			/* default values */
-			switch (fepriv->fe_info.delivery) {
+			switch (fepriv->delsys) {
 			case DVBFE_DELSYS_DVBS:
 			case DVBFE_DELSYS_DSS:
 			case DVBFE_DELSYS_DVBS2:
@@ -1848,17 +1849,22 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 			err = 0;
 		}
 		break;
+	case DVBFE_SET_DELSYS:
+		memcpy(&fepriv->delsys, (enum dvbfe_delsys *) parg, sizeof (enum dvbfe_delsys));
+		if (fe->ops.set_delsys)
+			fe->ops.set_delsys(fe, fepriv->delsys);
+
+		break;
 	case DVBFE_GET_INFO:
 		printk("%s: DVBFE_GET_INFO\n", __func__);
 		if (fe->ops.get_info) {
-			memcpy(&fepriv->fe_info, (struct dvbfe_info *) parg, sizeof (struct dvbfe_info));
 			err = fe->ops.get_info(fe, &fepriv->fe_info);
 			memcpy((struct dvbfe_info *) parg, &fepriv->fe_info, sizeof (struct dvbfe_info));
 		} else {
 			memset(&fepriv->fe_info, 0, sizeof(struct dvbfe_info));
 			switch (fe->ops.info.type) {
 				case FE_QPSK:
-					fepriv->fe_info.delivery = DVBFE_DELSYS_DVBS;
+					fepriv->delsys = DVBFE_DELSYS_DVBS;
 					fepriv->fe_info.delsys.dvbs.modulation = DVBFE_MOD_QPSK;
 					if (fe->ops.info.caps & FE_CAN_FEC_1_2)
 						fepriv->fe_info.delsys.dvbs.fec |= DVBFE_FEC_1_2;
@@ -1880,7 +1886,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 						fepriv->fe_info.delsys.dvbs.fec |= DVBFE_FEC_AUTO;
 					break;
 				case FE_QAM:
-					fepriv->fe_info.delivery = DVBFE_DELSYS_DVBC;
+					fepriv->delsys = DVBFE_DELSYS_DVBC;
 					if (fe->ops.info.caps & FE_CAN_QAM_16)
 						fepriv->fe_info.delsys.dvbc.modulation |= DVBFE_MOD_QAM16;
 					if (fe->ops.info.caps & FE_CAN_QAM_32)
@@ -1895,7 +1901,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 						fepriv->fe_info.delsys.dvbc.modulation |= DVBFE_MOD_QAMAUTO;
 					break;
 				case FE_OFDM:
-					fepriv->fe_info.delivery = DVBFE_DELSYS_DVBT;
+					fepriv->delsys = DVBFE_DELSYS_DVBT;
 					if (fe->ops.info.caps & FE_CAN_QPSK)
 						fepriv->fe_info.delsys.dvbt.modulation |= DVBFE_MOD_QPSK;
 					if (fe->ops.info.caps & FE_CAN_QAM_16)
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 6358ddd..4d1fb57 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -296,6 +296,7 @@ struct dvb_frontend_ops {
 	int (*get_params)(struct dvb_frontend *fe, struct dvbfe_params *fe_params);
 	int (*get_info)(struct dvb_frontend *fe, struct dvbfe_info *fe_info);
 	int (*get_delsys)(struct dvb_frontend *fe, enum dvbfe_delsys *fe_delsys);
+	int (*set_delsys)(struct dvb_frontend *fe, enum dvbfe_delsys fe_delsys);
 
 	/* These callbacks are for devices that implement their own
 	 * tuning algorithms, rather than a simple swzigzag
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index 73f391d..6f5fecf 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -588,11 +588,6 @@ struct dvbfe_atsc_info {
 /* DVB Frontend related Information	*/
 struct dvbfe_info {
 	char				name[128];
-
-	/* For Multi Standard tuners, set "delivery"
-	 * to the relevant delivery system to retrieve the
-	 * relevant delivery system related information.
-	 */
 	enum dvbfe_delsys		delivery;
 
 	union {
@@ -619,7 +614,8 @@ struct dvbfe_info {
 
 	__u8				pad[128];
 };
-#define DVBFE_GET_INFO			_IOWR('o', 85, struct dvbfe_info)
+#define DVBFE_GET_INFO			_IOR('o', 85, struct dvbfe_info)
+#define DVBFE_SET_DELSYS		_IOW('o', 87, enum dvbfe_delsys)
 
 enum dvbfe_status {
 	DVBFE_HAS_SIGNAL		= (1 <<  0),	/*  something above noise floor	*/


--------------050905080600080303020601--
