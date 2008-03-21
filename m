Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYCUEUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYCUEUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 00:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYCUEUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 00:20:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45207 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbYCUEUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 00:20:09 -0400
Message-ID: <47E33671.1000107@jp.fujitsu.com>
Date: Fri, 21 Mar 2008 13:15:45 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>
CC: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH  8/16][BUG] PCI slot: Fix invalid memory access (Not for mainline!)
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com>
In-Reply-To: <47E33472.1000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix kernel oops in pci_release_slot() when dbg() is enabled.

The dbg() in pci_release_slot() cause a kernel oops (invalid memory
access) because it accesses slot after it is released. We need to
access slot before calling kobject_put().

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/slot.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.25-rc6/drivers/pci/slot.c
===================================================================
--- linux-2.6.25-rc6.orig/drivers/pci/slot.c
+++ linux-2.6.25-rc6/drivers/pci/slot.c
@@ -191,13 +191,14 @@ EXPORT_SYMBOL_GPL(pci_create_slot);
 
 int pci_destroy_slot(struct pci_slot *slot)
 {
+	dbg("%s: decreased refcount to %d on %x:%d\n", __func__,
+	    atomic_read(&slot->kobj.kref.refcount) - 1, slot->bus->number,
+	    slot->number);
+
 	down_write(&pci_bus_sem);
 	kobject_put(&slot->kobj);
 	up_write(&pci_bus_sem);
 
-	dbg("%s: decreased refcount to %d on %x:%d\n", __func__,
-	    atomic_read(&slot->kobj.kref.refcount), slot->bus->number,
-	    slot->number);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pci_destroy_slot);


