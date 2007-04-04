Return-Path: <linux-kernel-owner+w=401wt.eu-S2992921AbXDDPVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992921AbXDDPVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992922AbXDDPVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:21:16 -0400
Received: from ag-out-0708.google.com ([72.14.246.250]:52319 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992921AbXDDPVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:21:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L90eWLQfXKFQTDjh0Uo+RIkHVK9kdiTEqU7CWqY84xkHjSZfuKOc5KAT+rfySwOfwDKZp63tYLQCDtEH+09udQmlseNVaFDS1fhoqVT9A2F+8GYlcMh91QWwsdZd8wrBiGwuoNWgaTpPknIKySMSZaIiUrcxlSJ2aoAlYvxf+hw=
Message-ID: <f9be06770704040821h6d96e703hf405335fa73f289b@mail.gmail.com>
Date: Wed, 4 Apr 2007 11:21:04 -0400
From: "Karl Pickett" <karl.pickett@gmail.com>
To: "Vincent Vanackere" <vincent.vanackere@gmail.com>
Subject: Re: [PATCH] Make ati_remote button repeat sensitivity soft-configurable
Cc: Eric.Piel@tremplin-utc.net, linux-kernel@vger.kernel.org,
       inux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <f9be06770704040637k419a7fd7t2cdd52186d91ad5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f9be06770704031734k11ec894fpdf1afe385108aece@mail.gmail.com>
	 <461357D8.8060608@tremplin-utc.net>
	 <65258a580704040145m6eb7108frfa8197d3b88e207a@mail.gmail.com>
	 <f9be06770704040637k419a7fd7t2cdd52186d91ad5f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Would this be more acceptable?  I haven't compiled or tested yet..but
you can see what I'm trying to do.. make the delay time based instead
of implementation/count based...

Signed-off-by: Karl Pickett <karl.pickett@gmail.com>

--- ./ati_remote.c.kjp	2007-04-04 10:56:20.000000000 -0400
+++ ./ati_remote.c	2007-04-04 11:13:02.000000000 -0400
@@ -120,6 +120,7 @@
  * behaviour.
  */
 #define FILTER_TIME     60 /* msec */
+#define REPEAT_DELAY    500 /* msec */

 static unsigned long channel_mask;
 module_param(channel_mask, ulong, 0644);
@@ -133,6 +134,11 @@
 module_param(repeat_filter, int, 0644);
 MODULE_PARM_DESC(repeat_filter, "Repeat filter time, default = 60 msec");

+static int repeat_delay = REPEAT_DELAY;
+module_param(repeat_delay, int, 0644);
+MODULE_PARM_DESC(repeat_delay, "Delay before sending repeats, "
+                                "default = " #REPEAT_DELAY " msec");
+
 #define dbginfo(dev, format, arg...) do { if (debug) dev_info(dev ,
format , ## arg); } while (0)
 #undef err
 #define err(format, arg...) printk(KERN_ERR format , ## arg)
@@ -175,6 +181,7 @@
         unsigned long old_jiffies;
         unsigned long acc_jiffies;  /* handle acceleration */
         unsigned int repeat_count;
+        unsigned long first_jiffies;

         char name[NAME_BUFSIZE];
         char phys[NAME_BUFSIZE];
@@ -501,21 +508,26 @@
         }

         if (ati_remote_tbl[index].kind == KIND_FILTERED) {
+                unsigned long now = jiffies;
+
                 /* Filter duplicate events which happen "too close"
together. */
                 if (ati_remote->old_data[0] == data[1] &&
                     ati_remote->old_data[1] == data[2] &&
-                    time_before(jiffies, ati_remote->old_jiffies +
msecs_to_jiffies(repeat_filter))) {
+                    time_before(now, ati_remote->old_jiffies +
+                            msecs_to_jiffies(repeat_filter))) {
                         ati_remote->repeat_count++;
                 } else {
                         ati_remote->repeat_count = 0;
+                        ati_remote->first_jiffies = now;
                 }

                 ati_remote->old_data[0] = data[1];
                 ati_remote->old_data[1] = data[2];
-                ati_remote->old_jiffies = jiffies;
+                ati_remote->old_jiffies = now;

                 if (ati_remote->repeat_count > 0 &&
-                    ati_remote->repeat_count < 5)
+                                time_before(now, ati_remote->first_jiffies +
+                                        msecs_to_jiffies(repeat_delay)))
                         return;


-- 
Karl Pickett
The most wasted of all days is one without laughter.—E.E. Cummings
