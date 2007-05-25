Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbXEYDVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbXEYDVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 23:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXEYDVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 23:21:38 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33723 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbXEYDVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 23:21:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tom.l.nguyen@intel.com, iss_storagedev@hp.com, jens.axboe@oracle.com,
       Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] msi: mask the msix vector before we unmap it.
References: <20070524160756.GA14083@beardog.cca.cpqcorp.net>
	<20070524102702.bca37396.akpm@linux-foundation.org>
	<20070524200743.GB14083@beardog.cca.cpqcorp.net>
	<m1lkfedjuz.fsf@ebiederm.dsl.xmission.com>
	<20070524211112.GE14083@beardog.cca.cpqcorp.net>
Date: Thu, 24 May 2007 21:16:30 -0600
In-Reply-To: <20070524211112.GE14083@beardog.cca.cpqcorp.net> (Mike Miller's
	message of "Thu, 24 May 2007 16:11:12 -0500")
Message-ID: <m14pm1egoh.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


With these two lines in the reverse order the drives/block/ccis.c was
oopsing in msi_free_irqs.  Silly us calling writel on an area after
we unmap it.

BUG: unable to handle kernel paging request at virtual address f8b2200c
 printing eip:
c01e9cc7
*pdpt = 0000000000003001
*pde = 0000000037e48067
*pte = 0000000000000000
Oops: 0002 [#1]
SMP
Modules linked in: cciss ipv6 parport_pc lp parport autofs4 i2c_dev i2c_core
sunrpc loop dm_multipath button battery asus_acpi ac tg3 floppy sg dm_snapshot
dm_zero dm_mirror ext3 jbd dm_mod ata_piix libata mptsas scsi_transport_sas
mptspi scsi_transport_spi mptscsih mptbase sd_mod scsi_mod
CPU:    1
EIP:    0060:[<c01e9cc7>]    Not tainted VLI
EFLAGS: 00010286   (2.6.22-rc2-gd2579053 #1)
EIP is at msi_free_irqs+0x81/0xbe
eax: f8b22000   ebx: f71f3180   ecx: f7fff280   edx: c1886eb8
esi: f7c4e800   edi: f7c4ec48   ebp: 00000002   esp: f5a0dec8
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process rmmod (pid: 5286, ti=f5a0d000 task=c47d2550 task.ti=f5a0d000)
Stack: 00000002 f8b72294 00000400 f8b69ca7 f8b6bc6c 00000002 00000000 00000000
       00000000 00000000 00000000 f5a997f4 f8b69d61 f7c5a4b0 f7c4e848 f7c4e848
       f7c4e800 f7c4e800 f8b72294 f7c4e848 f8b72294 c01e3cdf f7c4e848 c024c469
Call Trace:
 [<f8b69ca7>] cciss_shutdown+0xae/0xc3 [cciss]
 [<f8b69d61>] cciss_remove_one+0xa5/0x178 [cciss]
 [<c01e3cdf>] pci_device_remove+0x16/0x35
 [<c024c469>] __device_release_driver+0x71/0x8e
 [<c024c56e>] driver_detach+0xa0/0xde
 [<c024bc5c>] bus_remove_driver+0x27/0x41
 [<c01e3ef3>] pci_unregister_driver+0xb/0x13
 [<f8b6a343>] cciss_cleanup+0xf/0x51 [cciss]
 [<c0139ced>] sys_delete_module+0x110/0x135
 [<c0104c7a>] sysenter_past_esp+0x5f/0x85

Here's a patch that just reverses the 2 lines of code as Eric suggests. Please
consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Chase Maupin <chase.maupin@hp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index e01380b..6632150 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -558,12 +558,12 @@ static int msi_free_irqs(struct pci_dev* dev)
 
 	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
 		if (entry->msi_attrib.type == PCI_CAP_ID_MSIX) {
-			if (list_is_last(&entry->list, &dev->msi_list))
-				iounmap(entry->mask_base);
-
 			writel(1, entry->mask_base + entry->msi_attrib.entry_nr
 				  * PCI_MSIX_ENTRY_SIZE
 				  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
+
+			if (list_is_last(&entry->list, &dev->msi_list))
+				iounmap(entry->mask_base);
 		}
 		list_del(&entry->list);
 		kfree(entry);
