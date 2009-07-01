Return-Path: <linux-kernel-owner+w=401wt.eu-S1764686AbZGAA4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764686AbZGAA4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761413AbZGAAel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:41 -0400
Received: from kroah.org ([198.145.64.141]:60283 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761440AbZGAAei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:24 2009
Message-Id: <20090701002424.089082409@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Isely <isely@pobox.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Michael Krufky <mkrufky@linuxtv.org>
Subject: [patch 035/108] V4L: pvrusb2: Re-fix hardware scaling on video standard change
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=v4l-pvrusb2-re-fix-hardware-scaling-on-video-standard-change.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Isely <isely@pobox.com>

(cherry picked from commit a6862da2f3c7ce3ec6644958bc8937b630b9e2c1)

The cx25840 module's VBI initialization logic uses the current video
standard as part of its internal algorithm.  This therefore means that
we probably need to make sure that the correct video standard has been
set before initializing VBI.  (Normally we would not care about VBI,
but as described in an earlier changeset, VBI must be initialized
correctly on the cx25840 in order for the chip's hardware scaler to
operate correctly.)

It's kind of messy to force the video standard to be set before
initializing VBI (mainly because we can't know what the app really
wants that early in the initialization process).  So this patch does
the next best thing: VBI is re-initialized after any point where the
video standard has been set.

Signed-off-by: Mike Isely <isely@pobox.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/pvrusb2/pvrusb2-hdw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -2950,6 +2950,7 @@ static void pvr2_subdev_update(struct pv
 			vs = hdw->std_mask_cur;
 			v4l2_device_call_all(&hdw->v4l2_dev, 0,
 					     core, s_std, vs);
+			pvr2_hdw_cx25840_vbi_hack(hdw);
 		}
 		hdw->tuner_signal_stale = !0;
 		hdw->cropcap_stale = !0;


