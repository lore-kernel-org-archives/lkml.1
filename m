Return-Path: <linux-kernel-owner+w=401wt.eu-S936137AbXHGVBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936137AbXHGVBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935548AbXHGUuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:50:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56309 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935541AbXHGUuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:50:54 -0400
Date: Tue, 7 Aug 2007 13:45:14 -0700
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
       Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [2.6.22.2 review 30/84] V4L: ivtv: Add locking to ensure stream
	setup is atomic
Message-ID: <20070807204514.GE23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-ivtv-add-locking-to-ensure-stream-setup-is-atomic.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Hans Verkuil <hverkuil@xs4all.nl>

Starting an MPEG and VBI capture simultaneously caused errors in
the VBI setup: this setup was done twice when it should be done
only for the first stream that is opened.
Added a mutex to prevent this from happening.

(cherry picked from commit f885969196da6ae905162c0d1c5f0553de12cb40)

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

---
 drivers/media/video/ivtv/ivtv-driver.c  |    1 +
 drivers/media/video/ivtv/ivtv-driver.h  |    1 +
 drivers/media/video/ivtv/ivtv-streams.c |   30 +++++++++++++++++++-----------
 3 files changed, 21 insertions(+), 11 deletions(-)

--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -622,6 +622,7 @@ static int __devinit ivtv_init_struct1(s
 	itv->enc_mbox.max_mbox = 2; /* the encoder has 3 mailboxes (0-2) */
 	itv->dec_mbox.max_mbox = 1; /* the decoder has 2 mailboxes (0-1) */
 
+	mutex_init(&itv->serialize_lock);
 	mutex_init(&itv->i2c_bus_lock);
 	mutex_init(&itv->udma.lock);
 
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -722,6 +722,7 @@ struct ivtv {
 	int search_pack_header;
 
 	spinlock_t dma_reg_lock; /* lock access to DMA engine registers */
+	struct mutex serialize_lock;  /* lock used to serialize starting streams */
 
 	/* User based DMA for OSD */
 	struct ivtv_user_dma udma;
--- a/drivers/media/video/ivtv/ivtv-streams.c
+++ b/drivers/media/video/ivtv/ivtv-streams.c
@@ -446,6 +446,9 @@ int ivtv_start_v4l2_encode_stream(struct
 	if (s->v4l2dev == NULL)
 		return -EINVAL;
 
+	/* Big serialization lock to ensure no two streams are started
+	   simultaneously: that can give all sorts of weird results. */
+	mutex_lock(&itv->serialize_lock);
 	IVTV_DEBUG_INFO("Start encoder stream %s\n", s->name);
 
 	switch (s->type) {
@@ -487,6 +490,7 @@ int ivtv_start_v4l2_encode_stream(struct
 			0, sizeof(itv->vbi.sliced_mpeg_size));
 		break;
 	default:
+		mutex_unlock(&itv->serialize_lock);
 		return -EINVAL;
 	}
 	s->subtype = subtype;
@@ -568,6 +572,7 @@ int ivtv_start_v4l2_encode_stream(struct
 	if (ivtv_vapi(itv, CX2341X_ENC_START_CAPTURE, 2, captype, subtype))
 	{
 		IVTV_DEBUG_WARN( "Error starting capture!\n");
+		mutex_unlock(&itv->serialize_lock);
 		return -EINVAL;
 	}
 
@@ -583,6 +588,7 @@ int ivtv_start_v4l2_encode_stream(struct
 
 	/* you're live! sit back and await interrupts :) */
 	atomic_inc(&itv->capturing);
+	mutex_unlock(&itv->serialize_lock);
 	return 0;
 }
 
@@ -762,17 +768,6 @@ int ivtv_stop_v4l2_encode_stream(struct 
 	/* when: 0 =  end of GOP  1 = NOW!, type: 0 = mpeg, subtype: 3 = video+audio */
 	ivtv_vapi(itv, CX2341X_ENC_STOP_CAPTURE, 3, stopmode, cap_type, s->subtype);
 
-	/* only run these if we're shutting down the last cap */
-	if (atomic_read(&itv->capturing) - 1 == 0) {
-		/* event notification (off) */
-		if (test_and_clear_bit(IVTV_F_I_DIG_RST, &itv->i_flags)) {
-			/* type: 0 = refresh */
-			/* on/off: 0 = off, intr: 0x10000000, mbox_id: -1: none */
-			ivtv_vapi(itv, CX2341X_ENC_SET_EVENT_NOTIFICATION, 4, 0, 0, IVTV_IRQ_ENC_VIM_RST, -1);
-			ivtv_set_irq_mask(itv, IVTV_IRQ_ENC_VIM_RST);
-		}
-	}
-
 	then = jiffies;
 
 	if (!test_bit(IVTV_F_S_PASSTHROUGH, &s->s_flags)) {
@@ -840,17 +835,30 @@ int ivtv_stop_v4l2_encode_stream(struct 
 	/* Clear capture and no-read bits */
 	clear_bit(IVTV_F_S_STREAMING, &s->s_flags);
 
+	/* ensure these global cleanup actions are done only once */
+	mutex_lock(&itv->serialize_lock);
+
 	if (s->type == IVTV_ENC_STREAM_TYPE_VBI)
 		ivtv_set_irq_mask(itv, IVTV_IRQ_ENC_VBI_CAP);
 
 	if (atomic_read(&itv->capturing) > 0) {
+		mutex_unlock(&itv->serialize_lock);
 		return 0;
 	}
 
 	/* Set the following Interrupt mask bits for capture */
 	ivtv_set_irq_mask(itv, IVTV_IRQ_MASK_CAPTURE);
 
+	/* event notification (off) */
+	if (test_and_clear_bit(IVTV_F_I_DIG_RST, &itv->i_flags)) {
+		/* type: 0 = refresh */
+		/* on/off: 0 = off, intr: 0x10000000, mbox_id: -1: none */
+		ivtv_vapi(itv, CX2341X_ENC_SET_EVENT_NOTIFICATION, 4, 0, 0, IVTV_IRQ_ENC_VIM_RST, -1);
+		ivtv_set_irq_mask(itv, IVTV_IRQ_ENC_VIM_RST);
+	}
+
 	wake_up(&s->waitq);
+	mutex_unlock(&itv->serialize_lock);
 
 	return 0;
 }

-- 
