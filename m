Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbZDRWIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbZDRWIj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 18:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbZDRWI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 18:08:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:49258 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbZDRWI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 18:08:29 -0400
Message-ID: <49EA4EB9.2030307@kernel.org>
Date: Sat, 18 Apr 2009 15:05:45 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] driver: dont update dev_name via device_add path
References: <20090416235452.GE21405@elte.hu> <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain> <20090417131633.GA30578@elte.hu> <49E8FD0B.2050308@zytor.com> <49E96731.1000501@kernel.org> <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain> <49EA27B9.3030004@kernel.org> <20090418192314.GA22107@suse.de> <ac3eb2510904181300v2593c36dua6c2420828860706@mail.gmail.com> <1240086446.2411.9.camel@poy> <20090418203718.GD30144@elte.hu>
In-Reply-To: <20090418203718.GD30144@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

notice one system /proc/iomem some entries missed the name for pci_devices

it turns that dev->dev.kobj name is changed after device_add.

for pci code:
via acpi_pci_root_driver.ops.add (aka acpi_pci_root_add) ==> pci_acpi_scan_root
is used to scan pci bus/device, and at the same time we read the resource for pci_dev
in the pci_read_bases, we have res->name = pci_name(pci_dev); pci_name is calling dev_name.

later via acpi_pci_root_driver.ops.start (aka acpi_pci_root_start) ==> pci_bus_add_device to
add all pci_dev in kobj tree.
pci_bus_add_device will call device_add.

actually in device_add

        /* first, register with generic layer. */
        error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev_name(dev));
        if (error)
                goto Error;

will get one new name for that kobj, old name is freed.

[Impact: fix corrupted names in /proc/iomem ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/base/core.c |    3 ++-
 lib/kobject.c       |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -891,7 +891,8 @@ int device_add(struct device *dev)
 		set_dev_node(dev, dev_to_node(parent));
 
 	/* first, register with generic layer. */
-	error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev_name(dev));
+	/* we require the name to be set before, and pass NULL */
+	error = kobject_add(&dev->kobj, dev->kobj.parent, NULL);
 	if (error)
 		goto Error;
 
Index: linux-2.6/lib/kobject.c
===================================================================
--- linux-2.6.orig/lib/kobject.c
+++ linux-2.6/lib/kobject.c
@@ -218,6 +218,9 @@ int kobject_set_name_vargs(struct kobjec
 	const char *old_name = kobj->name;
 	char *s;
 
+	if (kobj->name && !fmt)
+		return 0;
+
 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
 	if (!kobj->name)
 		return -ENOMEM;
