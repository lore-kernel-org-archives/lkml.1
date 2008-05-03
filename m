Return-Path: <linux-kernel-owner+w=401wt.eu-S1764959AbYECQbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764959AbYECQbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 12:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759314AbYECQbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 12:31:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33249 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758437AbYECQbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 12:31:23 -0400
Date: Sat, 3 May 2008 18:30:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch] video: build fix for drivers/media/video/mt9v022.c
Message-ID: <20080503163058.GA15272@elte.hu>
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


x86.git testing found the following build bug on latest -git:

  CC [M]  drivers/media/video/mt9v022.o
  drivers/media/video/mt9v022.c: In function 'bus_switch_request':
  drivers/media/video/mt9v022.c:199: error: implicit declaration of function 'gpio_is_valid'
  drivers/media/video/mt9v022.c:201: error: implicit declaration of function 'gpio_request'
  drivers/media/video/mt9v022.c:207: error: implicit declaration of function 'gpio_direction_output'
  drivers/media/video/mt9v022.c:211: error: implicit declaration of function 'gpio_free'
  drivers/media/video/mt9v022.c: In function 'bus_switch_act':
  drivers/media/video/mt9v022.c:237: error: implicit declaration of function 'gpio_set_value_cansleep'
  make[2]: *** [drivers/media/video] Error 2
  make[1]: *** [drivers/media] Error 2
  make[1]: *** Waiting for unfinished jobs....
  make: *** [drivers] Error 2

with this config:

   http://redhat.com/~mingo/misc/config-Sat_May__3_16_08_39_CEST_2008.bad

the bug was that the driver uses GPIO functionality but only includes 
the GPIO interface definitions for the CONFIG_MT9M001_PCA9536_SWITCH 
case, which was not set in this config.

The quick fix seems to be to include linux/gpio.h unconditionally. (this 
seems like a small cleanup as well as it removes and #ifdef is more 
robust than an inclusion of asm/gpio.h) Not tested too much yet, so 
please have another look in any case.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/mt9v022.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux/drivers/media/video/mt9v022.c
===================================================================
--- linux.orig/drivers/media/video/mt9v022.c
+++ linux/drivers/media/video/mt9v022.c
@@ -13,15 +13,12 @@
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/log2.h>
+#include <linux/gpio.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
 
-#ifdef CONFIG_MT9M001_PCA9536_SWITCH
-#include <asm/gpio.h>
-#endif
-
 /* mt9v022 i2c address 0x48, 0x4c, 0x58, 0x5c
  * The platform has to define i2c_board_info
  * and call i2c_register_board_info() */
