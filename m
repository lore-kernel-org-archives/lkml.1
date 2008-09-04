Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbYIDUYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbYIDUYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYIDUX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:23:27 -0400
Received: from mail.work.de ([212.12.32.20]:34069 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756962AbYIDUXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:23:24 -0400
Message-ID: <48C043B5.2000202@gmail.com>
Date: Fri, 05 Sep 2008 00:23:17 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 3/31] frontend core update
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------010400010202090505030104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010400010202090505030104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 6a505dda50ecd5eddffdabb79a9a32ccaf9fe29b Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:11:15 +0200
Subject: [PATCH] DVB Frontend API update: Frontend core support

* Add support for the new datastuctures and ioctls,
for the updated API

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |  495
+++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 443 insertions(+), 52 deletions(-)


--------------010400010202090505030104
Content-Type: text/x-patch;
 name="3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="3.patch"

>From 6a505dda50ecd5eddffdabb79a9a32ccaf9fe29b Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:11:15 +0200
Subject: [PATCH] DVB Frontend API update: Frontend core support

* Add support for the new datastuctures and ioctls,
for the updated API

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 8cbdb21..da7283c 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -8,6 +8,7 @@
  *				      for convergence integrated media GmbH
  *
  * Copyright (C) 2004 Andrew de Quincey (tuning thread cleanup)
+ * Copyright (C) Manu Abraham (Multi protocol support)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -95,7 +96,12 @@ struct dvb_frontend_private {
 
 	/* thread/frontend values */
 	struct dvb_device *dvbdev;
+	/* Legacy datatype, superseded by dvbfe_params		*/
 	struct dvb_frontend_parameters parameters;
+	/* dvbfe_params supersedes dvb_frontend_parameters	*/
+	struct dvbfe_params	fe_params;
+	struct dvbfe_info	fe_info;
+
 	struct dvb_fe_events events;
 	struct semaphore sem;
 	struct list_head list_head;
@@ -124,10 +130,64 @@ struct dvb_frontend_private {
 	unsigned int step_size;
 	int quality;
 	unsigned int check_wrapped;
+
+	enum dvbfe_search	algo_status;
 };
 
 static void dvb_frontend_wakeup(struct dvb_frontend *fe);
 
+struct modcod_table {
+	u32 dvbfe_modcod;
+	u32 dvbfe_modulation;
+	u32 dvbfe_fec;
+};
+
+static struct modcod_table dvbs2_modcod_lookup[] = {
+	{ DVBFE_MODCOD_DUMMY_PLFRAME,	DVBFE_MOD_NONE,		DVBFE_FEC_NONE    },
+	{ DVBFE_MODCOD_QPSK_1_4,	DVBFE_MOD_QPSK,		DVBFE_FEC_1_4	  },
+	{ DVBFE_MODCOD_QPSK_1_3,	DVBFE_MOD_QPSK,		DVBFE_FEC_1_3	  },
+	{ DVBFE_MODCOD_QPSK_2_5,	DVBFE_MOD_QPSK,		DVBFE_FEC_2_5	  },
+	{ DVBFE_MODCOD_QPSK_1_2,	DVBFE_MOD_QPSK,		DVBFE_FEC_1_2	  },
+	{ DVBFE_MODCOD_QPSK_3_5,	DVBFE_MOD_QPSK,		DVBFE_FEC_3_5	  },
+	{ DVBFE_MODCOD_QPSK_2_3,	DVBFE_MOD_QPSK,		DVBFE_FEC_2_3	  },
+	{ DVBFE_MODCOD_QPSK_3_4,	DVBFE_MOD_QPSK,		DVBFE_FEC_3_4	  },
+	{ DVBFE_MODCOD_QPSK_4_5,	DVBFE_MOD_QPSK,		DVBFE_FEC_4_5	  },
+	{ DVBFE_MODCOD_QPSK_5_6,	DVBFE_MOD_QPSK,		DVBFE_FEC_5_6	  },
+	{ DVBFE_MODCOD_QPSK_8_9,	DVBFE_MOD_QPSK,		DVBFE_FEC_8_9	  },
+	{ DVBFE_MODCOD_QPSK_9_10,	DVBFE_MOD_QPSK,		DVBFE_FEC_9_10	  },
+	{ DVBFE_MODCOD_8PSK_3_5,	DVBFE_MOD_8PSK,		DVBFE_FEC_3_5	  },
+	{ DVBFE_MODCOD_8PSK_2_3,	DVBFE_MOD_8PSK,		DVBFE_FEC_2_3	  },
+	{ DVBFE_MODCOD_8PSK_3_4,	DVBFE_MOD_8PSK,		DVBFE_FEC_3_4	  },
+	{ DVBFE_MODCOD_8PSK_5_6,	DVBFE_MOD_8PSK,		DVBFE_FEC_5_6	  },
+	{ DVBFE_MODCOD_8PSK_8_9,	DVBFE_MOD_8PSK,		DVBFE_FEC_8_9	  },
+	{ DVBFE_MODCOD_8PSK_9_10,	DVBFE_MOD_8PSK,		DVBFE_FEC_9_10	  },
+	{ DVBFE_MODCOD_16APSK_2_3,	DVBFE_MOD_16APSK,	DVBFE_FEC_2_3	  },
+	{ DVBFE_MODCOD_16APSK_3_4,	DVBFE_MOD_16APSK,	DVBFE_FEC_3_4	  },
+	{ DVBFE_MODCOD_16APSK_4_5,	DVBFE_MOD_16APSK,	DVBFE_FEC_4_5	  },
+	{ DVBFE_MODCOD_16APSK_5_6,	DVBFE_MOD_16APSK,	DVBFE_FEC_5_6	  },
+	{ DVBFE_MODCOD_16APSK_8_9,	DVBFE_MOD_16APSK,	DVBFE_FEC_8_9	  },
+	{ DVBFE_MODCOD_16APSK_9_10,	DVBFE_MOD_16APSK,	DVBFE_FEC_9_10	  },
+	{ DVBFE_MODCOD_32APSK_3_4,	DVBFE_MOD_32APSK,	DVBFE_FEC_3_4	  },
+	{ DVBFE_MODCOD_32APSK_4_5,	DVBFE_MOD_32APSK,	DVBFE_FEC_4_5	  },
+	{ DVBFE_MODCOD_32APSK_5_6,	DVBFE_MOD_32APSK,	DVBFE_FEC_5_6	  },
+	{ DVBFE_MODCOD_32APSK_8_9,	DVBFE_MOD_32APSK,	DVBFE_FEC_8_9	  },
+	{ DVBFE_MODCOD_32APSK_9_10,	DVBFE_MOD_32APSK,	DVBFE_FEC_9_10	  },
+	{ DVBFE_MODCOD_RESERVED_1,	DVBFE_MOD_NONE,		DVBFE_FEC_NONE	  },
+	{ DVBFE_MODCOD_BPSK_1_3,	DVBFE_MOD_BPSK,		DVBFE_FEC_1_3	  },
+	{ DVBFE_MODCOD_BPSK_1_4,	DVBFE_MOD_BPSK,		DVBFE_FEC_1_4	  },
+	{ DVBFE_MODCOD_RESERVED_2,	DVBFE_MOD_NONE,		DVBFE_FEC_NONE    }
+};
+
+void decode_dvbs2_modcod(u32 dvbfe_modcod,
+			 enum dvbfe_modulation *modulation,
+			 enum dvbfe_fec *fec)
+{
+	BUG_ON(dvbfe_modcod >= ARRAY_SIZE(dvbs2_modcod_lookup));
+	*modulation = dvbs2_modcod_lookup[dvbfe_modcod].dvbfe_modulation;
+	*fec = dvbs2_modcod_lookup[dvbfe_modcod].dvbfe_fec;
+}
+EXPORT_SYMBOL(decode_dvbs2_modcod);
+
 static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -149,12 +209,21 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 
 	e = &events->events[events->eventw];
 
-	memcpy (&e->parameters, &fepriv->parameters,
-		sizeof (struct dvb_frontend_parameters));
+	if (fe->legacy)
+		memcpy(&e->parameters, &fepriv->parameters, sizeof (struct dvb_frontend_parameters));
+	else
+		memcpy(&e->fe_params, &fepriv->fe_params, sizeof (struct dvbfe_params));
 
-	if (status & FE_HAS_LOCK)
-		if (fe->ops.get_frontend)
-			fe->ops.get_frontend(fe, &e->parameters);
+	if (fe->legacy) {
+		/* Legacy	*/
+		if (status & FE_HAS_LOCK)
+			if (fe->ops.get_frontend)
+				fe->ops.get_frontend(fe, &e->parameters);
+	} else {
+		if (status & FE_HAS_LOCK)
+			if (fe->ops.get_params)
+				fe->ops.get_params(fe, &e->fe_params);
+	}
 
 	events->eventw = wp;
 
@@ -165,6 +234,73 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 	wake_up_interruptible (&events->wait_queue);
 }
 
