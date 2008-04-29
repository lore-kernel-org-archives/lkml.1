Return-Path: <linux-kernel-owner+w=401wt.eu-S1763321AbYD2NSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763321AbYD2NSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbYD2NSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:18:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41767 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510AbYD2NSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:18:41 -0400
Date: Tue, 29 Apr 2008 15:18:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jaime Velasco Juan <jsagarribay@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] video: fix build bugs in drivers/media/video/stk-webcam.c
Message-ID: <20080429131824.GA4742@elte.hu>
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


x86.git randconfig testing found these build bugs in current -git:

 drivers/media/video/stk-webcam.c: In function 'stk_create_sysfs_files':
 drivers/media/video/stk-webcam.c:340: error: implicit declaration of function 'video_device_create_file'
 drivers/media/video/stk-webcam.c: In function 'stk_remove_sysfs_files':
 [...]
 drivers/media/video/stk-webcam.c: In function 'v4l_stk_mmap':
 drivers/media/video/stk-webcam.c:846: error: 'VM_WRITE' undeclared (first use in this function)
 [...]

config at:

  http://redhat.com/~mingo/misc/config-Tue_Apr_29_15_00_47_CEST_2008.bad

the reason was a missing include file, and a dependency on a deprecated
(but still in use) VIDEO_V4L1_COMPAT API.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/Kconfig      |    1 +
 drivers/media/video/stk-webcam.c |    1 +
 2 files changed, 2 insertions(+)

Index: linux/drivers/media/video/Kconfig
===================================================================
--- linux.orig/drivers/media/video/Kconfig
+++ linux/drivers/media/video/Kconfig
@@ -835,6 +835,7 @@ config USB_ZR364XX
 config USB_STKWEBCAM
 	tristate "USB Syntek DC1125 Camera support"
 	depends on VIDEO_V4L2 && EXPERIMENTAL
+	select VIDEO_V4L1_COMPAT
 	---help---
 	  Say Y here if you want to use this type of camera.
 	  Supported devices are typically found in some Asus laptops,
Index: linux/drivers/media/video/stk-webcam.c
===================================================================
--- linux.orig/drivers/media/video/stk-webcam.c
+++ linux/drivers/media/video/stk-webcam.c
@@ -28,6 +28,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/kref.h>
+#include <linux/mm.h>
 
 #include <linux/usb.h>
 #include <linux/vmalloc.h>
