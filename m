Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZKPGIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZKPGIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 01:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZKPGIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 01:08:50 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33236 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZKPGIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 01:08:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=oelHWMX7WUwTMDXm6itw7zKlA+RvXeqXn2pLBz48ak5dPddItlVBeW5ST5U4Xm7ACq
         95WFntf5L/jBd+VhGk46qgDGE89XfrQft/xdVjeyT1ALfL5ZFNqy1LZQPxFP1xG3LWxh
         YeFPlAvgHjL3a/SpQzpBIeFk4bOAEGnsGqt0o=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/5] mfd: pcf50633 - make 'is_suspended' a bool
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
       Balaji Rao <balajirrao@openmoko.org>
Date: Sun, 15 Nov 2009 22:08:43 -0800
Message-ID: <20091116060843.20162.17883.stgit@localhost.localdomain>
In-Reply-To: <20091116060611.20162.81714.stgit@localhost.localdomain>
References: <20091116060611.20162.81714.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The field holds boolean data and should be typed as such. Also annotate
check for is_spspended in IRQ handler with 'unlikely'.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/mfd/pcf50633-core.c       |    6 +++---
 include/linux/mfd/pcf50633/core.h |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 03dcc92..fb44e4d 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -412,8 +412,8 @@ static void pcf50633_irq_worker(struct work_struct *work)
 	}
 
 	/* Have we just resumed ? */
-	if (pcf->is_suspended) {
-		pcf->is_suspended = 0;
+	if (unlikely(pcf->is_suspended)) {
+		pcf->is_suspended = false;
 
 		/* Set the resume reason filtering out non resumers */
 		for (i = 0; i < ARRAY_SIZE(pcf_int); i++)
@@ -510,7 +510,7 @@ static int pcf50633_suspend(struct i2c_client *client, pm_message_t state)
 		goto out;
 	}
 
-	pcf->is_suspended = 1;
+	pcf->is_suspended = true;
 
 out:
 	return ret;
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index d9034cc..43bb2ac 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -13,6 +13,7 @@
 #ifndef __LINUX_MFD_PCF50633_CORE_H
 #define __LINUX_MFD_PCF50633_CORE_H
 
+#include <linux/types.h>
 #include <linux/i2c.h>
 #include <linux/workqueue.h>
 #include <linux/regulator/driver.h>
@@ -139,7 +140,7 @@ struct pcf50633 {
 
 	u8 suspend_irq_masks[5];
 	u8 resume_reason[5];
-	int is_suspended;
+	bool is_suspended;
 
 	int onkey1s_held;
 

