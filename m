Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbYIDUWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbYIDUWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbYIDUWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:22:42 -0400
Received: from mail.work.de ([212.12.32.20]:34056 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbYIDUWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:22:41 -0400
Message-ID: <48C0438C.40807@gmail.com>
Date: Fri, 05 Sep 2008 00:22:36 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 1/31] userspace interface update
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------080902050008020701030204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080902050008020701030204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From b7610ae0277728a4ec1e63d9c047f5e07db07580 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 11:43:18 +0200
Subject: [PATCH] DVB Frontend API changes

* Add support for DSS, DVB-S2, DVB-H delivery systems,
modulations and other parameters

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>


 frontend.h |  386
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 379 insertions(+), 7 deletions(-)


--------------080902050008020701030204
Content-Type: text/x-patch;
 name="1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="1.patch"

>From b7610ae0277728a4ec1e63d9c047f5e07db07580 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 11:43:18 +0200
Subject: [PATCH] DVB Frontend API changes

* Add support for DSS, DVB-S2, DVB-H delivery systems,
modulations and other parameters

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index c8cbd90..b17c218 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -7,6 +7,8 @@
  *		    Andre Draszik <ad@convergence.de>
  *		    for convergence integrated media GmbH
  *
+ * Copyright (C) Manu Abraham <abraham.manu@gmail.com>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU Lesser General Public License
  * as published by the Free Software Foundation; either version 2.1
@@ -234,12 +236,6 @@ struct dvb_frontend_parameters {
 };
 
 
-struct dvb_frontend_event {
-	fe_status_t status;
-	struct dvb_frontend_parameters parameters;
-};
-
-
 /**
  * When set, this flag will disable any zigzagging or other "normal" tuning
  * behaviour. Additionally, there will be no automatic monitoring of the lock
@@ -270,8 +266,384 @@ struct dvb_frontend_event {
 #define FE_SET_FRONTEND		   _IOW('o', 76, struct dvb_frontend_parameters)
 #define FE_GET_FRONTEND		   _IOR('o', 77, struct dvb_frontend_parameters)
 #define FE_SET_FRONTEND_TUNE_MODE  _IO('o', 81) /* unsigned int */
-#define FE_GET_EVENT		   _IOR('o', 78, struct dvb_frontend_event)
 
 #define FE_DISHNETWORK_SEND_LEGACY_CMD _IO('o', 80) /* unsigned int */
 
