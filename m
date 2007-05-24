Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbXEXUH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbXEXUH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXEXUHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:07:49 -0400
Received: from palrel10.hp.com ([156.153.255.245]:44138 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbXEXUHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:07:48 -0400
Date: Thu, 24 May 2007 15:07:43 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tom.l.nguyen@intel.com,
       iss_storagedev@hp.com, jens.axboe@oracle.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Ellerman <michael@ellerman.id.au>
Subject: Re: msi_free_irqs #2
Message-ID: <20070524200743.GB14083@beardog.cca.cpqcorp.net>
References: <20070524160756.GA14083@beardog.cca.cpqcorp.net> <20070524102702.bca37396.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524102702.bca37396.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 10:27:02AM -0700, Andrew Morton wrote:
> On Thu, 24 May 2007 11:07:56 -0500
> "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> 
> > So I guess I found the answer to my own question. msi_free_irqs was apparently added
> > in 2.6.22-something. I don't find it in 2.6.21.2 or anywhere else. So somebody broke a
> > couple of things.
> > The most noticable is cciss hangs after turning on interrupts. The reason for that is
> > the kernel now looks at my array of MSI-X vectors in reverse order. We have 4 ways of
> > generating an interrupt on Smart Array hw. They are:
> > 
> > #       define DOORBELL_INT     0
> > #       define PERF_MODE_INT    1
> > #       define SIMPLE_MODE_INT  2
> > #       define MEMQ_MODE_INT    3
> > 

I apologize for the vagueness of the message. This dirty hack makes cciss work in the
.22-rc kernel. I have not yet figured out what broke.

-----------------------------------------------------------------------------------------
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 5acc6c4..7383483 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3494,7 +3494,7 @@ static void cciss_shutdown(struct pci_dev *pdev)
 	} else {
 		printk(KERN_WARNING "Error flushing cache on controller %d\n", i);
 	}
-	free_irq(hba[i]->intr[2], hba[i]);
+	free_irq(hba[i]->intr[SIMPLE_MODE_INT], hba[i]);
 }
 
 static void __devexit cciss_remove_one(struct pci_dev *pdev)
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index b70988d..26b5866 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -70,8 +70,8 @@ struct ctlr_info
 	int 	highest_lun;
 	int	usage_count;  /* number of opens all all minor devices */
 #	define DOORBELL_INT	0
-#	define PERF_MODE_INT	1
-#	define SIMPLE_MODE_INT	2
+#	define PERF_MODE_INT	2
+#	define SIMPLE_MODE_INT	1
 #	define MEMQ_MODE_INT	3
 	unsigned int intr[4];
 	unsigned int msix_vector;
-----------------------------------------------------------------------------------------

> > For INTx these four lines are OR'ed together and run to one interrupt pin. MSI-X
> > breaks this hardware OR'ing so we must register either all 4 or at the least the
> > correct interrupt. When I first submitted the MSI/X support I was registering all 4.
> > Someone changed that to only register a single MSI-X vector. That worked fine until
> > 2.6.22-something. 
> > Now it appears that the kernel is looking at the array in reverse order. IOW, I must
> > register PERF_MODE_INT in order for cciss to work. That's messed up. Anybody want to

Have not yet found the change that caused this but my nasty little hack gets around it
for my testing. After I return from the long weekend I'll try to hunt this down.


> > `fess up to making these changes? :)
> > I'll keep working this, but I'm going to undo someones change when I figure out where
> > it's broke.
> > 
> 
> I'd guess that you're referring to Michael's changes.  If you can identify
> the offending code in a less vague fashion, more confident answers can
> be given ;)
> 
> I canot find any sign of anyone altering the IRQ handling in cciss.c after
> your initial MSI-support merge.  But that's perhaps isn't what you meant.
> it's all rather foggy.  Please either quote file-n-line, or grab a copy
> of git-blame.

Now for my original mail where the driver Oops'ed on rmmod. This patch prevents the
Oops but I'm not 100% sure it's right. Here's the Oops:


Completed flushing cache on controller 2
BUG: unable to handle kernel paging request at virtual address f8b2200c
 printing eip:
c01e9cc7
*pdpt = 0000000000003001
*pde = 0000000037e48067
*pte = 0000000000000000
Oops: 0002 [#1]
SMP
Modules linked in: cciss ipv6 parport_pc lp parport autofs4 i2c_dev i2c_core sunrpc loop dm_multipath button battery asus_acpi ac tg3 floppy sg dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod ata_piix libata mptsas scsi_transport_sas mptspi scsi_transport_spi mptscsih mptbase sd_mod scsi_mod
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
 =======================
Code: 00 39 c2 74 5d 0f b6 03 24 1f 3c 11 75 24 8d 86 54 04 00 00 39 43 0c 75 08 8b 43 14 e8 32 df f2 ff 0f b7 43 02 c1 e0 04 03 43 14 <c7> 40 0c 01 00 00 00 8d 4b 0c 8b 43 0c 8b 51 04 89 50 04 89 02
EIP: [<c01e9cc7>] msi_free_irqs+0x81/0xbe SS:ESP 0068:f5a0dec8
BUG: sleeping function called from invalid context at kernel/rwsem.c:20
in_atomic():0, irqs_disabled():1
 [<c011d16a>] __might_sleep+0xa7/0xad
 [<c013239a>] down_read+0x12/0x25
 [<c013db2f>] acct_collect+0x32/0x128
 [<c0121dc4>] do_exit+0x198/0x37e
 [<c0105f7b>] die+0x1da/0x1e2
 [<c03123ad>] do_page_fault+0x5b9/0x69c
 [<c01127b6>] smp_call_function+0x1a/0x1d
 [<c0311df4>] do_page_fault+0x0/0x69c
 [<c0310b1a>] error_code+0x72/0x78
 [<c011007b>] single_msr_reserve+0xf/0x3b
 [<c01e9cc7>] msi_free_irqs+0x81/0xbe
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
 =======================


Michael or Eric, would you please review this patch and see if it's OK? Adding an else
between the the if (list_is....) and the writel resolved the Oops. I'm not sure how this 
is supposed to work but using entry->mask_base after iounmap'ing seems wrong.


diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d9cbd58..0e67723 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -560,10 +560,11 @@ static int msi_free_irqs(struct pci_dev* dev)
 		if (entry->msi_attrib.type == PCI_CAP_ID_MSIX) {
 			if (list_is_last(&entry->list, &dev->msi_list))
 				iounmap(entry->mask_base);
-
-			writel(1, entry->mask_base + entry->msi_attrib.entry_nr
-				  * PCI_MSIX_ENTRY_SIZE
-				  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
+			else
+				writel(1, entry->mask_base
+					+ entry->msi_attrib.entry_nr
+					* PCI_MSIX_ENTRY_SIZE
+					+ PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
 		}
 		list_del(&entry->list);
 		kfree(entry);
-----------------------------------------------------------------------------------------

I hope this clears up a little of the fog.

Thanks,
mikem

