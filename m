Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbYFBTVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbYFBTVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYFBTVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:21:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49309 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbYFBTVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:21:18 -0400
Date: Mon, 2 Jun 2008 21:21:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       bersace03@laposte.net, johannes@sipsolutions.de
Subject: Re: [PATCH] Firmware loader driver for USB Apple iSight camera
Message-ID: <20080602192103.GA31589@elte.hu>
References: <20080520190628.GA14580@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520190628.GA14580@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Uninitialised Apple iSight drivers present with a distinctive USB ID. 
> Once firmware has been uploaded, they disconnect and reconnect with a 
> new ID. At this point they can be driven by the uvcvideo driver. As 
> this is unique to the Apple cameras and not functionality shared by 
> any other UVC devices, it makes sense to provide the firmware loading 
> functionality in a separate driver. This driver will read an isight.fw 
> file extracted from the Apple driver using the tools at 
> http://bersace03.free.fr/ift/ and upload it to the camera. It will 
> also handle the case where the device loses its firmware during 
> hibernation and must have it reloaded.

this caused a build failure - find the fix below. (fix can also be 
pulled/cherry-picked from -tip's tip/out-of-tree topic branch)

	Ingo

-------------------->
commit 1f910d33b2084d03267db20359472891f95b45b4
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jun 2 21:07:27 2008 +0200

    USB: fix build bug in USB_ISIGHTFW
    
    -tip tree testing found this build bug:
    
      drivers/built-in.o: In function `isight_firmware_load':
      isight_firmware.c:(.text+0x1ade08): undefined reference to `request_firmware'
      isight_firmware.c:(.text+0x1adf9c): undefined reference to `release_firmware'
    
    select FW_LOADER in USB_ISIGHTFW.

diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index eb6c069..001789c 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -272,6 +272,7 @@ config USB_TEST
 config USB_ISIGHTFW
 	tristate "iSight firmware loading support"
 	depends on USB
+	select FW_LOADER
 	help
 	  This driver loads firmware for USB Apple iSight cameras, allowing
 	  them to be driven by the USB video class driver available at
