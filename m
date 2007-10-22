Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbXJVAJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbXJVAJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 20:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbXJVAJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 20:09:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49789 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXJVAJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 20:09:13 -0400
Date: Mon, 22 Oct 2007 02:09:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net, mwallis@serialmonkey.com
Subject: Re: rt73usb: support for wireless in Kohjinsha subnotebook
Message-ID: <20071022000919.GB29024@elf.ucw.cz>
References: <20071020184100.GA11640@elf.ucw.cz> <efe7343f0710210802v6abc54d9k19293942477dabcc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efe7343f0710210802v6abc54d9k19293942477dabcc@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This device is NOT a Ralink USB wifi adapter!
> 
> Get the windows driver in this link and see for yourself.
> http://www.conitech.it/conitech/ita/risorse.asp?cod=CN402USB
> (ISSC W89C35 802.11bg WLAN USB Adapters (Native Wifi driver))

Thanks a lot. With some patches, I got driver from conitech.it to
compile and partly work on 2.6.23. I can now transmit packets but not
yet receive them.

(use Makefile.26 instead of Makefile)

								Pavel

--- hal_142_o.ofic/linux/sysdef.h	2006-11-29 11:12:10.000000000 +0100
+++ hal_142_o/linux/sysdef.h	2007-10-21 22:21:13.000000000 +0200
@@ -7,7 +7,7 @@
 // The definition WB_LINUX is a keyword for this OS
 //=============================================================================
 #define WB_LINUX
-#define WB_LINUX_WPA_PSK
+//#define WB_LINUX_WPA_PSK
 //#define _WPA_PSK_DEBUG
 
 //#define _IBSS_BEACON_SEQ_STICK_
Only in hal_142_o/linux: w35und.ko
Only in hal_142_o/linux: w35und.mod.c
--- hal_142_o.ofic/linux/wb35reg.c	2006-11-29 11:43:58.000000000 +0100
+++ hal_142_o/linux/wb35reg.c	2007-10-21 22:19:27.000000000 +0200
@@ -879,6 +879,7 @@
 	if( (pHwData->phy_type == RF_WB_242) ||
 		(pHwData->phy_type == RF_WB_242_1) ) // 20060619.5 Add
 	{
+		extern void phy_calibration_winbond(hw_data_t *phw_data, u32 frequency);
 		phy_calibration_winbond ( pHwData, 2412 ); // Sync operation
 		Wb35Reg_ReadSync( pHwData, 0x103c, &BB3c );
 		Wb35Reg_ReadSync( pHwData, 0x1054, &BB54 );
--- hal_142_o.ofic/linux/wbusb.c	2006-11-29 11:02:54.000000000 +0100
+++ hal_142_o/linux/wbusb.c	2007-10-21 22:16:19.000000000 +0200
@@ -28,7 +28,6 @@
 	};
 #else
 	static struct usb_driver wb35_driver = {
-			.owner =	THIS_MODULE,
 			.name =		"w35und",
 			.probe =	wb35_probe,
 			.disconnect = wb35_disconnect,
--- hal_142_o.ofic/wblinux.c	2006-11-29 10:39:54.000000000 +0100
+++ hal_142_o/wblinux.c	2007-10-21 23:49:07.000000000 +0200
@@ -98,7 +98,8 @@
 			BufSize = pRxLayer1->BufferQueue[i].BufferSize;
 			BufAddr = pRxLayer1->BufferQueue[i].pBufferAddress;
 			//DataDmp(BufAddr, BufSize, 0);
-	        eth_copy_and_sum( skb, BufAddr, BufSize, 0 );
+			//	        eth_io_copy_and_sum( skb, BufAddr, BufSize, 0 );
+		skb_copy_from_linear_data(skb, BufAddr, BufSize);
 	        skb_put( skb, BufSize );
 		}
 

I wonder if I got skb_copy right...?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
