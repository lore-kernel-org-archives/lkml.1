Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbZINHHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbZINHHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbZINHHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:07:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60098 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZINHHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:07:08 -0400
Date: Mon, 14 Sep 2009 09:06:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Re: newer version of HTC Dream support
Message-ID: <20090914070659.GA7146@elf.ucw.cz>
References: <20090911071155.GA1386@ucw.cz> <20090911075847.2fb7210a.randy.dunlap@oracle.com> <20090911161335.GA8137@elf.ucw.cz> <20090911092157.ba202b0a.randy.dunlap@oracle.com> <20090911212751.GA25544@elf.ucw.cz> <20090911153422.7d523a73.randy.dunlap@oracle.com> <20090913083719.GA6645@elf.ucw.cz> <20090913135422.f2d7cb88.randy.dunlap@oracle.com> <20090913223806.GB9522@elf.ucw.cz> <20090913162154.ee412cbe.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090913162154.ee412cbe.randy.dunlap@oracle.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > Puzzle is almost over. If you disable 
...
> > #obj-y += audio_out.o audio_in.o audio_mp3.o audmgr.o audpp.o
> > #obj-y += snd.o
> > 
> > from build, the rest should now build ok.

Ok, I have one to fix this. Camera flash should be easy to solve,
Dream has none :-).

---

Fix compilation of audio bits for HTC Dream.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-msm/include/mach/board.h b/arch/arm/mach-msm/include/mach/board.h
index 271256c..478970b 100644
--- a/arch/arm/mach-msm/include/mach/board.h
+++ b/arch/arm/mach-msm/include/mach/board.h
@@ -71,4 +71,14 @@ struct msm_camera_sensor_info {
 	struct msm_camera_device_platform_data *pdata;
 };
 
+struct snd_endpoint {
+	int id;
+	const char *name;
+};
+
+struct msm_snd_endpoints {
+	struct snd_endpoint *endpoints;
+	unsigned num;
+};
+
 #endif
diff --git a/drivers/staging/dream/qdsp5/audio_out.c b/drivers/staging/dream/qdsp5/audio_out.c
index d1adcf6..df87ca3 100644
--- a/drivers/staging/dream/qdsp5/audio_out.c
+++ b/drivers/staging/dream/qdsp5/audio_out.c
@@ -38,8 +38,6 @@
 #include <mach/qdsp5/qdsp5audppcmdi.h>
 #include <mach/qdsp5/qdsp5audppmsg.h>
 
-#include <mach/htc_pwrsink.h>
-
 #include "evlog.h"
 
 #define LOG_AUDIO_EVENTS 1
@@ -260,7 +258,6 @@ static int audio_enable(struct audio *audio)
 	}
 
 	audio->enabled = 1;
-	htc_pwrsink_set(PWRSINK_AUDIO, 100);
 	return 0;
 }
 
@@ -695,7 +692,6 @@ static int audio_release(struct inode *inode, struct file *file)
 	audio_flush(audio);
 	audio->opened = 0;
 	mutex_unlock(&audio->lock);
-	htc_pwrsink_set(PWRSINK_AUDIO, 0);
 	return 0;
 }
 
