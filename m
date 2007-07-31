Return-Path: <linux-kernel-owner+w=401wt.eu-S941355AbXGaEk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941355AbXGaEk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967093AbXGaEcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:32:51 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34734 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331AbXGaEcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:32:48 -0400
Date: Mon, 30 Jul 2007 21:33:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       v4l-dvb-maintainer@linuxtv.org, xyzzy@speakeasy.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 25/26] V4L: bttv: fix v4l1 api usage breaking the driver
Message-ID: <20070731043359.GZ3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-bttv-fix-v4l1-api-usage-breaking-the-driver.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trent Piepho <xyzzy@speakeasy.org>

If one uses a V4L *one* application, such as vlc or mplayer's v4l driver, as
the first user after the driver is loaded, the driver wedges itself and will
never capture properly.  Even if one uses a V4L2 application later, it still
won't work.

If one uses a V4L *two* application first, such as tvtime or mplayer's v4l2
driver, then the driver will be ok.  One can then run a V4L1 application, and
it will work.

It turns out the problem is with norm changing and the crop support that was
added in 2.6.21.  The driver defaults to PAL, and keeps the last norm it was
set too across opens.  If one changes the norm via V4L1, the cropping
parameters are not reset like they should be, and they'll remain broken across
device opens.

This patch removes the direct setting of btv->tvnorm in the V4L1 ioctl
VIDIOCSCHAN handler.  The norm is set via the existing call to set_input(),
which calls set_tvnorm(), which will reset the cropping values now that it is
able to detect the norm change.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
(cherry picked from commit 333408f21590d50397f3004e3f87070fa8f52c51)

 drivers/media/video/bt8xx/bttv-driver.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- linux-2.6.21.6.orig/drivers/media/video/bt8xx/bttv-driver.c
+++ linux-2.6.21.6/drivers/media/video/bt8xx/bttv-driver.c
@@ -1313,7 +1313,7 @@ set_tvnorm(struct bttv *btv, unsigned in
 
 /* Call with btv->lock down. */
 static void
-set_input(struct bttv *btv, unsigned int input)
+set_input(struct bttv *btv, unsigned int input, unsigned int norm)
 {
 	unsigned long flags;
 
@@ -1332,7 +1332,7 @@ set_input(struct bttv *btv, unsigned int
 	}
 	audio_input(btv,(input == bttv_tvcards[btv->c.type].tuner ?
 		       TVAUDIO_INPUT_TUNER : TVAUDIO_INPUT_EXTERN));
-	set_tvnorm(btv,btv->tvnorm);
+	set_tvnorm(btv, norm);
 	i2c_vidiocschan(btv);
 }
 
@@ -1423,7 +1423,7 @@ static void bttv_reinit_bt848(struct btt
 
 	init_bt848(btv);
 	btv->pll.pll_current = -1;
-	set_input(btv,btv->input);
+	set_input(btv, btv->input, btv->tvnorm);
 }
 
 static int get_control(struct bttv *btv, struct v4l2_control *c)
@@ -1993,8 +1993,7 @@ static int bttv_common_ioctls(struct btt
 			return 0;
 		}
 
-		btv->tvnorm = v->norm;
-		set_input(btv,v->channel);
+		set_input(btv, v->channel, v->norm);
 		mutex_unlock(&btv->lock);
 		return 0;
 	}
@@ -2130,7 +2129,7 @@ static int bttv_common_ioctls(struct btt
 		if (*i > bttv_tvcards[btv->c.type].video_inputs)
 			return -EINVAL;
 		mutex_lock(&btv->lock);
-		set_input(btv,*i);
+		set_input(btv, *i, btv->tvnorm);
 		mutex_unlock(&btv->lock);
 		return 0;
 	}
@@ -4762,7 +4761,7 @@ static int __devinit bttv_probe(struct p
 		bt848_hue(btv,32768);
 		bt848_sat(btv,32768);
 		audio_mute(btv, 1);
-		set_input(btv,0);
+		set_input(btv, 0, btv->tvnorm);
 		bttv_crop_reset(&btv->crop[0], btv->tvnorm);
 		btv->crop[1] = btv->crop[0]; /* current = default */
 		disclaim_vbi_lines(btv);

-- 
