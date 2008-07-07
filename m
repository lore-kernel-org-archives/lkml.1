Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYGGRkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYGGRkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYGGRkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:40:32 -0400
Received: from qmta01.westchester.pa.mail.comcast.net ([76.96.62.16]:57787
	"EHLO QMTA01.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753751AbYGGRkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:40:31 -0400
X-Authority-Analysis: v=1.0 c=1 a=fmkApugzUIIA:10 a=kpXAE35kjxYA:10
 a=_IJnZSgf9f5JNVSi5xgA:9 a=slYTfeDnTvTaJRxpne8A:7
 a=8mjJQg54jTdEpqmjD8f-b9wE5HgA:4 a=JTUSPwgBgNAA:10 a=oCUJXWGl-OwA:10
To: Romano Giannetti <romano@dea.icai.upcomillas.es>
Cc: linux-kernel@vger.kernel.org, linux-uvc-devel@berlios.de,
       laurent.pinchart@skynet.be
Subject: Re: Linux 2.6.26-rc9 circular lock with uvcvideo on resume from hibernation
X-Message-Flag: Warning: May contain useful information
X-Priority: 1
X-MSMail-Priority: High
References: <1215426867.5113.8.camel@pern>
From: Roland Dreier <roland@digitalvampire.org>
Date: Mon, 07 Jul 2008 10:40:28 -0700
In-Reply-To: <1215426867.5113.8.camel@pern> (Romano Giannetti's message of "Mon, 07 Jul 2008 12:34:26 +0200")
Message-ID: <878wwdbnjn.fsf@shaolin.home.digitalvampire.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > [ 1132.942569] khubd/2264 is trying to acquire lock:
 > [ 1132.942614]  (videodev_lock){--..}, at: [<f89e4595>] video_unregister_device+0x15/0x60 [videodev]
 > [ 1132.942810] 
 > [ 1132.942811] but task is already holding lock:
 > [ 1132.942890]  (&uvc_driver.open_mutex){--..}, at: [<f8a35c09>] uvc_disconnect+0x29/0x50 [uvcvideo]

Thanks very much for the report (and for testing development kernels
with lockdep enabled!).  I think the patch below should fix this.

Laurent -- if this patch looks good to you, please forward on for
merging.

Thanks,
  Roland

---

[PATCH] uvc: Fix possible AB-BA deadlock with videodev_lock and open_mutex

The uvcvideo driver's uvc_v4l2_open() method is called from videodev's
video_open() function, which means it is called with the videodev_lock
mutex held.  uvc_v4l2_open() then takes uvc_driver.open_mutex to check
dev->state and avoid racing against a device disconnect, which means
that open_mutex must nest inside videodev_lock.

However uvc_disconnect() takes the open_mutex around setting
dev->state and also around putting its device reference.  However, if
uvc_disconnect() ends up dropping the last reference, it will call
uvc_delete(), which calls into the videodev code to unregister its
device, and this will end up taking videodev_lock.  This opens a
(unlikely in practice) window for an AB-BA deadlock and also causes a
lockdep warning because of the lock misordering.

Fortunately there is no apparent reason to hold open_mutex when doing
kref_put() in uvc_disconnect(): if uvc_v4l2_open() runs before the
state is set to UVC_DEV_DISCONNECTED, then it will take another
reference to the device and kref_put() won't call uvc_delete; if
uvc_v4l2_open() runs after the state is set, it will run before
uvc_delete(), see the state, and return immediately -- uvc_delete()
does uvc_unregister_video() (and hence video_unregister_device(),
which is synchronized with videodev_lock) as its first thing, so there
is no risk of use-after-free in uvc_v4l2_open().

Bug diagnosed based on a lockdep warning reported by Romano Giannetti
<romano@dea.icai.upcomillas.es>.

Signed-off-by: Roland Dreier <roland@digitalvampire.org>
---
 drivers/media/video/uvc/uvc_driver.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 60ced58..5d60cb3 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -1634,11 +1634,10 @@ static void uvc_disconnect(struct usb_interface *intf)
 	 * chance to increase the reference count (kref_get).
 	 */
 	mutex_lock(&uvc_driver.open_mutex);
-
 	dev->state |= UVC_DEV_DISCONNECTED;
-	kref_put(&dev->kref, uvc_delete);
-
 	mutex_unlock(&uvc_driver.open_mutex);
+
+	kref_put(&dev->kref, uvc_delete);
 }
 
 static int uvc_suspend(struct usb_interface *intf, pm_message_t message)

