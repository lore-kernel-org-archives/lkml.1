Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861AbZLOFlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbZLOFlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZLOFlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:41:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46173 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbZLOFlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:41:12 -0500
Date: Tue, 15 Dec 2009 16:41:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>
Subject: linux-next: origin tree build failure
Message-Id: <20091215164108.45c9d766.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/mfd/twl4030-codec.c:29:31: error: linux/i2c/twl4030.h: No such file or directory

(there were more, but I assume that they all stem form this one).

Caused by commit 0b83ddebc6e884dc0221358cf68c461520fbdd8e ("MFD: twl4030:
add twl4030_codec MFD as a new child to the core") from Linus' tree
interacting with commit b07682b6056eb6701f8cb86aa5800e6f2ea7919b ("mfd:
Rename twl4030* driver files to enable re-use") also from Linus' tree.
This file seems to have been missed in the renaming.

I have applied this patch for today (please check):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 15 Dec 2009 16:33:10 +1100
Subject: [PATCH] mfd: fix for twl4030 renaming

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mfd/twl4030-codec.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/twl4030-codec.c b/drivers/mfd/twl4030-codec.c
index 77b9149..700b149 100644
--- a/drivers/mfd/twl4030-codec.c
+++ b/drivers/mfd/twl4030-codec.c
@@ -26,7 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/platform_device.h>
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl4030-codec.h>
 
@@ -56,7 +56,7 @@ static int twl4030_codec_set_resource(enum twl4030_codec_res id, int enable)
 	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
 	u8 val;
 
-	twl4030_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &val,
+	twl_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &val,
 			codec->resource[id].reg);
 
 	if (enable)
@@ -64,7 +64,7 @@ static int twl4030_codec_set_resource(enum twl4030_codec_res id, int enable)
 	else
 		val &= ~codec->resource[id].mask;
 
-	twl4030_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
+	twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
 					val, codec->resource[id].reg);
 
 	return val;
@@ -75,7 +75,7 @@ static inline int twl4030_codec_get_resource(enum twl4030_codec_res id)
 	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
 	u8 val;
 
-	twl4030_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &val,
+	twl_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &val,
 			codec->resource[id].reg);
 
 	return val;
@@ -183,7 +183,7 @@ static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Invalid audio_mclk\n");
 		return -EINVAL;
 	}
-	twl4030_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
+	twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
 					val, TWL4030_REG_APLL_CTL);
 
 	codec = kzalloc(sizeof(struct twl4030_codec), GFP_KERNEL);
-- 
1.6.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
