Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbZEVVJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbZEVVJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbZEVVFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:05:04 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:48330 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180AbZEVVE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:04:57 -0400
Message-Id: <4df523cf314b1890e64eceb29def2bce41cbdffc.1243024967.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
References: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
Subject: [mISDN PATCH v2 19/19] Fix DTMF detection enable/disable
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Fri, 22 May 2009 23:04:58 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Eversberg <andreas@eversberg.eu>

DTMF detection was enabled when it was not supposed to.

Signed-off-by: Andreas Eversberg <andreas@eversberg.eu>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/mISDN/dsp.h      |    1 +
 drivers/isdn/mISDN/dsp_core.c |    2 ++
 drivers/isdn/mISDN/dsp_dtmf.c |    3 +++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp.h b/drivers/isdn/mISDN/dsp.h
index 564ea3e..18af868 100644
--- a/drivers/isdn/mISDN/dsp.h
+++ b/drivers/isdn/mISDN/dsp.h
@@ -116,6 +116,7 @@ struct dsp_conf {
 #define ECHOCAN_BUFF_MASK 0x3ff /* -1 */
 
 struct dsp_dtmf {
+	int		enable; /* dtmf is enabled */
 	int		treshold; /* above this is dtmf (square of) */
 	int		software; /* dtmf uses software decoding */
 	int		hardware; /* dtmf uses hardware decoding */
diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index c357506..c12cd2f 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -306,6 +306,7 @@ dsp_control_req(struct dsp *dsp, struct mISDNhead *hh, struct sk_buff *skb)
 					"to %d\n", *((int *)data));
 			dsp->dtmf.treshold = (*(int *)data) * 10000;
 		}
+		dsp->dtmf.enable = 1;
 		/* init goertzel */
 		dsp_dtmf_goertzel_init(dsp);
 
@@ -316,6 +317,7 @@ dsp_control_req(struct dsp *dsp, struct mISDNhead *hh, struct sk_buff *skb)
 	case DTMF_TONE_STOP: /* turn off DTMF */
 		if (dsp_debug & DEBUG_DSP_CORE)
 			printk(KERN_DEBUG "%s: stop dtmf\n", __func__);
+		dsp->dtmf.enable = 0;
 		dsp->dtmf.hardware = 0;
 		dsp->dtmf.software = 0;
 		break;
diff --git a/drivers/isdn/mISDN/dsp_dtmf.c b/drivers/isdn/mISDN/dsp_dtmf.c
index efc371c..9ae2d33 100644
--- a/drivers/isdn/mISDN/dsp_dtmf.c
+++ b/drivers/isdn/mISDN/dsp_dtmf.c
@@ -51,6 +51,9 @@ void dsp_dtmf_hardware(struct dsp *dsp)
 {
 	int hardware = 1;
 
+	if (!dsp->dtmf.enable)
+		return;
+
 	if (!dsp->features.hfc_dtmf)
 		hardware = 0;
 
-- 
1.6.0.2

