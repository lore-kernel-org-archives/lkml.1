Return-Path: <linux-kernel-owner+w=401wt.eu-S1751220AbZKCFot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbZKCFot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 00:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZKCFos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 00:44:48 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:58556 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbZKCFor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 00:44:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MsVCpLWdri8N3svPDkIlVWC8QYmAshDTJgHe/NEeBaXePcoT47AeZD/EGyKNvNDQCj
         CXfywAtw0TBsqoRCaJWb26aeJcY/MMZ8kBlpAWn1sSQY3y//AFySOMqd8lS/EKOCvv/V
         1sIK9r6Z6Wccq7MV477xIGZwrwQoP71VoPoGg=
Date: Mon, 2 Nov 2009 21:44:46 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: fix locking context in ml_ff_set_gain
Message-ID: <20091103054446.GB3212@core.coreip.homeip.net>
References: <20091031141925.149c9874@infradead.org> <20091102063818.GB3354@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102063818.GB3354@core.coreip.homeip.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 01, 2009 at 10:38:19PM -0800, Dmitry Torokhov wrote:
> Hi Arjan,
> 
> On Sat, Oct 31, 2009 at 02:19:25PM -0700, Arjan van de Ven wrote:
> > From 177c4e7a84c40925605d485f6d5367deb44a84c8 Mon Sep 17 00:00:00 2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Sat, 31 Oct 2009 14:13:40 -0700
> > Subject: [PATCH] input: fix locking context in ml_ff_set_gain
> > 
> > the ml_ff_set_gain() function uses spin_lock_bh/spin_unlock_bh
> > for locking. Unfortunately, this function can be called with irqs
> > off:
> > vfs_write ->
> > evdev_write ->
> > input_inject_event (disables interrupts) ->
> > input_handle_event ->
> > input_ff_event ->
> > ml_ff_set_gain
> > 
> > and doing spin_unlock_bh() with interrupts off is not allowed
> > (and causes a nice warning as a result).
> > 
> > This patch fixes this by turning the locking into the _irqsave variant.
> 
> Thank you for the patch but it seems that the rest of the locking in
> ff-memless.c is screwqed up ever since locking (dev->event_lock) was
> added to the input core and this change plugs one hole but exposes
> others.  I think I need to convert ff-memless.c over to rely on
> event_lock instead of the private timer_lock, but I will need a couple
> of days.
> 

OK, it ended up being pretty simple. Anssi, any chance you could test it
to make sure I did not screw up? Thanks!

-- 
Dmitry


Input: fix locking in memoryless force-feedback devices

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Now that input core acquires dev->event_lock spinlock and disables
interrupts when propagating input events, using spin_lock_bh() in
ff-memless driver is not allowed. Actually, the timer_lock itself
is not needed anymore, we should simply use dev->event_lock
as well.

Also do a small cleanup in force-feedback core.

Reported-by: kerneloops.org
Reported-by: http://www.kerneloops.org/searchweek.php?search=ml_ff_set_gain
Reported-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/ff-core.c    |   20 +++++++++++---------
 drivers/input/ff-memless.c |   25 ++++++++++---------------
 include/linux/input.h      |    4 ++++
 3 files changed, 25 insertions(+), 24 deletions(-)


diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
index 72c63e5..38df81f 100644
--- a/drivers/input/ff-core.c
+++ b/drivers/input/ff-core.c
@@ -337,16 +337,16 @@ int input_ff_create(struct input_dev *dev, int max_effects)
 	dev->ff = ff;
 	dev->flush = flush_effects;
 	dev->event = input_ff_event;
-	set_bit(EV_FF, dev->evbit);
+	__set_bit(EV_FF, dev->evbit);
 
 	/* Copy "true" bits into ff device bitmap */
 	for (i = 0; i <= FF_MAX; i++)
 		if (test_bit(i, dev->ffbit))
-			set_bit(i, ff->ffbit);
+			__set_bit(i, ff->ffbit);
 
 	/* we can emulate RUMBLE with periodic effects */
 	if (test_bit(FF_PERIODIC, ff->ffbit))
-		set_bit(FF_RUMBLE, dev->ffbit);
+		__set_bit(FF_RUMBLE, dev->ffbit);
 
 	return 0;
 }
