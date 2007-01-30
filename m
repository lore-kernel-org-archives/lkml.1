Return-Path: <linux-kernel-owner+w=401wt.eu-S1751569AbXA3Vfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbXA3Vfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXA3Vfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:35:42 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:33847 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbXA3Vfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:35:41 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 16:35:40 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding:Sender:Reply-To;
	b=oKINdxL1KQ028aVWKoDynu0lmI6gV6PQn9CK5Ffk38YNpSTDVPUfHtCI0/xePcA+7VGprNj4N+2r8etQwZfTHsQQV2qjXy/vE/5az/ZAHgJpX8qqo7C9PGftaHkshiKf;
Message-ID: <45BFB8F5.5010607@simon.arlott.org.uk>
Date: Tue, 30 Jan 2007 21:30:29 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] cxacru: Store all device status information and report
 it when atm_proc_read is called.
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Reply-To: Simon Arlott <e5d74fcd64729b17de1hc0yh0003aeoo@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is much more (useful) line status information than is output through usbatm, this patch stores the status array and overrides atm_proc_read to output all of it.

This change may affect users polling the /proc/net/atm/cxacru file for line up/down status, however better status information is already provided through INFO level printks.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>

---
 drivers/usb/atm/cxacru.c |  144 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 144 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 1fa0844..1049e34 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -159,6 +159,7 @@ struct cxacru_data {
 
 	int line_status;
 	struct delayed_work poll_work;
+	u32 cxinf_status[CXINF_MAX];
 
 	/* contol handles */
 	struct mutex cm_serialize;
@@ -170,6 +171,146 @@ struct cxacru_data {
 	struct completion snd_done;
 };
 
+static int cxacru_proc_read(struct usbatm_data *usbatm_instance,
+	struct atm_dev *atm_dev, loff_t * pos, char *page)
+{
+	struct cxacru_data *instance = usbatm_instance->driver_data;
+	u32 *cxinf = instance->cxinf_status;
+	int left = *pos;
+
+	if (!left--)
+		return sprintf(page, "# %s\n", usbatm_instance->description);
+
+	if (!left--) {
+		if (cxinf[CXINF_LINE_STATUS] == 5) {
+			return sprintf(page, "# UP %u/%u\n",
+				cxinf[CXINF_DOWNSTREAM_RATE],
+				cxinf[CXINF_UPSTREAM_RATE]);
+		} else {
+			return sprintf(page, "# DOWN\n");
+		}
+	}
+
+	if (!left--)
+		return sprintf(page, "MAC=%02x:%02x:%02x:%02x:%02x:%02x\n",
+					atm_dev->esi[0], atm_dev->esi[1],
+					atm_dev->esi[2], atm_dev->esi[3],
+					atm_dev->esi[4], atm_dev->esi[5]);
+
+	if (!left--)
+		switch (cxinf[CXINF_LINK_STATUS]) {
+		case 1: return sprintf(page, "LINK_STATUS=\"not connected\"\n");
+		case 2: return sprintf(page, "LINK_STATUS=\"connected\"\n");
+		case 3: return sprintf(page, "LINK_STATUS=\"lost\"\n");
+		default:
+			return sprintf(page, "LINK_STATUS=\"unknown (%u)\"\n",
+						cxinf[CXINF_LINK_STATUS]);
+		}
+
+	if (!left--)
+		switch (cxinf[CXINF_LINE_STATUS]) {
+		case 0: return sprintf(page, "LINE_STATUS=\"down\"\n");
+		case 1: return sprintf(page, "LINE_STATUS=\"attempting to activate\"\n");
+		case 2: return sprintf(page, "LINE_STATUS=\"training\"\n");
+		case 3: return sprintf(page, "LINE_STATUS=\"channel analysis\"\n");
+		case 4: return sprintf(page, "LINE_STATUS=\"exchange\"\n");
+		case 5: return sprintf(page, "LINE_STATUS=\"up\"\n");
+		case 6: return sprintf(page, "LINE_STATUS=\"waiting\"\n");
+		case 7: return sprintf(page, "LINE_STATUS=\"initialising\"\n");
+		default:
+			return sprintf(page, "LINE_STATUS=\"unknown (%u)\"\n",
+						cxinf[CXINF_LINE_STATUS]);
+		}
+
+	if (!left--)
+		return sprintf(page, "\n");
+
+	if (cxinf[CXINF_LINE_STATUS] == 5) /* up */
+		if (!left--)
+			return sprintf(page, "DOWNSTREAM_RATE=%u\n",
+					cxinf[CXINF_DOWNSTREAM_RATE]);
+	if (!left--)
+		return sprintf(page,
+			"DOWNSTREAM_SNR_MARGIN=%d.%02u\n"
+			"DOWNSTREAM_ATTENUATION=%d.%02u\n"
+			"DOWNSTREAM_BITS_PER_FRAME=%u\n"
+			"DOWNSTREAM_CRC_ERRORS=%u\n"
+			"DOWNSTREAM_FEC_ERRORS=%u\n"
+			"DOWNSTREAM_HEC_ERRORS=%u\n"
+			"\n",
+			cxinf[CXINF_DOWNSTREAM_SNR_MARGIN] / 100,
+			cxinf[CXINF_DOWNSTREAM_SNR_MARGIN] % 100,
+			cxinf[CXINF_DOWNSTREAM_ATTENUATION] / 100,
+			cxinf[CXINF_DOWNSTREAM_ATTENUATION] % 100,
+			cxinf[CXINF_DOWNSTREAM_BITS_PER_FRAME],
+			cxinf[CXINF_DOWNSTREAM_CRC_ERRORS],
+			cxinf[CXINF_DOWNSTREAM_FEC_ERRORS],
+			cxinf[CXINF_DOWNSTREAM_HEC_ERRORS]);
+
+	if (cxinf[CXINF_LINE_STATUS] == 5) /* up */
+		if (!left--)
+			return sprintf(page, "UPSTREAM_RATE=%u\n",
+					cxinf[CXINF_UPSTREAM_RATE]);
+	if (!left--)
+		return sprintf(page,
+			"UPSTREAM_SNR_MARGIN=%d.%02u\n"
+			"UPSTREAM_ATTENUATION=%d.%02u\n"
+			"UPSTREAM_BITS_PER_FRAME=%u\n"
+			"UPSTREAM_CRC_ERRORS=%u\n"
+			"UPSTREAM_FEC_ERRORS=%u\n"
+			"UPSTREAM_HEC_ERRORS=%u\n"
+			"TRANSMITTER_POWER=%d\n"
+			"\n",
+			cxinf[CXINF_UPSTREAM_SNR_MARGIN] / 100,
+			cxinf[CXINF_UPSTREAM_SNR_MARGIN] % 100,
+			cxinf[CXINF_UPSTREAM_ATTENUATION] / 100,
+			cxinf[CXINF_UPSTREAM_ATTENUATION] % 100,
+			cxinf[CXINF_UPSTREAM_BITS_PER_FRAME],
+			cxinf[CXINF_UPSTREAM_CRC_ERRORS],
+			cxinf[CXINF_UPSTREAM_FEC_ERRORS],
+			cxinf[CXINF_UPSTREAM_HEC_ERRORS],
+			cxinf[CXINF_TRANSMITTER_POWER] - 256);
+
+	if (!left--)
+		return sprintf(page,
+			"AAL5_TX=%u\n"
+			"AAL5_TX_ERR=%u\n"
+			"AAL5_RX=%u\n"
+			"AAL5_RX_ERR=%u\n"
+			"AAL5_RX_DROP=%u\n"
+			"\n",
+			atomic_read(&atm_dev->stats.aal5.tx),
+			atomic_read(&atm_dev->stats.aal5.tx_err),
+			atomic_read(&atm_dev->stats.aal5.rx),
+			atomic_read(&atm_dev->stats.aal5.rx_err),
+			atomic_read(&atm_dev->stats.aal5.rx_drop));
+
+	if (!left--)
+		return sprintf(page,
+			"ADSL_HEADEND=%u\n"
+			"ADSL_HEADEND_ENVIRONMENT=%u\n"
+			"STARTUP_ATTEMPTS=%u\n"
+			"LINE_STARTABLE=%u\n"
+			"CONTROLLER_VERSION=%u\n",
+			cxinf[CXINF_ADSL_HEADEND],
+			cxinf[CXINF_ADSL_HEADEND_ENVIRONMENT],
+			cxinf[CXINF_STARTUP_ATTEMPTS],
+			cxinf[CXINF_LINE_STARTABLE],
+			cxinf[CXINF_CONTROLLER_VERSION]);
+
+	if (!left--)
+		switch (cxinf[CXINF_MODULATION]) {
+		case 1: return sprintf(page, "MODULATION=\"ANSI T1.413\"\n");
+		case 2: return sprintf(page, "MODULATION=\"ITU-T G.992.1 (G.DMT)\"\n");
+		case 3: return sprintf(page, "MODULATION=\"ITU-T G.992.2 (G.LITE)\"\n");
+		default:
+			return sprintf(page, "MODULATION=\"unknown (%u)\"\n",
+						cxinf[CXINF_MODULATION]);
+		}
+
+	return 0;
+}
+
 /* the following three functions are stolen from drivers/usb/core/message.c */
 static void cxacru_blocking_completion(struct urb *urb)
 {
@@ -395,6 +536,8 @@ static void cxacru_poll_status(struct wo
 		goto reschedule;
 	}
 
+	memcpy(instance->cxinf_status, buf, sizeof(instance->cxinf_status));
+
 	if (instance->line_status == buf[CXINF_LINE_STATUS])
 		goto reschedule;
 
@@ -842,6 +985,7 @@ static struct usbatm_driver cxacru_drive
 	.heavy_init	= cxacru_heavy_init,
 	.unbind		= cxacru_unbind,
 	.atm_start	= cxacru_atm_start,
+	.proc_read	= cxacru_proc_read,
 	.bulk_in	= CXACRU_EP_DATA,
 	.bulk_out	= CXACRU_EP_DATA,
 	.rx_padding	= 3,
-- 
1.4.3.1


-- 
Simon Arlott (subscribed to lkml, don't CC)
