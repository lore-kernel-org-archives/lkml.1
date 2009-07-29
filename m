Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZG2W3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZG2W3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 18:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZG2W3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 18:29:23 -0400
Received: from colo3.heeltoe.com ([207.210.106.184]:39805 "EHLO
	colo3.heeltoe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZG2W3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 18:29:22 -0400
X-Greylist: delayed 1232 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2009 18:29:22 EDT
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] forced recalibration for the OLPC hgpk touchpad 
From: Paul Fox <pgf@laptop.org>
In-reply-to: <3026.1243972079@foxharp.boston.ma.us> 
References: <3026.1243972079@foxharp.boston.ma.us>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29771.1248905330.1@foxharp.boston.ma.us>
Date: Wed, 29 Jul 2009 18:08:50 -0400
Message-ID: <29774.1248905330@foxharp.boston.ma.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is a resubmission, in the hopes of jump-starting the merge
discussion.  it was last discussed in early june of this year.

the OLPC XO laptop incorporates a combination touchpad/tablet
device which unfortunately requires frequent recalibration.  the
driver will force this automatically when various suspicious
behaviors are observed, and the user can recalibrate manually
(with a special keyboard sequence).  there's currently no way,
however, for an external program to cause recalibration.

this patch creates a new node in /sys which, when written with '1',
will force a touchpad recalibration.  no other writes (or reads)
of this node are supported.

during the previous discussion, dmitry suggested that we instead
use the reconnect capability which is already available in /sys. 
i experimented with this, and unfortunately a full reset of
the touchpad takes quite a long time -- 1.1 or 1.2 seconds. 
recalibration deprives the user of their touchpad for long enough
as it is -- i don't think we can afford that time.  (note
that this is a workaround for bad hardware -- the XO no longer
uses this touchpad at least partly due to this very issue, but
there are enough in use that we're still trying to improve
things.)

paul

Signed-off-by: Paul Fox <pgf@laptop.org>
Acked-by: Andres Salomon <dilinger@collabora.co.uk>

diff --git a/drivers/input/mouse/hgpk.c b/drivers/input/mouse/hgpk.c
index a1ad2f1..e736ebd 100644
--- a/drivers/input/mouse/hgpk.c
+++ b/drivers/input/mouse/hgpk.c
@@ -369,12 +369,40 @@ static ssize_t hgpk_set_powered(struct psmouse *psmouse, void *data,
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
+	psmouse_queue_work(psmouse, &priv->recalib_wq,
+				msecs_to_jiffies(1));
+
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
+	device_remove_file(&psmouse->ps2dev.serio->dev,
+			   &psmouse_attr_recalibrate.dattr);
 	psmouse_reset(psmouse);
 	kfree(priv);
 }
@@ -423,8 +451,18 @@ static int hgpk_register(struct psmouse *psmouse)
 
 	err = device_create_file(&psmouse->ps2dev.serio->dev,
 				 &psmouse_attr_powered.dattr);
-	if (err)
-		hgpk_err(psmouse, "Failed to create sysfs attribute\n");
+	if (err) {
+		hgpk_err(psmouse, "Failed creating 'powered' sysfs node\n");
+	} else {
+		err = device_create_file(&psmouse->ps2dev.serio->dev,
+					 &psmouse_attr_recalibrate.dattr);
+		if (err) {
+			hgpk_err(psmouse,
+				"Failed creating 'recalibrate' sysfs node\n");
+			device_remove_file(&psmouse->ps2dev.serio->dev,
+					&psmouse_attr_powered.dattr);
+		}
+	}
 
 	return err;
 }
=---------------------
 paul fox, pgf@laptop.org
