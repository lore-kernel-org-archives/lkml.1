Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbXDDAeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbXDDAeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934044AbXDDAeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:34:36 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:25312 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997AbXDDAef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qPs69P+CsUZQnxs5g4fimmmNa+2gnSzXv/hF6ev90au490jV237ph/w3hEBJIgLqRhooW9RoFZn2x+FzZSW8ck8AFKwxRNL3NOoJfyMnrkUmkF2LK08IvPOSbeMYNnQaAuUlFVSbpWyjDDNhuG1IAQO9Q3Or4/7kcHZwyB0Ytuo=
Message-ID: <f9be06770704031734k11ec894fpdf1afe385108aece@mail.gmail.com>
Date: Tue, 3 Apr 2007 20:34:17 -0400
From: "Karl Pickett" <karl.pickett@gmail.com>
To: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       dmitry.torokhov@gmail.com
Subject: [PATCH] Make ati_remote button repeat sensitivity soft-configurable
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The ati_remote driver is a little too sensitive for my wife... if you
do anything but barely tap the button you can get multiple events
reported.  We prefer a more conservative no-repeat setting.  This is a
pretty trivial patch which just makes one hard coded value soft
configurable and does not change the default.

--- linux-source-2.6.20/drivers/usb/input/ati_remote.c.kjp
2006-12-07 22:50:56.000000000 -0500
+++ linux-source-2.6.20/drivers/usb/input/ati_remote.c  2007-04-03
20:19:24.000000000 -0400
@@ -119,7 +119,9 @@
  * and we have to take this into account for an accurate repeat
  * behaviour.
  */
-#define FILTER_TIME    60 /* msec */
+#define FILTER_TIME    60 /* millisec between each repeat */
+
+#define FILTER_MAX     5 /* number of repeats to ignore */

 static unsigned long channel_mask;
 module_param(channel_mask, ulong, 0644);
@@ -133,6 +135,11 @@
 module_param(repeat_filter, int, 0644);
 MODULE_PARM_DESC(repeat_filter, "Repeat filter time, default = 60 msec");

+static int repeat_filter_max = FILTER_MAX;
+module_param(repeat_filter_max, int, 0644);
+MODULE_PARM_DESC(repeat_filter_max,
+       "Number of repeats to ignore, default = 5");
+
 #define dbginfo(dev, format, arg...) do { if (debug) dev_info(dev ,
format , ## arg); } while (0)
 #undef err
 #define err(format, arg...) printk(KERN_ERR format , ## arg)
@@ -515,7 +522,7 @@
                ati_remote->old_jiffies = jiffies;

                if (ati_remote->repeat_count > 0 &&
-                   ati_remote->repeat_count < 5)
+                   ati_remote->repeat_count < repeat_filter_max)
                        return;




-- 
Karl Pickett
The most wasted of all days is one without laughter.—E.E. Cummings
