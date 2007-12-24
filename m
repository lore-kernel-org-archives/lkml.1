Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbXLXOjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbXLXOjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXLXOj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:39:28 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:58425 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbXLXOj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:39:27 -0500
Date: Mon, 24 Dec 2007 15:39:00 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 18/38] drivers/media/video: Use time_before, time_before_eq,
 etc.
Message-ID: <Pine.LNX.4.64.0712241538290.23999@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -r -u -p a/drivers/media/video/c-qcam.c b/drivers/media/video/c-qcam.c
--- a/drivers/media/video/c-qcam.c	2007-11-01 10:30:39.000000000 +0100
+++ b/drivers/media/video/c-qcam.c	2007-12-23 20:36:52.000000000 +0100
@@ -36,6 +36,7 @@
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
 #include <linux/mutex.h>
+#include <linux/jiffies.h>
 
 #include <asm/uaccess.h>
 
@@ -95,7 +96,8 @@ static unsigned int qcam_await_ready1(st
 	unsigned long oldjiffies = jiffies;
 	unsigned int i;
 
-	for (oldjiffies = jiffies; (jiffies - oldjiffies) < msecs_to_jiffies(40); )
+	for (oldjiffies = jiffies;
+	     time_before(jiffies, oldjiffies + msecs_to_jiffies(40)); )
 		if (qcam_ready1(qcam) == value)
 			return 0;
 
@@ -120,7 +122,8 @@ static unsigned int qcam_await_ready2(st
 	unsigned long oldjiffies = jiffies;
 	unsigned int i;
 
-	for (oldjiffies = jiffies; (jiffies - oldjiffies) < msecs_to_jiffies(40); )
+	for (oldjiffies = jiffies;
+	     time_before(jiffies, oldjiffies + msecs_to_jiffies(40)); )
 		if (qcam_ready2(qcam) == value)
 			return 0;
 
diff -r -u -p a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
--- a/drivers/media/video/ivtv/ivtv-fileops.c	2007-11-01 10:30:39.000000000 +0100
+++ b/drivers/media/video/ivtv/ivtv-fileops.c	2007-12-23 20:37:15.000000000 +0100
@@ -219,7 +219,9 @@ static struct ivtv_buffer *ivtv_get_buff
 			/* Process pending program info updates and pending VBI data */
 			ivtv_update_pgm_info(itv);
 
-			if (jiffies - itv->dualwatch_jiffies > msecs_to_jiffies(1000)) {
+			if (time_after(jiffies,
+				       itv->dualwatch_jiffies +
+				       msecs_to_jiffies(1000))) {
 				itv->dualwatch_jiffies = jiffies;
 				ivtv_dualwatch(itv);
 			}
diff -r -u -p a/drivers/media/video/ivtv/ivtv-mailbox.c b/drivers/media/video/ivtv/ivtv-mailbox.c
--- a/drivers/media/video/ivtv/ivtv-mailbox.c	2007-10-22 11:25:10.000000000 +0200
+++ b/drivers/media/video/ivtv/ivtv-mailbox.c	2007-12-23 20:37:40.000000000 +0100
@@ -177,7 +177,8 @@ static int get_mailbox(struct ivtv *itv,
 
 		/* Sleep before a retry, if not atomic */
 		if (!(flags & API_NO_WAIT_MB)) {
-			if (jiffies - then > msecs_to_jiffies(10*retries))
+			if (time_after(jiffies,
+				       then + msecs_to_jiffies(10*retries)))
 			       break;
 			ivtv_msleep_timeout(10, 0);
 		}
@@ -244,7 +245,9 @@ static int ivtv_api_call(struct ivtv *it
 	   data, then just return 0 as there is no need to issue this command again.
 	   Just an optimization to prevent unnecessary use of mailboxes. */
 	if (itv->api_cache[cmd].last_jiffies &&
-	    jiffies - itv->api_cache[cmd].last_jiffies < msecs_to_jiffies(1800000) &&
+	    time_before(jiffies,
+			itv->api_cache[cmd].last_jiffies +
+			msecs_to_jiffies(1800000)) &&
 	    !memcmp(data, itv->api_cache[cmd].data, sizeof(itv->api_cache[cmd].data))) {
 		itv->api_cache[cmd].last_jiffies = jiffies;
 		return 0;
@@ -299,7 +302,7 @@ static int ivtv_api_call(struct ivtv *it
 		}
 	}
 	while (!(readl(&mbox->flags) & IVTV_MBOX_FIRMWARE_DONE)) {
-		if (jiffies - then > api_timeout) {
+		if (time_after(jiffies, then + api_timeout)) {
 			IVTV_DEBUG_WARN("Could not get result (%s)\n", api_info[cmd].name);
 			/* reset the mailbox, but it is likely too late already */
 			write_sync(0, &mbox->flags);
@@ -311,7 +314,7 @@ static int ivtv_api_call(struct ivtv *it
 		else
 			ivtv_msleep_timeout(1, 0);
 	}
-	if (jiffies - then > msecs_to_jiffies(100))
+	if (time_after(jiffies, then + msecs_to_jiffies(100)))
 		IVTV_DEBUG_WARN("%s took %u jiffies\n",
 				api_info[cmd].name,
 				jiffies_to_msecs(jiffies - then));
diff -r -u -p a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/video/ivtv/ivtv-streams.c
--- a/drivers/media/video/ivtv/ivtv-streams.c	2007-12-13 20:41:15.000000000 +0100
+++ b/drivers/media/video/ivtv/ivtv-streams.c	2007-12-23 20:37:55.000000000 +0100
@@ -783,7 +783,8 @@ int ivtv_stop_v4l2_encode_stream(struct 
 
 			/* wait 2s for EOS interrupt */
 			while (!test_bit(IVTV_F_I_EOS, &itv->i_flags) &&
-				jiffies < then + msecs_to_jiffies (2000)) {
+				time_before(jiffies,
+					    then + msecs_to_jiffies(2000))) {
 				schedule_timeout(msecs_to_jiffies(10));
 			}
 
