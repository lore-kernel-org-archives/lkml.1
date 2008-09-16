Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbYIPTvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbYIPTvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbYIPTvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:51:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52872 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYIPTvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:51:40 -0400
Date: Tue, 16 Sep 2008 20:51:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, Adel Gadllah <adel.gadllah@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Message-ID: <20080916195134.GB14879@srcf.ucam.org>
References: <48CFC03A.8020708@lwfinger.net> <200809161742.15527.mb@bu3sch.de> <48CFE820.7010305@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CFE820.7010305@lwfinger.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 12:08:48PM -0500, Larry Finger wrote:

> I agree with Michael. From what I know, the only possible reason for
> having this state would be if user space could somehow affect the
> state of the hardware switch. As the user's finger is the only such
> thing, then there is no use for the RFKILL_STATE_HARD_BLOCKED state,
> particularly when it breaks LED operations.

RFKILL_STATE_HARD_BLOCKED indicates that the hardware is disabled in a 
way that userspace can't influence, so sounds like exactly the right 
state to have here. I still have absolutely no idea what b43 rfkill is 
supposed to be doing - why on earth is it requesting rfkill-input, and 
why does it generate keypress events? I /think/ it should e something 
like the following (untested, I'm not near any of my b43 hardware at the 
moment). This basically does the following:

1) Split the update function in two, so it can be called by either 
polling or an interrupt driven event on newer hardware (not implemented 
yet)
2) Remove all the input handling
3) Change the state updates to use rfkill_force_state, which will 
generate an event that gets sent up to userland
4) Retains the RFKILL_STATE_HARD_BLOCKED code

When the user flicks a switch or presses a button that physically 
disables the radio, the state will now automatically change to 
RFKILL_STATE_HARD_BLOCKED. If they have a key that generates KEY_WLAN 
but doesn't change the radio state, rfkill-input will trigger a change 
to RFKILL_STATE_SOFT_BLOCKED.

Like I said, this is only build-tested - I won't be back at a b43 until 
next week. If someone could give this a go, that would be great.

diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
index fec5645..e8b2acb 100644
--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -49,21 +49,18 @@ static void b43_rfkill_update_state(struct b43_wldev *dev)
 	struct b43_rfkill *rfk = &(dev->wl->rfkill);
 
 	if (!dev->radio_hw_enable) {
-		rfk->rfkill->state = RFKILL_STATE_HARD_BLOCKED;
+		rfkill_force_state(rfk->rfkill, RFKILL_STATE_HARD_BLOCKED);
 		return;
 	}
 
 	if (!dev->phy.radio_on)
-		rfk->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
+		rfkill_force_state(rfk->rfkill, RFKILL_STATE_SOFT_BLOCKED);
 	else
-		rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
-
+		rfkill_force_state(rfk->rfkill, RFKILL_STATE_UNBLOCKED);
 }
 
-/* The poll callback for the hardware button. */
-static void b43_rfkill_poll(struct input_polled_dev *poll_dev)
+static void b43_rfkill_update(struct b43_wldev *dev)
 {
-	struct b43_wldev *dev = poll_dev->private;
 	struct b43_wl *wl = dev->wl;
 	bool enabled;
 	bool report_change = 0;
@@ -82,13 +79,25 @@ static void b43_rfkill_poll(struct input_polled_dev *poll_dev)
 			enabled ? "ENABLED" : "DISABLED");
 	}
 	mutex_unlock(&wl->mutex);
+}
 
-	/* send the radio switch event to the system - note both a key press
-	 * and a release are required */
-	if (unlikely(report_change)) {
-		input_report_key(poll_dev->input, KEY_WLAN, 1);
-		input_report_key(poll_dev->input, KEY_WLAN, 0);
-	}
+static void b43_rfkill_poll(unsigned long data)
+{
+	struct b43_rfkill *rfkill = (struct b43_rfkill *)data;
+	schedule_work(&rfkill->poll_queue);
+}
+
+static void b43_rfkill_work(struct work_struct *work)
+{
+	struct b43_rfkill *rfk = container_of(work, struct b43_rfkill, 
+					      poll_queue);
+	struct b43_wl *wl = container_of(rfk, struct b43_wl, rfkill);
+	struct b43_wldev *dev = wl->current_dev;
+
+	b43_rfkill_update(dev);
+	rfk->poll_timer.function = b43_rfkill_poll;
+	rfk->poll_timer.expires = round_jiffies(jiffies + HZ);
+	add_timer(&rfk->poll_timer);
 }
 
 /* Called when the RFKILL toggled in software. */
