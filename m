Return-Path: <linux-kernel-owner+w=401wt.eu-S1762202AbZCNAp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762202AbZCNAp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbZCNATx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:53 -0400
Received: from kroah.org ([198.145.64.141]:34980 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750871AbZCNATj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:39 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:51 2009
Message-Id: <20090314000750.928991728@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 78/96] V4L: ivtv: fix decoder crash regression
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=0003-V4L-ivtv-fix-decoder-crash-regression.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

(cherry picked from commit ac9575f75c52bcb455120f8c43376b556acba048)

The video_ioctl2 conversion of ivtv in kernel 2.6.27 introduced a bug
causing decoder commands to crash. The decoder commands should have been
handled from the video_ioctl2 default handler, ensuring correct mapping
of the argument between user and kernel space. Unfortunately they ended
up before the video_ioctl2 call, causing random crashes.

Thanks to hannes@linus.priv.at for testing and helping me track down the
cause!

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/ivtv/ivtv-ioctl.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1744,6 +1744,18 @@ static int ivtv_default(struct file *fil
 		break;
 	}
 
+	case IVTV_IOC_DMA_FRAME:
+	case VIDEO_GET_PTS:
+	case VIDEO_GET_FRAME_COUNT:
+	case VIDEO_GET_EVENT:
+	case VIDEO_PLAY:
+	case VIDEO_STOP:
+	case VIDEO_FREEZE:
+	case VIDEO_CONTINUE:
+	case VIDEO_COMMAND:
+	case VIDEO_TRY_COMMAND:
+		return ivtv_decoder_ioctls(file, cmd, (void *)arg);
+
 	default:
 		return -EINVAL;
 	}
@@ -1786,18 +1798,6 @@ static int ivtv_serialized_ioctl(struct 
 		ivtv_vapi(itv, CX2341X_DEC_SET_AUDIO_MODE, 2, itv->audio_bilingual_mode, itv->audio_stereo_mode);
 		return 0;
 
-	case IVTV_IOC_DMA_FRAME:
-	case VIDEO_GET_PTS:
-	case VIDEO_GET_FRAME_COUNT:
-	case VIDEO_GET_EVENT:
-	case VIDEO_PLAY:
-	case VIDEO_STOP:
-	case VIDEO_FREEZE:
-	case VIDEO_CONTINUE:
-	case VIDEO_COMMAND:
-	case VIDEO_TRY_COMMAND:
-		return ivtv_decoder_ioctls(filp, cmd, (void *)arg);
-
 	default:
 		break;
 	}