@@ -362,12 +362,14 @@ EXPORT_SYMBOL_GPL(input_ff_create);
  */
 void input_ff_destroy(struct input_dev *dev)
 {
-	clear_bit(EV_FF, dev->evbit);
-	if (dev->ff) {
-		if (dev->ff->destroy)
-			dev->ff->destroy(dev->ff);
-		kfree(dev->ff->private);
-		kfree(dev->ff);
+	struct ff_device *ff = dev->ff;
+
+	__clear_bit(EV_FF, dev->evbit);
+	if (ff) {
+		if (ff->destroy)
+			ff->destroy(ff);
+		kfree(ff->private);
+		kfree(ff);
 		dev->ff = NULL;
 	}
 }
diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index 2d1415e..2e8b4e3 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -61,7 +61,6 @@ struct ml_device {
 	struct ml_effect_state states[FF_MEMLESS_EFFECTS];
 	int gain;
 	struct timer_list timer;
-	spinlock_t timer_lock;
 	struct input_dev *dev;
 
 	int (*play_effect)(struct input_dev *dev, void *data,
@@ -371,35 +370,34 @@ static void ml_effect_timer(unsigned long timer_data)
 
 	debug("timer: updating effects");
 
-	spin_lock(&ml->timer_lock);
+	spin_lock_irq(&dev->event_lock);
 	ml_play_effects(ml);
-	spin_unlock(&ml->timer_lock);
+	spin_unlock_irq(&dev->event_lock);
 }
 
+/*
+ * Sets requested gain for FF effects. Called with dev->event_lock held.
+ */
 static void ml_ff_set_gain(struct input_dev *dev, u16 gain)
 {
 	struct ml_device *ml = dev->ff->private;
 	int i;
 
-	spin_lock_bh(&ml->timer_lock);
-
 	ml->gain = gain;
 
 	for (i = 0; i < FF_MEMLESS_EFFECTS; i++)
 		__clear_bit(FF_EFFECT_PLAYING, &ml->states[i].flags);
 
 	ml_play_effects(ml);
-
-	spin_unlock_bh(&ml->timer_lock);
 }
 
+/*
+ * Start/stop specified FF effect. Called with dev->event_lock held.
+ */
 static int ml_ff_playback(struct input_dev *dev, int effect_id, int value)
 {
 	struct ml_device *ml = dev->ff->private;
 	struct ml_effect_state *state = &ml->states[effect_id];
-	unsigned long flags;
-
-	spin_lock_irqsave(&ml->timer_lock, flags);
 
 	if (value > 0) {
 		debug("initiated play");
@@ -425,8 +423,6 @@ static int ml_ff_playback(struct input_dev *dev, int effect_id, int value)
 		ml_play_effects(ml);
 	}
 
-	spin_unlock_irqrestore(&ml->timer_lock, flags);
-
 	return 0;
 }
 
@@ -436,7 +432,7 @@ static int ml_ff_upload(struct input_dev *dev,
 	struct ml_device *ml = dev->ff->private;
 	struct ml_effect_state *state = &ml->states[effect->id];
 
-	spin_lock_bh(&ml->timer_lock);
+	spin_lock_irq(&dev->event_lock);
 
 	if (test_bit(FF_EFFECT_STARTED, &state->flags)) {
 		__clear_bit(FF_EFFECT_PLAYING, &state->flags);
@@ -448,7 +444,7 @@ static int ml_ff_upload(struct input_dev *dev,
 		ml_schedule_timer(ml);
 	}
 
-	spin_unlock_bh(&ml->timer_lock);
+	spin_unlock_irq(&dev->event_lock);
 
 	return 0;
 }
@@ -482,7 +478,6 @@ int input_ff_create_memless(struct input_dev *dev, void *data,
 	ml->private = data;
 	ml->play_effect = play_effect;
 	ml->gain = 0xffff;
-	spin_lock_init(&ml->timer_lock);
 	setup_timer(&ml->timer, ml_effect_timer, (unsigned long)dev);
 
 	set_bit(FF_GAIN, dev->ffbit);
diff --git a/include/linux/input.h b/include/linux/input.h
index 0ccfc30..c2b1a7d 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1377,6 +1377,10 @@ extern struct class input_class;
  * methods; erase() is optional. set_gain() and set_autocenter() need
  * only be implemented if driver sets up FF_GAIN and FF_AUTOCENTER
  * bits.
+ *
+ * Note that playback(), set_gain() and set_autocenter() are called with
+ * dev->event_lock spinlock held and interrupts off and thus may not
+ * sleep.
  */
 struct ff_device {
 	int (*upload)(struct input_dev *dev, struct ff_effect *effect,
