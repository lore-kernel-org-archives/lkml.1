Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbXDLXRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbXDLXRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbXDLXRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:17:16 -0400
Received: from twin.jikos.cz ([213.151.79.26]:50213 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbXDLXRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:17:15 -0400
Date: Fri, 13 Apr 2007 01:16:56 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Helge Hafting <helgehaf@aitel.hist.no>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
In-Reply-To: <20070412202519.GB14705@aitel.hist.no>
Message-ID: <Pine.LNX.4.64.0704130107170.12991@twin.jikos.cz>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
 <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org>
 <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704122023510.12991@twin.jikos.cz>
 <20070412202519.GB14705@aitel.hist.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007, Helge Hafting wrote:

> Are you sure this is the correct patch - against 2.6.21-rc6-mm1 ?
> Hunk 1 out of 1 failed . . .

Well I am pretty sure:

box:~/scratch # wget ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/2.6.21-rc6-mm1.bz2>/dev/null 2>&1
box:~/scratch # wget ftp://ftp.kernel.org/pub/linux/kernel/v2.6/linux-2.6.20.tar.bz2>/dev/null 2>&1
box:~/scratch # wget ftp://ftp.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.21-rc6.bz2>/dev/null 2>&1 
box:~/scratch # tar xf linux-2.6.20.tar.bz2
box:~/scratch # cd linux-2.6.20/
box:~/scratch/linux-2.6.20 # mv ../patch-2.6.21-rc6.bz2 .
box:~/scratch/linux-2.6.20 # bunzip2 patch-2.6.21-rc6.bz2
box:~/scratch/linux-2.6.20 # patch -p1 < patch-2.6.21-rc6 >/dev/null 2>&1; echo $?
0
box:~/scratch/linux-2.6.20 # mv ../2.6.21-rc6-mm1.bz2 .
box:~/scratch/linux-2.6.20 # bunzip2 2.6.21-rc6-mm1.bz2
box:~/scratch/linux-2.6.20 # patch -p1 < 2.6.21-rc6-mm1 >/dev/null 2>&1; echo $?
0
box:~/scratch/linux-2.6.20 # cat tmp.patch
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 1ddca31..d930f62 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1550,15 +1550,22 @@ static int __init hid_init(void)
        retval = hiddev_init();
        if (retval)
                goto hiddev_init_fail;
+       printk(KERN_DEBUG "hid_init: before usb_register()\n");
        retval = usb_register(&hid_driver);
+       printk(KERN_DEBUG "hid_init: after usb_register(), retuned %d\n", 
retval);
        if (retval)
                goto usb_register_fail;
        info(DRIVER_VERSION ":" DRIVER_DESC);

+       printk(KERN_DEBUG "hid_init: returning 0\n");
+       dump_stack();
        return 0;
 usb_register_fail:
+       printk(KERN_DEBUG "hid_init: calling hiddev_exit()\n");
        hiddev_exit();
 hiddev_init_fail:
+       printk(KERN_DEBUG "hid_init: returning %d\n", retval);
+       dump_stack();
        return retval;
 }
box:~/scratch/linux-2.6.20 # patch -p1 < tmp.patch
patching file drivers/hid/usbhid/hid-core.c
box:~/scratch/linux-2.6.20 #

So I guess you are operating on some broken version of 2.6.21-rc6-mm1 
codebase if you are getting rejects on this trivial patch.


Anyway, based on information you have provided in your later messages, it 
seems that it is probably not necessairly related neither to USB nor HID, 
as you are getting hangs at different stages of boot, depending on your 
local configuration/kernel version used.

Is vanilla 2.6.21-rc6 ok? If so, would you have time to bisect the 
offending patch?

Thanks,

-- 
Jiri Kosina
