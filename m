Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbYIDShU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbYIDShU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbYIDSf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:35:58 -0400
Received: from mail.work.de ([212.12.32.20]:58857 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624AbYIDSf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:35:56 -0400
Message-ID: <48C02A87.3020403@gmail.com>
Date: Thu, 04 Sep 2008 22:35:51 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 4/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------000609010400000301020107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000609010400000301020107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 398e5176385e8779f7d88eaa2856085248d690fc Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:16:58 +0200
Subject: [PATCH] DVB Frontend backward compatibility support

* Add backward compatibility support for older applications
and drivers to be used by the updated frontend API

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>


 dvb_frontend.c |  392
++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 dvb_frontend.h |   10 +
 2 files changed, 401 insertions(+), 1 deletion(-)

--------------000609010400000301020107
Content-Type: text/x-patch;
 name="4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="4.patch"

>From 398e5176385e8779f7d88eaa2856085248d690fc Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:16:58 +0200
Subject: [PATCH] DVB Frontend backward compatibility support

* Add backward compatibility support for older applications
and drivers to be used by the updated frontend API

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index da7283c..feebac0 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -8,7 +8,9 @@
  *				      for convergence integrated media GmbH
  *
  * Copyright (C) 2004 Andrew de Quincey (tuning thread cleanup)
- * Copyright (C) Manu Abraham (Multi protocol support)
+ *
+ * Multi protocol support and backward compatibility
+ * Copyright (C) Manu Abraham
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -188,6 +190,386 @@ void decode_dvbs2_modcod(u32 dvbfe_modcod,
 }
 EXPORT_SYMBOL(decode_dvbs2_modcod);
 
+static int newfec_to_oldfec(enum dvbfe_fec new_fec, enum fe_code_rate *old_fec)
+{
+	switch (new_fec) {
+	case DVBFE_FEC_NONE:
+		*old_fec = FEC_NONE;
+		break;
+	case DVBFE_FEC_1_2:
+		*old_fec = FEC_1_2;
+		break;
+	case DVBFE_FEC_2_3:
+		*old_fec = FEC_2_3;
+		break;
+	case DVBFE_FEC_3_4:
+		*old_fec = FEC_3_4;
+		break;
+	case DVBFE_FEC_4_5:
+		*old_fec = FEC_4_5;
+		break;
+	case DVBFE_FEC_5_6:
+		*old_fec = FEC_5_6;
+		break;
+	case DVBFE_FEC_6_7:
+		*old_fec = FEC_6_7;
+		break;
+	case DVBFE_FEC_7_8:
+		*old_fec = FEC_7_8;
+		break;
+	case DVBFE_FEC_8_9:
+		*old_fec = FEC_8_9;
+		break;
+	case DVBFE_FEC_AUTO:
+		*old_fec = FEC_AUTO;
+		break;
+	default:
+		printk("%s: Unsupported FEC\n", __func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int oldfec_to_newfec(enum fe_code_rate old_fec, enum dvbfe_fec *new_fec)
+{
+	switch (old_fec) {
+	case FEC_NONE:
+		*new_fec = DVBFE_FEC_NONE;
+		break;
+	case FEC_1_2:
+		*new_fec = DVBFE_FEC_1_2;
+		break;
+	case FEC_2_3:
+		*new_fec = DVBFE_FEC_2_3;
+		break;
+	case FEC_3_4:
+		*new_fec = DVBFE_FEC_3_4;
+		break;
+	case FEC_4_5:
+		*new_fec = DVBFE_FEC_4_5;
+		break;
+	case FEC_5_6:
+		*new_fec = DVBFE_FEC_5_6;
+		break;
+	case FEC_6_7:
+		*new_fec = DVBFE_FEC_6_7;
+		break;
+	case FEC_7_8:
+		*new_fec = DVBFE_FEC_7_8;
+		break;
+	case FEC_8_9:
+		*new_fec = DVBFE_FEC_8_9;
+		break;
+	case FEC_AUTO:
+		*new_fec = DVBFE_FEC_AUTO;
+		break;
+	default:
+		printk("%s: Unsupported FEC\n", __func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int newmod_to_oldmod(enum dvbfe_modulation new_mod, enum fe_modulation *old_mod)
+{
+	switch (new_mod) {
+	case DVBFE_MOD_QPSK:
+		*old_mod = QPSK;
+		break;
+	case DVBFE_MOD_QAM16:
+		*old_mod = QAM_16;
+		break;
+	case DVBFE_MOD_QAM32:
+		*old_mod = QAM_32;
+		break;
+	case DVBFE_MOD_QAM64:
+		*old_mod = QAM_64;
+		break;
+	case DVBFE_MOD_QAM128:
+		*old_mod = QAM_128;
+		break;
+	case DVBFE_MOD_QAM256:
+		*old_mod = QAM_256;
+		break;
+	case DVBFE_MOD_QAMAUTO:
+		*old_mod = QAM_AUTO;
+		break;
+	case DVBFE_MOD_VSB8:
+		*old_mod = VSB_8;
+		break;
+	case DVBFE_MOD_VSB16:
+		*old_mod = VSB_16;
+		break;
+	default:
+		printk("%s: Unsupported Modulation\n", __func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int oldmod_to_newmod(enum fe_modulation old_mod, enum dvbfe_modulation *new_mod)
+{
+	switch (old_mod) {
+	case QPSK:
+		*new_mod = DVBFE_MOD_QPSK;
+		break;
+	case QAM_16:
+		*new_mod = DVBFE_MOD_QAM16;
+		break;
+	case QAM_32:
+		*new_mod = DVBFE_MOD_QAM32;
+		break;
+	case QAM_64:
+		*new_mod = DVBFE_MOD_QAM64;
+		break;
+	case QAM_128:
+		*new_mod = DVBFE_MOD_QAM128;
+		break;
+	case QAM_256:
+		*new_mod = DVBFE_MOD_QAM256;
+		break;
+	case QAM_AUTO:
+		*new_mod = DVBFE_MOD_AUTO;
+		break;
+	case VSB_8:
+		*new_mod = DVBFE_MOD_VSB8;
+		break;
+	case VSB_16:
+		*new_mod = DVBFE_MOD_VSB16;
+		break;
+	default:
+		printk("%s: Unsupported Modulation\n", __func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int newapi_to_olddrv(struct dvbfe_params *params,
+		     struct dvb_frontend_parameters *p,
+		     enum dvbfe_delsys delsys)
+{
+	struct dvb_qpsk_parameters	*qpsk	= &p->u.qpsk;
+	struct dvb_qam_parameters	*qam	= &p->u.qam;
+	struct dvb_ofdm_parameters	*ofdm	= &p->u.ofdm;
+	struct dvb_vsb_parameters	*vsb	= &p->u.vsb;
+
+	struct dvbs_params		*dvbs	= &params->delsys.dvbs;
+	struct dvbc_params		*dvbc	= &params->delsys.dvbc;
+	struct dvbt_params		*dvbt	= &params->delsys.dvbt;
+	struct atsc_params		*atsc	= &params->delsys.atsc;
+
+	p->frequency = params->frequency;
+	p->inversion = params->inversion;
+
+	switch (delsys) {
+	case DVBFE_DELSYS_DVBS:
+		qpsk->symbol_rate		= dvbs->symbol_rate;
+		newfec_to_oldfec(dvbs->fec, &qpsk->fec_inner);
+		break;
+	case DVBFE_DELSYS_DVBC:
+		qam->symbol_rate		= dvbc->symbol_rate;
+		newmod_to_oldmod(dvbc->modulation, &qam->modulation);
+		newfec_to_oldfec(dvbc->fec, &qam->fec_inner);
+		break;
+	case DVBFE_DELSYS_DVBT:
+		switch (dvbt->bandwidth) {
+		case DVBFE_BANDWIDTH_8_MHZ:
+			ofdm->bandwidth		= BANDWIDTH_8_MHZ;
+			break;
+		case DVBFE_BANDWIDTH_7_MHZ:
+			ofdm->bandwidth		= BANDWIDTH_7_MHZ;
+			break;
+		case DVBFE_BANDWIDTH_6_MHZ:
+			ofdm->bandwidth		= BANDWIDTH_6_MHZ;
+			break;
+		case DVBFE_BANDWIDTH_AUTO:
+			ofdm->bandwidth		= BANDWIDTH_AUTO;
+			break;
+		default:
+			dprintk("%s: Unsupported bandwidth\n", __func__);
+			return -EINVAL;
+		}
+		newfec_to_oldfec(dvbt->code_rate_HP, &ofdm->code_rate_HP);
+		newfec_to_oldfec(dvbt->code_rate_LP, &ofdm->code_rate_LP);
+		newmod_to_oldmod(dvbt->constellation, &ofdm->constellation);
+		switch (dvbt->transmission_mode) {
+		case DVBFE_TRANSMISSION_MODE_2K:
+			ofdm->transmission_mode = TRANSMISSION_MODE_2K;
+			break;
+		case DVBFE_TRANSMISSION_MODE_8K:
+			ofdm->transmission_mode = TRANSMISSION_MODE_8K;
+			break;
+		case DVBFE_TRANSMISSION_MODE_AUTO:
+			ofdm->transmission_mode = TRANSMISSION_MODE_AUTO;
+			break;
+		default:
+			dprintk("%s: Unsupported transmission mode\n", __func__);
+			return -EINVAL;
+		}
+		switch (dvbt->guard_interval) {
+		case DVBFE_GUARD_INTERVAL_1_32:
+			ofdm->guard_interval	= GUARD_INTERVAL_1_32;
+			break;
+		case DVBFE_GUARD_INTERVAL_1_16:
+			ofdm->guard_interval	= GUARD_INTERVAL_1_16;
+			break;
+		case DVBFE_GUARD_INTERVAL_1_8:
+			ofdm->guard_interval	= GUARD_INTERVAL_1_8;
+			break;
+		case DVBFE_GUARD_INTERVAL_1_4:
+			ofdm->guard_interval	= GUARD_INTERVAL_1_4;
+			break;
+		case DVBFE_GUARD_INTERVAL_AUTO:
+			ofdm->guard_interval	= GUARD_INTERVAL_AUTO;
+			break;
+		}
+		switch (dvbt->hierarchy) {
+		case DVBFE_HIERARCHY_OFF:
+			ofdm->hierarchy_information		= HIERARCHY_NONE;
+			break;
+		case DVBFE_HIERARCHY_AUTO:
+			ofdm->hierarchy_information		= HIERARCHY_AUTO;
+			break;
+		case DVBFE_HIERARCHY_ON:
+			switch (dvbt->alpha) {
+			case DVBFE_ALPHA_1:
+				ofdm->hierarchy_information	= HIERARCHY_1;
+				break;
+			case DVBFE_ALPHA_2:
+				ofdm->hierarchy_information	= HIERARCHY_2;
+				break;
+			case DVBFE_ALPHA_4:
+				ofdm->hierarchy_information	= HIERARCHY_4;
+				break;
+			}
+			break;
+		}
+	case DVBFE_DELSYS_ATSC:
+		newmod_to_oldmod(atsc->modulation, &vsb->modulation);
+		break;
+	case DVBFE_DELSYS_DVBS2:
+	case DVBFE_DELSYS_DSS:
+	case DVBFE_DELSYS_DVBH:
+		printk("%s: SORRY ! Backward compatibility unavailable for these delivery systems !!\n", __func__);
+		break;
+	default:
+		dprintk("%s: Unsupported delivery system\n", __func__);
+		return -EINVAL;
+		break;
+	}
+	return 0;
+}
+
+int olddrv_to_newapi(struct dvb_frontend *fe,
+		     struct dvbfe_params *params,
+		     struct dvb_frontend_parameters *p,
+		     enum fe_type fe_type)
+{
+	struct dvb_qpsk_parameters	*qpsk	= &p->u.qpsk;
+	struct dvb_qam_parameters	*qam	= &p->u.qam;
+	struct dvb_ofdm_parameters	*ofdm	= &p->u.ofdm;
+	struct dvb_vsb_parameters	*vsb	= &p->u.vsb;
+
+	struct dvbs_params		*dvbs	= &params->delsys.dvbs;
+	struct dvbc_params		*dvbc	= &params->delsys.dvbc;
+	struct dvbt_params		*dvbt	= &params->delsys.dvbt;
+	struct atsc_params		*atsc	= &params->delsys.atsc;
+
+	params->frequency = p->frequency;
+	params->inversion = p->inversion;
+
+	switch (fe_type) {
+	case FE_QPSK:
+		dvbs->symbol_rate		= qpsk->symbol_rate;
+		oldfec_to_newfec(qpsk->fec_inner, &dvbs->fec);
+		break;
+	case FE_QAM:
+		dvbc->symbol_rate		= qam->symbol_rate;
+		oldmod_to_newmod(qam->modulation, &dvbc->modulation);
+		oldfec_to_newfec(qam->fec_inner, &dvbc->fec);
+		break;
+	case FE_OFDM:
+		switch (ofdm->bandwidth) {
+		case BANDWIDTH_8_MHZ:
+			dvbt->bandwidth		= DVBFE_BANDWIDTH_8_MHZ;
+			break;
+		case BANDWIDTH_7_MHZ:
+			dvbt->bandwidth		= DVBFE_BANDWIDTH_7_MHZ;
+			break;
+		case BANDWIDTH_6_MHZ:
+			dvbt->bandwidth		= DVBFE_BANDWIDTH_6_MHZ;
+			break;
+		case BANDWIDTH_AUTO:
+			dvbt->bandwidth		= DVBFE_BANDWIDTH_AUTO;
+			break;
+		}
+		oldfec_to_newfec(ofdm->code_rate_HP, &dvbt->code_rate_HP);
+		oldfec_to_newfec(ofdm->code_rate_LP, &dvbt->code_rate_LP);
+		oldmod_to_newmod(ofdm->constellation, &dvbt->constellation);
+		switch (ofdm->transmission_mode) {
+		case TRANSMISSION_MODE_2K:
+			dvbt->transmission_mode	= DVBFE_TRANSMISSION_MODE_2K;
+			break;
+		case TRANSMISSION_MODE_8K:
+			dvbt->transmission_mode = DVBFE_TRANSMISSION_MODE_8K;
+			break;
+		case TRANSMISSION_MODE_AUTO:
+			dvbt->transmission_mode	= DVBFE_TRANSMISSION_MODE_AUTO;
+			break;
+		}
+		switch (ofdm->guard_interval) {
+		case GUARD_INTERVAL_1_32:
+			dvbt->guard_interval	= DVBFE_GUARD_INTERVAL_1_32;
+			break;
+		case GUARD_INTERVAL_1_16:
+			dvbt->guard_interval	= DVBFE_GUARD_INTERVAL_1_16;
+			break;
+		case GUARD_INTERVAL_1_8:
+			dvbt->guard_interval	= DVBFE_GUARD_INTERVAL_1_8;
+			break;
+		case GUARD_INTERVAL_1_4:
+			dvbt->guard_interval	= DVBFE_GUARD_INTERVAL_1_4;
+			break;
+		case GUARD_INTERVAL_AUTO:
+			dvbt->guard_interval	= DVBFE_GUARD_INTERVAL_AUTO;
+			break;
+		}
+		switch (ofdm->hierarchy_information) {
+		case HIERARCHY_NONE:
+			dvbt->hierarchy		= DVBFE_HIERARCHY_OFF;
+			break;
+		case HIERARCHY_AUTO:
+			dvbt->hierarchy		= DVBFE_HIERARCHY_AUTO;
+			break;
+		case HIERARCHY_1:
+			dvbt->hierarchy		= DVBFE_HIERARCHY_ON;
+			dvbt->alpha		= DVBFE_ALPHA_1;
+			break;
+		case HIERARCHY_2:
+			dvbt->hierarchy		= DVBFE_HIERARCHY_ON;
+			dvbt->alpha		= DVBFE_ALPHA_2;
+			break;
+		case HIERARCHY_4:
+			dvbt->hierarchy		= DVBFE_HIERARCHY_ON;
+			dvbt->alpha		= DVBFE_ALPHA_4;
+			break;
+		}
+		break;
+	case FE_ATSC:
+		newmod_to_oldmod(atsc->modulation, &vsb->modulation);
+		break;
+	default:
+		dprintk("%s: Unsupported delivery system\n", __func__);
+		return -EINVAL;
+		break;
+	}
+	return 0;
+}
+
 static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
@@ -1323,6 +1705,9 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		memset(&fetunesettings, 0, sizeof (struct dvb_frontend_tune_settings));
 		memcpy(&fetunesettings.fe_params, parg, sizeof (struct dvbfe_params));
 
+		if (newapi_to_olddrv(&fepriv->fe_params, &fepriv->parameters, fepriv->fe_info.delivery)  == -EINVAL)
+			printk("%s: ERROR !!! Converting New parameters --> Old parameters\n", __func__);
+
 		/* Request the search algorithm to search	*/
 		fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
 
@@ -1399,6 +1784,11 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		if (fe->ops.get_params) {
 			memcpy(parg, &fepriv->fe_params, sizeof (struct dvbfe_params));
 			err = fe->ops.get_params(fe, (struct dvbfe_params *) parg);
+		} else if (fe->ops.get_frontend) {
+			memcpy (parg, &fepriv->parameters, sizeof (struct dvb_frontend_parameters));
+			err = fe->ops.get_frontend(fe, (struct dvb_frontend_parameters*) parg);
+			if (olddrv_to_newapi(fe, &fepriv->fe_params, &fepriv->parameters, fe->ops.info.type) == -EINVAL)
+				printk("%s: ERROR !!! Converting Old parameters --> New parameters\n", __func__);
 		}
 		break;
 	case DVBFE_GET_DELSYS:
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 0621287..84eb7d9 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -345,4 +345,14 @@ extern void decode_dvbs2_modcod(u32 modcod,
 				enum dvbfe_modulation *modulation,
 				enum dvbfe_fec *fec);
 
+
+extern int newapi_to_olddrv(struct dvbfe_params *params,
+			    struct dvb_frontend_parameters *p,
+			    enum dvbfe_delsys delsys);
+
+extern int olddrv_to_newapi(struct dvb_frontend *fe,
+			    struct dvbfe_params *params,
+			    struct dvb_frontend_parameters *p,
+			    enum fe_type fe_type);
+
 #endif

--------------000609010400000301020107--
