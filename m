Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbXENSNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbXENSNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 14:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbXENSNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 14:13:08 -0400
Received: from argus.EECS.Berkeley.EDU ([128.32.42.200]:47418 "EHLO
	EECS.Berkeley.EDU" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756629AbXENSNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 14:13:08 -0400
From: Jason Riedy <ejr@cs.berkeley.edu>
To: Dmitry Torokhov <dtor@insightbb.com>
cc: Remi Colinet <remi.colinet@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.21-mm1 (git-input) on Dell D610 laptop 
In-reply-to: <200705132334.38386.dtor@insightbb.com> 
X-Mailer: MH-E 8.0.3; nmh 1.1; GNU Emacs 22.0.96
Date: Mon, 14 May 2007 11:12:44 -0700
Message-ID: <26856.1179166364@argus.EECS.Berkeley.EDU>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

And Dmitry Torokhov writes:
> I don't think so. Could you please try the patch below? Thanks!

The appended patch on top of yours fixes the too-early access of
psmouse->private.  I don't know the expected lifetime of
psmouse->private, so I chickened out of simply assigning priv
earlier.

BTW, why do you pass psmouse down through the initializations
rather than ps2dev and private?

Jason, using git's index, dammit...

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 2aeb299..990d2a5 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -384,10 +384,9 @@ static int alps_poll(struct psmouse *psmouse)
 	return 0;
 }
 
-static int alps_hw_init(struct psmouse *psmouse, int *version)
+static int alps_hw_init(struct psmouse *psmouse, struct alps_data *priv,
+			int *version)
 {
-	struct alps_data *priv = psmouse->private;
-
 	priv->i = alps_get_model(psmouse, version);
 	if (!priv->i)
 		return -1;
@@ -421,7 +420,7 @@ static int alps_reconnect(struct psmouse *psmouse)
 {
 	psmouse_reset(psmouse);
 
-	if (alps_hw_init(psmouse, NULL))
+	if (alps_hw_init(psmouse, (struct alps_data *)psmouse->private, NULL))
 		return -1;
 
 	return 0;
@@ -449,7 +448,7 @@ int alps_init(struct psmouse *psmouse)
 
 	priv->dev2 = dev2;
 
-	if (alps_hw_init(psmouse, &version))
+	if (alps_hw_init(psmouse, priv, &version))
 		goto init_fail;
 
 	dev1->evbit[LONG(EV_KEY)] |= BIT(EV_KEY);
