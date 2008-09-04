Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYIDSgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYIDSgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbYIDSfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:35:31 -0400
Received: from mail.work.de ([212.12.32.20]:54803 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbYIDSf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:35:26 -0400
Message-ID: <48C02A6A.7020501@gmail.com>
Date: Thu, 04 Sep 2008 22:35:22 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 2/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------000402060805090707090208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000402060805090707090208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 1d7134c1f2c34eade3ab5526ff301e98e97346a8 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 11:55:41 +0200
Subject: [PATCH] DVB Frontend driver API overhaul

* Add support for different frontend driver tuning algorithms
* Add support for tuning algorithms required by sophisticated
silicon tuners
* Add new callbacks for use with multistandard drivers

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>


 dvb_frontend.h |  151
+++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 146 insertions(+), 5 deletions(-)

--------------000402060805090707090208
Content-Type: text/x-patch;
 name="2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.patch"

>From 1d7134c1f2c34eade3ab5526ff301e98e97346a8 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 11:55:41 +0200
Subject: [PATCH] DVB Frontend driver API overhaul

* Add support for different frontend driver tuning algorithms
* Add support for tuning algorithms required by sophisticated
silicon tuners
* Add new callbacks for use with multistandard drivers

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index aa4133f..0621287 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -8,6 +8,9 @@
  * Overhauled by Holger Waechtler
  * Kernel I2C stuff by Michael Hunold <hunold@convergence.de>
  *
+ * Overhauled for Silicon Tuners, Search Algorithms and multiprotocol
+ * support by Manu Abraham <abraham.manu@gmail.com>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU Lesser General Public License
  * as published by the Free Software Foundation; either version 2.1
@@ -46,6 +49,7 @@ struct dvb_frontend_tune_settings {
 	int step_size;
 	int max_drift;
 	struct dvb_frontend_parameters parameters;
+	struct dvbfe_params fe_params;
 };

 struct dvb_frontend;
@@ -69,6 +73,124 @@ struct analog_parameters {
 	u64 std;
 };

+enum dvbfe_modcod {
+	DVBFE_MODCOD_DUMMY_PLFRAME	= 0,
+	DVBFE_MODCOD_QPSK_1_4,
+	DVBFE_MODCOD_QPSK_1_3,
+	DVBFE_MODCOD_QPSK_2_5,
+	DVBFE_MODCOD_QPSK_1_2,
+	DVBFE_MODCOD_QPSK_3_5,
+	DVBFE_MODCOD_QPSK_2_3,
+	DVBFE_MODCOD_QPSK_3_4,
+	DVBFE_MODCOD_QPSK_4_5,
+	DVBFE_MODCOD_QPSK_5_6,
+	DVBFE_MODCOD_QPSK_8_9,
+	DVBFE_MODCOD_QPSK_9_10,
+	DVBFE_MODCOD_8PSK_3_5,
+	DVBFE_MODCOD_8PSK_2_3,
+	DVBFE_MODCOD_8PSK_3_4,
+	DVBFE_MODCOD_8PSK_5_6,
+	DVBFE_MODCOD_8PSK_8_9,
+	DVBFE_MODCOD_8PSK_9_10,
+	DVBFE_MODCOD_16APSK_2_3,
+	DVBFE_MODCOD_16APSK_3_4,
+	DVBFE_MODCOD_16APSK_4_5,
+	DVBFE_MODCOD_16APSK_5_6,
+	DVBFE_MODCOD_16APSK_8_9,
+	DVBFE_MODCOD_16APSK_9_10,
+	DVBFE_MODCOD_32APSK_3_4,
+	DVBFE_MODCOD_32APSK_4_5,
+	DVBFE_MODCOD_32APSK_5_6,
+	DVBFE_MODCOD_32APSK_8_9,
+	DVBFE_MODCOD_32APSK_9_10,
+	DVBFE_MODCOD_RESERVED_1,
+	DVBFE_MODCOD_BPSK_1_3,
+	DVBFE_MODCOD_BPSK_1_4,
+	DVBFE_MODCOD_RESERVED_2
+};
+
+enum tuner_param {
+	DVBFE_TUNER_FREQUENCY		= (1 <<  0),
+	DVBFE_TUNER_TUNERSTEP		= (1 <<  1),
+	DVBFE_TUNER_IFFREQ		= (1 <<  2),
+	DVBFE_TUNER_BANDWIDTH		= (1 <<  3),
+	DVBFE_TUNER_REFCLOCK		= (1 <<  4),
+	DVBFE_TUNER_IQSENSE		= (1 <<  5),
+	DVBFE_TUNER_DUMMY		= (1 << 31)
+};
+
+/*
+ * ALGO_HW: (Hardware Algorithm)
+ * ----------------------------------------------------------------
+ * Devices that support this algorithm do everything in hardware
+ * and no software support is needed to handle them.
+ * Requesting these devices to LOCK is the only thing required,
+ * device is supposed to do everything in the hardware.
+ *
+ * ALGO_SW: (Software Algorithm)
+ * ----------------------------------------------------------------
+ * These are dumb devices, that require software to do everything
+ *
+ * ALGO_CUSTOM: (Customizable Agorithm)
+ * ----------------------------------------------------------------
+ * Devices having this algorithm can be customized to have specific
+ * algorithms in the frontend driver, rather than simply doing a
+ * software zig-zag. In this case the zigzag maybe hardware assisted
+ * or it maybe completely done in hardware. In all cases, usage of
+ * this algorithm, in conjunction with the search and track
+ * callbacks, utilizes the driver specific algorithm.
+ *
+ * ALGO_RECOVERY: (Recovery Algorithm)
+ * ----------------------------------------------------------------
+ * These devices has AUTO recovery capabilities from LOCK failure
+ */
+enum dvbfe_algo {
+	DVBFE_ALGO_HW			= (1 <<  0),
+	DVBFE_ALGO_SW			= (1 <<  1),
+	DVBFE_ALGO_CUSTOM		= (1 <<  2),
+	DVBFE_ALGO_RECOVERY		= (1 <<  31)
+};
+
+struct tuner_state {
+	u32 frequency;
+	u32 tunerstep;
+	u32 ifreq;
+	u32 bandwidth;
+	u32 iqsense;
+	u32 refclock;
+};
+
+/*
+ * search callback possible return status
+ *
+ * DVBFE_ALGO_SEARCH_SUCCESS
+ * The frontend search algorithm completed and returned succesfully
+ *
+ * DVBFE_ALGO_SEARCH_ASLEEP
+ * The frontend search algorithm is sleeping
+ *
+ * DVBFE_ALGO_SEARCH_FAILED
+ * The frontend search for a signal failed
+ *
+ * DVBFE_ALGO_SEARCH_INVALID
+ * The frontend search algorith was probably supplied with invalid
+ * parameters and the search is an invalid one
+ *
+ * DVBFE_ALGO_SEARCH_ERROR
+ * The frontend search algorithm failed due to some error
+ *
+ * DVBFE_ALGO_SEARCH_AGAIN
+ * The frontend search algorithm was requested to search again
+ */
+enum dvbfe_search {
+	DVBFE_ALGO_SEARCH_SUCCESS	= (1 <<  0),
+	DVBFE_ALGO_SEARCH_ASLEEP	= (1 <<  1),
+	DVBFE_ALGO_SEARCH_FAILED	= (1 <<  2),
+	DVBFE_ALGO_SEARCH_INVALID	= (1 <<  3),
+	DVBFE_ALGO_SEARCH_AGAIN		= (1 <<  4),
+	DVBFE_ALGO_SEARCH_ERROR		= (1 << 31),
+};
+
 struct dvb_tuner_ops {

 	struct dvb_tuner_info info;
@@ -95,10 +217,12 @@ struct dvb_tuner_ops {
 	int (*get_status)(struct dvb_frontend *fe, u32 *status);
 	int (*get_rf_strength)(struct dvb_frontend *fe, u16 *strength);

-	/** These are provided seperately from set_params in order to facilitate silicon
-	 * tuners which require sophisticated tuning loops, controlling each parameter seperately. */
-	int (*set_frequency)(struct dvb_frontend *fe, u32 frequency);
-	int (*set_bandwidth)(struct dvb_frontend *fe, u32 bandwidth);
+	/**
+	 * These are provided seperately from set_params in order to facilitate silicon
+	 * tuners which require sophisticated tuning loops, controlling each parameter seperately.
+	 */
+	int (*set_state)(struct dvb_frontend *fe, enum tuner_param param, struct tuner_state *state);
+	int (*get_state)(struct dvb_frontend *fe, enum tuner_param param, struct tuner_state *state);
 };

 struct analog_demod_info {
@@ -142,7 +266,7 @@ struct dvb_frontend_ops {
 		    unsigned int *delay,
 		    fe_status_t *status);
 	/* get frontend tuning algorithm from the module */
-	int (*get_frontend_algo)(struct dvb_frontend *fe);
+	enum dvbfe_algo (*get_frontend_algo)(struct dvb_frontend *fe);

 	/* these two are only used for the swzigzag code */
 	int (*set_frontend)(struct dvb_frontend* fe, struct dvb_frontend_parameters* params);
@@ -167,6 +291,18 @@ struct dvb_frontend_ops {
 	int (*i2c_gate_ctrl)(struct dvb_frontend* fe, int enable);
 	int (*ts_bus_ctrl)(struct dvb_frontend* fe, int acquire);

+	/* These callbacks are based on the superseding IOCTL's	*/
+	int (*set_params)(struct dvb_frontend *fe, struct dvbfe_params *fe_params);
+	int (*get_params)(struct dvb_frontend *fe, struct dvbfe_params *fe_params);
+	int (*get_info)(struct dvb_frontend *fe, struct dvbfe_info *fe_info);
+	int (*get_delsys)(struct dvb_frontend *fe, enum dvbfe_delsys *fe_delsys);
+
+	/* These callbacks are for devices that implement their own
+	 * tuning algorithms, rather than a simple swzigzag
+	 */
+	enum dvbfe_search (*search)(struct dvb_frontend *fe, struct dvbfe_params *fe_params);
+	int (*track)(struct dvb_frontend *fe, struct dvbfe_params *fe_params);
+
 	struct dvb_tuner_ops tuner_ops;
 	struct analog_demod_ops analog_ops;
 };
@@ -190,6 +326,7 @@ struct dvb_frontend {
 	void *frontend_priv;
 	void *sec_priv;
 	void *analog_demod_priv;
+	u32 legacy;
 };

 extern int dvb_register_frontend(struct dvb_adapter *dvb,
@@ -204,4 +341,8 @@ extern void dvb_frontend_reinitialise(struct dvb_frontend *fe);
 extern void dvb_frontend_sleep_until(struct timeval *waketime, u32 add_usec);
 extern s32 timeval_usec_diff(struct timeval lasttime, struct timeval curtime);

+extern void decode_dvbs2_modcod(u32 modcod,
+				enum dvbfe_modulation *modulation,
+				enum dvbfe_fec *fec);
+
 #endif

--------------000402060805090707090208--
