Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbZEFLMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbZEFLMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbZEFLMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:12:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64997 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZEFLMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:12:19 -0400
Date: Wed, 6 May 2009 13:13:36 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Kwangwoo Lee <kwangwoo.lee@gmail.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] input: Add support for the TSC2003 controller.
Message-ID: <20090506111336.GB14326@avionic-design.de>
References: <1241006627-22811-1-git-send-email-thierry.reding@avionic-design.de> <5d5443650904290623n3712cd7dja653a139cff2cf6d@mail.gmail.com> <483a38b80904291835p51044741p9bd83d33a40031c@mail.gmail.com> <20090504113751.GA22603@avionic-design.de> <5d5443650905040503n501e3b47qc890dc4c71a85b1c@mail.gmail.com> <20090504145700.GA875@avionic-design.de> <483a38b80905052125r76358182g7ce6b890c921b655@mail.gmail.com> <20090506064529.GA14326@avionic-design.de> <483a38b80905052354m221ddc03tcbe9d35ee902b467@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <483a38b80905052354m221ddc03tcbe9d35ee902b467@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18MXHLL3qETd5pLZvk7ONBrB7QKA1LvZQCIXfn
 wuqyLYNYSjauITG6oROQH7hFyiXWLi79gXW7qQrla7+iea+MBJ
 XhfYvlVzPnzAvWx5EKkZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Kwangwoo Lee wrote:
> On Wed, May 6, 2009 at 3:45 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > * Kwangwoo Lee wrote:
> > [...]
> >> Thanks for the patch. It looks good. :)
> >> The code in the patch is already merged in the main kernel tree.
> >>
> >> @@ -235,7 +245,7 @@ static irqreturn_t tsc2007_irq(int irq, void *ha=
ndle)
> >> =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&ts->lock, flags);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 if (likely(ts->get_pendown_state())) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 disable_irq(ts->irq);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 disable_irq_nosync(ts->i=
rq);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hrtimer_start(&ts->=
timer, ktime_set(0, TS_POLL_DELAY),
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 HRTIMER_M=
ODE_REL);
> >> =C2=A0 =C2=A0 =C2=A0 }
> >
> > Oh, I hadn't noticed. I diffed against 2.6.30-rc4. Do you want me to =
send a
> > new patch or will you just rip that piece out?
>=20
> Send fixed patch with your Signed-off-by line.

Attached is the previous patch with said change removed.

Thierry


--k1lZvvs/B4yU6o8G
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
 drivers/input/touchscreen/tsc2007.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscree=
n/tsc2007.c
index 4ab0702..2939355 100644
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

--k1lZvvs/B4yU6o8G--
