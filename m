Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbYEGTan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbYEGTan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbYEGTad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:30:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbYEGTa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:30:29 -0400
Date: Wed, 7 May 2008 16:29:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Jaime Velasco" <jsagarribay@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] video: fix build bugs in
 drivers/media/video/stk-webcam.c
Message-ID: <20080507162950.23f191e2@gaivota>
In-Reply-To: <461039140804300011v5454a169ldbd17ebefa2391d@mail.gmail.com>
References: <20080429131824.GA4742@elte.hu>
	<461039140804300011v5454a169ldbd17ebefa2391d@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 08:11:08 +0100
"Jaime Velasco" <jsagarribay@gmail.com> wrote:

> 2008/4/29 Ingo Molnar <mingo@elte.hu>:
> >
> >  x86.git randconfig testing found these build bugs in current -git:
> >
> >   drivers/media/video/stk-webcam.c: In function 'stk_create_sysfs_files':
> >   drivers/media/video/stk-webcam.c:340: error: implicit declaration of function 'video_device_create_file'
> >   drivers/media/video/stk-webcam.c: In function 'stk_remove_sysfs_files':
> >   [...]
> >   drivers/media/video/stk-webcam.c: In function 'v4l_stk_mmap':
> >   drivers/media/video/stk-webcam.c:846: error: 'VM_WRITE' undeclared (first use in this function)
> >   [...]
> >
> >  config at:
> >
> >   http://redhat.com/~mingo/misc/config-Tue_Apr_29_15_00_47_CEST_2008.bad
> >
> >  the reason was a missing include file, and a dependency on a deprecated
> >  (but still in use) VIDEO_V4L1_COMPAT API.
> >
> >  Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Acked-by: Jaime Velasco Juan <jsagarribay@gmail.com>

The V4L1 symbols are used to help us to track what drivers are still using the
depreciated V4L1 API, or otherwise provide support for V4L1 compatibility
layer. This is not the case of stkwebcam.

So, instead of the proposed patch, I prefer just to disable the additional
non-V4L2 sysfs interface, if the flag is not enabled.

There are some discussions at the ML to create a standard to allow configuring
V4L2 controls via sysfs, but this is not standard yet. The idea is to add some
support at videodev.h using the same handlers defined by video_ioctl2.
Unfortunately, people stopped discussing this, due to the lack of time and
people to work on this.

I think this could be a nice addition to V4L2, and will help to avoid creating
non-standardized interfaces at sysfs.

> For the record, this bug was found in march, but it seems
> I forgot to CC: the patch to Mauro, Sorry about that.
> 
> http://marc.info/?l=linux-video&m=120594964524615&w=2

I probably missed this.

---

Instead of Ingo's approach, this seems to be cleaner:

Fix compilation, when V4L1_COMPAT is disabled

From: Mauro Carvalho Chehab <mchehab@infradead.org>

This driver uses some sysfs helper functions that are available only for legacy
drivers. It also requires linux/mm.h.

This patch fixes compiliation when not in compat mode.

Thanks to Ingo Molnar for identifying this issue.

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
---

 drivers/media/video/stk-webcam.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index 9276ed9..b12c60c 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -30,6 +30,7 @@
 #include <linux/kref.h>
 
 #include <linux/usb.h>
+#include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
@@ -245,6 +246,8 @@ static int stk_initialise(struct stk_camera *dev)
 		return -1;
 }
 
+#ifdef CONFIG_VIDEO_V4L1_COMPAT
+
 /* sysfs functions */
 /*FIXME cleanup this */
 
@@ -350,6 +353,10 @@ static void stk_remove_sysfs_files(struct video_device *vdev)
 	video_device_remove_file(vdev, &dev_attr_vflip);
 }
 
+#else
+#define stk_create_sysfs_files(a)
+#define stk_remove_sysfs_files(a)
+#endif
 
 /* *********************************************** */
 /*





Cheers,
Mauro
