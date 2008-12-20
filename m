Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYLTKz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYLTKz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 05:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYLTKzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 05:55:19 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:47745 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbYLTKzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 05:55:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=f9bIbxdXGhiI+O5oRcGkIrqGtkPefEQ8dgYzL2wtE1792gAIl9EqzD4A47L0Rux8gG
         M9qwNGnXZ8d+Zu42s8hR2K7nSygQ8Q+SithSx4npN0UNDLEyARaYMHviGY6UG85O6P71
         L8xLggvgxD5fEucZ7osBqlrte+Q7ipjgdJWOs=
Date: Sat, 20 Dec 2008 11:56:58 +0100
To: Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] pci: fix no_pci_devices()
Message-ID: <20081220105658.GA1760@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081220085851.GA25095@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 9:58 AM, Greg KH <gregkh@suse.de> wrote:
> Care to make a patch for no_pci_devices() to work properly in this kind
> of situation?

How does this look?

I have introduced a variable pci_is_initiated, which is set after the bus
has been registered.

Should the variable be atomic? My assumption is that initcalls are
synchronous and that the variable therefore cannot be accessed concurrently
by two or more CPUs.


Vegard


>From 409132338c9a6122dc7da08d2764492dbf351f32 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sat, 20 Dec 2008 11:37:16 +0100
Subject: [PATCH] pci: fix no_pci_devices()

In short, no_pci_devices() should not use bus_find_device() before
initcalls have run, because the pci bus structure has not been
initialized yet.

Reference: http://lkml.org/lkml/2008/12/20/21

Cc: Greg KH <gregkh@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 drivers/pci/pci-driver.c |   10 +++++++++-
 drivers/pci/probe.c      |    3 +++
 include/linux/pci.h      |    1 +
 3 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index b4cdd69..9e0215e 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -825,6 +825,8 @@ int pci_uevent(struct device *dev, struct kobj_uevent_env *env)
 }
 #endif
 
+int pci_is_initiated __read_mostly;
+
 struct bus_type pci_bus_type = {
 	.name		= "pci",
 	.match		= pci_bus_match,
@@ -838,7 +840,13 @@ struct bus_type pci_bus_type = {
 
 static int __init pci_driver_init(void)
 {
-	return bus_register(&pci_bus_type);
+	int ret;
+
+	ret = bus_register(&pci_bus_type);
+	if (ret == 0)
+		pci_is_initiated = 1;
+
+	return ret;
 }
 
 postcore_initcall(pci_driver_init);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 003a9b3..1320a81 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -35,6 +35,9 @@ int no_pci_devices(void)
 	struct device *dev;
 	int no_devices;
 
+	if (!pci_is_initiated)
+		return 1;
+
 	dev = bus_find_device(&pci_bus_type, NULL, NULL, find_anything);
 	no_devices = (dev == NULL);
 	put_device(dev);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index feb4657..9e1b30f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -484,6 +484,7 @@ extern struct bus_type pci_bus_type;
  * code, or pci core code. */
 extern struct list_head pci_root_buses;	/* list of all known PCI buses */
 /* Some device drivers need know if pci is initiated */
+extern int pci_is_initiated;
 extern int no_pci_devices(void);
 
 void pcibios_fixup_bus(struct pci_bus *);
-- 
1.5.6.5

