Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbZCTXTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbZCTXTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbZCTXNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:13:50 -0400
Received: from kroah.org ([198.145.64.141]:53165 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759401AbZCTXNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:13:49 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:11 2009
Message-Id: <20090320222711.617501597@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:28 -0700
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
       alan@lxorguk.ukuu.org.uk, Mark Jenks <mjenks1968@gmail.com>,
       Andy Walls <awalls@radix.net>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Jarod Wilson <jarod@redhat.com>
Subject: [patch 17/32] V4L/DVB (10218): cx23885: Fix Oops for mixed install of analog and digital only cards
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-cx23885-fix-oops-for-mixed-install-of-analog-and-digital-only-cards.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andy Walls <awalls@radix.net>

commit cd8f894eacf13996d920fdd2aef1afc55156b191 upstream.

Analog support for HVR-1250 has not been completed, but does exist for
the HVR-1800.

Since both cards use the same driver, it tries to create the analog
dev for both devices, which is not possible.

This causes a NULL error to show up in video_open and mpeg_open.

-Mark

Iterations through the cx23885_devlist must check for NULL
pointers as some supported devices only have DVB support at the moment.
Mark Jenks encoutered an Oops in a system with both an HVR-1250 and HVR-1800
installed.

-Andy

Reported-by: Mark Jenks <mjenks1968@gmail.com>
Tested-by: Mark Jenks <mjenks1968@gmail.com>
Signed-off-by: Mark Jenks <mjenks1968@gmail.com>
Signed-off-by: Andy Walls <awalls@radix.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx23885/cx23885-417.c   |    3 ++-
 drivers/media/video/cx23885/cx23885-video.c |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -1585,7 +1585,8 @@ static int mpeg_open(struct inode *inode
 
 	list_for_each(list, &cx23885_devlist) {
 		h = list_entry(list, struct cx23885_dev, devlist);
-		if (h->v4l_device->minor == minor) {
+		if (h->v4l_device &&
+		    h->v4l_device->minor == minor) {
 			dev = h;
 			break;
 		}
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -733,12 +733,13 @@ static int video_open(struct inode *inod
 
 	list_for_each(list, &cx23885_devlist) {
 		h = list_entry(list, struct cx23885_dev, devlist);
-		if (h->video_dev->minor == minor) {
+		if (h->video_dev &&
+		    h->video_dev->minor == minor) {
 			dev  = h;
 			type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		}
 		if (h->vbi_dev &&
-		   h->vbi_dev->minor == minor) {
+		    h->vbi_dev->minor == minor) {
 			dev  = h;
 			type = V4L2_BUF_TYPE_VBI_CAPTURE;
 		}


