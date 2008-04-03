Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbYDCNPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbYDCNPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbYDCNO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:14:57 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:33579 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753565AbYDCNO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:14:56 -0400
X-Belgacom-Dynamic: yes
Subject: [PATCH] usbcore, kernel 2.6.18.1
From: Gerd Luyten <gluyten@skynet.be>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 03 Apr 2008 15:14:54 +0200
Message-Id: <1207228494.8542.9.camel@workstation.dyn.nu>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to eventually detect a Velleman K8055 USB device.
Without the patch it will fail detection with following errors:
usb 1-2: can't read configurations, error -110
=> probably because of usb non-conformance reason of the K8055 card.
(timing issues...)

With this patch, detection will keep on trying until usb card gets
recognized.
This patch adds a device reset in the "fail:" sequence instead of just
marking the device state as NOTATTACHED.

[gluyten@workstation pup214]$ diff -u
linux-2.6.18.1/drivers/usb/core/hub.c hub.c
--- linux-2.6.18.1/drivers/usb/core/hub.c       2006-10-14
05:34:03.000000000 +0200
+++ hub.c       2008-04-03 14:47:49.000000000 +0200
@@ -1450,7 +1450,9 @@
        return 0;

 fail:
-       usb_set_device_state(udev, USB_STATE_NOTATTACHED);
+//     usb_set_device_state(udev, USB_STATE_NOTATTACHED);
+       usb_lock_device_for_reset(udev, NULL);
+       usb_reset_composite_device(udev, NULL);
        return err;
 }



-- 
Gerd Luyten <gluyten@skynet.be>

