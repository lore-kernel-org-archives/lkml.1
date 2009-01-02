Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbZABJht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbZABJht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbZABJhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:37:39 -0500
Received: from rtr.ca ([76.10.145.34]:59118 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZABJhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:37:38 -0500
Message-ID: <495DE060.8040707@rtr.ca>
Date: Fri, 02 Jan 2009 04:37:36 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: libusb broken on 2.6.28 x86_64 ?
References: <495DB4AC.50602@rtr.ca> <495DBBC1.7040202@rtr.ca> <20090102072436.GA3444@suse.de> <495DC771.9030103@rtr.ca> <20090102075835.GA3955@suse.de> <495DCD18.8060900@rtr.ca> <20090102082824.GA4212@suse.de>
In-Reply-To: <20090102082824.GA4212@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
..
> Hm, care to run 'git bisect'?
..

No, thanks.  But the number of USB core changes in 2.6.28 is rather small,
so I just ended up looking at each of them in more detail.

This patch, below, FIXES it for me, by undoing a change from 2.6.28.

Signed-off-by: Mark Lord <mlord@pobox.com>

--- old/drivers/usb/core/driver.c	2008-12-24 18:26:37.000000000 -0500
+++ linux/drivers/usb/core/driver.c	2009-01-02 04:34:11.000000000 -0500
@@ -279,9 +279,7 @@
 	 * altsetting means creating new endpoint device entries).
 	 * When either of these happens, defer the Set-Interface.
 	 */
-	if (intf->cur_altsetting->desc.bAlternateSetting == 0)
-		;	/* Already in altsetting 0 so skip Set-Interface */
-	else if (!error && intf->dev.power.status == DPM_ON)
+	if (!error && intf->dev.power.status == DPM_ON)
 		usb_set_interface(udev, intf->altsetting[0].
 				desc.bInterfaceNumber, 0);
 	else
