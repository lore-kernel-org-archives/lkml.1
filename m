Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbYEKTzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbYEKTzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYEKTzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:55:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:32239 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYEKTzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:55:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=biQeEGueNy/LkzvDSIceLBMO2TfB4Ye6YoFW1zc0aL92crc+dhC69GqbaV+4gy1OE1nCvKRvNZ68tPSRW8iBbkOw5Um8Cfwjn0/OGw3H8tWey8v3Zh66++Osl0AwSdIf2AupGkjn7s0FYgTJwowCNKRRRoVw8voL9aLkE0V/NQs=
Date: Sun, 11 May 2008 21:54:41 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] v4l/tuner-core: consistent handling of return values
Message-ID: <20080511195438.GE19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change check_mode and set_mode to return negative errors and fix all callers

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
compile tested only
---
 drivers/media/video/tuner-core.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -539,7 +539,7 @@ static void set_addr(struct i2c_client *c, struct tuner_setup *tun_setup)
 static inline int check_mode(struct tuner *t, char *cmd)
 {
 	if ((1 << t->mode & t->mode_mask) == 0) {
-		return EINVAL;
+		return -EINVAL;
 	}
 
 	switch (t->mode) {
@@ -733,11 +733,11 @@ static inline int set_mode(struct i2c_client *client, struct tuner *t, int mode,
 
 	t->mode = mode;
 
-	if (check_mode(t, cmd) == EINVAL) {
+	if (check_mode(t, cmd) == -EINVAL) {
 		t->mode = T_STANDBY;
 		if (analog_ops->standby)
 			analog_ops->standby(&t->fe);
-		return EINVAL;
+		return -EINVAL;
 	}
 	return 0;
 }
@@ -779,13 +779,13 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 		break;
 	case AUDC_SET_RADIO:
 		if (set_mode(client, t, V4L2_TUNER_RADIO, "AUDC_SET_RADIO")
-				== EINVAL)
+				== -EINVAL)
 			return 0;
 		if (t->radio_freq)
 			set_freq(client, t->radio_freq);
 		break;
 	case TUNER_SET_STANDBY:
-		if (check_mode(t, "TUNER_SET_STANDBY") == EINVAL)
+		if (check_mode(t, "TUNER_SET_STANDBY") == -EINVAL)
 			return 0;
 		t->mode = T_STANDBY;
 		if (analog_ops->standby)
@@ -793,7 +793,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 		break;
 #ifdef CONFIG_VIDEO_ALLOW_V4L1
 	case VIDIOCSAUDIO:
-		if (check_mode(t, "VIDIOCSAUDIO") == EINVAL)
+		if (check_mode(t, "VIDIOCSAUDIO") == -EINVAL)
 			return 0;
 		if (check_v4l2(t) == EINVAL)
 			return 0;
@@ -816,7 +816,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 			if (check_v4l2(t) == EINVAL)
 				return 0;
 
-			if (set_mode(client,t,V4L2_TUNER_ANALOG_TV, "VIDIOCSCHAN")==EINVAL)
+			if (set_mode(client,t,V4L2_TUNER_ANALOG_TV, "VIDIOCSCHAN")==-EINVAL)
 				return 0;
 
 			if (vc->norm < ARRAY_SIZE(map))
@@ -830,7 +830,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 		{
 			unsigned long *v = arg;
 
-			if (check_mode(t, "VIDIOCSFREQ") == EINVAL)
+			if (check_mode(t, "VIDIOCSFREQ") == -EINVAL)
 				return 0;
 			if (check_v4l2(t) == EINVAL)
 				return 0;
@@ -842,7 +842,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 		{
 			struct video_tuner *vt = arg;
 
-			if (check_mode(t, "VIDIOCGTUNER") == EINVAL)
+			if (check_mode(t, "VIDIOCGTUNER") == -EINVAL)
 				return 0;
 			if (check_v4l2(t) == EINVAL)
 				return 0;
@@ -886,7 +886,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 		{
 			struct video_audio *va = arg;
 
-			if (check_mode(t, "VIDIOCGAUDIO") == EINVAL)
+			if (check_mode(t, "VIDIOCGAUDIO") == -EINVAL)
 				return 0;
 			if (check_v4l2(t) == EINVAL)
 				return 0;
@@ -928,7 +928,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 			v4l2_std_id *id = arg;
 
 			if (set_mode (client, t, V4L2_TUNER_ANALOG_TV, "VIDIOC_S_STD")
-					== EINVAL)
+					== -EINVAL)
 				return 0;
 
 			switch_v4l2();
@@ -944,7 +944,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 			struct v4l2_frequency *f = arg;
 
 			if (set_mode (client, t, f->type, "VIDIOC_S_FREQUENCY")
-					== EINVAL)
+					== -EINVAL)
 				return 0;
 			switch_v4l2();
 			set_freq(client,f->frequency);
@@ -955,7 +955,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 		{
 			struct v4l2_frequency *f = arg;
 
-			if (check_mode(t, "VIDIOC_G_FREQUENCY") == EINVAL)
+			if (check_mode(t, "VIDIOC_G_FREQUENCY") == -EINVAL)
 				return 0;
 			switch_v4l2();
 			f->type = t->mode;
@@ -976,7 +976,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 		{
 			struct v4l2_tuner *tuner = arg;
 
-			if (check_mode(t, "VIDIOC_G_TUNER") == EINVAL)
+			if (check_mode(t, "VIDIOC_G_TUNER") == -EINVAL)
 				return 0;
 			switch_v4l2();
 
@@ -1023,7 +1023,7 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 		{
 			struct v4l2_tuner *tuner = arg;
 
-			if (check_mode(t, "VIDIOC_S_TUNER") == EINVAL)
+			if (check_mode(t, "VIDIOC_S_TUNER") == -EINVAL)
 				return 0;
 
 			switch_v4l2();
-- 
