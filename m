Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab0BRP7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:59:46 -0500
Received: from www.linuxtv.org ([130.149.80.248]:42264 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758474Ab0BRP7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:59:24 -0500
Subject: [git:v4l-dvb/master] V4L/DVB: tm6000: only register after initialized
From: Patch from Mauro Carvalho Chehab 
	<linuxtv-commits-bounces@linuxtv.org>
To: linuxtv-commits@linuxtv.org
Data: Fri, 12 Feb 2010 03:51:43 -0300
Cc: Mocean Laboratories <info@mocean-labs.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-kernel@vger.kernel.org, Kang Yong <kangyong@telegent.com>,
       Huang Shijie <shijie8@gmail.com>, Zhang Xiaobing <xbzhang@telegent.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Richard Rojfors <richard.rojfors@pelagicore.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1Ni8UK-00087I-Bw@www.linuxtv.org>
Date: Thu, 18 Feb 2010 16:40:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@redhat.com>

Udev calls an utility when it senses a v4l device. So, register needs
to be delayed, otherwise it may cause block conditions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/staging/tm6000/tm6000-cards.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

---

http://git.linuxtv.org/v4l-dvb.git?a=commit;h=8509e90e868c7eb832a34435e5be284bfce545f7

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index ff04bba..8297801 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -453,11 +453,6 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 	if (rc<0)
 		goto err;
 
-	/* register and initialize V4L2 */
-	rc=tm6000_v4l2_register(dev);
-	if (rc<0)
-		goto err;
-
 	/* Default values for STD and resolutions */
 	dev->width = 720;
 	dev->height = 480;
@@ -480,12 +475,18 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 			"tvaudio", "tvaudio", I2C_ADDR_TDA9874, NULL);
 
+	/* register and initialize V4L2 */
+	rc=tm6000_v4l2_register(dev);
+	if (rc<0)
+		goto err;
+
 	if(dev->caps.has_dvb) {
 		dev->dvb = kzalloc(sizeof(*(dev->dvb)), GFP_KERNEL);
 		if(!dev->dvb) {
 			rc = -ENOMEM;
 			goto err2;
 		}
+
 #ifdef CONFIG_VIDEO_TM6000_DVB
 		rc = tm6000_dvb_register(dev);
 		if(rc < 0) {