diff --git a/include/linux/msm_audio.h b/include/linux/msm_audio.h
new file mode 100644
index 0000000..8390eb1
--- /dev/null
+++ b/include/linux/msm_audio.h
@@ -0,0 +1,115 @@
+/* include/linux/msm_audio.h
+ *
+ * Copyright (C) 2008 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __LINUX_MSM_AUDIO_H
+#define __LINUX_MSM_AUDIO_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+#include <asm/sizes.h>
+
+/* PCM Audio */
+
+#define AUDIO_IOCTL_MAGIC 'a'
+
+#define AUDIO_START        _IOW(AUDIO_IOCTL_MAGIC, 0, unsigned)
+#define AUDIO_STOP         _IOW(AUDIO_IOCTL_MAGIC, 1, unsigned)
+#define AUDIO_FLUSH        _IOW(AUDIO_IOCTL_MAGIC, 2, unsigned)
+#define AUDIO_GET_CONFIG   _IOR(AUDIO_IOCTL_MAGIC, 3, unsigned)
+#define AUDIO_SET_CONFIG   _IOW(AUDIO_IOCTL_MAGIC, 4, unsigned)
+#define AUDIO_GET_STATS    _IOR(AUDIO_IOCTL_MAGIC, 5, unsigned)
+#define AUDIO_ENABLE_AUDPP _IOW(AUDIO_IOCTL_MAGIC, 6, unsigned)
+#define AUDIO_SET_ADRC     _IOW(AUDIO_IOCTL_MAGIC, 7, unsigned)
+#define AUDIO_SET_EQ       _IOW(AUDIO_IOCTL_MAGIC, 8, unsigned)
+#define AUDIO_SET_RX_IIR   _IOW(AUDIO_IOCTL_MAGIC, 9, unsigned)
+#define AUDIO_SET_VOLUME   _IOW(AUDIO_IOCTL_MAGIC, 10, unsigned)
+#define AUDIO_ENABLE_AUDPRE  _IOW(AUDIO_IOCTL_MAGIC, 11, unsigned)
+#define AUDIO_SET_AGC        _IOW(AUDIO_IOCTL_MAGIC, 12, unsigned)
+#define AUDIO_SET_NS         _IOW(AUDIO_IOCTL_MAGIC, 13, unsigned)
+#define AUDIO_SET_TX_IIR     _IOW(AUDIO_IOCTL_MAGIC, 14, unsigned)
+#define AUDIO_PAUSE	     _IOW(AUDIO_IOCTL_MAGIC, 15, unsigned)
+#define AUDIO_GET_PCM_CONFIG _IOR(AUDIO_IOCTL_MAGIC, 30, unsigned)
+#define AUDIO_SET_PCM_CONFIG _IOW(AUDIO_IOCTL_MAGIC, 31, unsigned)
+#define AUDIO_SWITCH_DEVICE  _IOW(AUDIO_IOCTL_MAGIC, 32, unsigned)
+
+#define	AUDIO_MAX_COMMON_IOCTL_NUM	100
+
+#define	AUDIO_MAX_COMMON_IOCTL_NUM	100
+
+struct msm_audio_config {
+	uint32_t buffer_size;
+	uint32_t buffer_count;
+	uint32_t channel_count;
+	uint32_t sample_rate;
+	uint32_t type;
+	uint32_t unused[3];
+};
+
+struct msm_audio_stats {
+	uint32_t byte_count;
+	uint32_t sample_count;
+	uint32_t unused[2];
+};
+
+/* Audio routing */
+
+#define SND_IOCTL_MAGIC 's'
+
+#define SND_MUTE_UNMUTED 0
+#define SND_MUTE_MUTED   1
+
+struct msm_snd_device_config {
+	uint32_t device;
+	uint32_t ear_mute;
+	uint32_t mic_mute;
+};
+
+#define SND_SET_DEVICE _IOW(SND_IOCTL_MAGIC, 2, struct msm_device_config *)
+
+#define SND_METHOD_VOICE 0
+
+struct msm_snd_volume_config {
+	uint32_t device;
+	uint32_t method;
+	uint32_t volume;
+};
+
+#define SND_SET_VOLUME _IOW(SND_IOCTL_MAGIC, 3, struct msm_snd_volume_config *)
+
+/* Returns the number of SND endpoints supported. */
+
+#define SND_GET_NUM_ENDPOINTS _IOR(SND_IOCTL_MAGIC, 4, unsigned *)
+
+struct msm_snd_endpoint {
+	int id; /* input and output */
+	char name[64]; /* output only */
+};
+
+/* Takes an index between 0 and one less than the number returned by
+ * SND_GET_NUM_ENDPOINTS, and returns the SND index and name of a
+ * SND endpoint.  On input, the .id field contains the number of the
+ * endpoint, and on exit it contains the SND index, while .name contains
+ * the description of the endpoint.
+ */
+
+#define SND_GET_ENDPOINT _IOWR(SND_IOCTL_MAGIC, 5, struct msm_snd_endpoint *)
+
+struct msm_audio_pcm_config {
+	uint32_t pcm_feedback;	/* 0 - disable > 0 - enable */
+	uint32_t buffer_count;	/* Number of buffers to allocate */
+	uint32_t buffer_size;	/* Size of buffer for capturing of
+				   PCM samples */
+};
+#endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
