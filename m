Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbXFABxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbXFABxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXFABxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:53:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:26197 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbXFABxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ty5FAsZBNlkrJ7PORbDyID8sXmM9uDpdLQYZIwzaAxKrjo70u+iEjjqf86B1YETixGr4xSrCN1kAQIrYR6UFyaJceXhmfL6Wd80oGPW7J7EfSXpzVe0ipdiTax/buiBXMrIuso2Q/3f/HtD6WjpByRf1WYDJFL7C7ACov2Oxvyw=
Message-ID: <a8e1da0705311853w4df1aae8k87c55fdfbfa96b10@mail.gmail.com>
Date: Fri, 1 Jun 2007 01:53:39 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [patch -mm] alsa mixer_oss kfree fix
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jaroslav Kysela" <perex@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Fix possible null pointer kfree.

Signed-off-by: dave young <hidave.darkstar@gmail.com>

mixer_oss.c |    120 +-
 1 file changed, 74 insertions(+), 46 deletions(-)

diff -purN linux/sound/core/oss/mixer_oss.c linux.new/sound/core/oss/mixer_oss.c
--- linux/sound/core/oss/mixer_oss.c	2007-06-01 09:00:12.000000000 +0000
+++ linux.new/sound/core/oss/mixer_oss.c	2007-06-01 09:36:10.000000000 +0000
@@ -512,23 +512,27 @@ static void snd_mixer_oss_get_volume1_vo
 		return;
 	}
 	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
+	if (uinfo == NULL)
+		goto out_uinfo;
 	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
-	if (uinfo == NULL || uctl == NULL)
-		goto __unalloc;
+	if (uctl == NULL)
+		goto out_uctl;
 	if (kctl->info(kctl, uinfo))
-		goto __unalloc;
+		goto out;
 	if (kctl->get(kctl, uctl))
-		goto __unalloc;
+		goto out;
 	if (uinfo->type == SNDRV_CTL_ELEM_TYPE_BOOLEAN &&
 	    uinfo->value.integer.min == 0 && uinfo->value.integer.max == 1)
-		goto __unalloc;
+		goto out;
 	*left = snd_mixer_oss_conv1(uctl->value.integer.value[0],
uinfo->value.integer.min, uinfo->value.integer.max,
&pslot->volume[0]);
 	if (uinfo->count > 1)
 		*right = snd_mixer_oss_conv1(uctl->value.integer.value[1],
uinfo->value.integer.min, uinfo->value.integer.max,
&pslot->volume[1]);
-      __unalloc:
+out:
+	kfree(uctl);
+out_uctl:
+	kfree(uinfo);
+out_uinfo:
 	up_read(&card->controls_rwsem);
-      	kfree(uctl);
-      	kfree(uinfo);
 }

 static void snd_mixer_oss_get_volume1_sw(struct snd_mixer_oss_file *fmixer,
@@ -550,13 +554,15 @@ static void snd_mixer_oss_get_volume1_sw
 		return;
 	}
 	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
+	if (uinfo == NULL)
+		goto out_uinfo;
 	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
-	if (uinfo == NULL || uctl == NULL)
-		goto __unalloc;
+	if (uctl == NULL)
+		goto out_uctl;
 	if (kctl->info(kctl, uinfo))
-		goto __unalloc;
+		goto out;
 	if (kctl->get(kctl, uctl))
-		goto __unalloc;
+		goto out;
 	if (!uctl->value.integer.value[0]) {
 		*left = 0;
 		if (uinfo->count == 1)
@@ -564,10 +570,12 @@ static void snd_mixer_oss_get_volume1_sw
 	}
 	if (uinfo->count > 1 && !uctl->value.integer.value[route ? 3 : 1])
 		*right = 0;
-      __unalloc:
-	up_read(&card->controls_rwsem);
-      	kfree(uctl);
+out:
+	kfree(uctl);
+out_uctl:
 	kfree(uinfo);
+out_uinfo:
+	up_read(&card->controls_rwsem);
 }

 static int snd_mixer_oss_get_volume1(struct snd_mixer_oss_file *fmixer,
@@ -613,25 +621,29 @@ static void snd_mixer_oss_put_volume1_vo
 	if ((kctl = snd_ctl_find_numid(card, numid)) == NULL)
 		return;
 	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
+	if (uinfo == NULL)
+		goto out_uinfo;
 	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
-	if (uinfo == NULL || uctl == NULL)
-		goto __unalloc;
+	if (uctl == NULL)
+		goto out_uctl;
 	if (kctl->info(kctl, uinfo))
-		goto __unalloc;
+		goto out;
 	if (uinfo->type == SNDRV_CTL_ELEM_TYPE_BOOLEAN &&
 	    uinfo->value.integer.min == 0 && uinfo->value.integer.max == 1)
-		goto __unalloc;
+		goto out;
 	uctl->value.integer.value[0] = snd_mixer_oss_conv2(left,
uinfo->value.integer.min, uinfo->value.integer.max);
 	if (uinfo->count > 1)
 		uctl->value.integer.value[1] = snd_mixer_oss_conv2(right,
uinfo->value.integer.min, uinfo->value.integer.max);
 	if ((res = kctl->put(kctl, uctl)) < 0)
-		goto __unalloc;
+		goto out;
 	if (res > 0)
 		snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_VALUE, &kctl->id);
