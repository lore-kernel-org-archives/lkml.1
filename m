Return-Path: <linux-kernel-owner+w=401wt.eu-S1946249AbXBCC4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946249AbXBCC4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946244AbXBCCgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:36:18 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52705 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946246AbXBCCgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:36:00 -0500
Message-Id: <20070203024013.737331000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:21 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Drake <dsd@gentoo.org>, ard@telegraafnet.nl,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: [patch 17/59] PCI: prevent down_read when pci_devices is empty
Content-Disposition: inline; filename=pci-prevent-down_read-when-pci_devices-is-empty.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Ard van Breemen <ard@telegraafnet.nl>

The pci_find_subsys gets called very early by obsolete ide setup parameters.
This is a bogus call since pci is not initialized yet, so the list is empty.
But in the mean time, interrupts get enabled by down_read.  This can result in
a kernel panic when the irq controller gets initialized.

This patch checks if the device list is empty before taking the semaphore, and
hence will not enable irq's.  Furthermore it will inform that it is called
while pci_devices is empty as a reminder that the ide code needs to be fixed.

The pci_get_subsys can get called in the same manner, and as such is patched
in the same manner.

[akpm@osdl.org: cleanups]
Signed-off-by: Ard van Breemen <ard@telegraafnet.nl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
This is the other half of the fix for bug #7505

 drivers/pci/search.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- linux-2.6.19.2.orig/drivers/pci/search.c
+++ linux-2.6.19.2/drivers/pci/search.c
@@ -193,6 +193,18 @@ static struct pci_dev * pci_find_subsys(
 	struct pci_dev *dev;
 
 	WARN_ON(in_interrupt());
+
+	/*
+	 * pci_find_subsys() can be called on the ide_setup() path, super-early
+	 * in boot.  But the down_read() will enable local interrupts, which
+	 * can cause some machines to crash.  So here we detect and flag that
+	 * situation and bail out early.
+	 */
+	if (unlikely(list_empty(&pci_devices))) {
+		printk(KERN_INFO "pci_find_subsys() called while pci_devices "
+				"is still empty\n");
+		return NULL;
+	}
 	down_read(&pci_bus_sem);
 	n = from ? from->global_list.next : pci_devices.next;
 
@@ -259,6 +271,18 @@ pci_get_subsys(unsigned int vendor, unsi
 	struct pci_dev *dev;
 
 	WARN_ON(in_interrupt());
+
+	/*
+	 * pci_get_subsys() can potentially be called by drivers super-early
+	 * in boot.  But the down_read() will enable local interrupts, which
+	 * can cause some machines to crash.  So here we detect and flag that
+	 * situation and bail out early.
+	 */
+	if (unlikely(list_empty(&pci_devices))) {
+		printk(KERN_NOTICE "pci_get_subsys() called while pci_devices "
+				"is still empty\n");
+		return NULL;
+	}
 	down_read(&pci_bus_sem);
 	n = from ? from->global_list.next : pci_devices.next;
 

--
