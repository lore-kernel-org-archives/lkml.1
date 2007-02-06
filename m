Return-Path: <linux-kernel-owner+w=401wt.eu-S965333AbXBFAkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965333AbXBFAkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965378AbXBFAkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:40:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51016 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965333AbXBFAky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:40:54 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 6 Feb 2007 01:39:59 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: ohci1394 broke 2.6.19 -> 2.6.20-rc1
To: Robert Crocombe <rcrocomb@gmail.com>
cc: linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <tkrat.c39467d7194502c4@s5r6.in-berlin.de>
Message-ID: <tkrat.f2510ec744e6b5c8@s5r6.in-berlin.de>
References: <e6babb600702051521l4a08eb2dw2a7f423fd0d7edd7@mail.gmail.com>
 <tkrat.c39467d7194502c4@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On  6 Feb, Stefan Richter wrote:
> Robert Crocombe wrote:
>> moving to anything more recent than 2.6.19
>> means ohci1394 is non-functional (no 1394 hosts are detected) and the
>> module cannot be removed.

Not using the option disable_nodemgr=1 should avoid the bug.

>> I have narrowed it down to 2.6.19 works, 2.6.20-rc1 doesn't.  Lots of detail at:
>> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=7942
> 
> I get a spinlock lockup on 2.6.20-rc6 + some 1394 updates with a similar
> trace to what Robert posted at bugzilla --- *if* I use ieee1394's option
> disable_nodemgr=1. (Never used it before.) The key appears to be how
> hpsb_alloc_host interacts with the driver core. I don't know if hosts.c
> is at fault or some change in the driver core.

It's my oversight, see patch.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: fix host device registering when nodemgr disabled

Since my commit 8252bbb1363b7fe963a3eb6f8a36da619a6f5a65 in 2.6.20-rc1,
host devices have a dummy driver attached.  Alas the driver was not
registered before use if ieee1394 was loaded with disable_nodemgr=1.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/ieee1394_core.c |    1 +
 drivers/ieee1394/nodemgr.c       |    3 +--
 drivers/ieee1394/nodemgr.h       |    4 +---
 3 files changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6.20-rc6/drivers/ieee1394/ieee1394_core.c
===================================================================
--- linux-2.6.20-rc6.orig/drivers/ieee1394/ieee1394_core.c	2007-02-03 18:04:50.000000000 +0100
+++ linux-2.6.20-rc6/drivers/ieee1394/ieee1394_core.c	2007-02-06 01:28:04.000000000 +0100
@@ -1132,6 +1132,7 @@ static int __init ieee1394_init(void)
 		}
 	}
 
+	ret = driver_register(&nodemgr_mid_layer_driver);
 	ret = class_register(&hpsb_host_class);
 	if (ret < 0)
 		goto release_all_bus;
Index: linux-2.6.20-rc6/drivers/ieee1394/nodemgr.c
===================================================================
--- linux-2.6.20-rc6.orig/drivers/ieee1394/nodemgr.c	2007-01-27 14:07:00.000000000 +0100
+++ linux-2.6.20-rc6/drivers/ieee1394/nodemgr.c	2007-02-06 01:29:21.000000000 +0100
@@ -249,7 +249,7 @@ static struct device nodemgr_dev_templat
  * useful drivers for them yet, and there would be a deadlock possible if the
  * driver core scans the host device while the host's low-level driver (i.e.
  * the host's parent device) is being removed. */
-static struct device_driver nodemgr_mid_layer_driver = {
+struct device_driver nodemgr_mid_layer_driver = {
 	.bus		= &ieee1394_bus_type,
 	.name		= "nodemgr",
 	.owner		= THIS_MODULE,
@@ -1857,7 +1857,6 @@ int init_ieee1394_nodemgr(void)
 		class_unregister(&nodemgr_ne_class);
 		return error;
 	}
-	error = driver_register(&nodemgr_mid_layer_driver);
 	hpsb_register_highlevel(&nodemgr_highlevel);
 	return 0;
 }
Index: linux-2.6.20-rc6/drivers/ieee1394/nodemgr.h
===================================================================
--- linux-2.6.20-rc6.orig/drivers/ieee1394/nodemgr.h	2007-01-27 14:07:00.000000000 +0100
+++ linux-2.6.20-rc6/drivers/ieee1394/nodemgr.h	2007-02-06 01:30:27.000000000 +0100
@@ -181,10 +181,8 @@ int nodemgr_for_each_host(void *__data, 
 int init_ieee1394_nodemgr(void);
 void cleanup_ieee1394_nodemgr(void);
 
-/* The template for a host device */
+extern struct device_driver nodemgr_mid_layer_driver;
 extern struct device nodemgr_dev_template_host;
-
-/* Bus attributes we export */
 extern struct bus_attribute *const fw_bus_attrs[];
 
 #endif /* _IEEE1394_NODEMGR_H */



-- 
Stefan Richter
-=====-=-=== --=- --==-
http://arcgraph.de/sr/


