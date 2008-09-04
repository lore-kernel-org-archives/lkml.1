Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbYIDUZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbYIDUZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757314AbYIDUYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:24:15 -0400
Received: from mail.work.de ([212.12.32.20]:34088 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbYIDUYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:24:13 -0400
Message-ID: <48C043E7.5050206@gmail.com>
Date: Fri, 05 Sep 2008 00:24:07 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 7/31] backward compat for older delivery systems
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------090901010401000203030001"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090901010401000203030001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 209207c583848b37a54b135256a62a5eb4135516 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:26:28 +0200
Subject: [PATCH] DVB Fix: use backward compatibility for older delivery
systems

* The backward compatibilty of the existing delivery systems was
broken. The patch fixes the same.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


--------------090901010401000203030001
Content-Type: text/x-patch;
 name="7.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="7.patch"

>From 209207c583848b37a54b135256a62a5eb4135516 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:26:28 +0200
Subject: [PATCH] DVB Fix: use backward compatibility for older delivery systems

* The backward compatibilty of the existing delivery systems was
broken. The patch fixes the same.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 106bf2b..de49e4b 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1433,7 +1433,6 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int err = -EOPNOTSUPP;
-	enum dvbfe_delsys delsys = 0;
 
 	dprintk ("%s\n", __func__);
 
@@ -1699,15 +1698,21 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 
 	case DVBFE_SET_PARAMS: {
 		struct dvb_frontend_tune_settings fetunesettings;
+		enum dvbfe_delsys delsys = fepriv->fe_info.delivery;
 
 		fe->legacy = 0;
 		memcpy(&fepriv->fe_params, parg, sizeof (struct dvbfe_params));
 		memset(&fetunesettings, 0, sizeof (struct dvb_frontend_tune_settings));
 		memcpy(&fetunesettings.fe_params, parg, sizeof (struct dvbfe_params));
 
-		if (newapi_to_olddrv(&fepriv->fe_params, &fepriv->parameters, fepriv->fe_info.delivery)  == -EINVAL)
-			printk("%s: ERROR !!! Converting New parameters --> Old parameters\n", __func__);
+		if ((delsys && DVBFE_DELSYS_DVBS) ||
+		    (delsys && DVBFE_DELSYS_DVBC) ||
+		    (delsys && DVBFE_DELSYS_DVBT) ||
+		    (delsys && DVBFE_DELSYS_ATSC)) {
 
+			if (newapi_to_olddrv(&fepriv->fe_params, &fepriv->parameters, fepriv->fe_info.delivery)  == -EINVAL)
+				printk("%s: ERROR !!! Converting New parameters --> Old parameters\n", __func__);
+		}
 		/* Request the search algorithm to search	*/
 		fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
 


--------------090901010401000203030001--
