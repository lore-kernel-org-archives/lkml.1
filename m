Return-Path: <linux-kernel-owner+w=401wt.eu-S932588AbZHLLIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbZHLLIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932553AbZHLLIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:08:19 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:45665 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547AbZHLLIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:08:18 -0400
From: iceberg <strakh@ispras.ru>
Organization: ISP RAS
To: linux-kernel@vger.kernel.org
Subject: [PATCH] 
 =?iso-8859-1?q?=A0drivers/media/video=3A_fix_lock_imbalances_in?=
 =?iso-8859-1?q?_hdpvr-core=2Ec?=
Date: Wed, 12 Aug 2009 15:08:24 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908121508.24619.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ./drivers/media/video/hdpvr/hdpvr-core.c in function 
device_authorization: 
        If after mutex_lock in usb_control_msg returns ret!=46 we go to 
label error. In this case before exit from function mutex must be unlocked.

Fix lock imbalances in function device_authorization.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>

---
diff --git a/a/drivers/media/video/hdpvr/hdpvr-core.c 
b/b/drivers/media/video/hdpvr/hdpvr-core.c
index 188bd5a..1d03d1c 100644
--- a/a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -126,7 +126,7 @@ static int device_authorization(struct hdpvr_device *dev)
        char *print_buf = kzalloc(5*buf_size+1, GFP_KERNEL);
        if (!print_buf) {
                v4l2_err(&dev->v4l2_dev, "Out of memory\n");
-               goto error;
+               return retval;
        }
 #endif

@@ -188,10 +188,10 @@ static int device_authorization(struct hdpvr_device 
*dev)
                              10000);
        v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
                 "magic request returned %d\n", ret);
-       mutex_unlock(&dev->usbc_mutex);

        retval = ret != 8;
 error:
+       moutex_unlock(&dev->usbc_mutex);
        return retval;
 }



