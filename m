Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZFBUG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZFBUG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZFBUGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:06:20 -0400
Received: from colo3.heeltoe.com ([207.210.106.184]:46826 "EHLO
	colo3.heeltoe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZFBUGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:06:20 -0400
X-Greylist: delayed 1098 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jun 2009 16:06:19 EDT
To: dmitry.torokhov@gmail.com
Subject: [PATCH] forced recalibration for the OLPC hgpk touchpad
From: pgf@laptop.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3023.1243972079.1@foxharp.boston.ma.us>
Date: Tue, 02 Jun 2009 15:47:59 -0400
Message-ID: <3026.1243972079@foxharp.boston.ma.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OLPC XO laptop incorporates a combination touchpad/tablet
device which unfortunately requires frequent recalibration.  The
driver will force this automatically when various suspicious
behaviors are observed, and the user can recalibrate manually
(with a special keyboard sequence).  There's currently no way,
however, for an external program to cause recalibration.

This patch creates a new node in /sys which, when written with '1',
will force a touchpad recalibration.  No other writes (or reads)
of this node are supported.

paul

--------------------


Signed-off-by: Paul Fox <pgf@foxharp.boston.ma.us>

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
