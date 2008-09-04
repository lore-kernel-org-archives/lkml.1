Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbYIDU2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbYIDU2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758198AbYIDUZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:25:43 -0400
Received: from mail.work.de ([212.12.32.20]:42085 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758189AbYIDUZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:25:42 -0400
Message-ID: <48C04441.5030608@gmail.com>
Date: Fri, 05 Sep 2008 00:25:37 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: Arvo Jarve <arvo@softshark.ee>
Subject: DVB Update [PATCH 15/31] add event with changed status
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------020103060104040400020500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020103060104040400020500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 8053f283eb95229023d30a431e76823acaf4a617 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 13:50:56 +0200
Subject: [PATCH] DVB Add event only with changed status

The event list was updated continuously, add to the event list
only when the status has changed

From: Arvo Jarve <arvo@softshark.ee>
Signed-off-by: Arvo Jarve <arvo@softshark.ee>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)


--------------020103060104040400020500
Content-Type: text/x-patch;
 name="15.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="15.patch"

>From 8053f283eb95229023d30a431e76823acaf4a617 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 13:50:56 +0200
Subject: [PATCH] DVB Add event only with changed status

The event list was updated continuously, add to the event list
only when the status has changed

From: Arvo Jarve <arvo@softshark.ee>
Signed-off-by: Arvo Jarve <arvo@softshark.ee>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 3ca28d0..93b08fa 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -586,10 +586,13 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 
 	e = &events->events[events->eventw];
 
-	if (fe->legacy)
+	if (fe->legacy) {
 		memcpy(&e->parameters, &fepriv->parameters, sizeof (struct dvb_frontend_parameters));
-	else
+		e->status = status;
+	} else {
 		memcpy(&e->fe_params, &fepriv->fe_params, sizeof (struct dvbfe_params));
+		e->fe_events.status = status;
+	}
 
 	if (fe->legacy) {
 		/* Legacy	*/
@@ -606,8 +609,6 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 
 	mutex_unlock(&events->mtx);
 
-	e->status = status;
-
 	wake_up_interruptible (&events->wait_queue);
 }
 
@@ -1211,19 +1212,13 @@ restart:
 						/* We did do a search as was requested, the flags are
 						 * now unset as well and has the flags wrt to search.
 						 */
+					} else {
+						fepriv->algo_status &= ~DVBFE_ALGO_SEARCH_AGAIN;
 					}
-					fepriv->algo_status &= ~DVBFE_ALGO_SEARCH_AGAIN;
 				}
 				/* Track the carrier if the search was successful	*/
 				if (fepriv->algo_status == DVBFE_ALGO_SEARCH_SUCCESS) {
-					if (fepriv->algo_status & DVBFE_ALGO_SEARCH_SUCCESS)
-						dprintk("%s: status = DVBFE_ALGO_SEARCH_SUCCESS\n", __func__);
-					if (fepriv->algo_status & DVBFE_ALGO_SEARCH_FAILED)
-						fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
-
-					fe->ops.read_status(fe, &s);
-					dvb_frontend_add_event(fe, s); /* update event list	*/
-					fepriv->status = s;
+					dprintk("%s: STATUS = DVBFE_ALGO_SEARCH_SUCCESS\n", __func__);
 					if (fe->ops.track) {
 						dprintk("%s: TRACK callback exists at 0x%p\n", __func__, fe->ops.track);
 #if 0
@@ -1234,6 +1229,20 @@ restart:
 #endif
 						fe->ops.track(fe, fe_params, &fepriv->delay);
 					}
+				} else {
+					fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
+					fepriv->delay = HZ / 2;
+				}
+				fe->ops.read_status(fe, &s);
+				if (s != fepriv->status) {
+					dvb_frontend_add_event(fe, s); /* update event list */
+					fepriv->status = s;
+					if (!(s & FE_HAS_LOCK)) {
+						fepriv->delay = HZ / 10;
+						fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
+					} else {
+						fepriv->delay = 60 * HZ;
+					}
 				}
 				break;
 			default:


--------------020103060104040400020500--
