Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbYD3LB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbYD3LB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbYD3LBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:01:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56979 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416AbYD3LBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:01:50 -0400
Date: Wed, 30 Apr 2008 13:01:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: [patch, -git] media/video/sound build fix, TEA5761/TEA5767
Message-ID: <20080430110115.GA5633@elte.hu>
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


x86.git randconfig testing found the following new build error in latest 
-git:

 drivers/built-in.o: In function `v4l2_i2c_drv_attach_legacy':
 tuner-core.c:(.text+0x1a829d): undefined reference to `v4l2_i2c_attach'
 drivers/built-in.o: In function `tuner_command':
 tuner-core.c:(.text+0x1a971c): undefined reference to `v4l_printk_ioctl'

the reason appears to be that the TEA5761/TEA5767 tuner code is 
dependent on (legacy?) V4L infrastructure like v4l2_i2c_attach, by 
virtue of drivers/media/video/tuner-core.c including 
media/v4l2-i2c-drv-legacy.h and ./sound/i2c/other/Makefile doing:

  snd-tea575x-tuner-objs := tea575x-tuner.o

for now i solved this via adding a VIDEO_V4L2_COMMON dependency to 
MEDIA_TUNER - which solves the build problem by excluding these drivers 
- but i suspect there might be a better fix as well that does not 
restrict the selectability of these drivers.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/common/tuners/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/media/common/tuners/Kconfig
===================================================================
--- linux.orig/drivers/media/common/tuners/Kconfig
+++ linux/drivers/media/common/tuners/Kconfig
@@ -20,7 +20,7 @@ config MEDIA_ATTACH
 config MEDIA_TUNER
 	tristate
 	default DVB_CORE || VIDEO_DEV
-	depends on DVB_CORE || VIDEO_DEV
+	depends on (DVB_CORE || VIDEO_DEV) && VIDEO_V4L2_COMMON
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_MT20XX if !MEDIA_TUNER_CUSTOMIZE
