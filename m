Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbXEMMp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbXEMMp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 08:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbXEMMo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 08:44:58 -0400
Received: from neon.samage.net ([85.17.153.66]:41571 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757364AbXEMMo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 08:44:57 -0400
Message-ID: <2221.81.207.0.53.1179060294.squirrel@secure.samage.net>
In-Reply-To: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
Date: Sun, 13 May 2007 14:44:54 +0200 (CEST)
Subject: Re: Linux 2.6.22-rc1
From: "Indan Zupancic" <indan@nul.nu>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 40b81d93390a3dca3ee709c9c36a2335
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When compiling 2.6.22-rc1 I get the following (new and interesting) warnings:

GEN     /home/indan/src/git/obj/Makefile
scripts/kconfig/conf -s arch/i386/Kconfig
drivers/macintosh/Kconfig:116:warning:
'select' used by config symbol 'PMAC_APM_EMU'
refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
drivers/net/Kconfig:2283:warning:
'select' used by config symbol 'UCC_GETH'
refers to undefined symbol 'UCC_FAST'
drivers/input/keyboard/Kconfig:170:warning:
'select' used by config symbol 'KEYBOARD_ATARI'
refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:181:warning:
'select' used by config symbol 'MOUSE_ATARI'
refers to undefined symbol 'ATARI_KBD_CORE'

And:

/home/indan/src/git/linux-2.6/drivers/base/dd.c:211:
warning: 'device_probe_drivers' defined but not used

No idea how the first warnings can show up at all when I've selected nothing
related to them, nor who to CC for it.

Added Greg to the CC list for the second warning. device_probe_drivers() is
a static function, so it seems safe to remove.

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 92428e5..b0088b0 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -207,19 +207,6 @@ static int __device_attach(struct device_driver * drv, void * data)
 	return driver_probe_device(drv, dev);
 }

-static int device_probe_drivers(void *data)
-{
-	struct device *dev = data;
-	int ret = 0;
-
-	if (dev->bus) {
-		down(&dev->sem);
-		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
-		up(&dev->sem);
-	}
-	return ret;
-}
-
 /**
  *	device_attach - try to attach device to a driver.
  *	@dev:	device.


