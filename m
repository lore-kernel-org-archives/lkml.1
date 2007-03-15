Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbXCOHxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbXCOHxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 03:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbXCOHxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 03:53:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:57914 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751551AbXCOHxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 03:53:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19xM51Z0cFxuygQef9iOP29it7QXsn/Q3eMmpyBiN
	9Pf2jdOmwVDwEK
Subject: Re: kref refcounting breakage in mainline
From: Mike Galbraith <efault@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20070315052724.GA12576@kroah.com>
References: <20070302005833.949be737.akpm@linux-foundation.org>
	 <20070306002521.GA12164@kroah.com>
	 <1173159802.6955.6.camel@Homer.simpson.net>
	 <20070306210445.GB29164@kroah.com>
	 <1173245937.6613.26.camel@Homer.simpson.net>
	 <1173541446.6561.32.camel@Homer.simpson.net>
	 <20070315052724.GA12576@kroah.com>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 08:53:07 +0100
Message-Id: <1173945187.6624.14.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 22:27 -0700, Greg KH wrote:

> But can you try this version instead?

It exploded in strcmp().  Unfortunately, the full oops didn't make it to
either console or serial console.

[   30.783048] ipmi message handler version 39.1
[   30.787632] ipmi device interface
[   30.791166] IPMI System Interface driver.
[   30.816961] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[   30.832700]  printing eip:
[   30.842383] c02d4098
[   30.851458] *pde = 00000000
[   30.861089] Oops: 0000 [#1]
[   30.870585] PREEMPT SMP 
[   30.879724] Modules linked in:
[   30.889288] CPU:    1
[   30.889290] EIP:    0060:[<c02d4098>]    Not tainted VLI
[   30.889292] EFLAGS: 00010282   (2.6.21-rc3-smp #81)


I did this...

--- kernel/module.c.org	2007-03-15 07:20:15.000000000 +0100
+++ kernel/module.c	2007-03-15 08:13:36.000000000 +0100
@@ -2419,15 +2419,19 @@ void module_remove_driver(struct device_
 
 	if (drv->owner && drv->owner->mkobj.drivers_dir)
 		mk = &drv->owner->mkobj;
-	else {
+	else if (drv->mod_name) {
 		/* Lookup built-in module entry in /sys/modules */
 		mkobj = kset_find_obj(&module_subsys.kset, drv->mod_name);
 		if (!mkobj)
-			return;
+			goto out_free;
 		mk = container_of(mkobj, struct module_kobject, kobj);
+	} else {
+		WARN_ON(1);
+		goto out_free;
 	}
 	sysfs_remove_link(mk->drivers_dir, driver_name);
 	kobject_put(mkobj);
+out_free:
 	kfree(driver_name);
 }
 EXPORT_SYMBOL(module_remove_driver);

...and it booted.

[   24.670410] ipmi message handler version 39.1
[   24.675000] ipmi device interface
[   24.678542] IPMI System Interface driver.
[   24.703956] BUG: at kernel/module.c:2429 module_remove_driver()
[   24.716837]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
[   24.728909]  [<c01057b2>] show_trace+0x12/0x14
[   24.740239]  [<c0105856>] dump_stack+0x16/0x18
[   24.751469]  [<c01441ce>] module_remove_driver+0xa5/0xa7
[   24.763584]  [<c035a014>] bus_remove_driver+0x6d/0x82
[   24.775390]  [<c035a978>] driver_unregister+0xb/0x18
[   24.787019]  [<c034c8c2>] init_ipmi_si+0x7a9/0x7c1
[   24.798450]  [<c06705bc>] init+0x144/0x26c
[   24.809129]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
[   24.820916]  =======================
[   24.830926] ipmi_si: Unable to find any System Interface(s)
[   24.842952] IPMI Watchdog: driver initialized
  24.853749] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.

	-Mike

