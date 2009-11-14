Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbZKNC5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbZKNC5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 21:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbZKNC5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 21:57:38 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:46514 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbZKNC5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 21:57:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OH7MRql6I4RbCyjAlN7FlE/2sEBEKscomkk1PBJr+wl0DiYcu3XEC4IgXt3vKQgk2V
         AKMWbLyLWDcHCtHf592VurJgKi00VDPaUBxmsBHk6ufx3MM6ksrl+7OhFClYE3DSgMpc
         +jEcWpdvFRhWobl6iHb9o66vE6oTXcGSs72So=
Date: Fri, 13 Nov 2009 18:57:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linux Input <linux-input@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jim Paradis <jparadis@redhat.com>
Subject: [PATCH] Input: keyboard - fix lack of locking when traversing
	handler->h_list
Message-ID: <20091114025737.GC3587@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keyboard handler should not attempt to traverse handler->h_list on
its own, without any locking, otherwise it races with registering
and unregistering of input handles which leads to crashes.

Introduce input_handler_for_each_handle() helper that allows safely
iterate over all handles attached to a particular handler and switch
keyboard handler to use it.

Reported-by: Jim Paradis <jparadis@redhat.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/char/keyboard.c |  189 ++++++++++++++++++++++++-----------------------
 drivers/input/input.c   |   37 +++++++++
 include/linux/input.h   |   10 ++
 3 files changed, 140 insertions(+), 96 deletions(-)


diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 737be95..8847ea6 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -46,8 +46,6 @@
 
 extern void ctrl_alt_del(void);
 
-#define to_handle_h(n) container_of(n, struct input_handle, h_node)
-
 /*
  * Exported functions/variables
  */
@@ -190,78 +188,85 @@ EXPORT_SYMBOL_GPL(unregister_keyboard_notifier);
  *  etc.). So this means that scancodes for the extra function keys won't
  *  be valid for the first event device, but will be for the second.
  */
+
+struct getset_keycode_data {
+	unsigned int scancode;
+	unsigned int keycode;
+	int error;
+};
+
+static int getkeycode_helper(struct input_handle *handle, void *data)
+{
+	struct getset_keycode_data *d = data;
+
+	d->error = input_get_keycode(handle->dev, d->scancode, &d->keycode);
+
+	return d->error == 0; /* stop as soon as we successfully get one */
+}
+
 int getkeycode(unsigned int scancode)
 {
-	struct input_handle *handle;
-	int keycode;
-	int error = -ENODEV;
+	struct getset_keycode_data d = { scancode, 0, -ENODEV };
 
-	list_for_each_entry(handle, &kbd_handler.h_list, h_node) {
-		error = input_get_keycode(handle->dev, scancode, &keycode);
-		if (!error)
-			return keycode;
-	}
+	input_handler_for_each_handle(&kbd_handler, &d, getkeycode_helper);
 
-	return error;
+	return d.error;
+}
+
+static int setkeycode_helper(struct input_handle *handle, void *data)
+{
+	struct getset_keycode_data *d = data;
+
+	d->error = input_set_keycode(handle->dev, d->scancode, d->keycode);
+
+	return d->error == 0; /* stop as soon as we successfully set one */
 }
 
 int setkeycode(unsigned int scancode, unsigned int keycode)
 {
-	struct input_handle *handle;
-	int error = -ENODEV;
+	struct getset_keycode_data d = { scancode, keycode, -ENODEV };
 
-	list_for_each_entry(handle, &kbd_handler.h_list, h_node) {
-		error = input_set_keycode(handle->dev, scancode, keycode);
-		if (!error)
-			break;
-	}
+	input_handler_for_each_handle(&kbd_handler, &d, setkeycode_helper);
 
-	return error;
+	return d.error;
 }
 
 /*
  * Making beeps and bells.
  */
