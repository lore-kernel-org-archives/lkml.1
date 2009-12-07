Return-Path: <linux-kernel-owner+w=401wt.eu-S1758875AbZLGAeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbZLGAeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758504AbZLGAdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:33:51 -0500
Received: from kroah.org ([198.145.64.141]:34248 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758330AbZLGAMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:44 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:44 2009
Message-Id: <20091207000644.223985205@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Isely <isely@pobox.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [024/119] V4L/DVB (13170): bttv: Fix reversed polarity error when switching video standard
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13170-bttv-fix-reversed-polarity-error-when-switching-video-standard.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mike Isely <isely@pobox.com>

commit 2de26c0a4a218a351bb1970eeaddf2905b47ff13 upstream.

The bttv driver function which handles switching of the video standard
(set_tvnorm() in bttv-driver.c) includes a check which can optionally
also reset the cropping configuration to a default value.  It is
"optional" based on a comparison of the cropcap parameters of the
previous vs the newly requested video standard.  The comparison is
being done with a memcmp(), a function which only returns a true value
if the comparison actually fails.

This if-statement appears to have been written to assume wrong
memcmp() semantics.  That is, it was re-initializing the cropping
configuration only if the new video standard did NOT have different
cropcap values.  That doesn't make any sense.  One definitely should
reset things if the cropcap parameters are different - if there's any
comparison to made at all.

The effect of this problem was that a transition from, say, PAL to
NTSC would leave in place old cropping setup that made sense for the
PAL geometry but not for NTSC.  If the application doesn't care about
cropping it also won't try to reset the cropping configuration,
resulting in an improperly cropped video frame.  In the case I was
testing this actually caused black video frames to be displayed.

Another interesting effect of this bug is that if one does something
which does NOT change the video standard and this function is run,
then the cropping setup gets reset anyway - again because of the
backwards comparison.  It turns out that just running anything which
merely opens and closes the video device node (e.g. v4l-info) will
cause this to happen.  One can argue that simply opening the device
node and not doing anything to it should not mess with any of its
state - but because of this behavior, any TV app which does such
things (e.g. xawtv) probably therefore doesn't see the problem.

The solution is to fix the sense of the if-statement.  It's easy to
see how this mistake could have been made given how memcmp() works.
The patch is therefore removal of a single "!" character from the
if-statement in set_tvnorm in bttv-driver.c.

Signed-off-by: Mike Isely <isely@pobox.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/bt8xx/bttv-driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -1299,7 +1299,7 @@ set_tvnorm(struct bttv *btv, unsigned in
 
 	tvnorm = &bttv_tvnorms[norm];
 
-	if (!memcmp(&bttv_tvnorms[btv->tvnorm].cropcap, &tvnorm->cropcap,
+	if (memcmp(&bttv_tvnorms[btv->tvnorm].cropcap, &tvnorm->cropcap,
 		    sizeof (tvnorm->cropcap))) {
 		bttv_crop_reset(&btv->crop[0], norm);
 		btv->crop[1] = btv->crop[0]; /* current = default */


