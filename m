Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZESOyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZESOyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbZESOxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:53:52 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:59090 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbZESOxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:53:51 -0400
Message-Id: <e12a2192b193c0b4069258d9d5c753298317cfb2.1242739648.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
Subject: [PATCH 04/19] Add watchdog functionality to hfcmulti driver
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Tue, 19 May 2009 15:58:25 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Eversberg <andreas@eversberg.eu>

This patch was made by Titus Moldovan and provides IOCTL functions for enabling
and disabling the controller's built in watchdog. The use is optional.

Signed-off-by: Andreas Eversberg <andreas@eversberg.eu>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/hardware/mISDN/hfc_multi.h |    1 +
 drivers/isdn/hardware/mISDN/hfcmulti.c  |   32 ++++++++++++++++++++++++++++++-
 include/linux/mISDNif.h                 |    3 +-
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfc_multi.h b/drivers/isdn/hardware/mISDN/hfc_multi.h
index 545b3f9..b1517dd 100644
--- a/drivers/isdn/hardware/mISDN/hfc_multi.h
+++ b/drivers/isdn/hardware/mISDN/hfc_multi.h
@@ -102,6 +102,7 @@ struct hfcm_hw {
 	u_char	r_sci_msk;
 	u_char	r_tx0, r_tx1;
 	u_char	a_st_ctrl0[8];
+	u_char	r_bert_wd_md;
 	timer_t	timer;
 };
 
diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 30831d7..9bd85ae 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -4191,11 +4191,41 @@ open_bchannel(struct hfc_multi *hc, struct dchannel *dch,
 static int
 channel_dctrl(struct dchannel *dch, struct mISDN_ctrl_req *cq)
 {
+	struct hfc_multi	*hc = dch->hw;
 	int	ret = 0;
+	int	wd_mode, wd_cnt;
 
 	switch (cq->op) {
 	case MISDN_CTRL_GETOP:
-		cq->op = 0;
+		cq->op = MISDN_CTRL_HFC_OP;
+		break;
+	case MISDN_CTRL_HFC_WD_INIT: /* init the watchdog */
+		wd_cnt = cq->p1 & 0xf;
+		wd_mode = !!(cq->p1 >> 4);
+		if (debug & DEBUG_HFCMULTI_MSG)
+			printk(KERN_DEBUG
+			    "%s: MISDN_CTRL_HFC_WD_INIT mode %s counter 0x%x\n",
+			    __func__, wd_mode ? "AUTO" : "MANUAL", wd_cnt);
+		/* set the watchdog timer */
+		HFC_outb(hc, R_TI_WD, poll_timer | (wd_cnt << 4));
+		hc->hw.r_bert_wd_md = (wd_mode ? V_AUTO_WD_RES : 0);
+		if (hc->ctype == HFC_TYPE_XHFC)
+			hc->hw.r_bert_wd_md |= 0x40 /* V_WD_EN */;
+		/* init the watchdog register and reset the counter */
+		HFC_outb(hc, R_BERT_WD_MD, hc->hw.r_bert_wd_md | V_WD_RES);
+		if (test_bit(HFC_CHIP_PLXSD, &hc->chip)) {
+			/* enable the watchdog output for Speech-Design */
+			HFC_outb(hc, R_GPIO_SEL, V_GPIO_SEL7);
+			HFC_outb(hc, R_GPIO_EN1, V_GPIO_EN15);
+			HFC_outb(hc, R_GPIO_OUT1, 0);
+			HFC_outb(hc, R_GPIO_OUT1, V_GPIO_OUT15);
+		}
+		break;
+	case MISDN_CTRL_HFC_WD_RESET: /* reset the watchdog counter */
+		if (debug & DEBUG_HFCMULTI_MSG)
+			printk(KERN_DEBUG "%s: MISDN_CTRL_HFC_WD_RESET\n",
+			    __func__);
+		HFC_outb(hc, R_BERT_WD_MD, hc->hw.r_bert_wd_md | V_WD_RES);
 		break;
 	default:
 		printk(KERN_WARNING "%s: unknown Op %x\n",
diff --git a/include/linux/mISDNif.h b/include/linux/mISDNif.h
index 5da3d95..cf97459 100644
--- a/include/linux/mISDNif.h
+++ b/include/linux/mISDNif.h
@@ -362,7 +362,8 @@ clear_channelmap(u_int nr, u_char *map)
 #define MISDN_CTRL_HFC_RECEIVE_ON	0x4006
 #define MISDN_CTRL_HFC_ECHOCAN_ON 	0x4007
 #define MISDN_CTRL_HFC_ECHOCAN_OFF 	0x4008
-
+#define MISDN_CTRL_HFC_WD_INIT		0x4009
+#define MISDN_CTRL_HFC_WD_RESET		0x400A
 
 /* socket options */
 #define MISDN_TIME_STAMP		0x0001
-- 
1.6.0.2

