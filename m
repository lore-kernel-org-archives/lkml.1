Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0CFLNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 06:13:18 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:35164 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab0CFLNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 06:13:16 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: commit 554f76962d3a6eb5110415f1591aca83f96a84ae hangs USB for vmware 7.0.1
Date: Sat, 6 Mar 2010 12:12:51 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Petr Vandrovec <petr@vmware.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Jeff Chua <jeff.tw.chua@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
References: <Pine.LNX.4.64.1003060606480.6040@boston.corp.fedex.com> <4B91FA42.8020400@vmware.com> <20100306093306.GA27247@core.coreip.homeip.net>
In-Reply-To: <20100306093306.GA27247@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003061212.51110.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 6. März 2010 10:33:07 schrieb Dmitry Torokhov:
> I did not have issues with bringing VMware GUI with
> 64096c17417380d8a472d096645f4cbc9406c987 as tip of Linus's tree (which
> is a believe the latest published), but got the following traces when
> yanked USB keyboard out:
> 
> [ 1784.954389] usb 5-1: USB disconnect, address 2
> [ 1784.954394] usb 5-1.3: USB disconnect, address 3
> [ 1920.558046] INFO: task khubd:27 blocked for more than 120 seconds.
> [ 1920.558051] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1920.558054] khubd         D 0000000000000202     0    27      2 0x00000000
> [ 1920.558060]  ffff88011ba29960 0000000000000046 ffff88000260eec0 ffff88011ba20000
> [ 1920.558067]  ffff88011ba28000 ffff88011ba29fd8 ffff88011ba29fd8 ffff88011ba20000
> [ 1920.558073]  ffff88011ba29fd8 0000000000013d80 0000000000013d80 0000000000013d80
> [ 1920.558079] Call Trace:
> [ 1920.558088]  [<ffffffff81478591>] __mutex_lock_common+0x1a1/0x4a0
> [ 1920.558094]  [<ffffffff8136f922>] ? usbfs_conn_disc_event+0x12/0x40
> [ 1920.558099]  [<ffffffff8107eb7d>] ? trace_hardirqs_on+0xd/0x10
> [ 1920.558103]  [<ffffffff8136f922>] ? usbfs_conn_disc_event+0x12/0x40
> [ 1920.558107]  [<ffffffff8147896e>] mutex_lock_nested+0x3e/0x50
> [ 1920.558111]  [<ffffffff8136f922>] usbfs_conn_disc_event+0x12/0x40
> [ 1920.558115]  [<ffffffff81371184>] usbfs_notify+0xa4/0x240

Thanks, seems like a lock is taken twice.
Dmitry, can you test this patch, too?

	Regards
		Oliver

>From e58722a5fc0c00bceaea1f70d5024f6325ac3a6c Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Sat, 6 Mar 2010 12:09:41 +0100
Subject: [PATCH] usb: usbfs: Fix deadlock of khubd

The caller of usbfs_conn_disc_event() already holds usbfs_mutex.
Don't take it again.

Signed-off-by: Oliver Neukum <neukum@b1-systems.de>
---
 drivers/usb/core/devices.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index c83c975..08def6b 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -155,11 +155,10 @@ static const struct class_info clas_info[] =
 
 /*****************************************************************/
 
+/* the caller holds usbfs_mutex */
 void usbfs_conn_disc_event(void)
 {
-	mutex_lock(&usbfs_mutex);
 	conndiscevcnt++;
-	mutex_unlock(&usbfs_mutex);
 	wake_up(&deviceconndiscwq);
 }
 
-- 
1.6.4.2

