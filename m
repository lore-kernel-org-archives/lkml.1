Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbZEVVGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbZEVVGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757987AbZEVVEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:04:50 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:49940 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588AbZEVVEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:04:48 -0400
Message-Id: <bd12c9d9d160674dc960d9294af368200e5ac030.1243024967.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
References: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
Subject: [mISDN PATCH v2 07/19] Fix DTMF locking bug issue
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Fri, 22 May 2009 23:04:48 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Eversberg <andreas@eversberg.eu>

DTMF digits were sent up to socket in locked state.
Receive audio stream was not enabled in certain condition.

Signed-off-by: Andreas Eversberg <andreas@eversberg.eu>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    4 +-
 drivers/isdn/mISDN/dsp.h               |    2 +-
 drivers/isdn/mISDN/dsp_core.c          |   37 +++++++++++++++++--------------
 3 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index fc76f40..bc0d3ef 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -1817,8 +1817,8 @@ hfcmulti_dtmf(struct hfc_multi *hc)
 			coeff[(co<<1)|1] = mantissa;
 		}
 		if (debug & DEBUG_HFCMULTI_DTMF)
-			printk("%s: DTMF ready %08x %08x %08x %08x "
-			    "%08x %08x %08x %08x\n", __func__,
+			printk(" DTMF ready %08x %08x %08x %08x "
+			    "%08x %08x %08x %08x\n",
 			    coeff[0], coeff[1], coeff[2], coeff[3],
 			    coeff[4], coeff[5], coeff[6], coeff[7]);
 		hc->chan[ch].coeff_count++;
diff --git a/drivers/isdn/mISDN/dsp.h b/drivers/isdn/mISDN/dsp.h
index 4a1c444..41c6cfd 100644
--- a/drivers/isdn/mISDN/dsp.h
+++ b/drivers/isdn/mISDN/dsp.h
@@ -124,7 +124,7 @@ struct dsp_dtmf {
 		/* buffers one full dtmf frame */
 	u8		lastwhat, lastdigit;
 	int		count;
-	u8		digits[16]; /* just the dtmf result */
+	u8		digits[16]; /* dtmf result */
 };
 
 
diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 621ea9b..6b49398 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -311,6 +311,7 @@ dsp_control_req(struct dsp *dsp, struct mISDNhead *hh, struct sk_buff *skb)
 
 		/* check dtmf hardware */
 		dsp_dtmf_hardware(dsp);
+		dsp_rx_off(dsp);
 		break;
 	case DTMF_TONE_STOP: /* turn off DTMF */
 		if (dsp_debug & DEBUG_DSP_CORE)
@@ -657,11 +658,10 @@ get_features(struct mISDNchannel *ch)
 static int
 dsp_function(struct mISDNchannel *ch,  struct sk_buff *skb)
 {
-	struct dsp			*dsp = container_of(ch, struct dsp, ch);
+	struct dsp		*dsp = container_of(ch, struct dsp, ch);
 	struct mISDNhead	*hh;
 	int			ret = 0;
-	u8			*digits;
-	int			cont;
+	u8			*digits = NULL;
 	u_long			flags;
 
 	hh = mISDN_HEAD_P(skb);
@@ -716,40 +716,43 @@ dsp_function(struct mISDNchannel *ch,  struct sk_buff *skb)
 		/* change volume if requested */
 		if (dsp->rx_volume)
 			dsp_change_volume(skb, dsp->rx_volume);
-
 		/* check if dtmf soft decoding is turned on */
 		if (dsp->dtmf.software) {
 			digits = dsp_dtmf_goertzel_decode(dsp, skb->data,
 				skb->len, (dsp_options&DSP_OPT_ULAW)?1:0);
+		}
+		/* we need to process receive data if software */
+		if (dsp->pcm_slot_tx < 0 && dsp->pcm_slot_rx < 0) {
+			/* process data from card at cmx */
+			dsp_cmx_receive(dsp, skb);
+		}
+
+		spin_unlock_irqrestore(&dsp_lock, flags);
+
+		/* send dtmf result, if any */
+		if (digits) {
 			while (*digits) {
+				int k;
 				struct sk_buff *nskb;
 				if (dsp_debug & DEBUG_DSP_DTMF)
 					printk(KERN_DEBUG "%s: digit"
 					    "(%c) to layer %s\n",
 					    __func__, *digits, dsp->name);
-				cont = DTMF_TONE_VAL | *digits;
+				k = *digits | DTMF_TONE_VAL;
 				nskb = _alloc_mISDN_skb(PH_CONTROL_IND,
-				    MISDN_ID_ANY, sizeof(int), &cont,
-				    GFP_ATOMIC);
+					MISDN_ID_ANY, sizeof(int), &k,
+					GFP_ATOMIC);
 				if (nskb) {
 					if (dsp->up) {
 						if (dsp->up->send(
 						    dsp->up, nskb))
-						dev_kfree_skb(nskb);
+							dev_kfree_skb(nskb);
 					} else
 						dev_kfree_skb(nskb);
 				}
 				digits++;
 			}
 		}
-		/* we need to process receive data if software */
-		if (dsp->pcm_slot_tx < 0 && dsp->pcm_slot_rx < 0) {
-			/* process data from card at cmx */
-			dsp_cmx_receive(dsp, skb);
-		}
-
-		spin_unlock_irqrestore(&dsp_lock, flags);
-
 		if (dsp->rx_disabled) {
 			/* if receive is not allowed */
 			break;
@@ -789,7 +792,7 @@ dsp_function(struct mISDNchannel *ch,  struct sk_buff *skb)
 					if (dsp->up) {
 						if (dsp->up->send(
 						    dsp->up, nskb))
-						dev_kfree_skb(nskb);
+							dev_kfree_skb(nskb);
 					} else
 						dev_kfree_skb(nskb);
 				}
-- 
1.6.0.2