+static int dvbfe_sanity_check(struct dvb_frontend *fe)
+{
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+
+	/* Sanity checks	*/
+	if ((fepriv->fe_params.frequency < fepriv->fe_info.frequency_min) ||
+	    (fepriv->fe_params.frequency > fepriv->fe_info.frequency_max))
+		return -EINVAL;
+
+	switch (fepriv->fe_params.delivery) {
+	case DVBFE_DELSYS_DVBS:
+		if (!(fepriv->fe_params.delsys.dvbs.modulation &
+		      fepriv->fe_info.delsys.dvbs.modulation))
+			return -EINVAL;
+		if (!(fepriv->fe_params.delsys.dvbs.fec &
+		      fepriv->fe_info.delsys.dvbs.fec))
+			return -EINVAL;
+		break;
+	case DVBFE_DELSYS_DVBS2:
+		if (!(fepriv->fe_params.delsys.dvbs2.modulation &
+		      fepriv->fe_info.delsys.dvbs2.modulation))
+			return -EINVAL;
+		if (!(fepriv->fe_params.delsys.dvbs2.fec &
+		      fepriv->fe_info.delsys.dvbs2.fec))
+			return -EINVAL;
+		break;
+	case DVBFE_DELSYS_DSS:
+		if (!(fepriv->fe_params.delsys.dss.modulation &
+		      fepriv->fe_info.delsys.dss.modulation))
+			return -EINVAL;
+		if (!(fepriv->fe_params.delsys.dss.fec &
+		      fepriv->fe_info.delsys.dss.fec))
+			return -EINVAL;
+		break;
+	case DVBFE_DELSYS_DVBC:
+		if (!(fepriv->fe_params.delsys.dvbc.modulation &
+		      fepriv->fe_info.delsys.dvbc.modulation))
+			return -EINVAL;
+		break;
+	case DVBFE_DELSYS_DVBT:
+		if (!(fepriv->fe_params.delsys.dvbt.constellation &
+		      fepriv->fe_info.delsys.dvbt.modulation))
+		      return -EINVAL;
+		if (!(fepriv->fe_params.delsys.dvbt.priority &
+		      fepriv->fe_info.delsys.dvbt.stream_priority))
+		      return -EINVAL;
+		break;
+	case DVBFE_DELSYS_DVBH:
+		if (!(fepriv->fe_params.delsys.dvbh.constellation &
+		      fepriv->fe_info.delsys.dvbh.modulation))
+		      return -EINVAL;
+		if (!(fepriv->fe_params.delsys.dvbh.priority &
+		      fepriv->fe_info.delsys.dvbh.stream_priority))
+		      return -EINVAL;
+		break;
+	case DVBFE_DELSYS_ATSC:
+		if (!(fepriv->fe_params.delsys.atsc.modulation &
+		      fepriv->fe_info.delsys.atsc.modulation))
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int dvb_frontend_get_event(struct dvb_frontend *fe,
 			    struct dvb_frontend_event *event, int flags)
 {
@@ -261,13 +397,29 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 {
 	int autoinversion;
 	int ready = 0;
+	int original_inversion;
+	u32 original_frequency;
+
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	int original_inversion = fepriv->parameters.inversion;
-	u32 original_frequency = fepriv->parameters.frequency;
 
-	/* are we using autoinversion? */
-	autoinversion = ((!(fe->ops.info.caps & FE_CAN_INVERSION_AUTO)) &&
-			 (fepriv->parameters.inversion == INVERSION_AUTO));
+	if (fe->legacy) {
+		/* Legacy	*/
+		original_inversion = fepriv->parameters.inversion;
+		original_frequency = fepriv->parameters.frequency;
+		/* are we using autoinversion ?	*/
+		/* Legacy	*/
+		autoinversion = ((!(fe->ops.info.caps & FE_CAN_INVERSION_AUTO)) &&
+				 (fepriv->parameters.inversion == INVERSION_AUTO));
+	} else {
+		/* Superseding	*/
+		original_inversion = fepriv->fe_params.inversion;
+		original_frequency = fepriv->fe_params.frequency;
+		if (fe->ops.get_info) {
+			fe->ops.get_info(fe, &fepriv->fe_info);
+		}
+		autoinversion = ((!(fepriv->fe_info.inversion & INVERSION_AUTO)) &&
+				 (fepriv->fe_params.inversion == INVERSION_AUTO));
+	}
 
 	/* setup parameters correctly */
 	while(!ready) {
@@ -330,17 +482,46 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 	dprintk("%s: drift:%i inversion:%i auto_step:%i "
 		"auto_sub_step:%i started_auto_step:%i\n",
 		__func__, fepriv->lnb_drift, fepriv->inversion,
-		fepriv->auto_step, fepriv->auto_sub_step, fepriv->started_auto_step);
+		fepriv->auto_step, fepriv->auto_sub_step,
+		fepriv->started_auto_step);
 
-	/* set the frontend itself */
-	fepriv->parameters.frequency += fepriv->lnb_drift;
-	if (autoinversion)
-		fepriv->parameters.inversion = fepriv->inversion;
-	if (fe->ops.set_frontend)
-		fe->ops.set_frontend(fe, &fepriv->parameters);
+	/* set the frontend itself	*/
+	/* Legacy	*/
+	if (fe->legacy)
+		fepriv->parameters.frequency += fepriv->lnb_drift;
+	else
+		/* Supeseding	*/
+		fepriv->fe_params.frequency += fepriv->lnb_drift;
 
-	fepriv->parameters.frequency = original_frequency;
-	fepriv->parameters.inversion = original_inversion;
+	if (autoinversion) {
+		/* Legacy	*/
+		if (fe->legacy)
+			fepriv->parameters.inversion = fepriv->inversion;
+		else
+			/* Superseding	*/
+			fepriv->fe_params.inversion = fepriv->inversion;
+	}
+	/* Legacy	*/
+	if (fe->legacy) {
+		if (fe->ops.set_frontend)
+			fe->ops.set_frontend(fe, &fepriv->parameters);
+	} else {
+//		if ((dvbfe_sanity_check(fe) == 0)) {
+			/* Superseding	*/
+			if (fe->ops.set_params)
+				fe->ops.set_params(fe, &fepriv->fe_params);
+//		} else
+//			return -EINVAL;
+	}
+	/* Legacy	*/
+	if (fe->legacy) {
+		fepriv->parameters.frequency = original_frequency;
+		fepriv->parameters.inversion = original_inversion;
+	} else {
+		/* Superseding	*/
+		fepriv->fe_params.frequency = original_frequency;
+		fepriv->fe_params.inversion = original_inversion;
+	}
 
 	fepriv->auto_sub_step++;
 	return 0;
@@ -355,19 +536,30 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 	if (fepriv->state & FESTATE_IDLE) {
 		fepriv->delay = 3*HZ;
 		fepriv->quality = 0;
-		return;
+		return 0;
 	}
 
 	/* in SCAN mode, we just set the frontend when asked and leave it alone */
 	if (fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT) {
 		if (fepriv->state & FESTATE_RETUNE) {
-			if (fe->ops.set_frontend)
-				fe->ops.set_frontend(fe, &fepriv->parameters);
+
+			if (fe->legacy) {
+				/* Legacy	*/
+				if (fe->ops.set_frontend)
+					fe->ops.set_frontend(fe, &fepriv->parameters);
+			} else {
+				if (dvbfe_sanity_check(fe) == 0) {
+					/* Superseding	*/
+					if (fe->ops.set_params)
+						fe->ops.set_params(fe, &fepriv->fe_params);
+				} else
+					return -EINVAL;
+			}
 			fepriv->state = FESTATE_TUNED;
 		}
 		fepriv->delay = 3*HZ;
 		fepriv->quality = 0;
-		return;
+		return 0;
 	}
 
 	/* get the frontend status */
@@ -388,11 +580,22 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 		fepriv->state = FESTATE_TUNED;
 
 		/* if we're tuned, then we have determined the correct inversion */
-		if ((!(fe->ops.info.caps & FE_CAN_INVERSION_AUTO)) &&
-		    (fepriv->parameters.inversion == INVERSION_AUTO)) {
-			fepriv->parameters.inversion = fepriv->inversion;
+		/* Legacy	*/
+		if (fe->legacy) {
+			if ((!(fe->ops.info.caps & FE_CAN_INVERSION_AUTO)) &&
+			    (fepriv->parameters.inversion == INVERSION_AUTO)) {
+				fepriv->parameters.inversion = fepriv->inversion;
+			}
+		} else {
+			/* Superseding	*/
+			if (fe->ops.get_info) {
+				fe->ops.get_info(fe, &fepriv->fe_info);
+				if ((!(fepriv->fe_info.inversion & INVERSION_AUTO)) &&
+				    (fepriv->fe_params.inversion == INVERSION_AUTO))
+					fepriv->fe_params.inversion = fepriv->inversion;
+			}
 		}
-		return;
+		return 0;
 	}
 
 	/* if we are tuned already, check we're still locked */
@@ -401,7 +604,7 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 
 		/* we're tuned, and the lock is still good... */
 		if (s & FE_HAS_LOCK) {
-			return;
+			return 0;
 		} else { /* if we _WERE_ tuned, but now don't have a lock */
 			fepriv->state = FESTATE_ZIGZAG_FAST;
 			fepriv->started_auto_step = fepriv->auto_step;
@@ -410,24 +613,43 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 	}
 
 	/* don't actually do anything if we're in the LOSTLOCK state,
-	 * the frontend is set to FE_CAN_RECOVER, and the max_drift is 0 */
-	if ((fepriv->state & FESTATE_LOSTLOCK) &&
-	    (fe->ops.info.caps & FE_CAN_RECOVER) && (fepriv->max_drift == 0)) {
-		dvb_frontend_swzigzag_update_delay(fepriv, s & FE_HAS_LOCK);
-		return;
+	 * the frontend is set to FE_CAN_RECOVER, and the max_drift is 0
+	 */
+	/* Legacy	*/
+	if (fe->legacy) {
+		if ((fepriv->state & FESTATE_LOSTLOCK) && (fepriv->max_drift == 0)) {
+			if (fe->ops.get_frontend_algo)
+				if (fe->ops.get_frontend_algo(fe) == DVBFE_ALGO_RECOVERY)
+					dvb_frontend_swzigzag_update_delay(fepriv, s & FE_HAS_LOCK);
+
+			return 0;
+		}
+	} else {
+		if (fepriv->state & FESTATE_LOSTLOCK) {
+			if (fe->ops.get_frontend_algo) {
+				if ((fe->ops.get_frontend_algo(fe) == DVBFE_ALGO_RECOVERY) &&
+				    (fepriv->max_drift == 0)) {
+
+					dvb_frontend_swzigzag_update_delay(fepriv, s & DVBFE_HAS_LOCK);
+					return 0;
+				}
+			}
+		}
 	}
 
 	/* don't do anything if we're in the DISEQC state, since this
 	 * might be someone with a motorized dish controlled by DISEQC.
-	 * If its actually a re-tune, there will be a SET_FRONTEND soon enough.	*/
+	 * If its actually a re-tune, there will be a SET_FRONTEND soon enough.
+	 */
 	if (fepriv->state & FESTATE_DISEQC) {
 		dvb_frontend_swzigzag_update_delay(fepriv, s & FE_HAS_LOCK);
-		return;
+		return 0;
 	}
 
 	/* if we're in the RETUNE state, set everything up for a brand
 	 * new scan, keeping the current inversion setting, as the next
-	 * tune is _very_ likely to require the same */
+	 * tune is _very_ likely to require the same
+	 */
 	if (fepriv->state & FESTATE_RETUNE) {
 		fepriv->lnb_drift = 0;
 		fepriv->auto_step = 0;
@@ -443,17 +665,19 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 		/* peform a tune */
 		if (dvb_frontend_swzigzag_autotune(fe, fepriv->check_wrapped)) {
 			/* OK, if we've run out of trials at the fast speed.
-			 * Drop back to slow for the _next_ attempt */
+			 * Drop back to slow for the _next_ attempt
+			 */
 			fepriv->state = FESTATE_SEARCHING_SLOW;
 			fepriv->started_auto_step = fepriv->auto_step;
-			return;
+			return 0;
 		}
 		fepriv->check_wrapped = 1;
 
 		/* if we've just retuned, enter the ZIGZAG_FAST state.
 		 * This ensures we cannot return from an
 		 * FE_SET_FRONTEND ioctl before the first frontend tune
-		 * occurs */
+		 * occurs
+		 */
 		if (fepriv->state & FESTATE_RETUNE) {
 			fepriv->state = FESTATE_TUNING_FAST;
 		}
@@ -464,9 +688,12 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 		dvb_frontend_swzigzag_update_delay(fepriv, s & FE_HAS_LOCK);
 
 		/* Note: don't bother checking for wrapping; we stay in this
-		 * state until we get a lock */
+		 * state until we get a lock
+		 */
 		dvb_frontend_swzigzag_autotune(fe, 0);
 	}
+
+	return 0;
 }
 
 static int dvb_frontend_is_exiting(struct dvb_frontend *fe)
@@ -509,7 +736,13 @@ static int dvb_frontend_thread(void *data)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	unsigned long timeout;
 	fe_status_t s;
+
+	enum dvbfe_algo algo;
+
+	/* Legacy datatype	*/
 	struct dvb_frontend_parameters *params;
+	/* Superseding datatype	*/
+	struct dvbfe_params *fe_params = &fepriv->fe_params;
 
 	dprintk("%s\n", __func__);
 
@@ -555,23 +788,78 @@ restart:
 
 		/* do an iteration of the tuning loop */
 		if (fe->ops.get_frontend_algo) {
-			if (fe->ops.get_frontend_algo(fe) == FE_ALGO_HW) {
-				/* have we been asked to retune? */
-				params = NULL;
+			algo = fe->ops.get_frontend_algo(fe);
+			switch (algo) {
+			case DVBFE_ALGO_HW:
+				dprintk("%s: Frontend ALGO = DVBFE_ALGO_HW\n", __func__);
+				params = NULL; /* have we been asked to RETUNE ?	*/
+
 				if (fepriv->state & FESTATE_RETUNE) {
+					dprintk("%s: Retune requested, FESTAT_RETUNE\n", __func__);
 					params = &fepriv->parameters;
 					fepriv->state = FESTATE_TUNED;
 				}
-
-				fe->ops.tune(fe, params, fepriv->tune_mode_flags, &fepriv->delay, &s);
+				if (fe->ops.tune) {
+					fe->ops.tune(fe, params, fepriv->tune_mode_flags, &fepriv->delay, &s);
+					dprintk("%s: TUNE callback exists at 0x%p\n", __func__, fe->ops.tune);
+				}
 				if (s != fepriv->status) {
+					dprintk("%s: state changed, adding current state\n", __func__);
 					dvb_frontend_add_event(fe, s);
 					fepriv->status = s;
 				}
-			} else
+				break;
+			case DVBFE_ALGO_SW:
+				dprintk("%s: Frontend ALGO = DVBFE_ALGO_SW\n", __func__);
 				dvb_frontend_swzigzag(fe);
-		} else
+				break;
+			case DVBFE_ALGO_CUSTOM:
+				params = NULL; /* have we been asked to RETUNE ?	*/
+				dprintk("%s: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=%d\n", __func__, fepriv->state);
+				if (fepriv->state & FESTATE_RETUNE) {
+					dprintk("%s: Retune requested, FESTAT_RETUNE\n", __func__);
+					fe_params = &fepriv->fe_params;
+					fepriv->state = FESTATE_TUNED;
+				}
+				/* Case where we are going to search for a carrier
+				 *
+				 * User asked us to retune again for some reason, possibly
+				 * requesting a search with a new set of parameters
+				 */
+				if (fepriv->algo_status & DVBFE_ALGO_SEARCH_AGAIN) {
+					if (fe->ops.search) {
+						fepriv->algo_status = fe->ops.search(fe, fe_params);
+						dprintk("%s: SEARCH callback exists at 0x%p\n", __func__, fe->ops.search);
+						/* We did do a search as was requested, the flags are
+						 * now unset as well and has the flags wrt to search.
+						 */
+					}
+					fepriv->algo_status &= ~DVBFE_ALGO_SEARCH_AGAIN;
+				}
+				/* Track the carrier if the search was successful	*/
+				if (fepriv->algo_status == DVBFE_ALGO_SEARCH_SUCCESS) {
+					if (fepriv->algo_status & DVBFE_ALGO_SEARCH_SUCCESS)
+						dprintk("%s: status = DVBFE_ALGO_SEARCH_SUCCESS\n", __func__);
+					if (fepriv->algo_status & DVBFE_ALGO_SEARCH_FAILED)
+						fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
+
+					fe->ops.read_status(fe, &s);
+					dvb_frontend_add_event(fe, s); /* update event list	*/
+					fepriv->status = s;
+					if (fe->ops.track) {
+						dprintk("%s: TRACK callback exists at 0x%p\n", __func__, fe->ops.track);
+						fe->ops.track(fe, fe_params);
+					}
+				}
+				break;
+			default:
+				dprintk("%s: UNDEFINED ALGO !\n", __func__);
+				break;
+			}
+
+		} else {
 			dvb_frontend_swzigzag(fe);
+		}
 	}
 
 	if (dvb_powerdown_on_sleep) {
@@ -589,6 +877,7 @@ restart:
 	fepriv->thread = NULL;
 	mb();
 
+	dprintk("%s: frontend_wakeup\n", __func__);
 	dvb_frontend_wakeup(fe);
 	return 0;
 }
@@ -762,6 +1051,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int err = -EOPNOTSUPP;
+	enum dvbfe_delsys delsys = 0;
 
 	dprintk ("%s\n", __func__);
 
@@ -947,12 +1237,10 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 			break;
 		}
 
-		memcpy (&fepriv->parameters, parg,
-			sizeof (struct dvb_frontend_parameters));
-
+		fe->legacy = 1;
+		memcpy(&fepriv->parameters, parg, sizeof (struct dvb_frontend_parameters));
 		memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
-		memcpy(&fetunesettings.parameters, parg,
-		       sizeof (struct dvb_frontend_parameters));
+		memcpy(&fetunesettings.parameters, parg, sizeof (struct dvb_frontend_parameters));
 
 		/* force auto frequency inversion if requested */
 		if (dvb_force_auto_inversion) {
@@ -1015,6 +1303,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		break;
 
 	case FE_GET_FRONTEND:
+		fe->legacy = 1;
 		if (fe->ops.get_frontend) {
 			memcpy (parg, &fepriv->parameters, sizeof (struct dvb_frontend_parameters));
 			err = fe->ops.get_frontend(fe, (struct dvb_frontend_parameters*) parg);
@@ -1025,6 +1314,108 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		fepriv->tune_mode_flags = (unsigned long) parg;
 		err = 0;
 		break;
+
+	case DVBFE_SET_PARAMS: {
+		struct dvb_frontend_tune_settings fetunesettings;
+
+		fe->legacy = 0;
+		memcpy(&fepriv->fe_params, parg, sizeof (struct dvbfe_params));
+		memset(&fetunesettings, 0, sizeof (struct dvb_frontend_tune_settings));
+		memcpy(&fetunesettings.fe_params, parg, sizeof (struct dvbfe_params));
+
+		/* Request the search algorithm to search	*/
+		fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
+
+		/* force auto frequency inversion if requested */
+		if (dvb_force_auto_inversion) {
+			fepriv->fe_params.inversion = DVBFE_INVERSION_AUTO;
+			fetunesettings.fe_params.inversion = DVBFE_INVERSION_AUTO;
+		}
+		if (fe->ops.get_delsys) {
+			fe->ops.get_delsys(fe, &delsys);
+			if ((delsys == DVBFE_DELSYS_DVBT) ||
+			    (delsys == DVBFE_DELSYS_DVBH)) {
+
+				/* without hierachical coding code_rate_LP is irrelevant,
+				 * so we tolerate the otherwise invalid FEC_NONE setting */
+				if (fepriv->fe_params.delsys.dvbt.hierarchy == DVBFE_HIERARCHY_OFF &&
+				    fepriv->fe_params.delsys.dvbt.code_rate_LP == DVBFE_FEC_NONE)
+
+					fepriv->fe_params.delsys.dvbt.code_rate_LP = DVBFE_FEC_AUTO;
+			}
+		}
+
+		/* get frontend-specific tuning settings */
+		if (fe->ops.get_tune_settings &&
+		   (fe->ops.get_tune_settings(fe, &fetunesettings) == 0)) {
+
+			fepriv->min_delay = (fetunesettings.min_delay_ms * HZ) / 1000;
+			fepriv->max_drift = fetunesettings.max_drift;
+			fepriv->step_size = fetunesettings.step_size;
+		} else {
+			/* default values */
+			switch (fepriv->fe_info.delivery) {
+			case DVBFE_DELSYS_DVBS:
+			case DVBFE_DELSYS_DSS:
+			case DVBFE_DELSYS_DVBS2:
+				fepriv->min_delay = HZ / 20;
+				fepriv->step_size = fepriv->fe_params.delsys.dvbs.symbol_rate / 16000;
+				fepriv->max_drift = fepriv->fe_params.delsys.dvbs.symbol_rate / 2000;
+				break;
+			case DVBFE_DELSYS_DVBC:
+				fepriv->min_delay = HZ / 20;
+				fepriv->step_size = 0; /* no zigzag */
+				fepriv->max_drift = 0;
+				break;
+			case DVBFE_DELSYS_DVBT:
+			case DVBFE_DELSYS_DVBH:
+				fepriv->min_delay = HZ / 20;
+				fepriv->step_size = fepriv->fe_info.frequency_step * 2;
+				fepriv->max_drift = (fepriv->fe_info.frequency_step * 2) + 1;
+				break;
+			case DVBFE_DELSYS_ATSC:
+				fepriv->min_delay = HZ / 20;
+				fepriv->step_size = 0;
+				fepriv->max_drift = 0;
+				break;
+			default:
+				return -EINVAL;
+			}
+		}
+		if (dvb_override_tune_delay > 0)
+			fepriv->min_delay = (dvb_override_tune_delay * HZ) / 1000;
+
+		fepriv->state = FESTATE_RETUNE;
+		printk("%s: FESTATE_RETUNE: fepriv->state=%d\n", __func__, fepriv->state);
+		dvb_frontend_wakeup(fe);
+		dvb_frontend_add_event(fe, 0);
+		fepriv->status = 0;
+		err = 0;
+		break;
+	}
+
+	case DVBFE_GET_PARAMS:
+		fe->legacy = 0;
+		if (fe->ops.get_params) {
+			memcpy(parg, &fepriv->fe_params, sizeof (struct dvbfe_params));
+			err = fe->ops.get_params(fe, (struct dvbfe_params *) parg);
+		}
+		break;
+	case DVBFE_GET_DELSYS:
+		fe->legacy = 0;
+		if (fe->ops.get_delsys) {
+			err = fe->ops.get_delsys(fe, (enum dvbfe_delsys *) parg);
+		}
+		break;
+	case DVBFE_GET_INFO:
+		printk("%s: DVBFE_GET_INFO\n", __func__);
+		fe->legacy = 0;
+		if (fe->ops.get_info) {
+			memcpy(&fepriv->fe_info, (struct dvbfe_info *) parg, sizeof (struct dvbfe_info));
+			err = fe->ops.get_info(fe, &fepriv->fe_info);
+			memcpy((struct dvbfe_info *) parg, &fepriv->fe_info, sizeof (struct dvbfe_info));
+		}
+		break;
 	};
 
 	up (&fepriv->sem);


--------------010400010202090505030104--
