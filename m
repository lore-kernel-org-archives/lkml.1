Return-Path: <linux-kernel-owner+w=401wt.eu-S1422768AbXCGRjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422768AbXCGRjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422801AbXCGRP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:15:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:43314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422822AbXCGRPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:46 -0500
Message-Id: <20070307171408.650932330@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 052/101] V4L: cx88-blackbird: allow usage of 376836 and 262144 sized firmware images
Content-Disposition: inline; filename=v4l-cx88-blackbird-allow-usage-of-376836-and-262144-sized-firmware-images.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Michael Krufky <mkrufky@linuxtv.org>

This updates the cx88-blackbird driver to be able to use the new cx23416
firmware image released by Hauppauge Computer Works, while retaining
compatibility with the older firmware images.
cx2341x firmware can be downloaded at: http://dl.ivtvdriver.org/ivtv/firmware/

(cherry picked from commit af70dbd3346999570db73b3bc3d4f7b7c004f2ea)

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx88/cx88-blackbird.c |   14 +++++++++-----
 drivers/media/video/cx88/cx88.h           |    1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

--- linux-2.6.20.1.orig/drivers/media/video/cx88/cx88-blackbird.c
+++ linux-2.6.20.1/drivers/media/video/cx88/cx88-blackbird.c
@@ -53,7 +53,8 @@ MODULE_PARM_DESC(debug,"enable debug mes
 
 /* ------------------------------------------------------------------ */
 
-#define BLACKBIRD_FIRM_IMAGE_SIZE 256*1024
+#define OLD_BLACKBIRD_FIRM_IMAGE_SIZE 262144
+#define     BLACKBIRD_FIRM_IMAGE_SIZE 376836
 
 /* defines below are from ivtv-driver.h */
 
@@ -401,7 +402,7 @@ static int blackbird_find_mailbox(struct
 	u32 value;
 	int i;
 
-	for (i = 0; i < BLACKBIRD_FIRM_IMAGE_SIZE; i++) {
+	for (i = 0; i < dev->fw_size; i++) {
 		memory_read(dev->core, i, &value);
 		if (value == signature[signaturecnt])
 			signaturecnt++;
@@ -449,12 +450,15 @@ static int blackbird_load_firmware(struc
 		return -1;
 	}
 
-	if (firmware->size != BLACKBIRD_FIRM_IMAGE_SIZE) {
-		dprintk(0, "ERROR: Firmware size mismatch (have %zd, expected %d)\n",
-			firmware->size, BLACKBIRD_FIRM_IMAGE_SIZE);
+	if ((firmware->size != BLACKBIRD_FIRM_IMAGE_SIZE) &&
+	    (firmware->size != OLD_BLACKBIRD_FIRM_IMAGE_SIZE)) {
+		dprintk(0, "ERROR: Firmware size mismatch (have %zd, expected %d or %d)\n",
+			firmware->size, BLACKBIRD_FIRM_IMAGE_SIZE,
+			OLD_BLACKBIRD_FIRM_IMAGE_SIZE);
 		release_firmware(firmware);
 		return -1;
 	}
+	dev->fw_size = firmware->size;
 
 	if (0 != memcmp(firmware->data, magic, 8)) {
 		dprintk(0, "ERROR: Firmware magic mismatch, wrong file?\n");
--- linux-2.6.20.1.orig/drivers/media/video/cx88/cx88.h
+++ linux-2.6.20.1/drivers/media/video/cx88/cx88.h
@@ -459,6 +459,7 @@ struct cx8802_dev {
 	u32                        mailbox;
 	int                        width;
 	int                        height;
+	int                        fw_size;
 
 	/* for dvb only */
 	struct videobuf_dvb        dvb;

--
