Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbXFOFlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbXFOFlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 01:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbXFOFlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 01:41:10 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:3669 "EHLO
	asav14.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbXFOFlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 01:41:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlE4ANDCcUZKhRO4UGdsb2JhbACHMYgDAQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Indan Zupancic <indan@nul.nu>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Date: Fri, 15 Jun 2007 01:41:05 -0400
User-Agent: KMail/1.9.3
Cc: Pavel Machek <pavel@ucw.cz>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andi Kleen <ak@suse.de>, Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20070604112426.GA2707@elf.ucw.cz> <20070613081825.GF13747@elf.ucw.cz> <41219.81.207.0.53.1181743761.squirrel@secure.samage.net>
In-Reply-To: <41219.81.207.0.53.1181743761.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150141.06142.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 10:09, Indan Zupancic wrote:
> On Wed, June 13, 2007 10:18, Pavel Machek wrote:
> >> Well, as I said before, I've the "stuck key"/repeated output too (as well
> >> as a warping PS/2 mouse), but no blinking led problem, so I believe the
> >> two things are totally unrelated.
> >
> > Well, after turning off CONFIG_BLINK, my problems went away, and with
> > a fast-blink done from userspace, I can make them way worse. They
> > _are_ related here.
> 
> I missed you saying that before, so to me it looked like everyone just
> assumed that.
> 
> So, just for fun, I tried running:
> 
> while true; do setleds +num; setleds -num; done
> 
> and it totally locked up my keyboard. Even SysRq didn't work.

Yeah, it does the same on my other laptop (newer HP as opposed
to an old Dell).
 
> On the 
> bright side, the numlock LED was indeed blinking. Though running the
> same with a sleep 0.1 added doesn't produce any problems. So maybe
> my problem is indeed a bit related to this after all, somehow. Anyone
> any ideas how to debug this problem?
> 

Does the patch below help?

-- 
Dmitry

Input: atkbd - throttle LED switching

On some boxes keyboard controllers are too slow to withstand
continuous flow of requests to turn keyboard LEDs on and off
and start losing some keypresses or even all of them.

Delay executing of LED switching request if we had another one
withing 50 ms thus easing load on the controller.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/atkbd.c |   40 ++++++++++++++++++++++++++--------------
 1 files changed, 26 insertions(+), 14 deletions(-)

Index: work/drivers/input/keyboard/atkbd.c
===================================================================
--- work.orig/drivers/input/keyboard/atkbd.c
+++ work/drivers/input/keyboard/atkbd.c
@@ -219,7 +219,8 @@ struct atkbd {
 	unsigned long time;
 	unsigned long err_count;
 
-	struct work_struct event_work;
+	struct delayed_work event_work;
+	unsigned long event_jiffies;
 	struct mutex event_mutex;
 	unsigned long event_mask;
 };
@@ -565,7 +566,7 @@ static int atkbd_set_leds(struct atkbd *
 
 static void atkbd_event_work(struct work_struct *work)
 {
-	struct atkbd *atkbd = container_of(work, struct atkbd, event_work);
+	struct atkbd *atkbd = container_of(work, struct atkbd, event_work.work);
 
 	mutex_lock(&atkbd->event_mutex);
 
@@ -579,12 +580,30 @@ static void atkbd_event_work(struct work
 }
 
 /*
+ * Schedule switch for execution. We need to throttle requests,
+ * otherwise keyboard may become unresponsive.
+ */
+static void atkbd_schedule_event_work(struct atkbd *atkbd, int event_bit)
+{
+	unsigned long delay = msecs_to_jiffies(50);
+
+	if (time_after(jiffies, atkbd->event_jiffies + delay))
+		delay = 0;
+
+	atkbd->event_jiffies = jiffies;
+	set_bit(event_bit, &atkbd->event_mask);
+	wmb();
+	schedule_delayed_work(&atkbd->event_work, delay);
+}
+
+/*
  * Event callback from the input module. Events that change the state of
  * the hardware are processed here. If action can not be performed in
  * interrupt context it is offloaded to atkbd_event_work.
  */
 
-static int atkbd_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
+static int atkbd_event(struct input_dev *dev,
+			unsigned int type, unsigned int code, int value)
 {
 	struct atkbd *atkbd = input_get_drvdata(dev);
 
@@ -594,19 +613,12 @@ static int atkbd_event(struct input_dev 
 	switch (type) {
 
 		case EV_LED:
-			set_bit(ATKBD_LED_EVENT_BIT, &atkbd->event_mask);
-			wmb();
-			schedule_work(&atkbd->event_work);
+			atkbd_schedule_event_work(atkbd, ATKBD_LED_EVENT_BIT);
 			return 0;
 
 		case EV_REP:
-
-			if (!atkbd->softrepeat) {
-				set_bit(ATKBD_REP_EVENT_BIT, &atkbd->event_mask);
-				wmb();
-				schedule_work(&atkbd->event_work);
-			}
-
+			if (!atkbd->softrepeat)
+				atkbd_schedule_event_work(atkbd, ATKBD_REP_EVENT_BIT);
 			return 0;
 	}
 
@@ -940,7 +952,7 @@ static int atkbd_connect(struct serio *s
 
 	atkbd->dev = dev;
 	ps2_init(&atkbd->ps2dev, serio);
-	INIT_WORK(&atkbd->event_work, atkbd_event_work);
+	INIT_DELAYED_WORK(&atkbd->event_work, atkbd_event_work);
 	mutex_init(&atkbd->event_mutex);
 
 	switch (serio->id.type) {
