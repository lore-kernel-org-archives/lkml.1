Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0BOATF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 19:19:05 -0500
Received: from mail001.aei.ca ([206.123.6.130]:60409 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab0BOATA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 19:19:00 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 1/1] Enable xy scrolling for Apple Magic Mouse
Date: Sun, 14 Feb 2010 19:18:56 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.32.8-crc; KDE/4.4.0; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz> <201002141724.33223.edt@aei.ca> <87zl3bbfdo.fsf@troilus.org>
In-Reply-To: <87zl3bbfdo.fsf@troilus.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002141918.56758.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 February 2010 17:51:15 Michael Poole wrote:
> Ed Tomlinson writes:
> 
> > Hi,
> >
> > Here is a patch that enables xy scrolling with the magic mouse.  I have also
> > changed the accelleration logic to work better with xy scrolling.
> 
> Hi Ed,
> 
> Your other patch to call input_unregister_device() looks good -- thanks!
> 
> I've never used a horizontal scroll wheel -- what are the common uses
> for it?  Why should the acceleration be separate for the two directions
> rather than using the same factor?  Why does the kernel need to emulate
> this rather than having user-space implement the emulation?

With style fixups.

Ed

--
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index b20484a..7d252d2 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -59,7 +59,8 @@ MODULE_PARM_DESC(report_undeciphered, "Report undeciphered multi-touch state fie
  * @delta_time: 18-bit difference between the two most recent touch
  *     reports from the mouse.
  * @ntouches: Number of touches in most recent touch report.
- * @scroll_accel: Number of consecutive scroll motions.
+ * @scroll_accel_y: Number of consecutive scroll motions.
+ * @scroll_accel_x: Number of consecutive scroll motions.
  * @scroll_jiffies: Time of last scroll motion.
  * @touches: Most recent data for a touch, indexed by tracking ID.
  * @tracking_ids: Mapping of current touch input data to @touches.
@@ -71,11 +72,13 @@ struct magicmouse_sc {
 	int last_timestamp;
 	int delta_time;
 	int ntouches;
-	int scroll_accel;
+	int scroll_accel_y;
+	int scroll_accel_x;
 	unsigned long scroll_jiffies;
 
 	struct {
 		short x;
+		short scroll_x;
 		short y;
 		short scroll_y;
 		u8 size;
@@ -139,8 +142,10 @@ static void magicmouse_emit_buttons(struct magicmouse_sc *msc, int state)
 	input_report_key(msc->input, BTN_LEFT, state & 1);
 	input_report_key(msc->input, BTN_RIGHT, state & 2);
 
-	if (state != last_state)
-		msc->scroll_accel = 0;
+	if (state != last_state) {
+		msc->scroll_accel_y = 0;
+		msc->scroll_accel_x = 0;
+	}
 }
 
 static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tdata)
@@ -159,34 +164,46 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
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
+			msc->scroll_accel_y = 0;
+			msc->scroll_accel_x = 0;
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
+			/* Calculate the scroll motion. */
+			stepy = (msc->touches[id].scroll_y - y) / accel_profile[msc->scroll_accel_y];
+			stepx = (msc->touches[id].scroll_x - x) / accel_profile[msc->scroll_accel_x];
+
+			/* Tell input about any motion. */
+			if (stepy != 0) {
 				msc->touches[id].scroll_y = y;
-				msc->scroll_jiffies = now;
-				input_report_rel(input, REL_WHEEL, step);
+				input_report_rel(input, REL_WHEEL, stepy);
+				msc->scroll_accel_y = min_t(int, msc->scroll_accel_y + 1,
+							        ARRAY_SIZE(accel_profile) - 1);
 			}
+			if (stepx != 0) {
+				msc->touches[id].scroll_x = x;
+				input_report_rel(input, REL_HWHEEL, stepx);
+				msc->scroll_accel_x = min_t(int, msc->scroll_accel_x + 1,
+							        ARRAY_SIZE(accel_profile) - 1);
+			}
+			msc->scroll_jiffies = now;
 			break;
 		}
 	}
@@ -300,8 +317,10 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
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
