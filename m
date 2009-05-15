Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbZEON1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbZEON1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbZEON1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:27:11 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37142 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbZEON1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:27:10 -0400
Date: Fri, 15 May 2009 16:16:36 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [RFC] Add Input IOCTL for accelerometer devices
Message-ID: <20090515131636.GE4443@nokia.com>
Reply-To: felipe.balbi@nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 15 May 2009 13:27:03.0969 (UTC) FILETIME=[D5F10910:01C9D560]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

the following patch is just an idea to see how the community feels about
it. Considering accelerometer devices, you might have different use
cases for it while running different applications. You could be using it
for screen rotation in one case but when opening a game, you could use
it as a game controller by turning the device side-by-side.

Thinking about that, I decided it would be nice to have some parameters
configured at runtime in order to be able to use the accelerometer on
different use cases.

The following proposal (really draft) tries to add a new IOCTL on input
layer such as userland could use that for passing proper parameters to
accelerometer drivers.

ps: the patch is in really early stage, I'm guessing the best would be
to, as force feedback devices, provide proper registration for an
accelerometer device.

diff --git a/include/linux/input.h b/include/linux/input.h
index adc1332..c3c9e82 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -55,6 +55,26 @@ struct input_absinfo {
        __s32 flat;
 };
 
+#define INPUT_ACCEL_IRQ_NONE   0
+#define INPUT_ACCEL_IRQ_HIGH   BIT(0)
+#define INPUT_ACCEL_IRQ_LOW    BIT(1)
+#define INPUT_ACCEL_IRQ_LATCH  BIT(2)
+
+struct input_accelinfo {
+       __u32 threshold;
+       __u32 duration;
+
+       /* the following 4 fields configure how the irqs will be generated:
+        * - High Event
+        * - Low Event
+        * - Latch irq request
+        */
+       __u8 x_irq;
+       __u8 y_irq;
+       __u8 z_irq;
+       __u8 click_irq;
+};
+
 #define EVIOCGVERSION          _IOR('E', 0x01, int)                    /* get driver version */
 #define EVIOCGID               _IOR('E', 0x02, struct input_id)        /* get device ID */
 #define EVIOCGREP              _IOR('E', 0x03, int[2])                 /* get repeat settings */
@@ -81,6 +101,8 @@ struct input_absinfo {
 
 #define EVIOCGRAB              _IOW('E', 0x90, int)                    /* Grab/Release device */
 
+#define EVIOCACCELINFO         _IOW('E', 0x91, struct input_accelinfo) /* set accelerometer's parameters */
+
 /*
  * Event types
  */
@@ -975,6 +997,8 @@ struct ff_effect {
 #include <linux/timer.h>
 #include <linux/mod_devicetable.h>
 
+struct input_accelinfo;
+
 /**
  * struct input_dev - represents an input device
  * @name: name of the device
@@ -1069,6 +1093,7 @@ struct input_dev {
        void *keycode;
        int (*setkeycode)(struct input_dev *dev, int scancode, int keycode);
        int (*getkeycode)(struct input_dev *dev, int scancode, int *keycode);
+       int (*set_accelinfo)(struct input_dev *dev, struct input_accelinfo *info);
 
        struct ff_device *ff;
 


-- 
balbi
