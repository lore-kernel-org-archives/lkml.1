Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbYEKHZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbYEKHZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 03:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYEKHZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 03:25:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58927 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYEKHZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 03:25:13 -0400
Date: Sun, 11 May 2008 09:21:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Michael Krufky <mkrufky@linuxtv.org>, Mike Isely <isely@pobox.com>
Subject: [patch] video: build fix for drivers/media/video/pvrusb2/
Message-ID: <20080511072137.GA16772@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86.git testing found the following build failure:

  drivers/built-in.o: In function `pvr2_dvb_feed_thread':
  pvrusb2-dvb.c:(.text+0x127e78): undefined reference to `dvb_dmx_swfilter'
  drivers/built-in.o: In function `pvr2_dvb_adapter_exit':
  pvrusb2-dvb.c:(.text+0x128357): undefined reference to `dvb_net_release'
  pvrusb2-dvb.c:(.text+0x12836f): undefined reference to `dvb_dmxdev_release'
  [...]

with this config:

  http://redhat.com/~mingo/misc/config-Sun_May_11_07_06_35_CEST_2008.bad

the reason for the missing symbols is this combination:

  CONFIG_VIDEO_PVRUSB2=y
  CONFIG_DVB_CORE=m

i.e. pvrusb2 is built-in, dvb-core is modular.

This patch solves the problem by adding a dependency on DVB_CORE - this 
is used by other drivers such as au0828 as well. This way the pvrusb2 
driver can still be built, but if dvb-core is a module then it will 
correctly be a module as well and cannot be built-in.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/pvrusb2/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/media/video/pvrusb2/Kconfig
===================================================================
--- linux.orig/drivers/media/video/pvrusb2/Kconfig
+++ linux/drivers/media/video/pvrusb2/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_PVRUSB2
 	tristate "Hauppauge WinTV-PVR USB2 support"
-	depends on VIDEO_V4L2 && I2C
+	depends on VIDEO_V4L2 && I2C && DVB_CORE
 	select FW_LOADER
 	select MEDIA_TUNER
 	select VIDEO_TVEEPROM
