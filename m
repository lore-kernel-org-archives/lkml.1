Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbXDCFEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbXDCFEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 01:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXDCFEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 01:04:21 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:7646 "EHLO
	asav06.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbXDCFEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 01:04:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAJR9EUZKhRO4UGdsb2JhbACHPIhEAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: usb hid: reset NumLock
Date: Tue, 3 Apr 2007 01:04:05 -0400
User-Agent: KMail/1.9.3
Cc: Jiri Kosina <jkosina@suse.cz>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuart_hayes@dell.com
References: <20070330105924.01a16dd6.zaitcev@redhat.com> <Pine.LNX.4.64.0704021641190.3808@jikos.suse.cz> <20070402161225.2866c002.zaitcev@redhat.com>
In-Reply-To: <20070402161225.2866c002.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704030104.06754.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 19:12, Pete Zaitcev wrote:
> On Mon, 2 Apr 2007 16:48:24 +0200 (CEST), Jiri Kosina <jkosina@suse.cz> wrote:
> > On Sun, 1 Apr 2007, Pete Zaitcev wrote:
> 
> > could you please change the order of the two functions, so that you 
> > don't have to put the forward declaration here?
> >[...]
> > I'd say this is a little bit overcommented.
> >[...]
> > So as soon as you have the VIDs and PIDs of the hardware which 
> > requires this, could you please update the patch and send it to me again?
> 
> How about this?

Actually I think I will be adding the patch below, but it has to wait
till 2.6.22 as it requires input core to struct device conversion
patch.

What do you think?

-- 
Dmitry

Input: add generic suspend and resume for uinput devices

Automatically turn off leds and sound effects as part of suspend
process and restore led state, sounds and repeat rate at resume.

Also synchronize hardware state with logical state at device
registration.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/input.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 80 insertions(+)

Index: work/drivers/input/input.c
===================================================================
--- work.orig/drivers/input/input.c
+++ work/drivers/input/input.c
@@ -997,10 +997,88 @@ static int input_dev_uevent(struct devic
 	return 0;
 }
 
+static void input_dev_toggle(struct input_dev *dev,
+			     unsigned int type, unsigned int code,
+			     unsigned long *cap_bits, unsigned long *bits,
+			     int force_off)
+{
+	if (test_bit(code, cap_bits)) {
+		if (!force_off)
+			dev->event(dev, type, code, test_bit(code, bits));
+		else if (test_bit(code, bits))
+			dev->event(dev, type, code, 0);
+	}
+}
+
+static void input_dev_reset(struct input_dev *dev, int force_off)
+{
+	int i;
+
+	if (!dev->event)
+		return;
+
+	/* synchronize led state */
+	if (test_bit(EV_LED, dev->evbit))
+		for (i = 0; i <= LED_MAX; i++)
+			input_dev_toggle(dev, EV_LED, i,
+					 dev->ledbit, dev->led, force_off);
+
+	/* restore sound */
+	if (test_bit(EV_SND, dev->evbit))
+		for (i = 0; i <= SND_MAX; i++)
+			input_dev_toggle(dev, EV_SND, i,
+					 dev->sndbit, dev->snd, force_off);
+
+	if (!force_off && test_bit(EV_REP, dev->evbit)) {
+		dev->event(dev, EV_REP, REP_PERIOD, dev->rep[REP_PERIOD]);
+		dev->event(dev, EV_REP, REP_DELAY, dev->rep[REP_DELAY]);
+	}
+}
+
+#ifdef CONFIG_PM
+static int input_dev_suspend(struct device *dev, pm_message_t state)
+{
+	struct input_dev *input_dev = to_input_dev(dev);
+
+	mutex_lock(&input_dev->mutex);
+
+	if (dev->power.power_state.event != state.event) {
+		if (state.event == PM_EVENT_SUSPEND)
+			input_dev_reset(input_dev, 1);
+
+		dev->power.power_state = state;
+	}
+
+	mutex_unlock(&input_dev->mutex);
+
+	return 0;
+}
+
+static int input_dev_resume(struct device *dev)
+{
+	struct input_dev *input_dev = to_input_dev(dev);
+
+	mutex_lock(&input_dev->mutex);
+
+	if (dev->power.power_state.event != PM_EVENT_ON)
+		input_dev_reset(to_input_dev(dev), 0);
+
+	dev->power.power_state = PMSG_ON;
+
+	mutex_unlock(&input_dev->mutex);
+
+	return 0;
+}
+#endif /* CONFIG_PM */
+
 static struct device_type input_dev_type = {
 	.groups		= input_dev_attr_groups,
 	.release	= input_dev_release,
 	.uevent		= input_dev_uevent,
+#ifdef CONFIG_PM
+	.suspend	= input_dev_suspend,
+	.resume		= input_dev_resume,
+#endif
 };
 
 struct class input_class = {
@@ -1080,6 +1158,8 @@ int input_register_device(struct input_d
 		dev->rep[REP_PERIOD] = 33;
 	}
 
+	input_dev_reset(dev, 0);
+
 	if (!dev->getkeycode)
 		dev->getkeycode = input_default_getkeycode;
 
