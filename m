Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbZEIX7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbZEIX7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 19:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZEIX7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 19:59:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:49129 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbZEIX7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 19:59:15 -0400
Subject: Re: dma-debug: add a check dma memory leaks
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reinette.chatre@intel.com, benh@kernel.crashing.org, greg@kroah.com
In-Reply-To: <20090421092016.GH17438@amd.com>
References: <200903302101.n2UL1O1n011970@hera.kernel.org>
	 <1240005065.19059.19.camel@macbook.infradead.org>
	 <20090421092016.GH17438@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 May 2009 00:59:12 +0100
Message-Id: <1241913552.24436.113.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Add BUS_NOTIFY_UNBOUND_DRIVER callback after driver removal

This adds a notifier callback which happens _after_ the driver has been
unbound from the device, needed for things like the DMA debugging API
which want to check that all DMA mappings have been correctly torn down.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
On Tue, 2009-04-21 at 11:20 +0200, Joerg Roedel wrote:
> On Fri, Apr 17, 2009 at 10:51:05PM +0100, David Woodhouse wrote:
> > Hm, cute... but not quite functioning as you intended. If you look at
> > __device_release_driver() in drivers/base/dd.c you'll see it actually
> > calls the notifier _before_ calling into the driver's ->remove() method.
> > So it's hardly surprising that not everything has been freed yet...
> > 
> > Reported by Reinette when it bit iwlwifi.
> > 
> > Ben, can we get away with changing the order so that the ->remove() is
> > called before the notifier, in this case?
> 
> Ben? I would like to keep this check. If its not possible to move this
> one behind the drivers ->remove function it may be an option to add
> another notifier?

It doesn't look like it's possible to move the UNBIND callback. Let's
add an UNBOUND callback instead... I've tested this and it fixes the
false positives.

Jörg, should you be using UNBOUND instead of UNBIND in the amd_iommu
notifier callback too?

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 742cbe6..efd00de 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -320,6 +320,10 @@ static void __device_release_driver(struct device *dev)
 		devres_release_all(dev);
 		dev->driver = NULL;
 		klist_remove(&dev->p->knode_driver);
+		if (dev->bus)
+			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
+						     BUS_NOTIFY_UNBOUND_DRIVER,
+						     dev);
 	}
 }
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 6a69caa..4ded2ae 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -116,6 +116,7 @@ extern int bus_unregister_notifier(struct bus_type *bus,
 #define BUS_NOTIFY_BOUND_DRIVER		0x00000003 /* driver bound to device */
 #define BUS_NOTIFY_UNBIND_DRIVER	0x00000004 /* driver about to be
 						      unbound */
+#define BUS_NOTIFY_UNBOUND_DRIVER	0x00000005 /* driver has been unbound */
 
 extern struct kset *bus_get_kset(struct bus_type *bus);
 extern struct klist *bus_get_device_klist(struct bus_type *bus);


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

