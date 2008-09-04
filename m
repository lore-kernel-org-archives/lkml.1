Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYIDU2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYIDU2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbYIDUZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:25:53 -0400
Received: from mail.work.de ([212.12.32.20]:42092 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758235AbYIDUZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:25:52 -0400
Message-ID: <48C0444B.2010800@gmail.com>
Date: Fri, 05 Sep 2008 00:25:47 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: Marco Schluessler <marco@lordzodiac.de>
Subject: DVB Update [PATCH 16/31] fix backward compat
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------040508080907050908050308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040508080907050908050308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 0093e2bd237fcf9825ab8d0c0deebb5bc8dff5c9 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 13:55:49 +0200
Subject: [PATCH] DVB Fix backward compatibility

Backward compatibility was broken in terms that it was all
around non-legacy devices being selected for device control
and hence drivers with the old callbacks never worked. The
patch fixes the approach where both set of drivers are working
now.

tested with a TT S2 3200 (new) and a FF S2300 (legacy) devices

From: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)


--------------040508080907050908050308
Content-Type: text/x-patch;
 name="16.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="16.patch"

>From 0093e2bd237fcf9825ab8d0c0deebb5bc8dff5c9 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 13:55:49 +0200
Subject: [PATCH] DVB Fix backward compatibility

Backward compatibility was broken in terms that it was all
around non-legacy devices being selected for device control
and hence drivers with the old callbacks never worked. The
patch fixes the approach where both set of drivers are working
now.

tested with a TT S2 3200 (new) and a FF S2300 (legacy) devices

From: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 93b08fa..784acbd 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1730,6 +1730,9 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		enum dvbfe_delsys delsys = fepriv->fe_info.delivery;
 
 		fe->legacy = 0;
+		if (!(fe->ops.set_params || fe->ops.search))
+			fe->legacy = 1;
+
 		memcpy(&fepriv->fe_params, parg, sizeof (struct dvbfe_params));
 		memset(&fetunesettings, 0, sizeof (struct dvb_frontend_tune_settings));
 		memcpy(&fetunesettings.fe_params, parg, sizeof (struct dvbfe_params));
@@ -1830,6 +1833,22 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		fe->legacy = 0;
 		if (fe->ops.get_delsys) {
 			err = fe->ops.get_delsys(fe, (enum dvbfe_delsys *) parg);
+		} else {
+			switch (fe->ops.info.type) {
+				case FE_QPSK:
+					*((enum dvbfe_delsys *) parg) = DVBFE_DELSYS_DVBS;
+					break;
+				case FE_QAM:
+					*((enum dvbfe_delsys *) parg) = DVBFE_DELSYS_DVBC;
+					break;
+				case FE_OFDM:
+					*((enum dvbfe_delsys *) parg) = DVBFE_DELSYS_DVBT;
+					break;
+				default:
+					up (&fepriv->sem);
+					return -EINVAL;
+			}
+			err = 0;
 		}
 		break;
 	case DVBFE_GET_INFO:
@@ -1839,6 +1858,9 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 			memcpy(&fepriv->fe_info, (struct dvbfe_info *) parg, sizeof (struct dvbfe_info));
 			err = fe->ops.get_info(fe, &fepriv->fe_info);
 			memcpy((struct dvbfe_info *) parg, &fepriv->fe_info, sizeof (struct dvbfe_info));
+		} else {
+			memcpy(&fepriv->fe_info, (struct dvbfe_info *) parg, sizeof (struct dvbfe_info));
+			err = 0;
 		}
 		break;
 	};


--------------040508080907050908050308--