+/*
+ * References:
+ * DVB-S : EN 300 421
+ * DVB-S2: EN 302 307, TR 102 376, EN 301 210
+ * DVB-C : EN 300 429
+ * DVB-T : EN 300 744
+ * DVB-H : EN 300 304
+ * ATSC  : A/53A
+ */
+
+/*
+ * Delivery Systems
+ * needs to set/queried for multistandard frontends
+ */
+enum dvbfe_delsys {
+	DVBFE_DELSYS_DVBS		= (1 <<  0),
+	DVBFE_DELSYS_DSS		= (1 <<  1),
+	DVBFE_DELSYS_DVBS2		= (1 <<  2),
+	DVBFE_DELSYS_DVBC		= (1 <<  3),
+	DVBFE_DELSYS_DVBT		= (1 <<  4),
+	DVBFE_DELSYS_DVBH		= (1 <<  5),
+	DVBFE_DELSYS_ATSC		= (1 <<  6),
+	DVBFE_DELSYS_DUMMY		= (1 << 31)
+};
+#define DVBFE_GET_DELSYS		_IOR('o', 82, enum dvbfe_delsys)
+
+/* Modulation types			*/
+enum dvbfe_modulation {
+	DVBFE_MOD_NONE			= (0 <<  0),
+	DVBFE_MOD_BPSK			= (1 <<  0),
+	DVBFE_MOD_QPSK			= (1 <<  1),
+	DVBFE_MOD_OQPSK			= (1 <<  2),
+	DVBFE_MOD_8PSK			= (1 <<  3),
+	DVBFE_MOD_16APSK		= (1 <<  4),
+	DVBFE_MOD_32APSK		= (1 <<  5),
+	DVBFE_MOD_QAM4			= (1 <<  6),
+	DVBFE_MOD_QAM16			= (1 <<  7),
+	DVBFE_MOD_QAM32			= (1 <<  8),
+	DVBFE_MOD_QAM64			= (1 <<  9),
+	DVBFE_MOD_QAM128		= (1 << 10),
+	DVBFE_MOD_QAM256		= (1 << 11),
+	DVBFE_MOD_QAM512		= (1 << 12),
+	DVBFE_MOD_QAM1024		= (1 << 13),
+	DVBFE_MOD_QAMAUTO		= (1 << 14),
+	DVBFE_MOD_OFDM			= (1 << 15),
+	DVBFE_MOD_COFDM			= (1 << 16),
+	DVBFE_MOD_VSB8			= (1 << 17),
+	DVBFE_MOD_VSB16			= (1 << 18),
+	DVBFE_MOD_AUTO			= (1 << 31)
+};
+
+/*
+ * Convolution Code Rate (Viterbi Inner Code Rate)
+ * DVB-S2 uses LDPC. Information on LDPC can be found at
+ * http://www.ldpc-codes.com
+ */
+enum dvbfe_fec {
+	DVBFE_FEC_NONE			= (0 <<  0),
+	DVBFE_FEC_1_4			= (1 <<  0),
+	DVBFE_FEC_1_3			= (1 <<  1),
+	DVBFE_FEC_2_5			= (1 <<  2),
+	DVBFE_FEC_1_2			= (1 <<  3),
+	DVBFE_FEC_3_5			= (1 <<  4),
+	DVBFE_FEC_2_3			= (1 <<  5),
+	DVBFE_FEC_3_4			= (1 <<  6),
+	DVBFE_FEC_4_5			= (1 <<  7),
+	DVBFE_FEC_5_6			= (1 <<  8),
+	DVBFE_FEC_6_7			= (1 <<  9),
+	DVBFE_FEC_7_8			= (1 << 10),
+	DVBFE_FEC_8_9			= (1 << 11),
+	DVBFE_FEC_9_10			= (1 << 12),
+	DVBFE_FEC_AUTO			= (1 << 31)
+};
+
+/* Frontend Inversion (I/Q Swap)	*/
+enum dvbfe_inversion {
+	DVBFE_INVERSION_OFF		= 0,
+	DVBFE_INVERSION_ON		= 1,
+	DVBFE_INVERSION_AUTO		= 2
+};
+
+/* DVB-S parameters			*/
+struct dvbs_params {
+	__u32				symbol_rate;
+
+	enum dvbfe_modulation		modulation;
+	enum dvbfe_fec			fec;
+};
+
+/* DSS parameters			*/
+struct dss_params {
+	__u32				symbol_rate;
+
+	enum dvbfe_modulation		modulation;
+	enum dvbfe_fec			fec;
+};
+
+/*
+ * Rolloff Rate (Nyquist Filter Rolloff)
+ * NOTE: DVB-S2 has rates of 0.20, 0.25, 0.35
+ * Values are x100
+ * Applies to DVB-S2
+ */
+enum dvbfe_rolloff {
+	DVBFE_ROLLOFF_35		= 0,
+	DVBFE_ROLLOFF_25		= 1,
+	DVBFE_ROLLOFF_20		= 2,
+	DVBFE_ROLLOFF_UNKNOWN		= 3
+};
+
+/* DVB-S2 parameters			*/
+struct dvbs2_params {
+	__u32				symbol_rate;
+
+	enum dvbfe_modulation		modulation;
+	enum dvbfe_fec			fec;
+
+	/* Informational fields only	*/
+	enum dvbfe_rolloff		rolloff;
+
+	__u8				matype_1;
+	__u8				matype_2;
+	__u8				upl_1;
+	__u8				upl_2;
+	__u8				dfl_1;
+	__u8				dfl_2;
+	__u8				sync;
+	__u8				syncd_1;
+	__u8				syncd_2;
+
+	__u8				pad[32];
+};
+
+/* DVB-C parameters			*/
+struct dvbc_params {
+	__u32				symbol_rate;
+	enum dvbfe_modulation		modulation;
+	enum dvbfe_fec			fec;
+};
+
+/* DVB-T Channel bandwidth		*/
+enum dvbfe_bandwidth {
+	DVBFE_BANDWIDTH_8_MHZ		= (1 <<  0),
+	DVBFE_BANDWIDTH_7_MHZ		= (1 <<  1),
+	DVBFE_BANDWIDTH_6_MHZ		= (1 <<  2),
+	DVBFE_BANDWIDTH_5_MHZ		= (1 <<  3),
+	DVBFE_BANDWIDTH_AUTO		= (1 << 31)
+};
+
+/* DVB-T/DVB-H transmission mode	*/
+enum dvbfe_transmission_mode {
+	DVBFE_TRANSMISSION_MODE_2K	= (1 <<  0),
+	DVBFE_TRANSMISSION_MODE_4K	= (1 <<  1),
+	DVBFE_TRANSMISSION_MODE_8K	= (1 <<  2),
+	DVBFE_TRANSMISSION_MODE_AUTO	= (1 << 31)
+};
+
+/* DVB-T/DVB-H Guard interval		*/
+enum dvbfe_guard_interval {
+	DVBFE_GUARD_INTERVAL_1_32	= (1 <<  1),
+	DVBFE_GUARD_INTERVAL_1_16	= (1 <<  2),
+	DVBFE_GUARD_INTERVAL_1_8	= (1 <<  3),
+	DVBFE_GUARD_INTERVAL_1_4	= (1 <<  4),
+	DVBFE_GUARD_INTERVAL_AUTO	= (1 << 31)
+};
+
+/* DVB-T/DVB-H Hierarchial modulation	*/
+enum dvbfe_hierarchy {
+	DVBFE_HIERARCHY_OFF		= (1 <<  0),
+	DVBFE_HIERARCHY_ON		= (1 <<  1),
+	DVBFE_HIERARCHY_AUTO		= (1 <<  2)
+};
+
+/* DVB-T/DVB-H Rolloff's		*/
+enum dvbfe_alpha {
+	DVBFE_ALPHA_1			= (1 <<  0),
+	DVBFE_ALPHA_2			= (1 <<  1),
+	DVBFE_ALPHA_4			= (1 <<  2)
+};
+
+/* Stream priority (Hierachial coding)	*/
+enum dvbfe_stream_priority {
+	DVBFE_STREAM_PRIORITY_HP	= (0 << 0),
+	DVBFE_STREAM_PRIORITY_LP	= (1 << 0)
+};
+
+/* DVB-T parameters			*/
+struct dvbt_params {
+	enum dvbfe_modulation		constellation;
+	enum dvbfe_bandwidth		bandwidth;
+	enum dvbfe_fec			code_rate_HP;
+	enum dvbfe_fec			code_rate_LP;
+	enum dvbfe_transmission_mode	transmission_mode;
+	enum dvbfe_guard_interval	guard_interval;
+	enum dvbfe_hierarchy		hierarchy;
+	enum dvbfe_alpha		alpha;
+	enum dvbfe_stream_priority	priority;
+
+	__u8				pad[32];
+};
+
+/* DVB-H Interleaver type		*/
+enum dvbfe_interleaver {
+	DVBFE_INTERLEAVER_NATIVE	= (1 <<  0),
+	DVBFE_INTERLEAVER_INDEPTH	= (1 <<  1),
+	DVBFE_INTERLEAVER_AUTO		= (1 << 31)
+};
+
+/* DVB-H MPE-FEC Indicator		*/
+enum dvbfe_mpefec {
+	DVBFE_MPEFEC_OFF		= (1 <<  0),
+	DVBFE_MPEFEC_ON			= (1 <<  1)
+};
+
+/* DVB-H Timeslicing Indicator		*/
+enum dvbfe_timeslicing {
+	DVBFE_TIMESLICING_OFF		= (1 <<  0),
+	DVBFE_TIMESLICING_ON		= (1 <<  1)
+};
+
+/* DVB-H parameters			*/
+struct dvbh_params {
+	enum dvbfe_modulation		constellation;
+	enum dvbfe_fec			code_rate_HP;
+	enum dvbfe_fec			code_rate_LP;
+	enum dvbfe_transmission_mode	transmission_mode;
+	enum dvbfe_guard_interval	guard_interval;
+	enum dvbfe_hierarchy		hierarchy;
+	enum dvbfe_alpha		alpha;
+	enum dvbfe_interleaver		interleaver;
+	enum dvbfe_mpefec		mpefec;
+	enum dvbfe_timeslicing		timeslicing;
+	enum dvbfe_stream_priority	priority;
+
+	__u32				bandwidth;
+	__u8				pad[32];
+};
+
+/* ATSC parameters			*/
+struct atsc_params {
+	enum dvbfe_modulation		modulation;
+
+	__u8				pad[32];
+};
+
+/* DVB Frontend Tuning Parameters	*/
+struct dvbfe_params {
+	__u32				frequency;
+	enum fe_spectral_inversion	inversion;
+	enum dvbfe_delsys		delivery;
+
+	__u8				pad[32];
+
+	union {
+		struct dvbs_params	dvbs;
+		struct dss_params	dss;
+		struct dvbs2_params	dvbs2;
+		struct dvbc_params	dvbc;
+		struct dvbt_params	dvbt;
+		struct dvbh_params	dvbh;
+		struct atsc_params	atsc;
+
+		__u8			pad[128];
+	} delsys;
+};
+#define DVBFE_SET_PARAMS		_IOW('o', 83, struct dvbfe_params)
+#define DVBFE_GET_PARAMS		_IOWR('o', 84, struct dvbfe_params)
+
+/* DVB-S capability bitfields		*/
+struct dvbfe_dvbs_info {
+	enum dvbfe_modulation		modulation;
+	enum dvbfe_fec			fec;
+};
+
+/* DSS capability bitfields		*/
+struct dvbfe_dss_info {
+	enum dvbfe_modulation		modulation;
+	enum dvbfe_fec			fec;
+};
+
+/* DVB-S2 capability bitfields		*/
+struct dvbfe_dvbs2_info {
+	enum dvbfe_modulation		modulation;
+	enum dvbfe_fec			fec;
+
+	__u8				pad[32];
+};
+
+/* DVB-C capability bitfields		*/
+struct dvbfe_dvbc_info {
+	enum dvbfe_modulation		modulation;
+};
+
+/* DVB-T capability bitfields		*/
+struct dvbfe_dvbt_info {
+	enum dvbfe_modulation		modulation;
+	enum dvbfe_stream_priority	stream_priority;
+
+	__u8				pad[32];
+};
+
+/* DVB-H capability bitfields		*/
+struct dvbfe_dvbh_info {
+	enum dvbfe_modulation		modulation;
+	enum dvbfe_stream_priority	stream_priority;
+
+	__u8				pad[32];
+};
+
+/* ATSC capability bitfields		*/
+struct dvbfe_atsc_info {
+	enum dvbfe_modulation		modulation;
+
+	__u8				pad[32];
+};
+
+/* DVB Frontend related Information	*/
+struct dvbfe_info {
+	char				name[128];
+
+	/* For Multi Standard tuners, set "delivery"
+	 * to the relevant delivery system to retrieve the
+	 * relevant delivery system related information.
+	 */
+	enum dvbfe_delsys		delivery;
+
+	union {
+		struct dvbfe_dvbs_info	dvbs;
+		struct dvbfe_dss_info	dss;
+		struct dvbfe_dvbs2_info	dvbs2;
+		struct dvbfe_dvbc_info	dvbc;
+		struct dvbfe_dvbt_info	dvbt;
+		struct dvbfe_dvbh_info	dvbh;
+		struct dvbfe_atsc_info	atsc;
+
+		__u8			pad[128];
+	} delsys;
+
+	__u32				frequency_min;
+	__u32				frequency_max;
+	__u32				frequency_step;
+	__u32				frequency_tolerance;
+	__u32				symbol_rate_min;
+	__u32				symbol_rate_max;
+	__u32				symbol_rate_tolerance;
+
+	enum fe_spectral_inversion	inversion;
+
+	__u8				pad[128];
+};
+#define DVBFE_GET_INFO			_IOWR('o', 85, struct dvbfe_info)
+
+enum dvbfe_status {
+	DVBFE_HAS_SIGNAL		= (1 <<  0),	/*  something above noise floor	*/
+	DVBFE_HAS_CARRIER		= (1 <<  1),	/*  Signal found		*/
+	DVBFE_HAS_VITERBI		= (1 <<  2),	/*  FEC is stable		*/
+	DVBFE_HAS_SYNC			= (1 <<  3),	/*  SYNC found			*/
+	DVBFE_HAS_LOCK			= (1 <<  4),	/*  OK ..			*/
+	DVBFE_TIMEDOUT			= (1 <<  5),	/*  no lock in last ~2 s	*/
+	DVBFE_STATUS_DUMMY		= (1 << 31)
+};
+
+/* DVB Frontend events			*/
+struct dvbfe_events {
+	enum dvbfe_status		status;
+
+	__u8				pad[32];
+};
+
+struct dvb_frontend_event {
+	fe_status_t status;
+	struct dvb_frontend_parameters parameters;
+	struct dvbfe_events fe_events;
+	struct dvbfe_params fe_params;
+};
+#define FE_GET_EVENT		   _IOR('o', 78, struct dvb_frontend_event)
+
 #endif /*_DVBFRONTEND_H_*/


--------------080902050008020701030204--
