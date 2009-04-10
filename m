Return-Path: <linux-kernel-owner+w=401wt.eu-S933553AbZDJBmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbZDJBmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 21:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763090AbZDJBm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 21:42:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57799 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762342AbZDJBmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 21:42:25 -0400
Message-ID: <49DEA42C.8060004@cn.fujitsu.com>
Date: Fri, 10 Apr 2009 09:43:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: tiwai@suse.de
CC: perex@perex.cz, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] sound/core: use memdup_user()
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
 sound/core/control.c        |   35 ++++++----------
 sound/core/pcm_compat.c     |   11 ++---
 sound/core/pcm_native.c     |   93 ++++++++++++++++---------------------------
 sound/core/seq/seq_compat.c |    9 ++--
 sound/core/timer.c          |   11 ++---
 5 files changed, 60 insertions(+), 99 deletions(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 4b20fa2..17b8d47 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -723,14 +723,11 @@ static int snd_ctl_elem_read_user(struct snd_card *card,
 {
 	struct snd_ctl_elem_value *control;
 	int result;
-	
-	control = kmalloc(sizeof(*control), GFP_KERNEL);
-	if (control == NULL)
-		return -ENOMEM;	
-	if (copy_from_user(control, _control, sizeof(*control))) {
-		kfree(control);
-		return -EFAULT;
-	}
+
+	control = memdup_user(_control, sizeof(*control));
+	if (IS_ERR(control))
+		return PTR_ERR(control);
+
 	snd_power_lock(card);
 	result = snd_power_wait(card, SNDRV_CTL_POWER_D0);
 	if (result >= 0)
@@ -784,13 +781,10 @@ static int snd_ctl_elem_write_user(struct snd_ctl_file *file,
 	struct snd_card *card;
 	int result;
 
-	control = kmalloc(sizeof(*control), GFP_KERNEL);
-	if (control == NULL)
-		return -ENOMEM;	
-	if (copy_from_user(control, _control, sizeof(*control))) {
-		kfree(control);
-		return -EFAULT;
-	}
+	control = memdup_user(_control, sizeof(*control));
+	if (IS_ERR(control))
+		return PTR_ERR(control);
+
 	card = file->card;
 	snd_power_lock(card);
 	result = snd_power_wait(card, SNDRV_CTL_POWER_D0);
@@ -916,13 +910,10 @@ static int snd_ctl_elem_user_tlv(struct snd_kcontrol *kcontrol,
 	if (op_flag > 0) {
 		if (size > 1024 * 128)	/* sane value */
 			return -EINVAL;
-		new_data = kmalloc(size, GFP_KERNEL);
-		if (new_data == NULL)
-			return -ENOMEM;
-		if (copy_from_user(new_data, tlv, size)) {
-			kfree(new_data);
-			return -EFAULT;
-		}
+
+		new_data = memdup_user(tlv, size);
+		if (IS_ERR(new_data))
+			return PTR_ERR(new_data);
 		change = ue->tlv_data_size != size;
 		if (!change)
 			change = memcmp(ue->tlv_data, new_data, size);
diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index 36d7a59..08bfed5 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -232,14 +232,11 @@ static int snd_pcm_ioctl_hw_params_compat(struct snd_pcm_substream *substream,
 	if (! (runtime = substream->runtime))
 		return -ENOTTY;
 
-	data = kmalloc(sizeof(*data), GFP_KERNEL);
-	if (data == NULL)
-		return -ENOMEM;
 	/* only fifo_size is different, so just copy all */
-	if (copy_from_user(data, data32, sizeof(*data32))) {
-		err = -EFAULT;
-		goto error;
-	}
+	data = memdup_user(data32, sizeof(*data32));
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
 	if (refine)
 		err = snd_pcm_hw_refine(substream, data);
 	else
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index a151fb0..fc6f98e 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -327,21 +327,16 @@ static int snd_pcm_hw_refine_user(struct snd_pcm_substream *substream,
 	struct snd_pcm_hw_params *params;
 	int err;
 
-	params = kmalloc(sizeof(*params), GFP_KERNEL);
-	if (!params) {
-		err = -ENOMEM;
-		goto out;
-	}
-	if (copy_from_user(params, _params, sizeof(*params))) {
-		err = -EFAULT;
-		goto out;
-	}
+	params = memdup_user(_params, sizeof(*params));
+	if (IS_ERR(params))
+		return PTR_ERR(params);
+
 	err = snd_pcm_hw_refine(substream, params);
 	if (copy_to_user(_params, params, sizeof(*params))) {
 		if (!err)
 			err = -EFAULT;
 	}
-out:
+
 	kfree(params);
 	return err;
 }
@@ -465,21 +460,16 @@ static int snd_pcm_hw_params_user(struct snd_pcm_substream *substream,
 	struct snd_pcm_hw_params *params;
 	int err;
 
-	params = kmalloc(sizeof(*params), GFP_KERNEL);
-	if (!params) {
-		err = -ENOMEM;
-		goto out;
-	}
-	if (copy_from_user(params, _params, sizeof(*params))) {
-		err = -EFAULT;
-		goto out;
-	}
+	params = memdup_user(_params, sizeof(*params));
+	if (IS_ERR(params))
+		return PTR_ERR(params);
+
 	err = snd_pcm_hw_params(substream, params);
 	if (copy_to_user(_params, params, sizeof(*params))) {
 		if (!err)
 			err = -EFAULT;
 	}
-out:
+
 	kfree(params);
 	return err;
 }
@@ -2593,13 +2583,11 @@ static int snd_pcm_playback_ioctl1(struct file *file,
 			return -EFAULT;
 		if (copy_from_user(&xfern, _xfern, sizeof(xfern)))
 			return -EFAULT;
-		bufs = kmalloc(sizeof(void *) * runtime->channels, GFP_KERNEL);
-		if (bufs == NULL)
-			return -ENOMEM;
-		if (copy_from_user(bufs, xfern.bufs, sizeof(void *) * runtime->channels)) {
-			kfree(bufs);
-			return -EFAULT;
-		}
+
+		bufs = memdup_user(xfern.bufs,
+				   sizeof(void *) * runtime->channels);
+		if (IS_ERR(bufs))
+			return PTR_ERR(bufs);
 		result = snd_pcm_lib_writev(substream, bufs, xfern.frames);
 		kfree(bufs);
 		__put_user(result, &_xfern->result);
@@ -2675,13 +2663,11 @@ static int snd_pcm_capture_ioctl1(struct file *file,
 			return -EFAULT;
 		if (copy_from_user(&xfern, _xfern, sizeof(xfern)))
 			return -EFAULT;
-		bufs = kmalloc(sizeof(void *) * runtime->channels, GFP_KERNEL);
-		if (bufs == NULL)
-			return -ENOMEM;
-		if (copy_from_user(bufs, xfern.bufs, sizeof(void *) * runtime->channels)) {
-			kfree(bufs);
-			return -EFAULT;
-		}
+
+		bufs = memdup_user(xfern.bufs,
+				   sizeof(void *) * runtime->channels);
+		if (IS_ERR(bufs))
+			return PTR_ERR(bufs);
 		result = snd_pcm_lib_readv(substream, bufs, xfern.frames);
 		kfree(bufs);
 		__put_user(result, &_xfern->result);
@@ -3312,18 +3298,12 @@ static int snd_pcm_hw_refine_old_user(struct snd_pcm_substream *substream,
 	int err;
 
 	params = kmalloc(sizeof(*params), GFP_KERNEL);
-	if (!params) {
-		err = -ENOMEM;
-		goto out;
-	}
-	oparams = kmalloc(sizeof(*oparams), GFP_KERNEL);
-	if (!oparams) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!params)
+		return -ENOMEM;
 
-	if (copy_from_user(oparams, _oparams, sizeof(*oparams))) {
-		err = -EFAULT;
+	oparams = memdup_user(_oparams, sizeof(*oparams));
+	if (IS_ERR(oparams)) {
+		err = PTR_ERR(oparams);
 		goto out;
 	}
 	snd_pcm_hw_convert_from_old_params(params, oparams);
@@ -3333,9 +3313,10 @@ static int snd_pcm_hw_refine_old_user(struct snd_pcm_substream *substream,
 		if (!err)
 			err = -EFAULT;
 	}
+
+	kfree(oparams);
 out:
 	kfree(params);
-	kfree(oparams);
 	return err;
 }
 
@@ -3347,17 +3328,12 @@ static int snd_pcm_hw_params_old_user(struct snd_pcm_substream *substream,
 	int err;
 
 	params = kmalloc(sizeof(*params), GFP_KERNEL);
-	if (!params) {
-		err = -ENOMEM;
-		goto out;
-	}
-	oparams = kmalloc(sizeof(*oparams), GFP_KERNEL);
-	if (!oparams) {
-		err = -ENOMEM;
-		goto out;
-	}
-	if (copy_from_user(oparams, _oparams, sizeof(*oparams))) {
-		err = -EFAULT;
+	if (!params)
+		return -ENOMEM;
+
+	oparams = memdup_user(_oparams, sizeof(*oparams));
+	if (IS_ERR(oparams)) {
+		err = PTR_ERR(oparams);
 		goto out;
 	}
 	snd_pcm_hw_convert_from_old_params(params, oparams);
@@ -3367,9 +3343,10 @@ static int snd_pcm_hw_params_old_user(struct snd_pcm_substream *substream,
 		if (!err)
 			err = -EFAULT;
 	}
+
+	kfree(oparams);
 out:
 	kfree(params);
-	kfree(oparams);
 	return err;
 }
 #endif /* CONFIG_SND_SUPPORT_OLD_API */
diff --git a/sound/core/seq/seq_compat.c b/sound/core/seq/seq_compat.c
index 38693f4..c956fe4 100644
--- a/sound/core/seq/seq_compat.c
+++ b/sound/core/seq/seq_compat.c
@@ -48,12 +48,11 @@ static int snd_seq_call_port_info_ioctl(struct snd_seq_client *client, unsigned
 	struct snd_seq_port_info *data;
 	mm_segment_t fs;
 
-	data = kmalloc(sizeof(*data), GFP_KERNEL);
-	if (! data)
-		return -ENOMEM;
+	data = memdup_user(data32, sizeof(*data32));
+	if (IS_ERR(data))
+		return PTR_ERR(data);
 
-	if (copy_from_user(data, data32, sizeof(*data32)) ||
-	    get_user(data->flags, &data32->flags) ||
+	if (get_user(data->flags, &data32->flags) ||
 	    get_user(data->time_queue, &data32->time_queue))
 		goto error;
 	data->kernel = NULL;
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 3f0050d..8f8b17a 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -1395,13 +1395,10 @@ static int snd_timer_user_ginfo(struct file *file,
 	struct list_head *p;
 	int err = 0;
 
-	ginfo = kmalloc(sizeof(*ginfo), GFP_KERNEL);
-	if (! ginfo)
-		return -ENOMEM;
-	if (copy_from_user(ginfo, _ginfo, sizeof(*ginfo))) {
-		kfree(ginfo);
-		return -EFAULT;
-	}
+	ginfo = memdup_user(_ginfo, sizeof(*ginfo));
+	if (IS_ERR(ginfo))
+		return PTR_ERR(ginfo);
+
 	tid = ginfo->tid;
 	memset(ginfo, 0, sizeof(*ginfo));
 	ginfo->tid = tid;
-- 
1.5.4.rc3

