Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab0AOJaL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767Ab0AOJaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:30:10 -0500
Received: from mx2.zhaw.ch ([160.85.104.51]:48141 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab0AOJaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:30:09 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] staging: iio: Fix locking in __iio_push_event
Date: Fri, 15 Jan 2010 10:30:01 +0100
Message-Id: <1263547801-8640-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.6.3.3
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.1.15.92117
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __CP_URI_IN_BODY 0, __FRAUD_BODY_WEBMAIL 0, __FRAUD_WEBMAIL 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly unlock the mutex when leaving the function. This was
discovered by the stanse tool at
http://decibel.fi.muni.cz/~xslaby/stanse/error.cgi?db=33-rc&id=138

Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/staging/iio/industrialio-core.c |   49 +++++++++++++++++--------------
 1 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 768f448..fa0f025 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -78,28 +78,33 @@ EXPORT_SYMBOL(__iio_change_event);
 
 	/* Does anyone care? */
 	mutex_lock(&ev_int->event_list_lock);
-	if (test_bit(IIO_BUSY_BIT_POS, &ev_int->handler.flags)) {
-		if (ev_int->current_events == ev_int->max_events)
-			return 0;
-		ev = kmalloc(sizeof(*ev), GFP_KERNEL);
-		if (ev == NULL) {
-			ret = -ENOMEM;
-			goto error_ret;
-		}
-		ev->ev.id = ev_code;
-		ev->ev.timestamp = timestamp;
-		ev->shared_pointer = shared_pointer_p;
-		if (ev->shared_pointer)
-			shared_pointer_p->ev_p = ev;
-
-		list_add_tail(&ev->list, &ev_int->det_events.list);
-		ev_int->current_events++;
-		mutex_unlock(&ev_int->event_list_lock);
-		wake_up_interruptible(&ev_int->wait);
-	} else
-		mutex_unlock(&ev_int->event_list_lock);
+	if (!test_bit(IIO_BUSY_BIT_POS, &ev_int->handler.flags))
+		goto out_unlock;
 
-error_ret:
+	if (ev_int->current_events == ev_int->max_events)
+		goto out_unlock;
+
+	ev = kmalloc(sizeof(*ev), GFP_KERNEL);
+	if (ev == NULL) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	ev->ev.id = ev_code;
+	ev->ev.timestamp = timestamp;
+	ev->shared_pointer = shared_pointer_p;
+	if (ev->shared_pointer)
+		shared_pointer_p->ev_p = ev;
+
+	list_add_tail(&ev->list, &ev_int->det_events.list);
+	ev_int->current_events++;
+	mutex_unlock(&ev_int->event_list_lock);
+	wake_up_interruptible(&ev_int->wait);
+
+	return 0;
+
+out_unlock:
+	mutex_unlock(&ev_int->event_list_lock);
 	return ret;
 }
 EXPORT_SYMBOL(__iio_push_event);
-- 
1.6.3.3

