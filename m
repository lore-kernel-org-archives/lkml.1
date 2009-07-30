Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbZG3FoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbZG3FoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 01:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZG3FoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 01:44:07 -0400
Received: from mail-px0-f203.google.com ([209.85.216.203]:59581 "EHLO
	mail-px0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZG3FoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 01:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=Yqy9VXRJ2Ok0HN2JGxn2wvc50cGHJen57Le20kHm1sFDVJviqRYsMMQH0+lnhF/pi6
         PDjSGNIrLiYjDYfe9KLetV7jj7I0sG/H04srQhwR/pt2Ym6toM3tCXrXRI8jICRomvzK
         hMbGzj/E2Jw1ud59GlCbJiRwDx/vPfuzzBupA=
Date: Wed, 29 Jul 2009 22:44:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Paul Fox <pgf@laptop.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] forced recalibration for the OLPC hgpk touchpad
References: <3026.1243972079@foxharp.boston.ma.us> <29774.1248905330@foxharp.boston.ma.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29774.1248905330@foxharp.boston.ma.us>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090730061803.C05C3526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Jul 29, 2009 at 06:08:50PM -0400, Paul Fox wrote:
> this is a resubmission, in the hopes of jump-starting the merge
> discussion.  it was last discussed in early june of this year.
> 
> the OLPC XO laptop incorporates a combination touchpad/tablet
> device which unfortunately requires frequent recalibration.  the
> driver will force this automatically when various suspicious
> behaviors are observed, and the user can recalibrate manually
> (with a special keyboard sequence).  there's currently no way,
> however, for an external program to cause recalibration.
> 
> this patch creates a new node in /sys which, when written with '1',
> will force a touchpad recalibration.  no other writes (or reads)
> of this node are supported.
> 
> during the previous discussion, dmitry suggested that we instead
> use the reconnect capability which is already available in /sys. 
> i experimented with this, and unfortunately a full reset of
> the touchpad takes quite a long time -- 1.1 or 1.2 seconds. 
> recalibration deprives the user of their touchpad for long enough
> as it is -- i don't think we can afford that time.  (note
> that this is a workaround for bad hardware -- the XO no longer
> uses this touchpad at least partly due to this very issue, but
> there are enough in use that we're still trying to improve
> things.)
> 

Sorry, I completely forgot about this patch... I am going to apply
it, however I think that we should not be creating the attribute
if the touchpad does not support recalibration. Also, I don't see
the reason why we can't schedule recalibration immediately instead
of waiting for 1 msec.

Could you please try updated version of the patch below?

Thanks!

-- 
Dmitry


Input: hgpk - forced recalibration for the OLPC touchpad

From: Paul Fox <pgf@laptop.org>

The OLPC XO laptop incorporates a combination touchpad/tablet device
which unfortunately requires frequent recalibration.  The driver will
force this automatically when various suspicious behaviors are
observed, and the user can recalibrate manually (with a special
keyboard sequence). There's currently no way, however, for an external
program to cause recalibration. We can not use the reconnect
capability which is already available in /sys because full reset of
the touchpad takes 1.1 - 1.2 secons which is too long.

This patch creates a new node in /sys which, when written with '1',
will force a touchpad recalibration; no other writes (or reads)
of this node are supported.

Signed-off-by: Paul Fox <pgf@laptop.org>
Acked-by: Andres Salomon <dilinger@collabora.co.uk>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/hgpk.c |   55 ++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 52 insertions(+), 3 deletions(-)


diff --git a/drivers/input/mouse/hgpk.c b/drivers/input/mouse/hgpk.c
index a1ad2f1..f5aa035 100644
--- a/drivers/input/mouse/hgpk.c
+++ b/drivers/input/mouse/hgpk.c
@@ -369,12 +369,46 @@ static ssize_t hgpk_set_powered(struct psmouse *psmouse, void *data,
 __PSMOUSE_DEFINE_ATTR(powered, S_IWUSR | S_IRUGO, NULL,
 		      hgpk_show_powered, hgpk_set_powered, 0);
 
+static ssize_t hgpk_trigger_recal_show(struct psmouse *psmouse,
+		void *data, char *buf)
+{
+	return -EINVAL;
+}
+
+static ssize_t hgpk_trigger_recal(struct psmouse *psmouse, void *data,
+				const char *buf, size_t count)
+{
+	struct hgpk_data *priv = psmouse->private;
+	unsigned long value;
+	int err;
+
+	err = strict_strtoul(buf, 10, &value);
+	if (err || value != 1)
+		return -EINVAL;
+
+	/*
+	 * We queue work instead of doing recalibration right here
+	 * to avoid adding locking to to hgpk_force_recalibrate()
+	 * since workqueue provides serialization.
+	 */
+	psmouse_queue_work(psmouse, &priv->recalib_wq, 0);
+	return count;
+}
+
+__PSMOUSE_DEFINE_ATTR(recalibrate, S_IWUSR | S_IRUGO, NULL,
+		      hgpk_trigger_recal_show, hgpk_trigger_recal, 0);
+
 static void hgpk_disconnect(struct psmouse *psmouse)
 {
 	struct hgpk_data *priv = psmouse->private;
 
 	device_remove_file(&psmouse->ps2dev.serio->dev,
 			   &psmouse_attr_powered.dattr);
+
+	if (psmouse->model >= HGPK_MODEL_C)
+		device_remove_file(&psmouse->ps2dev.serio->dev,
+				   &psmouse_attr_recalibrate.dattr);
+
 	psmouse_reset(psmouse);
 	kfree(priv);
 }
@@ -423,10 +457,25 @@ static int hgpk_register(struct psmouse *psmouse)
 
 	err = device_create_file(&psmouse->ps2dev.serio->dev,
 				 &psmouse_attr_powered.dattr);
-	if (err)
-		hgpk_err(psmouse, "Failed to create sysfs attribute\n");
+	if (err) {
+		hgpk_err(psmouse, "Failed creating 'powered' sysfs node\n");
+		return err;
+	}
 
-	return err;
+	/* C-series touchpads added the recalibrate command */
+	if (psmouse->model >= HGPK_MODEL_C) {
+		err = device_create_file(&psmouse->ps2dev.serio->dev,
+					 &psmouse_attr_recalibrate.dattr);
+		if (err) {
+			hgpk_err(psmouse,
+				"Failed creating 'recalibrate' sysfs node\n");
+			device_remove_file(&psmouse->ps2dev.serio->dev,
+					&psmouse_attr_powered.dattr);
+			return err;
+		}
+	}
+
+	return 0;
 }
 
 int hgpk_init(struct psmouse *psmouse)
