Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYAIPpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYAIPpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYAIPox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:44:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49220 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYAIPow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:44:52 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [GIT PATCHES] V4L/DVB fixes
Date: Wed, 9 Jan 2008 16:43:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
References: <20080107073818.368243b9@gaivota>
In-Reply-To: <20080107073818.368243b9@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801091643.52658.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/MJRdEGo+Q/CuS/DcX1iBt+zo2/+vNcZw9AQC
 r37Au41yVdUvZsyaDregblEUWwUaW40OzZGg0Y9zO3KGYLB1vG
 rCKTaVNrycrrtHqqhqFIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 7. Januar 2008 schrieb Mauro Carvalho Chehab:
>
> Hans Verkuil (1):
>       V4L/DVB (6916): ivtv: udelay has to be changed *after* the eeprom
> was read, not before

boils down to this patch:

89dab3573aa1d95fd222ee4551f964bfa4c16823
 drivers/media/video/ivtv/ivtv-driver.c |    4 ++++
 drivers/media/video/ivtv/ivtv-i2c.c    |    5 +----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-driver.c 
b/drivers/media/video/ivtv/ivtv-driver.c
index 6d2dd87..10d6faf 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -1076,6 +1076,10 @@ static int __devinit ivtv_probe(struct pci_dev *dev,
 		ivtv_process_eeprom(itv);
 	}
 
+	/* The mspx4xx chips need a longer delay for some reason */
+	if (!(itv->hw_flags & IVTV_HW_MSP34XX))
+		itv->i2c_algo.udelay = 5;
+
 	if (itv->std == 0) {
 		itv->std = V4L2_STD_NTSC_M;
 	}
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c 
b/drivers/media/video/ivtv/ivtv-i2c.c
index 44678fe..36e54f7 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -541,7 +541,7 @@ static const struct i2c_algo_bit_data 
ivtv_i2c_algo_template = {
 	.setscl		= ivtv_setscl_old,
 	.getsda		= ivtv_getsda_old,
 	.getscl		= ivtv_getscl_old,
-	.udelay		= 5,
+	.udelay		= 10,
 	.timeout	= 200,
 };
 
@@ -718,9 +718,6 @@ int init_ivtv_i2c(struct ivtv *itv)
 		       sizeof(struct i2c_adapter));
 		memcpy(&itv->i2c_algo, &ivtv_i2c_algo_template,
 		       sizeof(struct i2c_algo_bit_data));
-		/* The mspx4xx chips need a longer delay for some reason */
-		if (itv->hw_flags & IVTV_HW_MSP34XX)
-			itv->i2c_algo.udelay = 10;
 		itv->i2c_algo.data = itv;
 		itv->i2c_adap.algo_data = &itv->i2c_algo;
 	}

where the logic in hunk #1 was switched, resulting in a now misleading 
comment over there.

How about something in the line of:

	/* 
	 * We started with a bigger udelay in order to fulfill the needs of the
	 * mspx4xx chips: cut it down here for all other members of the family.
	 */

Cheers,
Pete
