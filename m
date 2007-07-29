Return-Path: <linux-kernel-owner+w=401wt.eu-S936600AbXG2Vn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936600AbXG2Vn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762324AbXG2Vnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:43:49 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:40954
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933895AbXG2Vns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:43:48 -0400
Date: Sun, 29 Jul 2007 23:43:41 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 5/5] Use mutex instead of semaphore in the DVB frontend tuning interface
Message-ID: <20070729214341.GH3432@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070729212909.GC3432@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729212909.GC3432@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The DVB frontend tuning interface uses a semaphore as mutex. Use the
mutex API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index b6c7f66..e35dd17 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -138,7 +138,7 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 
 	dprintk ("%s\n", __FUNCTION__);
 
-	if (down_interruptible (&events->sem))
+	if (mutex_lock_interruptible (&events->mtx))
 		return;
 
 	wp = (events->eventw + 1) % MAX_EVENT;
@@ -159,7 +159,7 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 
 	events->eventw = wp;
 
-	up (&events->sem);
+	mutex_unlock(&events->mtx);
 
 	e->status = status;
 
@@ -197,7 +197,7 @@ static int dvb_frontend_get_event(struct dvb_frontend *fe,
 			return ret;
 	}
 
-	if (down_interruptible (&events->sem))
+	if (mutex_lock_interruptible (&events->mtx))
 		return -ERESTARTSYS;
 
 	memcpy (event, &events->events[events->eventr],
@@ -205,7 +205,7 @@ static int dvb_frontend_get_event(struct dvb_frontend *fe,
 
 	events->eventr = (events->eventr + 1) % MAX_EVENT;
 
-	up (&events->sem);
+	mutex_unlock(&events->mtx);
 
 	return 0;
 }
@@ -1080,7 +1080,7 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 	init_MUTEX (&fepriv->sem);
 	init_waitqueue_head (&fepriv->wait_queue);
 	init_waitqueue_head (&fepriv->events.wait_queue);
-	init_MUTEX (&fepriv->events.sem);
+	mutex_init(&fepriv->events.mtx);
 	fe->dvb = dvb;
 	fepriv->inversion = INVERSION_OFF;
 
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index a770a87..f95de63 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
+#include <linux/mutex.h>
 
 #include <linux/dvb/frontend.h>
 
@@ -142,7 +143,7 @@ struct dvb_fe_events {
 	int			  eventr;
 	int			  overflow;
 	wait_queue_head_t	  wait_queue;
-	struct semaphore	  sem;
+	struct mutex		  mtx;
 };
 
 struct dvb_frontend {


-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

                       El camino se hace al andar
                           (Antonio Machado)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
