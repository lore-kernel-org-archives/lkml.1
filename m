Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbYHELOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbYHELOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbYHELOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:14:10 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:55232 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbYHELOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:14:09 -0400
Date: Tue, 5 Aug 2008 21:14:07 +1000
From: Simon Horman <horms@verge.net.au>
To: Sven Wegener <sven.wegener@stealer.net>,
       Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [patch] PCI: check the return value of
	device_create_bin_file() in pci_create_bus()
Message-ID: <20080805111406.GA13899@verge.net.au>
References: <20080805101605.GA19382@verge.net.au> <1217932416.7758.4.camel@localhost> <20080805101605.GA19382@verge.net.au> <alpine.LNX.1.10.0808051224350.5671@titan.stealer.net> <20080805110006.GA13409@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805110006.GA13409@verge.net.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the return value of device_create_bin_file in pci_create_bus,
unwind if necessary, and propagate any errors to the caller.

Cc: Sven Wegener <sven.wegener@stealer.net>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Simon Horman <horms@verge.net.au>

--- 

Revised the patch to free and NULLify b->legacy_io in
pci_create_legacy_files() on error. Thanks to
Sven Wegener and Michael Ellerman for pointing out this omission.

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
--- linux-2.6.orig/drivers/pci/probe.c	2008-08-05 20:50:10.000000000 +1000
+++ linux-2.6/drivers/pci/probe.c	2008-08-05 21:08:27.000000000 +1000
@@ -53,26 +53,42 @@ EXPORT_SYMBOL(no_pci_devices);
  * a per-bus basis.  This routine creates the files and ties them into
  * their associated read, write and mmap files from pci-sysfs.c
  */
-static void pci_create_legacy_files(struct pci_bus *b)
+static int pci_create_legacy_files(struct pci_bus *b)
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
+		return -ENOMEM;
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
+	return error;
 }
 
 void pci_remove_legacy_files(struct pci_bus *b)
@@ -84,7 +100,7 @@ void pci_remove_legacy_files(struct pci_
 	}
 }
 #else /* !HAVE_PCI_LEGACY */
-static inline void pci_create_legacy_files(struct pci_bus *bus) { return; }
+static inline int pci_create_legacy_files(struct pci_bus *bus) { return 0; }
 void pci_remove_legacy_files(struct pci_bus *bus) { return; }
 #endif /* HAVE_PCI_LEGACY */
 
@@ -1157,7 +1173,9 @@ struct pci_bus * pci_create_bus(struct d
 		goto dev_create_file_err;
 
 	/* Create legacy_io and legacy_mem files for this bus */
-	pci_create_legacy_files(b);
+	error = pci_create_legacy_files(b);
+	if (error)
+		goto pci_create_legacy_files_err;
 
 	b->number = b->secondary = bus;
 	b->resource[0] = &ioport_resource;
@@ -1167,6 +1185,8 @@ struct pci_bus * pci_create_bus(struct d
 
 	return b;
 
+pci_create_legacy_files_err:
+	device_remove_file(&b->dev, &dev_attr_cpuaffinity);
 dev_create_file_err:
 	device_unregister(&b->dev);
 class_dev_reg_err:
