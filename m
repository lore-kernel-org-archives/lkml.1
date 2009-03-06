Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZCFKeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZCFKeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZCFKeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:34:15 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:58059 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZCFKeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:34:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=AkGrGaNo0HqyID/M1XmbwWWGgY3QsGw8m8Q71Zq9lyKxveSq+oc8/fWALPWkLZ6rDH
         0o4TU6xw5vSTDG/r43EorQFFdJ32uXC1jMkNkWBLeEE5TpClAwOe5pdzOv5CnAvR42lZ
         aXAtQiqtC0E06i1JFPdFGBXN5viMkw1aBz29U=
Subject: usb-storage: Wait less time for settling when a memory device is
 connected
From: Martin Bammer <mrbm74@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 06 Mar 2009 11:34:07 +0100
Message-Id: <1236335647.16732.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was wondering why the usb-storage driver waits for my usb-stick and my
sdhc-card 5s before scanning. IMHO this is only needed for HDs. I've
created a patch for the driver which shortens the timeout to 1s when a
memory device is detected.
But I'm not shure if the detection code is right for all devices. This
maybe has to be tested and discussed.
I've tested it with a usb-stick, a sdhc-card and a usb-harddrive.
This patch is created for kernel 2.6.27.18.

Please CC me for answers to this thread.

--- a/drivers/usb/storage/usb.c 2009-03-03 23:33:37.000000000 +0100
+++ b/drivers/usb/storage/usb.c 2009-03-03 23:32:44.000000000 +0100
@@ -913,10 +913,16 @@ static int usb_stor_scan_thread(void * _
 
        set_freezable();
 
+       /* Shorten delay time for memory sticks/cards */
+       if ((1 == us->pusb_dev->descriptor.iManufacturer)
+           && (2 == us->pusb_dev->descriptor.iProduct)
+           && (3 == us->pusb_dev->descriptor.iSerialNumber)
+           && (delay_use > 0)) delay_use = 1;
+
        /* Wait for the timeout to expire or for a disconnect */
        if (delay_use > 0) {
                printk(KERN_DEBUG "usb-storage: waiting for device "
-                               "to settle before scanning\n");
+                               "to settle before scanning for %d
seconds\n", delay_use);
                wait_event_freezable_timeout(us->delay_wait,
                                test_bit(US_FLIDX_DONT_SCAN,
&us->dflags),
                                delay_use * HZ);


