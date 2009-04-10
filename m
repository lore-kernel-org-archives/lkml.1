Return-Path: <linux-kernel-owner+w=401wt.eu-S934834AbZDJBnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934834AbZDJBnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 21:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934428AbZDJBnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 21:43:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51824 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934426AbZDJBnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 21:43:16 -0400
Message-ID: <49DEA45F.4070405@cn.fujitsu.com>
Date: Fri, 10 Apr 2009 09:43:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: tiwai@suse.de
CC: perex@perex.cz, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sound/usb: use memdup_user()
References: <49DEA405.3070900@cn.fujitsu.com>
In-Reply-To: <49DEA405.3070900@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove open-coded memdup_user().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 sound/usb/usx2y/us122l.c     |   10 +++-------
 sound/usb/usx2y/usX2Yhwdep.c |   13 ++++++-------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 98276aa..012ff1f 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -349,14 +349,10 @@ static int usb_stream_hwdep_ioctl(struct snd_hwdep *hw, struct file *file,
 	if (cmd != SNDRV_USB_STREAM_IOCTL_SET_PARAMS)
 		return -ENOTTY;
 
-	cfg = kmalloc(sizeof(*cfg), GFP_KERNEL);
-	if (!cfg)
-		return -ENOMEM;
+	cfg = memdup_user((void *)arg, sizeof(*cfg));
+	if (IS_ERR(cfg))
+		return PTR_ERR(cfg);
 
-	if (copy_from_user(cfg, (void *)arg, sizeof(*cfg))) {
-		err = -EFAULT;
-		goto free;
-	}
 	if (cfg->version != USB_STREAM_INTERFACE_VERSION) {
 		err = -ENXIO;
 		goto free;
diff --git a/sound/usb/usx2y/usX2Yhwdep.c b/sound/usb/usx2y/usX2Yhwdep.c
index 4af8740..f3d8f71 100644
--- a/sound/usb/usx2y/usX2Yhwdep.c
+++ b/sound/usb/usx2y/usX2Yhwdep.c
@@ -203,13 +203,12 @@ static int snd_usX2Y_hwdep_dsp_load(struct snd_hwdep *hw,
 
 	if (access_ok(VERIFY_READ, dsp->image, dsp->length)) {
 		struct usb_device* dev = priv->chip.dev;
-		char *buf = kmalloc(dsp->length, GFP_KERNEL);
-		if (!buf)
-			return -ENOMEM;
-		if (copy_from_user(buf, dsp->image, dsp->length)) {
-			kfree(buf);
-			return -EFAULT;
-		}
+		char *buf;
+
+		buf = memdup_user(dsp->image, dsp->length);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
+
 		err = usb_set_interface(dev, 0, 1);
 		if (err)
 			snd_printk(KERN_ERR "usb_set_interface error \n");
-- 
1.5.4.rc3

