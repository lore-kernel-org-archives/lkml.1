Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbXIIUW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbXIIUW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758709AbXIIUWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:22:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:7086 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758674AbXIIUWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GpKRjXAgfbbD2PqQeMfe9JzkEZdy2Qwjtly7URf/PnE/WYwO6qOphCsUNZkCFg9yuQC9BJxz7ppFIb4SvYj2deuLp3x0XDf2mqQqaUewggmJEJCvCnrdHHlK8+vPvZEXVVXz93+zgd/043CA+0k7nACjLEAVHy06xQSdgW15YRI=
Message-ID: <92a12cdb0709091322r5dd65f5dse0668cff4fbd43b0@mail.gmail.com>
Date: Sun, 9 Sep 2007 21:22:17 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net
Subject: [PATCH] Patch Dreamcast AICA driver to handle Maple bus support
Cc: "Paul Mundt" <lethal@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patches the AICA sound driver for the Dreamcast to handle the
well known flakiness of the Dreamcast's G2 bus.

This is dependent on getting Maple bus support (see
http://lkml.org/lkml/2007/9/9/70) into the kernel.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

diff --git a/sound/sh/aica.c b/sound/sh/aica.c
index 7397865..a42c58f 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -35,6 +35,7 @@
 #include <linux/timer.h>
 #include <linux/delay.h>
 #include <linux/workqueue.h>
+#include <linux/maple.h>
 #include <sound/driver.h>
 #include <sound/core.h>
 #include <sound/control.h>
@@ -43,7 +44,7 @@
 #include <sound/info.h>
 #include <asm/io.h>
 #include <asm/dma.h>
-#include <asm/dreamcast/sysasic.h>
+#include <asm/mach/sysasic.h>
 #include "aica.h"

 MODULE_AUTHOR("Adrian McMenamin <adrian@mcmen.demon.co.uk>");
@@ -218,6 +219,12 @@ static int aica_dma_transfer(int channels, int buffer_size,
 	period_offset = dreamcastcard->clicks;
 	period_offset %= (AICA_PERIOD_NUMBER / channels);
 	runtime = substream->runtime;
+	/* If maple dma is running, wait for it to finish */
+	do{ cpu_relax();}
+	while (!maple_dma_done());
+	/* Turn off the maple dma now */
+	ctrl_outl(0, MAPLE_ENABLE);
+	local_irq_disable();	
 	for (q = 0; q < channels; q++) {
 		err = dma_xfer(AICA_DMA_CHANNEL,
 			       (unsigned long) (runtime->dma_area +
@@ -232,6 +239,9 @@ static int aica_dma_transfer(int channels, int buffer_size,
 			break;
 		dma_wait_for_completion(AICA_DMA_CHANNEL);
 	}
+	/* restore maple dma */
+	local_irq_enable();
+	maplebus_init_hardware();
 	return err;
 }
