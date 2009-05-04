Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbZEDO4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbZEDO4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZEDO4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:56:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60730 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbZEDOz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:55:59 -0400
Date: Mon, 4 May 2009 16:57:00 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Kwangwoo Lee <kwangwoo.lee@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] input: Add support for the TSC2003 controller.
Message-ID: <20090504145700.GA875@avionic-design.de>
References: <1241006627-22811-1-git-send-email-thierry.reding@avionic-design.de> <5d5443650904290623n3712cd7dja653a139cff2cf6d@mail.gmail.com> <483a38b80904291835p51044741p9bd83d33a40031c@mail.gmail.com> <20090504113751.GA22603@avionic-design.de> <5d5443650905040503n501e3b47qc890dc4c71a85b1c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <5d5443650905040503n501e3b47qc890dc4c71a85b1c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V01U2FsdGVkX196LO/vUo5NrvMIVjiEm7oSV0LHwMjIz9JKAIZ
 ulc4FMTNmAVyUxrGxnUOR9jjaQAvnaq7vVYj/py5M8T+kIWVFu
 63qY/lkqkUivjgIgogJrw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Trilok Soni wrote:
> Hi Thierry,
> 
> On Mon, May 4, 2009 at 5:07 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > * Kwangwoo Lee wrote:
> >> Hi Thierry and Trilok,
> >>
> >> On Wed, Apr 29, 2009 at 10:23 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
> >> > Hi Thierry,
> >> >
> >> > I have added linux-omap community. How different is this chip from
> >> > tsc2007. It looks to me that this chip is not much different from
> >> > tsc2007 (this is just quick look at the driver). If they
> >> > are similar please consider using i2c_device_id feature in tsc2007 to
> >> > accommodate this chip.
> >>
> >> I agree with the Trilok's opinion.
> > [snip]
> >
> > I only noticed the tsc2007 driver some time ago, when the tsc2003 was already
> > finished (it's actually pretty old, I just never got around to submitting
> > it). However I never got the tsc2007 to work on my platform because it uses
> > sleeping functions inside the timer handler, which results in an oops right
> > after the first touchscreen interrupt.
> >
> > I guess I could try and fix the tsc2007 properly instead of having a second,
> > pretty similar driver in the tree.
> >
> 
> This could be because of improper locking? If you share a crash we can
> have look at it.

Attached is a patch that fixes things for me. The problem was that the I2C
transfers were done in interrupt context which fails for the controller I use
(PXA270). The attached patch uses a struct work_struct to schedule the I2C
transfers so they are executed in non-interrupt context.

I've tested the patch on a minimal system with tslib and it work fine with
ts_calibrate and friends.

Thierry


--JP+T4n/bALQSJXh8
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="tsc2007.patch"
Content-Transfer-Encoding: quoted-printable

=46rom: Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH] tsc2007: Fix for I2C controllers that sleep during transfe=
rs.

This patch fixes the tsc2007 driver with I2C controllers that sleep during
transfers. By moving the critical code to a workqueue, I2C transfers can be
scheduled to run in non-interrupt context.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

---
 drivers/input/touchscreen/tsc2007.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscree=
n/tsc2007.c
index 4ab0702..6efb54d 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -70,6 +70,7 @@ struct ts_event {
 struct tsc2007 {
 	struct input_dev	*input;
 	char			phys[32];
+	struct work_struct	work;
 	struct hrtimer		timer;
 	struct ts_event		tc;
=20
@@ -173,6 +174,9 @@ static void tsc2007_send_event(void *tsc)
=20
 		dev_dbg(&ts->client->dev, "point(%4d,%4d), pressure (%4u)\n",
 			x, y, rt);
+	} else {
+		if (!ts->pendown)
+			ts->pendown =3D 1;
 	}
=20
 	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
@@ -197,11 +201,19 @@ static int tsc2007_read_values(struct tsc2007 *tsc)
 	return 0;
 }
=20
+static void tsc2007_work(struct work_struct *work)
+{
+	struct tsc2007 *ts =3D container_of(work, struct tsc2007, work);
+	tsc2007_read_values(ts);
+	tsc2007_send_event(ts);
+}
+
 static enum hrtimer_restart tsc2007_timer(struct hrtimer *handle)
 {
 	struct tsc2007 *ts =3D container_of(handle, struct tsc2007, timer);
+	unsigned long flags =3D 0;
=20
-	spin_lock_irq(&ts->lock);
+	spin_lock_irqsave(&ts->lock, flags);
=20
 	if (unlikely(!ts->get_pendown_state() && ts->pendown)) {
 		struct input_dev *input =3D ts->input;
@@ -217,12 +229,10 @@ static enum hrtimer_restart tsc2007_timer(struct hrti=
mer *handle)
 	} else {
 		/* pen is still down, continue with the measurement */
 		dev_dbg(&ts->client->dev, "pen is still down\n");
-
-		tsc2007_read_values(ts);
-		tsc2007_send_event(ts);
+		schedule_work(&ts->work);
 	}
=20
-	spin_unlock_irq(&ts->lock);
+	spin_unlock_irqrestore(&ts->lock, flags);
=20
 	return HRTIMER_NORESTART;
 }
@@ -235,7 +245,7 @@ static irqreturn_t tsc2007_irq(int irq, void *handle)
 	spin_lock_irqsave(&ts->lock, flags);
=20
 	if (likely(ts->get_pendown_state())) {
-		disable_irq(ts->irq);
+		disable_irq_nosync(ts->irq);
 		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
 					HRTIMER_MODE_REL);
 	}
@@ -252,7 +262,7 @@ static int tsc2007_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct tsc2007 *ts;
-	struct tsc2007_platform_data *pdata =3D pdata =3D client->dev.platform_da=
ta;
+	struct tsc2007_platform_data *pdata =3D client->dev.platform_data;
 	struct input_dev *input_dev;
 	int err;
=20
@@ -279,6 +289,7 @@ static int tsc2007_probe(struct i2c_client *client,
=20
 	hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	ts->timer.function =3D tsc2007_timer;
+	INIT_WORK(&ts->work, tsc2007_work);
=20
 	spin_lock_init(&ts->lock);
=20
--=20
tg: (091438d..) adx/input/tsc2007 (depends on: adx/master)

--JP+T4n/bALQSJXh8--
