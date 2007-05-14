Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbXENDes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbXENDes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 23:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbXENDel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 23:34:41 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:2747 "EHLO
	asav08.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbXENDek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 23:34:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AutRAPx1R0ZKhRO4W2dsb2JhbACHMIhFHQ0FEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jason Riedy <ejr@eecs.berkeley.edu>
Subject: Re: Regression in 2.6.21-mm1 (git-input) on Dell D610 laptop
Date: Sun, 13 May 2007 23:34:37 -0400
User-Agent: KMail/1.9.3
Cc: Remi Colinet <remi.colinet@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <4010.1179028730@argus.EECS.Berkeley.EDU>
In-Reply-To: <4010.1179028730@argus.EECS.Berkeley.EDU>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705132334.38386.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 May 2007 23:58, Jason Riedy wrote:
> And Dmitry Torokhov writes:
> > Have you tried any other -mm? Also, does it help if you stick
> >         ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> > at the very beginning of psmouse_initialize() in
> > drivers/input/mouse/psmouse-base.c?
> 
> Seems to fix it for me on a D620.
> 

Ok, thanks. 

> Bisecting on mainline gave commit
> f42649e84831efc69d5f621f1c36a39b4e384a99 (Input: ALPS - handle
> errors from input_register_device()) as the place where the
> trackpoint half stopped working.  I don't necessarily believe it,
> unless the psmouse_reset on failure caused problems without
> logging anything.
>

I don't think so. Could you please try the patch below? Thanks!

-- 
Dmitry

Input: ALPS - force stream mode

ALPS appears to need SETSTREAM command after reset, otherwise it
does not produce any data. Now that we do not request stream mode
by default individual drivers need to take care of it.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/alps.c |   55 +++++++++++++++++++++++----------------------
 1 files changed, 29 insertions(+), 26 deletions(-)

Index: work/drivers/input/mouse/alps.c
===================================================================
--- work.orig/drivers/input/mouse/alps.c
+++ work/drivers/input/mouse/alps.c
@@ -251,11 +251,15 @@ static const struct alps_model_info *alp
 
 	dbg("E7 report: %2.2x %2.2x %2.2x", param[0], param[1], param[2]);
 
-	for (i = 0; i < ARRAY_SIZE(rates) && param[2] != rates[i]; i++);
-	*version = (param[0] << 8) | (param[1] << 4) | i;
+	if (version) {
+		for (i = 0; i < ARRAY_SIZE(rates) && param[2] != rates[i]; i++)
+			/* empty */;
+		*version = (param[0] << 8) | (param[1] << 4) | i;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(alps_model_data); i++)
-		if (!memcmp(param, alps_model_data[i].signature, sizeof(alps_model_data[i].signature)))
+		if (!memcmp(param, alps_model_data[i].signature,
+			    sizeof(alps_model_data[i].signature)))
 			return alps_model_data + i;
 
 	return NULL;
@@ -380,32 +384,46 @@ static int alps_poll(struct psmouse *psm
 	return 0;
 }
 
-static int alps_reconnect(struct psmouse *psmouse)
+static int alps_hw_init(struct psmouse *psmouse, int *version)
 {
 	struct alps_data *priv = psmouse->private;
-	int version;
-
-	psmouse_reset(psmouse);
 
-	if (!(priv->i = alps_get_model(psmouse, &version)))
+	priv->i = alps_get_model(psmouse, version);
+	if (!priv->i)
 		return -1;
 
 	if ((priv->i->flags & ALPS_PASS) && alps_passthrough_mode(psmouse, 1))
 		return -1;
 
 	if (alps_tap_mode(psmouse, 1)) {
-		printk(KERN_WARNING "alps.c: Failed to reenable hardware tapping\n");
+		printk(KERN_WARNING "alps.c: Failed to enable hardware tapping\n");
 		return -1;
 	}
 
 	if (alps_absolute_mode(psmouse)) {
-		printk(KERN_ERR "alps.c: Failed to reenable absolute mode\n");
+		printk(KERN_ERR "alps.c: Failed to enable absolute mode\n");
 		return -1;
 	}
 
 	if ((priv->i->flags & ALPS_PASS) && alps_passthrough_mode(psmouse, 0))
 		return -1;
 
+	/* ALPS needs stream mode, otherwise it won't report any data */
+	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSTREAM)) {
+		printk(KERN_ERR "alps.c: Failed to enable stream mode\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int alps_reconnect(struct psmouse *psmouse)
+{
+	psmouse_reset(psmouse);
+
+	if (alps_hw_init(psmouse, NULL))
+		return -1;
+
 	return 0;
 }
 
@@ -431,22 +449,7 @@ int alps_init(struct psmouse *psmouse)
 
 	priv->dev2 = dev2;
 
-	priv->i = alps_get_model(psmouse, &version);
-	if (!priv->i)
-		goto init_fail;
-
-	if ((priv->i->flags & ALPS_PASS) && alps_passthrough_mode(psmouse, 1))
-		goto init_fail;
-
-	if (alps_tap_mode(psmouse, 1))
-		printk(KERN_WARNING "alps.c: Failed to enable hardware tapping\n");
-
-	if (alps_absolute_mode(psmouse)) {
-		printk(KERN_ERR "alps.c: Failed to enable absolute mode\n");
-		goto init_fail;
-	}
-
-	if ((priv->i->flags & ALPS_PASS) && alps_passthrough_mode(psmouse, 0))
+	if (alps_hw_init(psmouse, &version))
 		goto init_fail;
 
 	dev1->evbit[LONG(EV_KEY)] |= BIT(EV_KEY);