@@ -158,48 +167,23 @@ void b43_rfkill_init(struct b43_wldev *dev)
 	rfk->rfkill->toggle_radio = b43_rfkill_soft_toggle;
 	rfk->rfkill->user_claim_unsupported = 1;
 
-	rfk->poll_dev = input_allocate_polled_device();
-	if (!rfk->poll_dev) {
-		rfkill_free(rfk->rfkill);
-		goto err_freed_rfk;
-	}
-
-	rfk->poll_dev->private = dev;
-	rfk->poll_dev->poll = b43_rfkill_poll;
-	rfk->poll_dev->poll_interval = 1000; /* msecs */
-
-	rfk->poll_dev->input->name = rfk->name;
-	rfk->poll_dev->input->id.bustype = BUS_HOST;
-	rfk->poll_dev->input->id.vendor = dev->dev->bus->boardinfo.vendor;
-	rfk->poll_dev->input->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_WLAN, rfk->poll_dev->input->keybit);
-
 	err = rfkill_register(rfk->rfkill);
 	if (err)
-		goto err_free_polldev;
+		goto err_free_rfk;
 
-#ifdef CONFIG_RFKILL_INPUT_MODULE
-	/* B43 RF-kill isn't useful without the rfkill-input subsystem.
-	 * Try to load the module. */
-	err = request_module("rfkill-input");
-	if (err)
-		b43warn(wl, "Failed to load the rfkill-input module. "
-			"The built-in radio LED will not work.\n");
-#endif /* CONFIG_RFKILL_INPUT */
+	rfk->registered = 1;
 
-	err = input_register_polled_device(rfk->poll_dev);
-	if (err)
-		goto err_unreg_rfk;
+	INIT_WORK(&rfk->poll_queue, b43_rfkill_work);
 
-	rfk->registered = 1;
+	init_timer(&rfk->poll_timer);
+	rfk->poll_timer.function = b43_rfkill_poll;
+	rfk->poll_timer.expires = round_jiffies(jiffies + HZ);
+	rfk->poll_timer.data = (unsigned long)dev;
+	add_timer(&rfk->poll_timer);
 
 	return;
-err_unreg_rfk:
-	rfkill_unregister(rfk->rfkill);
-err_free_polldev:
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
-err_freed_rfk:
+err_free_rfk:
+	rfkill_free(rfk->rfkill);
 	rfk->rfkill = NULL;
 out_error:
 	rfk->registered = 0;
@@ -214,9 +198,8 @@ void b43_rfkill_exit(struct b43_wldev *dev)
 		return;
 	rfk->registered = 0;
 
-	input_unregister_polled_device(rfk->poll_dev);
+	del_timer(&rfk->poll_timer);
+
 	rfkill_unregister(rfk->rfkill);
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
 	rfk->rfkill = NULL;
 }
diff --git a/drivers/net/wireless/b43/rfkill.h b/drivers/net/wireless/b43/rfkill.h
index adacf93..1a4a719 100644
--- a/drivers/net/wireless/b43/rfkill.h
+++ b/drivers/net/wireless/b43/rfkill.h
@@ -7,14 +7,14 @@ struct b43_wldev;
 #ifdef CONFIG_B43_RFKILL
 
 #include <linux/rfkill.h>
-#include <linux/input-polldev.h>
-
 
 struct b43_rfkill {
 	/* The RFKILL subsystem data structure */
 	struct rfkill *rfkill;
-	/* The poll device for the RFKILL input button */
-	struct input_polled_dev *poll_dev;
+	/* The timer list for the RFKILL polling */
+	struct timer_list poll_timer;
+	/* Workqueue for the RFKILL polling */
+	struct work_struct poll_queue;
 	/* Did initialization succeed? Used for freeing. */
 	bool registered;
 	/* The unique name of this rfkill switch */


-- 
Matthew Garrett | mjg59@srcf.ucam.org
