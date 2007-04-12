Return-Path: <linux-kernel-owner+w=401wt.eu-S1030684AbXDLSdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030684AbXDLSdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030685AbXDLSdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:33:47 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37791 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030684AbXDLSdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:33:47 -0400
Date: Thu, 12 Apr 2007 20:32:50 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Helge Hafting <helgehaf@aitel.hist.no>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
In-Reply-To: <20070411230700.GA4023@aitel.hist.no>
Message-ID: <Pine.LNX.4.64.0704122023510.12991@twin.jikos.cz>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
 <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org>
 <20070411230700.GA4023@aitel.hist.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007, Helge Hafting wrote:

> The last messages (handwritten, somewhat shortened)
> calling hid_init+0x0/0x10()
> returned 0
> ran for 0 msec
> calling hid_init+0x0/0x50()
> usbcore registered new interface driver hiddev
> and then it hangs completely.

OK, so it hangs somewhere nearby usbhid's hid_init(), and the 
usb_register() has been already invoked. Could you please apply the 
superstupid patch below and send me the output up to the point it hangs? I 
am curious to know whether it hangs somewhere inside usb_register(), or 
elsewhere.

Thanks.

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 1ddca31..d930f62 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1550,15 +1550,22 @@ static int __init hid_init(void)
 	retval = hiddev_init();
 	if (retval)
 		goto hiddev_init_fail;
+	printk(KERN_DEBUG "hid_init: before usb_register()\n");
 	retval = usb_register(&hid_driver);
+	printk(KERN_DEBUG "hid_init: after usb_register(), retuned %d\n", retval);
 	if (retval)
 		goto usb_register_fail;
 	info(DRIVER_VERSION ":" DRIVER_DESC);
 
+	printk(KERN_DEBUG "hid_init: returning 0\n");
+	dump_stack();
 	return 0;
 usb_register_fail:
+	printk(KERN_DEBUG "hid_init: calling hiddev_exit()\n");
 	hiddev_exit();
 hiddev_init_fail:
+	printk(KERN_DEBUG "hid_init: returning %d\n", retval);
+	dump_stack();
 	return retval;
 }
 