-static void kd_nosound(unsigned long ignored)
+
+static int kd_sound_helper(struct input_handle *handle, void *data)
 {
-	struct input_handle *handle;
+	unsigned int *hz = data;
+	struct input_dev *dev = handle->dev;
 
-	list_for_each_entry(handle, &kbd_handler.h_list, h_node) {
-		if (test_bit(EV_SND, handle->dev->evbit)) {
-			if (test_bit(SND_TONE, handle->dev->sndbit))
-				input_inject_event(handle, EV_SND, SND_TONE, 0);
-			if (test_bit(SND_BELL, handle->dev->sndbit))
-				input_inject_event(handle, EV_SND, SND_BELL, 0);
-		}
+	if (test_bit(EV_SND, dev->evbit)) {
+		if (test_bit(SND_TONE, dev->sndbit))
+			input_inject_event(handle, EV_SND, SND_TONE, *hz);
+		if (test_bit(SND_BELL, handle->dev->sndbit))
+			input_inject_event(handle, EV_SND, SND_BELL, *hz ? 1 : 0);
 	}
+
+	return 0;
+}
+
+static void kd_nosound(unsigned long ignored)
+{
+	static unsigned int zero;
+
+	input_handler_for_each_handle(&kbd_handler, &zero, kd_sound_helper);
 }
 
 static DEFINE_TIMER(kd_mksound_timer, kd_nosound, 0, 0);
 
 void kd_mksound(unsigned int hz, unsigned int ticks)
 {
-	struct list_head *node;
+	del_timer_sync(&kd_mksound_timer);
 
-	del_timer(&kd_mksound_timer);
+	input_handler_for_each_handle(&kbd_handler, &hz, kd_sound_helper);
 
-	if (hz) {
-		list_for_each_prev(node, &kbd_handler.h_list) {
-			struct input_handle *handle = to_handle_h(node);
-			if (test_bit(EV_SND, handle->dev->evbit)) {
-				if (test_bit(SND_TONE, handle->dev->sndbit)) {
-					input_inject_event(handle, EV_SND, SND_TONE, hz);
-					break;
-				}
-				if (test_bit(SND_BELL, handle->dev->sndbit)) {
-					input_inject_event(handle, EV_SND, SND_BELL, 1);
-					break;
-				}
-			}
-		}
-		if (ticks)
-			mod_timer(&kd_mksound_timer, jiffies + ticks);
-	} else
-		kd_nosound(0);
+	if (hz && ticks)
+		mod_timer(&kd_mksound_timer, jiffies + ticks);
 }
 EXPORT_SYMBOL(kd_mksound);
 
@@ -269,30 +274,33 @@ EXPORT_SYMBOL(kd_mksound);
  * Setting the keyboard rate.
  */
 
-int kbd_rate(struct kbd_repeat *rep)
+static int kbd_rate_helper(struct input_handle *handle, void *data)
 {
-	struct list_head *node;
+	struct input_dev *dev = handle->dev;
+	struct kbd_repeat *rep = data;
 	unsigned int d = 0;
 	unsigned int p = 0;
 
-	list_for_each(node, &kbd_handler.h_list) {
-		struct input_handle *handle = to_handle_h(node);
-		struct input_dev *dev = handle->dev;
-
-		if (test_bit(EV_REP, dev->evbit)) {
-			if (rep->delay > 0)
-				input_inject_event(handle, EV_REP, REP_DELAY, rep->delay);
-			if (rep->period > 0)
-				input_inject_event(handle, EV_REP, REP_PERIOD, rep->period);
-			d = dev->rep[REP_DELAY];
-			p = dev->rep[REP_PERIOD];
-		}
+	if (test_bit(EV_REP, dev->evbit)) {
+		if (rep->delay > 0)
+			input_inject_event(handle, EV_REP, REP_DELAY, rep->delay);
+		if (rep->period > 0)
+			input_inject_event(handle, EV_REP, REP_PERIOD, rep->period);
+		d = dev->rep[REP_DELAY];
+		p = dev->rep[REP_PERIOD];
 	}
+
 	rep->delay  = d;
 	rep->period = p;
+
 	return 0;
 }
 
+int kbd_rate(struct kbd_repeat *rep)
+{
+	return input_handler_for_each_handle(&kbd_handler, rep, kbd_rate_helper);
+}
+
 /*
  * Helper Functions.
  */
@@ -997,36 +1005,36 @@ static inline unsigned char getleds(void)
 	return leds;
 }
 
+static int kbd_update_leds_helper(struct input_handle *handle, void *data)
+{
+	unsigned char leds = *(unsigned char *)data;
+
+	if (test_bit(EV_LED, handle->dev->evbit)) {
+		input_inject_event(handle, EV_LED, LED_SCROLLL, !!(leds & 0x01));
+		input_inject_event(handle, EV_LED, LED_NUML,    !!(leds & 0x02));
+		input_inject_event(handle, EV_LED, LED_CAPSL,   !!(leds & 0x04));
+		input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
+	}
+
+	return 0;
+}
+
 /*
- * This routine is the bottom half of the keyboard interrupt
- * routine, and runs with all interrupts enabled. It does
- * console changing, led setting and copy_to_cooked, which can
- * take a reasonably long time.
- *
- * Aside from timing (which isn't really that important for
- * keyboard interrupts as they happen often), using the software
- * interrupt routines for this thing allows us to easily mask
- * this when we don't want any of the above to happen.
- * This allows for easy and efficient race-condition prevention
- * for kbd_start => input_inject_event(dev, EV_LED, ...) => ...
+ * This is the tasklet that updates LED state on all keyboards
+ * attached to the box. he reason we use tasklet is that we
+ * need to handle the scenario when keyboard handler is not
+ * registered yet but we already getting updates form VT to
+ * update led state.
  */
-
 static void kbd_bh(unsigned long dummy)
 {
-	struct list_head *node;
 	unsigned char leds = getleds();
 
 	if (leds != ledstate) {
-		list_for_each(node, &kbd_handler.h_list) {
-			struct input_handle *handle = to_handle_h(node);
-			input_inject_event(handle, EV_LED, LED_SCROLLL, !!(leds & 0x01));
-			input_inject_event(handle, EV_LED, LED_NUML,    !!(leds & 0x02));
-			input_inject_event(handle, EV_LED, LED_CAPSL,   !!(leds & 0x04));
-			input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
-		}
+		input_handler_for_each_handle(&kbd_handler, &leds,
+					      kbd_update_leds_helper);
+		ledstate = leds;
 	}
-
-	ledstate = leds;
 }
 
 DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);
