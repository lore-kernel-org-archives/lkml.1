Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYGVA3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYGVA3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbYGVA3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:29:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:9567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbYGVA3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:29:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=rJtJJGNTJCkhlHsKswSA3Cv1mGxvkgSWD7JvU1XkSALO5py0MlcYNpFskK7R/7PSnB
         E/oyJXlNwUi3FrpOCmIlKADQ+OOBx0POl0Au93QsWrQSytNb6XpjYMrkTtro+ngIgsTQ
         oef8FaNQdU8xt5Fa6ggP2lSoOn61Wtgj54Zvc=
Message-ID: <488529D4.10007@gmail.com>
Date: Mon, 21 Jul 2008 20:29:08 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: hverkuil@xs4all.nl, ivtv-devel@ivtvdriver.org, video4linux-list@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] ivtv: test below 0 on unsigned has_ir
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

u32 has_ir, member of struct tveeprom is unsigned,
so assignment of -1 and subsequent tests fail

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---

diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 797e636..7d909f9 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -465,7 +465,7 @@ static void ivtv_process_eeprom(struct ivtv *itv)
 		itv->options.radio = (tv.has_radio != 0);
 	/* only enable newi2c if an IR blaster is present */
 	/* FIXME: for 2.6.20 the test against 2 should be removed */
-	if (itv->options.newi2c == -1 && tv.has_ir != -1 && tv.has_ir != 2) {
+	if (itv->options.newi2c == -1 && tv.has_ir != ~0 && tv.has_ir != 2) {
 		itv->options.newi2c = (tv.has_ir & 2) ? 1 : 0;
 		if (itv->options.newi2c) {
 		    IVTV_INFO("Reopen i2c bus for IR-blaster support\n");
diff --git a/drivers/media/video/tveeprom.c b/drivers/media/video/tveeprom.c
index 9da0e18..41c22a7 100644
--- a/drivers/media/video/tveeprom.c
+++ b/drivers/media/video/tveeprom.c
@@ -483,7 +483,7 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 			tvee->has_radio = eeprom_data[i+len-1];
 			/* old style tag, don't know how to detect
 			IR presence, mark as unknown. */
-			tvee->has_ir = -1;
+			tvee->has_ir = ~0;
 			tvee->model =
 				eeprom_data[i+8] +
 				(eeprom_data[i+9] << 8);
@@ -703,7 +703,7 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 		tveeprom_info("decoder processor is %s (idx %d)\n",
 			STRM(decoderIC, tvee->decoder_processor),
 			tvee->decoder_processor);
-	if (tvee->has_ir == -1)
+	if (tvee->has_ir == ~0)
 		tveeprom_info("has %sradio\n",
 				tvee->has_radio ? "" : "no ");
 	else
