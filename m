Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622Ab0ADQqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab0ADQqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833Ab0ADQqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:46:14 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48873 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753428Ab0ADQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:46:13 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] sound_oss: remove use of old BKL ioctl path
To: tiwai@suse.de, linux-kernel@vger.kernel.org
Date: Mon, 04 Jan 2010 16:22:59 +0000
Message-ID: <20100104162249.16949.95784.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 sound/oss/soundcard.c |   35 ++++++++++++++++++++++-------------
 1 files changed, 22 insertions(+), 13 deletions(-)


diff --git a/sound/oss/soundcard.c b/sound/oss/soundcard.c
index 61aaeda..6c3267b 100644
--- a/sound/oss/soundcard.c
+++ b/sound/oss/soundcard.c
@@ -328,11 +328,11 @@ static int sound_mixer_ioctl(int mixdev, unsigned int cmd, void __user *arg)
 	return mixer_devs[mixdev]->ioctl(mixdev, cmd, arg);
 }
 
-static int sound_ioctl(struct inode *inode, struct file *file,
-		       unsigned int cmd, unsigned long arg)
+static long sound_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int len = 0, dtype;
-	int dev = iminor(inode);
+	int dev = iminor(file->f_dentry->d_inode);
+	long ret = -EINVAL;
 	void __user *p = (void __user *)arg;
 
 	if (_SIOC_DIR(cmd) != _SIOC_NONE && _SIOC_DIR(cmd) != 0) {
@@ -353,6 +353,7 @@ static int sound_ioctl(struct inode *inode, struct file *file,
 	if (cmd == OSS_GETVERSION)
 		return __put_user(SOUND_VERSION, (int __user *)p);
 	
+	lock_kernel();
 	if (_IOC_TYPE(cmd) == 'M' && num_mixers > 0 &&   /* Mixer ioctl */
 	    (dev & 0x0f) != SND_DEV_CTL) {              
 		dtype = dev & 0x0f;
@@ -360,24 +361,31 @@ static int sound_ioctl(struct inode *inode, struct file *file,
 		case SND_DEV_DSP:
 		case SND_DEV_DSP16:
 		case SND_DEV_AUDIO:
-			return sound_mixer_ioctl(audio_devs[dev >> 4]->mixer_dev,
+			ret = sound_mixer_ioctl(audio_devs[dev >> 4]->mixer_dev,
 						 cmd, p);
-			
+			break;			
 		default:
-			return sound_mixer_ioctl(dev >> 4, cmd, p);
+			ret = sound_mixer_ioctl(dev >> 4, cmd, p);
+			break;
 		}
+		unlock_kernel();
+		return ret;
 	}
+
 	switch (dev & 0x0f) {
 	case SND_DEV_CTL:
 		if (cmd == SOUND_MIXER_GETLEVELS)
-			return get_mixer_levels(p);
-		if (cmd == SOUND_MIXER_SETLEVELS)
-			return set_mixer_levels(p);
-		return sound_mixer_ioctl(dev >> 4, cmd, p);
+			ret = get_mixer_levels(p);
+		else if (cmd == SOUND_MIXER_SETLEVELS)
+			ret = set_mixer_levels(p);
+		else
+			ret = sound_mixer_ioctl(dev >> 4, cmd, p);
+		break;
 
 	case SND_DEV_SEQ:
 	case SND_DEV_SEQ2:
-		return sequencer_ioctl(dev, file, cmd, p);
+		ret = sequencer_ioctl(dev, file, cmd, p);
+		break;
 
 	case SND_DEV_DSP:
 	case SND_DEV_DSP16:
@@ -390,7 +398,8 @@ static int sound_ioctl(struct inode *inode, struct file *file,
 		break;
 
 	}
-	return -EINVAL;
+	unlock_kernel();
+	return ret;
 }
 
 static unsigned int sound_poll(struct file *file, poll_table * wait)
@@ -490,7 +499,7 @@ const struct file_operations oss_sound_fops = {
 	.read		= sound_read,
 	.write		= sound_write,
 	.poll		= sound_poll,
-	.ioctl		= sound_ioctl,
+	.unlocked_ioctl	= sound_ioctl,
 	.mmap		= sound_mmap,
 	.open		= sound_open,
 	.release	= sound_release,