@@ -1300,6 +1308,7 @@ static void kbd_event(struct input_handle *handle, unsigned int event_type,
 		kbd_rawcode(value);
 	if (event_type == EV_KEY)
 		kbd_keycode(event_code, value, HW_RAW(handle->dev));
+
 	tasklet_schedule(&keyboard_tasklet);
 	do_poke_blanked_console = 1;
 	schedule_console_callback();
@@ -1363,15 +1372,11 @@ static void kbd_disconnect(struct input_handle *handle)
  */
 static void kbd_start(struct input_handle *handle)
 {
-	unsigned char leds = ledstate;
-
 	tasklet_disable(&keyboard_tasklet);
-	if (leds != 0xff) {
-		input_inject_event(handle, EV_LED, LED_SCROLLL, !!(leds & 0x01));
-		input_inject_event(handle, EV_LED, LED_NUML,    !!(leds & 0x02));
-		input_inject_event(handle, EV_LED, LED_CAPSL,   !!(leds & 0x04));
-		input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
-	}
+
+	if (ledstate != 0xff)
+		kbd_update_leds_helper(handle, &ledstate);
+
 	tasklet_enable(&keyboard_tasklet);
 }
 
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 77b6efe..b991e64 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1664,6 +1664,38 @@ void input_unregister_handler(struct input_handler *handler)
 EXPORT_SYMBOL(input_unregister_handler);
 
 /**
+ * input_handler_for_each_handle - handle iterator
+ * @handler: input handler to iterate
+ * @data: data for the callback
+ * @fn: function to be called for each handle
+ *
+ * Iterate over @bus's list of devices, and call @fn for each, passing
+ * it @data and stop when @fn returns a non-zero value. The function is
+ * using RCU to traverse the list and therefore may be usind in atonic
+ * contexts. The @fn callback is invoked from RCU critical section and
+ * thus must not sleep.
+ */
+int input_handler_for_each_handle(struct input_handler *handler, void *data,
+				  int (*fn)(struct input_handle *, void *))
+{
+	struct input_handle *handle;
+	int retval = 0;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(handle, &handler->h_list, h_node) {
+		retval = fn(handle, data);
+		if (retval)
+			break;
+	}
+
+	rcu_read_unlock();
+
+	return retval;
+}
+EXPORT_SYMBOL(input_handler_for_each_handle);
+
+/**
  * input_register_handle - register a new input handle
  * @handle: handle to register
  *
@@ -1696,7 +1728,7 @@ int input_register_handle(struct input_handle *handle)
 	 * we can't be racing with input_unregister_handle()
 	 * and so separate lock is not needed here.
 	 */
-	list_add_tail(&handle->h_node, &handler->h_list);
+	list_add_tail_rcu(&handle->h_node, &handler->h_list);
 
 	if (handler->start)
 		handler->start(handle);
@@ -1719,7 +1751,7 @@ void input_unregister_handle(struct input_handle *handle)
 {
 	struct input_dev *dev = handle->dev;
 
-	list_del_init(&handle->h_node);
+	list_del_rcu(&handle->h_node);
 
 	/*
 	 * Take dev->mutex to prevent race with input_release_device().
@@ -1727,6 +1759,7 @@ void input_unregister_handle(struct input_handle *handle)
 	mutex_lock(&dev->mutex);
 	list_del_rcu(&handle->d_node);
 	mutex_unlock(&dev->mutex);
+
 	synchronize_rcu();
 }
 EXPORT_SYMBOL(input_unregister_handle);
diff --git a/include/linux/input.h b/include/linux/input.h
index 4637f90..8693bc6 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1021,9 +1021,12 @@ struct ff_effect {
  * @keycodesize: size of elements in keycode table
  * @keycode: map of scancodes to keycodes for this device
  * @setkeycode: optional method to alter current keymap, used to implement
- *	sparse keymaps. If not supplied default mechanism will be used
+ *	sparse keymaps. If not supplied default mechanism will be used.
+ *	The methid is being called while holding event_lock and thus must
+ *	not sleep.
  * @getkeycode: optional method to retrieve current keymap. If not supplied
- *	default mechanism will be used
+ *	default mechanism will be used. The method is being called while
+ *	holding event_lock and thus must not sleep.
  * @ff: force feedback structure associated with the device if device
  *	supports force feedback effects
  * @repeat_key: stores key code of the last key pressed; used to implement
@@ -1295,6 +1298,9 @@ void input_unregister_device(struct input_dev *);
 int __must_check input_register_handler(struct input_handler *);
 void input_unregister_handler(struct input_handler *);
 
+int input_handler_for_each_handle(struct input_handler *, void *data,
+				  int (*fn)(struct input_handle *, void *));
+
 int input_register_handle(struct input_handle *);
 void input_unregister_handle(struct input_handle *);
 
-- 
Dmitry