-      __unalloc:
-	up_read(&card->controls_rwsem);
-      	kfree(uctl);
+out:
+	kfree(uctl);
+out_uctl:
 	kfree(uinfo);
+out_uinfo:
+	up_read(&card->controls_rwsem);
 }

 static void snd_mixer_oss_put_volume1_sw(struct snd_mixer_oss_file *fmixer,
@@ -654,11 +666,13 @@ static void snd_mixer_oss_put_volume1_sw
 		return;
 	}
 	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
+	if (uinfo == NULL)
+		goto out_uinfo;
 	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
-	if (uinfo == NULL || uctl == NULL)
-		goto __unalloc;
+	if (uctl == NULL)
+		goto out_uctl;
 	if (kctl->info(kctl, uinfo))
-		goto __unalloc;
+		goto out;
 	if (uinfo->count > 1) {
 		uctl->value.integer.value[0] = left > 0 ? 1 : 0;
 		uctl->value.integer.value[route ? 3 : 1] = right > 0 ? 1 : 0;
@@ -670,13 +684,15 @@ static void snd_mixer_oss_put_volume1_sw
 		uctl->value.integer.value[0] = (left > 0 || right > 0) ? 1 : 0;
 	}
 	if ((res = kctl->put(kctl, uctl)) < 0)
-		goto __unalloc;
+		goto out;
 	if (res > 0)
 		snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_VALUE, &kctl->id);
-      __unalloc:
-	up_read(&card->controls_rwsem);
-      	kfree(uctl);
+out:
+	kfree(uctl);
+out_uctl:
 	kfree(uinfo);
+out_uinfo:
+	up_read(&card->controls_rwsem);
 }

 static int snd_mixer_oss_put_volume1(struct snd_mixer_oss_file *fmixer,
@@ -775,21 +791,25 @@ static int snd_mixer_oss_get_recsrc2(str
 	int err, idx;
 	
 	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
+	if (uinfo == NULL){
+		err = -ENOMEM;
+		goto out_uinfo;
+	}
 	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
-	if (uinfo == NULL || uctl == NULL) {
+	if (uctl == NULL) {
 		err = -ENOMEM;
-		goto __unlock;
+		goto out_uctl;
 	}
 	down_read(&card->controls_rwsem);
 	kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
 	if (! kctl) {
 		err = -ENOENT;
-		goto __unlock;
+		goto out;
 	}
 	if ((err = kctl->info(kctl, uinfo)) < 0)
-		goto __unlock;
+		goto out;
 	if ((err = kctl->get(kctl, uctl)) < 0)
-		goto __unlock;
+		goto out;
 	for (idx = 0; idx < 32; idx++) {
 		if (!(mixer->mask_recsrc & (1 << idx)))
 			continue;
@@ -805,10 +825,12 @@ static int snd_mixer_oss_get_recsrc2(str
 		}
 	}
 	err = 0;
-      __unlock:
+out:
+	kfree(uctl);
+out_uctl:
+	kfree(uinfo);
+out_uinfo:
      	up_read(&card->controls_rwsem);
-      	kfree(uctl);
-      	kfree(uinfo);
       	return err;
 }

@@ -825,19 +847,23 @@ static int snd_mixer_oss_put_recsrc2(str
 	unsigned int idx;

 	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
+	if (uinfo == NULL){
+		err = -ENOMEM;
+		goto out_uinfo;
+	}
 	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
-	if (uinfo == NULL || uctl == NULL) {
+	if (uctl == NULL) {
 		err = -ENOMEM;
-		goto __unlock;
+		goto out_uctl;
 	}
 	down_read(&card->controls_rwsem);
 	kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
 	if (! kctl) {
 		err = -ENOENT;
-		goto __unlock;
+		goto out;
 	}
 	if ((err = kctl->info(kctl, uinfo)) < 0)
-		goto __unlock;
+		goto out;
 	for (idx = 0; idx < 32; idx++) {
 		if (!(mixer->mask_recsrc & (1 << idx)))
 			continue;
@@ -852,18 +878,20 @@ static int snd_mixer_oss_put_recsrc2(str
 		slot = NULL;
 	}
 	if (! slot)
-		goto __unlock;
+		goto out;
 	for (idx = 0; idx < uinfo->count; idx++)
 		uctl->value.enumerated.item[idx] = slot->capture_item;
 	err = kctl->put(kctl, uctl);
 	if (err > 0)
 		snd_ctl_notify(fmixer->card, SNDRV_CTL_EVENT_MASK_VALUE, &kctl->id);
 	err = 0;
-      __unlock:
-	up_read(&card->controls_rwsem);
+out:
 	kfree(uctl);
+out_uctl:
 	kfree(uinfo);
-	return err;
+out_uinfo:
+     	up_read(&card->controls_rwsem);
+      	return err;
 }

 struct snd_mixer_oss_assign_table {


Regards
dave
