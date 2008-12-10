Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbYLJVBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbYLJVBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 16:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbYLJVA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 16:00:56 -0500
Received: from relay3.sgi.com ([192.48.171.31]:58582 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754191AbYLJVA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 16:00:56 -0500
Date: Wed, 10 Dec 2008 15:00:53 -0600 (CST)
From: Brent Casavant <bcasavan@sgi.com>
Reply-To: Brent Casavant <bcasavan@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       mdr@sgi.com, rw@novell.com, greg@kroah.com
Subject: Re: [PATCH] ioc4: automatically load sgiioc4 subordinate module
In-Reply-To: <20081208154155.1a4dd7ae.akpm@linux-foundation.org>
Message-ID: <alpine.BSF.1.10.0812101458120.16859@pkunk.americas.sgi.com>
References: <alpine.BSF.1.10.0812051601060.388@pkunk.americas.sgi.com> <20081208145507.8d03834e.akpm@linux-foundation.org> <1228779363.5099.41.camel@nga> <20081208154155.1a4dd7ae.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (BSF 962 2008-03-14)
Organization: "Silicon Graphics, Inc."
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify ioc4 to always load the sgiioc4 IDE module if the board carrying
the IOC4 hardware actually implements the IDE interface (not all boards
bring this functionality off the IOC4 chip).  A drive hosted on the
IDE interface may contain the root filesystem, and sgiioc4 doesn't
load automatically as ioc4 owns the PCI device ID, not sgiioc4.

Signed-off-by: Michael Reed <mdr@sgi.com>
Signed-off-by: Brent Casavant <bcasavan@sgi.com>
---
Version 2: Add flush_scheduled_work() in ioc4_exit(), and add
explanatory comments.

 ioc4.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
index 6f76573..652629c 100644
--- a/drivers/misc/ioc4.c
+++ b/drivers/misc/ioc4.c
@@ -269,6 +269,16 @@ ioc4_variant(struct ioc4_driver_data *idd)
 	return IOC4_VARIANT_PCI_RT;
 }
 
+static void
+ioc4_load_modules(struct work_struct *work)
+{
+	/* arg just has to be freed */
+
+	request_module("sgiioc4");
+
+	kfree(work);
+}
+
 /* Adds a new instance of an IOC4 card */
 static int
 ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
@@ -378,6 +388,32 @@ ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 	}
 	mutex_unlock(&ioc4_mutex);
 
+	/* Request sgiioc4 IDE driver on boards that bring that functionality
+	 * off of IOC4.  The root filesystem may be hosted on a drive connected
+	 * to IOC4, so we need to make sure the sgiioc4 driver is loaded as it
+	 * won't be picked up by modprobes due to the ioc4 module owning the
+	 * PCI device.
+	 */
+	if (idd->idd_variant != IOC4_VARIANT_PCI_RT) {
+		struct work_struct *work;
+		work = kzalloc(sizeof(struct work_struct), GFP_KERNEL);
+		if (!work) {
+			printk(KERN_WARNING
+			       "%s: IOC4 unable to allocate memory for "
+			       "load of sub-modules.\n",
+			       __FUNCTION__);
+		}
+		else {
+			/* Request the module from a work procedure as the
+			 * modprobe goes out to a userland helper and that
+			 * will hang if done directly from ioc4_probe().
+			 */
+			printk(KERN_INFO "IOC4 loading sgiioc4 submodule\n");
+			INIT_WORK(work, ioc4_load_modules);
+			schedule_work(work);
+		}
+	}
+
 	return 0;
 
 out_misc_region:
@@ -462,6 +498,8 @@ ioc4_init(void)
 static void __devexit
 ioc4_exit(void)
 {
+	/* Ensure ioc4_load_modules() has completed before exiting */
+	flush_scheduled_work();
 	pci_unregister_driver(&ioc4_driver);
 }
 
-- 
Brent Casavant                          All music is folk music.  I ain't
bcasavan@sgi.com                        never heard a horse sing a song.
Silicon Graphics, Inc.                    -- Louis Armstrong
