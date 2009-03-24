Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbZCXVN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbZCXVN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZCXVNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:13:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:10497 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbZCXVNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZX19n1N0HIxwKo2t0gA0TQ+BgAN7qIfJ4WN+zzyldhK7YOBcyFXAaPHIU1TU+Sjid8
         /emH4HnDZG87N1jWDXtyxonkhzEsFadQhN00wgedDqNGFUPh4+E5Gl72ZxX7temqCHe9
         KYm/wwfvjPVro9vlEmEQoQSgwmsGIFWm2u3+k=
From: stoyboyker@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, perex@perex.cz, tiwai@suse.de
Subject: [PATCH 03/13] [oss] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 16:12:38 -0500
Message-Id: <1237929168-15341-4-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 sound/oss/sh_dac_audio.c |   60 ++++++++++++++++++++++++++++++---------------
 1 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/sound/oss/sh_dac_audio.c b/sound/oss/sh_dac_audio.c
index e5d4239..22ae271 100644
--- a/sound/oss/sh_dac_audio.c
+++ b/sound/oss/sh_dac_audio.c
@@ -111,35 +111,43 @@ static void dac_audio_set_rate(void)
 	ctrl_outl(interval, TMU1_TCNT);
 }
 
-static int dac_audio_ioctl(struct inode *inode, struct file *file,
-			   unsigned int cmd, unsigned long arg)
+static long dac_audio_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
 {
 	int val;
+	long ret;
 
 	switch (cmd) {
 	case OSS_GETVERSION:
-		return put_user(SOUND_VERSION, (int *)arg);
+		ret = put_user(SOUND_VERSION, (int *)arg);
+		break;
 
 	case SNDCTL_DSP_SYNC:
 		dac_audio_sync();
-		return 0;
+		ret = 0;
+		break;
 
 	case SNDCTL_DSP_RESET:
 		dac_audio_reset();
-		return 0;
+		ret = 0;
+		break;
 
 	case SNDCTL_DSP_GETFMTS:
-		return put_user(AFMT_U8, (int *)arg);
+		ret = put_user(AFMT_U8, (int *)arg);
+		break;
 
 	case SNDCTL_DSP_SETFMT:
-		return put_user(AFMT_U8, (int *)arg);
+		ret = put_user(AFMT_U8, (int *)arg);
+		break;
 
 	case SNDCTL_DSP_NONBLOCK:
 		file->f_flags |= O_NONBLOCK;
-		return 0;
+		ret = 0;
+		break;
 
 	case SNDCTL_DSP_GETCAPS:
-		return 0;
+		ret = 0;
+		break;
 
 	case SOUND_PCM_WRITE_RATE:
 		val = *(int *)arg;
@@ -147,32 +155,44 @@ static int dac_audio_ioctl(struct inode *inode, struct file *file,
 			rate = val;
 			dac_audio_set_rate();
 		}
-		return put_user(rate, (int *)arg);
+		ret = put_user(rate, (int *)arg);
+		break;
 
 	case SNDCTL_DSP_STEREO:
-		return put_user(0, (int *)arg);
+		ret = put_user(0, (int *)arg);
+		break;
 
 	case SOUND_PCM_WRITE_CHANNELS:
-		return put_user(1, (int *)arg);
+		ret = put_user(1, (int *)arg);
+		break;
 
 	case SNDCTL_DSP_SETDUPLEX:
-		return -EINVAL;
+		ret = -EINVAL;
+		break;
 
 	case SNDCTL_DSP_PROFILE:
-		return -EINVAL;
+		ret = -EINVAL;
+		break;
 
 	case SNDCTL_DSP_GETBLKSIZE:
-		return put_user(BUFFER_SIZE, (int *)arg);
+		ret = put_user(BUFFER_SIZE, (int *)arg);
+		break;
 
 	case SNDCTL_DSP_SETFRAGMENT:
-		return 0;
+		ret = 0;
+		break;
 
 	default:
 		printk(KERN_ERR "sh_dac_audio: unimplemented ioctl=0x%x\n",
 		       cmd);
-		return -EINVAL;
+		ret = -EINVAL;
+		break;
 	}
-	return -EINVAL;
+	if(!ret)
+	    ret = -EINVAL;
+
+	unlock_kernel();
+	return ret;
 }
 
 static ssize_t dac_audio_write(struct file *file, const char *buf, size_t count,
@@ -257,8 +277,8 @@ static int dac_audio_release(struct inode *inode, struct file *file)
 
 const struct file_operations dac_audio_fops = {
       .read =		dac_audio_read,
-      .write =	dac_audio_write,
-      .ioctl =	dac_audio_ioctl,
+      .write =		dac_audio_write,
+      .unlocked_ioctl =	dac_audio_ioctl,
       .open =		dac_audio_open,
       .release =	dac_audio_release,
 };
-- 
1.6.2

