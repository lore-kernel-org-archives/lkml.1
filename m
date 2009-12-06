Return-Path: <linux-kernel-owner+w=401wt.eu-S934606AbZLGAdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934606AbZLGAdC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:33:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbZLGAMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:48 -0500
Received: from kroah.org ([198.145.64.141]:34244 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758306AbZLGAMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:43 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:44 2009
Message-Id: <20091207000644.059666416@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Isely <isely@pobox.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [023/119] V4L/DVB (13169): bttv: Fix potential out-of-order field processing
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13169-bttv-fix-potential-out-of-order-field-processing.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mike Isely <isely@pobox.com>

commit 66349b4e7ab3825dbfc167a5f0309792a587adb7 upstream.

There is a subtle interaction in the bttv driver which can result in
fields being repeatedly processed out of order.  This is a problem
specifically when running in V4L2_FIELD_ALTERNATE mode (probably the
most common case).

1. The determination of which fields are associated with which buffers
happens in videobuf, before the bttv driver gets a chance to queue the
corresponding DMA.  Thus by the point when the DMA is queued for a
given buffer, the algorithm has to do the queuing based on the
buffer's already assigned field type - not based on which field is
"next" in the video stream.

2. The driver normally tries to queue both the top and bottom fields
at the same time (see bttv_irq_next_video()).  It tries to sort out
top vs bottom by looking at the field type for the next 2 available
buffers and assigning them appropriately.

3. However the bttv driver *always* actually processes the top field
first.  There's even an interrupt set aside for specifically
recognizing when the top field has been processed so that it can be
marked done even while the bottom field is still being DMAed.

Given all of the above, if one gets into a situation where
bttv_irq_next_video() gets entered when the first available buffer has
been pre-associated as a bottom field, then the function is going to
process the buffers out of order.  That first available buffer will be
put into the bottom field slot and the buffer after that will be put
into the top field slot.  Problem is, since the top field is always
processed first by the driver, then that second buffer (the one after
the first available buffer) will be the first one to be finished.
Because of the strict fifo handling of all video buffers, then that
top field won't be seen by the app until after the bottom field is
also processed.  Worse still, the app will get back the
chronologically later bottom field first, *before* the top field is
received.  The buffer's timestamps will even be backwards.

While not fatal to most TV apps, this behavior can subtlely degrade
userspace deinterlacing (probably will cause jitter).  That's probably
why it has gone unnoticed.  But it will also cause serious problems if
the app in question discards all but the latest received buffer (a
latency minimizing tactic) - causing one field to only ever be
displayed since the other is now always late.  Unfortunately once you
get into this state, you're stuck this way - because having consumed
two buffers, now the next time around the "first" available buffer
will again be a bottom field and the same thing happens.

How can we get into this state?  In a perfect world, where there's
always a few free buffers queued to the driver, it should be
impossible.  However if something disrupts streaming, e.g. if the
userspace app can't queue free buffers fast enough for a moment due
perhaps to a CPU scheduling glitch, then the driver can get
momentarily starved and some number of fields will be dropped.  That's
OK.  But if an odd number of fields get dropped, then that "first"
available buffer might be the bottom field and now we're stuck...

This patch fixes that problem by deliberately only setting up a single
field for one frame if we don't get a top field as the first available
buffer.  By purposely skipping the other field, then we only handle a
single buffer thus bringing things back into proper sync (i.e. top
field first) for the next frame.  To do this we just drop the few
lines in bttv_irq_next_video() that attempt to set up the second
buffer when that second buffer isn't for the bottom field.

This is definitely a problem in when in V4L2_FIELD_ALTERNATE mode.  In
the other modes this change either has no effect or doesn't harm
things any further anyway.

Signed-off-by: Mike Isely <isely@pobox.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/bt8xx/bttv-driver.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3798,11 +3798,34 @@ bttv_irq_next_video(struct bttv *btv, st
 		if (!V4L2_FIELD_HAS_BOTH(item->vb.field) &&
 		    (item->vb.queue.next != &btv->capture)) {
 			item = list_entry(item->vb.queue.next, struct bttv_buffer, vb.queue);
+			/* Mike Isely <isely@pobox.com> - Only check
+			 * and set up the bottom field in the logic
+			 * below.  Don't ever do the top field.  This
+			 * of course means that if we set up the
+			 * bottom field in the above code that we'll
+			 * actually skip a field.  But that's OK.
+			 * Having processed only a single buffer this
+			 * time, then the next time around the first
+			 * available buffer should be for a top field.
+			 * That will then cause us here to set up a
+			 * top then a bottom field in the normal way.
+			 * The alternative to this understanding is
+			 * that we set up the second available buffer
+			 * as a top field, but that's out of order
+			 * since this driver always processes the top
+			 * field first - the effect will be the two
+			 * buffers being returned in the wrong order,
+			 * with the second buffer also being delayed
+			 * by one field time (owing to the fifo nature
+			 * of videobuf).  Worse still, we'll be stuck
+			 * doing fields out of order now every time
+			 * until something else causes a field to be
+			 * dropped.  By effectively forcing a field to
+			 * drop this way then we always get back into
+			 * sync within a single frame time.  (Out of
+			 * order fields can screw up deinterlacing
+			 * algorithms.) */
 			if (!V4L2_FIELD_HAS_BOTH(item->vb.field)) {
-				if (NULL == set->top &&
-				    V4L2_FIELD_TOP == item->vb.field) {
-					set->top = item;
-				}
 				if (NULL == set->bottom &&
 				    V4L2_FIELD_BOTTOM == item->vb.field) {
 					set->bottom = item;


