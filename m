Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab0BNWYn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 17:24:43 -0500
Received: from mail001.aei.ca ([206.123.6.130]:58659 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab0BNWYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 17:24:41 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 1/1] Enable xy scrolling for Apple Magic Mouse
Date: Sun, 14 Feb 2010 17:24:32 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.32.8-crc; KDE/4.4.0; x86_64; ; )
Cc: Michael Poole <mdpoole@troilus.org>, linux-input@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz> <87y6j2eeqv.fsf_-_@troilus.org> <alpine.LNX.2.00.1002101456490.30967@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1002101456490.30967@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002141724.33223.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a patch that enables xy scrolling with the magic mouse.  I have also
changed the accelleration logic to work better with xy scrolling.

Comments
Ed Tomlinson

---
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index b20484a..3075d78 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -59,7 +59,7 @@ MODULE_PARM_DESC(report_undeciphered, "Report undeciphered multi-touch state fie
  * @delta_time: 18-bit difference between the two most recent touch
  *     reports from the mouse.
  * @ntouches: Number of touches in most recent touch report.
- * @scroll_accel: Number of consecutive scroll motions.
+ * @scroll_accely: Number of consecutive scroll motions.
  * @scroll_jiffies: Time of last scroll motion.
  * @touches: Most recent data for a touch, indexed by tracking ID.
  * @tracking_ids: Mapping of current touch input data to @touches.
@@ -71,11 +71,13 @@ struct magicmouse_sc {
 	int last_timestamp;
 	int delta_time;
 	int ntouches;
-	int scroll_accel;
+	int scroll_accely;
+	int scroll_accelx;
 	unsigned long scroll_jiffies;
 
 	struct {
 		short x;
+		short scroll_x;
 		short y;
 		short scroll_y;
 		u8 size;
@@ -139,8 +141,10 @@ static void magicmouse_emit_buttons(struct magicmouse_sc *msc, int state)
 	input_report_key(msc->input, BTN_LEFT, state & 1);
 	input_report_key(msc->input, BTN_RIGHT, state & 2);
 
-	if (state != last_state)
-		msc->scroll_accel = 0;
+	if (state != last_state) {
+		msc->scroll_accely = 0;
+		msc->scroll_accelx = 0;
+	}
 }
 
 static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tdata)
@@ -159,34 +163,46 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
 	msc->touches[id].size = misc & 63;
 
 	/* If requested, emulate a scroll wheel by detecting small
-	 * vertical touch motions along the middle of the mouse.
+	 * touch motions on the mouse.
 	 */
 	if (emulate_scroll_wheel &&
-	    middle_button_start < x && x < middle_button_stop) {
+	    msc->ntouches == 1) {
 		static const int accel_profile[] = {
-			256, 228, 192, 160, 128, 96, 64, 32,
+			192, 160, 128, 96, 64, 48, 32, 24,
 		};
 		unsigned long now = jiffies;
-		int step = msc->touches[id].scroll_y - y;
+		int stepx, stepy;
 
 		/* Reset acceleration after half a second. */
-		if (time_after(now, msc->scroll_jiffies + HZ / 2))
-			msc->scroll_accel = 0;
+		if (time_after(now, msc->scroll_jiffies + HZ / 2)) {
+			msc->scroll_accely = 0;
+			msc->scroll_accelx = 0;
+		}
 
-		/* Calculate and apply the scroll motion. */
 		switch (tdata[7] & TOUCH_STATE_MASK) {
 		case TOUCH_STATE_START:
 			msc->touches[id].scroll_y = y;
-			msc->scroll_accel = min_t(int, msc->scroll_accel + 1,
-						ARRAY_SIZE(accel_profile) - 1);
+			msc->touches[id].scroll_x = x;
 			break;
 		case TOUCH_STATE_DRAG:
-			step = step / accel_profile[msc->scroll_accel];
-			if (step != 0) {
+			/* Calculate and apply the scroll motion. */
+			stepy = (msc->touches[id].scroll_y - y)/accel_profile[msc->scroll_accely];
+			stepx = (msc->touches[id].scroll_x - x)/accel_profile[msc->scroll_accelx];
+
+			/* tell input about any motions */
+			if (stepy != 0) {
 				msc->touches[id].scroll_y = y;
-				msc->scroll_jiffies = now;
-				input_report_rel(input, REL_WHEEL, step);
+				input_report_rel(input, REL_WHEEL, stepy);
+				msc->scroll_accely = min_t(int, msc->scroll_accely + 1,
+							        ARRAY_SIZE(accel_profile) - 1);
 			}
+			if (stepx != 0) {
+				msc->touches[id].scroll_x = x;
+				input_report_rel(input, REL_HWHEEL, stepx);
+				msc->scroll_accelx = min_t(int, msc->scroll_accelx + 1,
+							        ARRAY_SIZE(accel_profile) - 1);
+			}
+			msc->scroll_jiffies = now;
 			break;
 		}
 	}
@@ -300,8 +316,10 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
 	__set_bit(EV_REL, input->evbit);
 	__set_bit(REL_X, input->relbit);
 	__set_bit(REL_Y, input->relbit);
-	if (emulate_scroll_wheel)
+	if (emulate_scroll_wheel) {
 		__set_bit(REL_WHEEL, input->relbit);
+		__set_bit(REL_HWHEEL, input->relbit);
+	}
 
 	if (report_touches) {
 		__set_bit(EV_ABS, input->evbit);
