Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbXBKMxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbXBKMxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 07:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932795AbXBKMxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 07:53:03 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:34398 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789AbXBKMxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 07:53:01 -0500
Date: Sun, 11 Feb 2007 13:54:23 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Paul Rolland <rol@witbe.net>, Andrew Morton <akpm@osdl.org>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       rol@as2917.net
Subject: [PATCH] keep track of network interface renaming
Message-ID: <20070211125423.GA30668@aepfle.de>
References: <011001c74dcf$c60c1c80$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <011001c74dcf$c60c1c80$2101a8c0@donald>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, Paul Rolland wrote:

> I'm facing something quite strange... When booting one of these kernels
> (it's a new machine, I've not been running older kernels), the boot message
> says :
> 
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 19 (level, low) -> IRQ 19
> sky2 v1.10 addr 0xff8fc000 irq 19 Yukon-EC (0xb6) rev 2
> sky2 eth0: addr 00:18:f3:e0:5d:d4
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> sky2 v1.10 addr 0xff7fc000 irq 16 Yukon-EC (0xb6) rev 2
> sky2 eth1: addr 00:18:f3:e0:36:fd
> 
> So, I'm expecting two interfaces : eth0 and eth1
> 
> Unfortunately, at the end of the boot process, I can find eth1 and eth2,

Unfortunately, this patch was not applied to mainline last year.
Maybe this year.


Keep track about which network interface names were renamed after the
network device driver printed its banner.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

--- linux-2.6.19.orig/net/core/dev.c
+++ linux-2.6.19/net/core/dev.c
@@ -749,7 +749,11 @@ int dev_change_name(struct net_device *d
 	else if (__dev_get_by_name(newname))
 		return -EEXIST;
 	else
+	{
+		if (strncmp(newname, dev->name, IFNAMSIZ))
+			printk(KERN_INFO "%s renamed to %s\n", dev->name, newname);
 		strlcpy(dev->name, newname, IFNAMSIZ);
+	}
 
 	err = class_device_rename(&dev->class_dev, dev->name);
 	if (!err) {
