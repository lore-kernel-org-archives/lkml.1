Return-Path: <linux-kernel-owner+w=401wt.eu-S1763484AbYHFA5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763484AbYHFA5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 20:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762738AbYHFA50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 20:57:26 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:43346 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762659AbYHFA5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 20:57:23 -0400
Date: Wed, 6 Aug 2008 10:57:21 +1000
From: Simon Horman <horms@verge.net.au>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [patch] PCI: check the return value of
	device_create_bin_file() in pci_create_bus()
Message-ID: <20080806005718.GE32143@verge.net.au>
References: <20080805101605.GA19382@verge.net.au> <1217932416.7758.4.camel@localhost> <20080805101605.GA19382@verge.net.au> <alpine.LNX.1.10.0808051224350.5671@titan.stealer.net> <20080805110006.GA13409@verge.net.au> <20080805111406.GA13899@verge.net.au> <20080805112814.GO26461@parisc-linux.org> <20080805121531.GA29763@verge.net.au> <20080805122639.GP26461@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805122639.GP26461@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the return value of device_create_bin_file in pci_create_bus and
unwind if necessary. Don't propagate error to caller, as failure to create
these files shouldn't prevent PCI from being initialised.

Cc: Sven Wegener <sven.wegener@stealer.net>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Simon Horman <horms@verge.net.au>

--- 

Tue, 5 Aug 2008 21:14:07 +1000
* Revised the patch to free and NULLify b->legacy_io in
  pci_create_legacy_files() on error. Thanks to
  Sven Wegener and Michael Ellerman for pointing out this omission.

Wed, 06 Aug 2008 10:49:30 +1000
* Don't propagate error to caller, as failure to create these files
  shouldn't prevent PCI from being initialised.
  Thanks to Matthew Wilcox

This patch resolves the following warnings:

drivers/pci/probe.c: In function `pci_create_bus':
drivers/pci/probe.c:66: warning: ignoring return value of `device_create_bin_file', declared with attribute warn_unused_result
drivers/pci/probe.c:74: warning: ignoring return value of `device_create_bin_file', declared with attribute warn_unused_result

# ia64-unknown-linux-gnu-gcc --version
ia64-unknown-linux-gnu-gcc (GCC) 3.4.5
Copyright (C) 2004 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c	2008-08-06 09:22:06.000000000 +1000
+++ linux-2.6/drivers/pci/probe.c	2008-08-06 09:41:09.000000000 +1000
@@ -52,27 +52,46 @@ EXPORT_SYMBOL(no_pci_devices);
  * Some platforms allow access to legacy I/O port and ISA memory space on
  * a per-bus basis.  This routine creates the files and ties them into
  * their associated read, write and mmap files from pci-sysfs.c
+ *
+ * On error unwind, but don't propogate the error to the caller
+ * as it is ok to set up the PCI bus without these files.
  */
 static void pci_create_legacy_files(struct pci_bus *b)
 {
+	int error;
+
 	b->legacy_io = kzalloc(sizeof(struct bin_attribute) * 2,
 			       GFP_ATOMIC);
-	if (b->legacy_io) {
-		b->legacy_io->attr.name = "legacy_io";
-		b->legacy_io->size = 0xffff;
-		b->legacy_io->attr.mode = S_IRUSR | S_IWUSR;
-		b->legacy_io->read = pci_read_legacy_io;
-		b->legacy_io->write = pci_write_legacy_io;
-		device_create_bin_file(&b->dev, b->legacy_io);
-
-		/* Allocated above after the legacy_io struct */
-		b->legacy_mem = b->legacy_io + 1;
-		b->legacy_mem->attr.name = "legacy_mem";
-		b->legacy_mem->size = 1024*1024;
-		b->legacy_mem->attr.mode = S_IRUSR | S_IWUSR;
-		b->legacy_mem->mmap = pci_mmap_legacy_mem;
-		device_create_bin_file(&b->dev, b->legacy_mem);
-	}
+	if (!b->legacy_io)
+		return;
+
+	b->legacy_io->attr.name = "legacy_io";
+	b->legacy_io->size = 0xffff;
+	b->legacy_io->attr.mode = S_IRUSR | S_IWUSR;
+	b->legacy_io->read = pci_read_legacy_io;
+	b->legacy_io->write = pci_write_legacy_io;
+	error = device_create_bin_file(&b->dev, b->legacy_io);
+	if (error)
+		goto legacy_io_err;
+
+	/* Allocated above after the legacy_io struct */
+	b->legacy_mem = b->legacy_io + 1;
+	b->legacy_mem->attr.name = "legacy_mem";
+	b->legacy_mem->size = 1024*1024;
+	b->legacy_mem->attr.mode = S_IRUSR | S_IWUSR;
+	b->legacy_mem->mmap = pci_mmap_legacy_mem;
+	error = device_create_bin_file(&b->dev, b->legacy_mem);
+	if (error)
+		goto legacy_mem_err;
+
+	return 0;
+
+legacy_mem_err:
+	device_remove_bin_file(&b->dev, b->legacy_io);
+legacy_io_err:
+	kfree(b->legacy_io);
+	b->legacy_io = NULL;
+	return;
 }
 
 void pci_remove_legacy_files(struct pci_bus *b)
