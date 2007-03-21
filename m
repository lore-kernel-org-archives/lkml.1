Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbXCUSO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbXCUSO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933310AbXCUSO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:14:59 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:49480 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933287AbXCUSO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:14:58 -0400
Message-ID: <4601761F.4000302@lwfinger.net>
Date: Wed, 21 Mar 2007 13:14:55 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Zan Lynx <zlynx@acm.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org>	<1174433034.62033.16.camel@localhost> <20070320223643.d8cbc3f6.akpm@linux-foundation.org>
In-Reply-To: <20070320223643.d8cbc3f6.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------020006020605050908090003"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020006020605050908090003
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Tue, 20 Mar 2007 17:23:54 -0600 Zan Lynx <zlynx@acm.org> wrote:
> 
>> On Mon, 2007-03-19 at 20:56 -0800, Andrew Morton wrote:
>>> Temporarily at
>>>
>>>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
>>>
>>> Will appear later at
>>>
>>>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
>> First impressions:
>> Several of the same bugs as rc3-mm*:
>>       * Freezes immediately if I touch the wlan0 device after loading
>>         the new Broadcom wireless driver.

The version of the ssb driver in 2.6.21-rc4-mm1 has a bug that causes a kernel oops if the bcm43xx
chip contains a USB (dangling) core. This bug has been fixed in Michael Buesch's tree, but
apparently not yet in Linville's wireless-dev tree. The patch is as follows:

commit 08531ff130bcc8181d9294a66e25010f48eefb97
Author: Michael Buesch <mb@bu3sch.de>
Date:   Wed Mar 7 23:01:08 2007 +0100

    ssb: Don't freeze unregistered devices.

    Signed-off-by: Michael Buesch <mb@bu3sch.de>

diff --git a/drivers/ssb/core.c b/drivers/ssb/core.c
index 2facada..c956edf 100644
--- a/drivers/ssb/core.c
+++ b/drivers/ssb/core.c
@@ -163,6 +163,8 @@ int ssb_devices_freeze(struct ssb_bus *bus)
 		dev = &(bus->devices[i]);
 		if (!dev->dev->driver)
 			continue;
+		if (!device_is_registered(dev->dev))
+			continue;
 		drv = drv_to_ssb_drv(dev->dev->driver);
 		if (drv && drv->suspend) {
 			err = drv->suspend(dev, state);
@@ -185,6 +187,8 @@ int ssb_devices_thaw(struct ssb_bus *bus)
 		dev = &(bus->devices[i]);
 		if (!dev->dev->driver)
 			continue;
+		if (!device_is_registered(dev->dev))
+			continue;
 		drv = drv_to_ssb_drv(dev->dev->driver);
 		if (drv && drv->resume) {
 			err = drv->resume(dev);

Larry


--------------020006020605050908090003
Content-Type: text/plain;
 name="usb_freeze"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usb_freeze"

commit 08531ff130bcc8181d9294a66e25010f48eefb97
Author: Michael Buesch <mb@bu3sch.de>
Date:   Wed Mar 7 23:01:08 2007 +0100

    ssb: Don't freeze unregistered devices.
    
    Signed-off-by: Michael Buesch <mb@bu3sch.de>

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 2facada..c956edf 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -163,6 +163,8 @@ int ssb_devices_freeze(struct ssb_bus *bus)
 		dev = &(bus->devices[i]);
 		if (!dev->dev->driver)
 			continue;
+		if (!device_is_registered(dev->dev))
+			continue;
 		drv = drv_to_ssb_drv(dev->dev->driver);
 		if (drv && drv->suspend) {
 			err = drv->suspend(dev, state);
@@ -185,6 +187,8 @@ int ssb_devices_thaw(struct ssb_bus *bus)
 		dev = &(bus->devices[i]);
 		if (!dev->dev->driver)
 			continue;
+		if (!device_is_registered(dev->dev))
+			continue;
 		drv = drv_to_ssb_drv(dev->dev->driver);
 		if (drv && drv->resume) {
 			err = drv->resume(dev);


--------------020006020605050908090003--
