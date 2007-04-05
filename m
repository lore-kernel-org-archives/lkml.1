Return-Path: <linux-kernel-owner+w=401wt.eu-S1766996AbXDEOXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766996AbXDEOXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767005AbXDEOXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:23:33 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:2704 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766996AbXDEOXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:23:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=i89yvhEeDq6HzozCnFUMNFWZ1Wm84mvKLDIv7TM7HULhuTSkue7Xa80qYFHd04hZtuzaLiDjs/+ukRetMqh9zJIlSCfUn0mhm3mAmsSXt6FJ7xoeAZ7JoVH1Gy0l1Gzdo8BeKkv9ji1yLU6qOee52uCwFpvGXl9mH0gyPmQb1dk=
Message-ID: <f9be06770704050723p1a01f9adyae8fc671c91edb7c@mail.gmail.com>
Date: Thu, 5 Apr 2007 10:23:28 -0400
From: "Karl Pickett" <karl.pickett@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: [PATCH] Make ati_remote button repeat sensitivity soft-configurable (V2)
Cc: "Vincent Vanackere" <vincent.vanackere@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry, please use this instead of my previous patch.  Thanks to
Vincent for the code review , fixes, and testing.

ati_remote causes repeats after only .23 seconds with my remote and
makes it hard to use comfortably.  Make a precise way of setting the
repeat delay time in milliseconds and default it to 500ms.  The old
behavior can be had by setting repeat_delay = 0.

Signed-off-by: Karl Pickett <karl.pickett@gmail.com>
Signed-off-by: Vincent Vanackere <vincent.vanackere@gmail.com>

 --- drivers/usb/input/ati_remote.c.orig	2007-04-04 22:05:10.000000000 +0200
+++ drivers/usb/input/ati_remote.c	2007-04-04 22:35:59.000000000 +0200
@@ -120,6 +120,7 @@
  * behaviour.
  */
 #define FILTER_TIME	60 /* msec */
+#define REPEAT_DELAY	500 /* msec */

 static unsigned long channel_mask;
 module_param(channel_mask, ulong, 0644);
@@ -133,6 +134,10 @@
 module_param(repeat_filter, int, 0644);
 MODULE_PARM_DESC(repeat_filter, "Repeat filter time, default = 60 msec");

+static int repeat_delay = REPEAT_DELAY;
+module_param(repeat_delay, int, 0644);
+MODULE_PARM_DESC(repeat_delay, "Delay before sending repeats, default
= 500 msec");
+
 #define dbginfo(dev, format, arg...) do { if (debug) dev_info(dev ,
format , ## arg); } while (0)
 #undef err
 #define err(format, arg...) printk(KERN_ERR format , ## arg)
@@ -174,6 +179,8 @@
 	unsigned char old_data[2];  /* Detect duplicate events */
 	unsigned long old_jiffies;
 	unsigned long acc_jiffies;  /* handle acceleration */
+	unsigned long first_jiffies;
+
 	unsigned int repeat_count;

 	char name[NAME_BUFSIZE];
@@ -501,21 +508,31 @@
 	}

 	if (ati_remote_tbl[index].kind == KIND_FILTERED) {
+		unsigned long now = jiffies;
+
 		/* Filter duplicate events which happen "too close" together. */
 		if (ati_remote->old_data[0] == data[1] &&
 		    ati_remote->old_data[1] == data[2] &&
-		    time_before(jiffies, ati_remote->old_jiffies +
msecs_to_jiffies(repeat_filter))) {
+		    time_before(now, ati_remote->old_jiffies +
+				     msecs_to_jiffies(repeat_filter))) {
 			ati_remote->repeat_count++;
 		} else {
 			ati_remote->repeat_count = 0;
+			ati_remote->first_jiffies = now;
 		}

 		ati_remote->old_data[0] = data[1];
 		ati_remote->old_data[1] = data[2];
-		ati_remote->old_jiffies = jiffies;
+		ati_remote->old_jiffies = now;

+		/* Ensure we skip at least the 4 first duplicate events (generated
+		 * by a single keypress), and continue skipping until repeat_delay
+		 * msecs have passed
+		 */
 		if (ati_remote->repeat_count > 0 &&
-		    ati_remote->repeat_count < 5)
+		    (ati_remote->repeat_count < 5 ||
+		     time_before(now, ati_remote->first_jiffies +
+				      msecs_to_jiffies(repeat_delay))))
 			return;




-- 
Karl Pickett
The most wasted of all days is one without laughter.—E.E. Cummings
