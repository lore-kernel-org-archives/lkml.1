Return-Path: <linux-kernel-owner+w=401wt.eu-S1765881AbYEUAdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765881AbYEUAdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764882AbYEUAbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:31:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45303 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764827AbYEUAbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:31:32 -0400
To: mchehab@infradead.org
Subject: [PATCH] ttusb endianness annotations and fixes
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycEt-0004oE-Qm@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:31:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |    2 +-
 drivers/media/dvb/ttusb-dec/ttusb_dec.c           |   25 +++++++++++----------
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c          |   10 ++++----
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
index 732ce4d..5d2d81a 100644
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -552,7 +552,7 @@ static void ttusb_process_muxpack(struct ttusb *ttusb, const u8 * muxpack,
 	u16 csum = 0, cc;
 	int i;
 	for (i = 0; i < len; i += 2)
-		csum ^= le16_to_cpup((u16 *) (muxpack + i));
+		csum ^= le16_to_cpup((__le16 *) (muxpack + i));
 	if (csum) {
 		printk("%s: muxpack with incorrect checksum, ignoring\n",
 		       __func__);
diff --git a/drivers/media/dvb/ttusb-dec/ttusb_dec.c b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
index 42eee04..fefdc05 100644
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -343,7 +343,7 @@ static int ttusb_dec_get_stb_state (struct ttusb_dec *dec, unsigned int *mode,
 	u8 c[COMMAND_PACKET_SIZE];
 	int c_length;
 	int result;
-	unsigned int tmp;
+	__be32 tmp;
 
 	dprintk("%s\n", __func__);
 
@@ -398,9 +398,9 @@ static void ttusb_dec_set_pids(struct ttusb_dec *dec)
 		   0x00, 0x00, 0xff, 0xff,
 		   0xff, 0xff, 0xff, 0xff };
 
-	u16 pcr = htons(dec->pid[DMX_PES_PCR]);
-	u16 audio = htons(dec->pid[DMX_PES_AUDIO]);
-	u16 video = htons(dec->pid[DMX_PES_VIDEO]);
+	__be16 pcr = htons(dec->pid[DMX_PES_PCR]);
+	__be16 audio = htons(dec->pid[DMX_PES_AUDIO]);
+	__be16 video = htons(dec->pid[DMX_PES_VIDEO]);
 
 	dprintk("%s\n", __func__);
 
@@ -435,7 +435,7 @@ static void ttusb_dec_process_pva(struct ttusb_dec *dec, u8 *pva, int length)
 	case 0x01: {		/* VideoStream */
 		int prebytes = pva[5] & 0x03;
 		int postbytes = (pva[5] & 0x0c) >> 2;
-		u16 v_pes_payload_length;
+		__be16 v_pes_payload_length;
 
 		if (output_pva) {
 			dec->video_filter->feed->cb.ts(pva, length, NULL, 0,
@@ -1006,7 +1006,7 @@ static int ttusb_dec_start_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
 		    0x00, 0x00, 0x00, 0x00,
 		    0x00, 0x00, 0x00, 0x00,
 		    0x00 };
-	u16 pid;
+	__be16 pid;
 	u8 c[COMMAND_PACKET_SIZE];
 	int c_length;
 	int result;
@@ -1278,9 +1278,10 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 	u8 *firmware = NULL;
 	size_t firmware_size = 0;
 	u16 firmware_csum = 0;
-	u16 firmware_csum_ns;
-	u32 firmware_size_nl;
-	u32 crc32_csum, crc32_check, tmp;
+	__be16 firmware_csum_ns;
+	__be32 firmware_size_nl;
+	u32 crc32_csum, crc32_check;
+	__be32 tmp;
 	const struct firmware *fw_entry = NULL;
 
 	dprintk("%s\n", __func__);
@@ -1306,7 +1307,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 	   valid. */
 	crc32_csum = crc32(~0L, firmware, 56) ^ ~0L;
 	memcpy(&tmp, &firmware[56], 4);
-	crc32_check = htonl(tmp);
+	crc32_check = ntohl(tmp);
 	if (crc32_csum != crc32_check) {
 		printk("%s: crc32 check of DSP code failed (calculated "
 		       "0x%08x != 0x%08x in file), file invalid.\n",
@@ -1627,7 +1628,7 @@ static int ttusb_dec_probe(struct usb_interface *intf,
 
 	usb_set_intfdata(intf, (void *)dec);
 
-	switch (le16_to_cpu(id->idProduct)) {
+	switch (id->idProduct) {
 	case 0x1006:
 		ttusb_dec_set_model(dec, TTUSB_DEC3000S);
 		break;
@@ -1652,7 +1653,7 @@ static int ttusb_dec_probe(struct usb_interface *intf,
 	ttusb_dec_init_dvb(dec);
 
 	dec->adapter.priv = dec;
-	switch (le16_to_cpu(id->idProduct)) {
+	switch (id->idProduct) {
 	case 0x1006:
 		dec->fe = ttusbdecfe_dvbs_attach(&fe_config);
 		break;
diff --git a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
index eb5eaec..443af24 100644
--- a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
@@ -86,7 +86,7 @@ static int ttusbdecfe_dvbt_set_frontend(struct dvb_frontend* fe, struct dvb_fron
 		   0x00, 0x00, 0x00, 0xff,
 		   0x00, 0x00, 0x00, 0xff };
 
-	u32 freq = htonl(p->frequency / 1000);
+	__be32 freq = htonl(p->frequency / 1000);
 	memcpy(&b[4], &freq, sizeof (u32));
 	state->config->send_command(fe, 0x71, sizeof(b), b, NULL, NULL);
 
@@ -117,10 +117,10 @@ static int ttusbdecfe_dvbs_set_frontend(struct dvb_frontend* fe, struct dvb_fron
 		   0x00, 0x00, 0x00, 0x00,
 		   0x00, 0x00, 0x00, 0x00,
 		   0x00, 0x00, 0x00, 0x00 };
-	u32 freq;
-	u32 sym_rate;
-	u32 band;
-	u32 lnb_voltage;
+	__be32 freq;
+	__be32 sym_rate;
+	__be32 band;
+	__be32 lnb_voltage;
 
 	freq = htonl(p->frequency +
 	       (state->hi_band ? LOF_HI : LOF_LO));
-- 
1.5.3.GIT


