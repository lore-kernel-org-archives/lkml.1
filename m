Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbXEXU7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbXEXU7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXEXU7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:59:07 -0400
Received: from palrel13.hp.com ([156.153.255.238]:34554 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbXEXU7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:59:05 -0400
Date: Thu, 24 May 2007 15:59:00 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tom.l.nguyen@intel.com, iss_storagedev@hp.com, jens.axboe@oracle.com,
       Michael Ellerman <michael@ellerman.id.au>
Subject: Re: msi_free_irqs #2
Message-ID: <20070524205900.GC14083@beardog.cca.cpqcorp.net>
References: <20070524160756.GA14083@beardog.cca.cpqcorp.net> <20070524102702.bca37396.akpm@linux-foundation.org> <m1r6p6dn3x.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r6p6dn3x.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 01:42:58PM -0600, Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Thu, 24 May 2007 11:07:56 -0500
> > "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> >
> >> So I guess I found the answer to my own question. msi_free_irqs was apparently
> > added
> >> in 2.6.22-something. I don't find it in 2.6.21.2 or anywhere else. So somebody
> > broke a
> >> couple of things.
> >> The most noticable is cciss hangs after turning on interrupts. The reason for
> > that is
> >> the kernel now looks at my array of MSI-X vectors in reverse order. We have 4
> > ways of
> >> generating an interrupt on Smart Array hw. They are:
> >> 
> >> #       define DOORBELL_INT     0
> >> #       define PERF_MODE_INT    1
> >> #       define SIMPLE_MODE_INT  2
> >> #       define MEMQ_MODE_INT    3
> >> 
> >> For INTx these four lines are OR'ed together and run to one interrupt
> > pin. MSI-X
> >> breaks this hardware OR'ing so we must register either all 4 or at the least
> > the
> >> correct interrupt. When I first submitted the MSI/X support I was registering
> > all 4.
> >> Someone changed that to only register a single MSI-X vector. That worked fine
> > until
> >> 2.6.22-something. 
> >> Now it appears that the kernel is looking at the array in reverse order. IOW,
> > I must
> >> register PERF_MODE_INT in order for cciss to work. That's messed up. Anybody
> > want to
> >> `fess up to making these changes? :)
> >> I'll keep working this, but I'm going to undo someones change when I figure
> > out where
> >> it's broke.
> >> 
> >
> > I'd guess that you're referring to Michael's changes.  If you can identify
> > the offending code in a less vague fashion, more confident answers can
> > be given ;)
> >
> > I canot find any sign of anyone altering the IRQ handling in cciss.c after
> > your initial MSI-support merge.  But that's perhaps isn't what you meant.
> > it's all rather foggy.  Please either quote file-n-line, or grab a copy
> > of git-blame.
> 
> Or perhaps git-bisect to find the offending patch.
> 
> I don't recall seeing anything that looked to bad but there was a fair
> amount of change needed to get the last bit of portability into the msi
> code, so it is possible something slipped through.
> 
> Possibly someone changed the default enable or disable state?
> 
> ....
> 
> Which reminds me.  Now that we have a reasonable list, we really need
> to reduce pci_enable_msix:
> 
> - int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec);
> + int pci_enable_msix(struct pci_dev* dev, int nvec);
> 
> And just have drivers that use more the one irq walk the list off of pci_dev
> of all of the msi irqs.  I did a little review a while ago and only
> 0-(nvec -1) are allocated and the are always in order in entries so it
> shouldn't be to bad to generate a patch for that case, and not having
> to worry about out of order or holes in the irq allocator would be
> good.
> 
> Eric

Found what seems the problem with our vectors being listed backward. In
drivers/pci/msi.c we should be using list_add_tail rather than list_add to preserve
the ordering across various kernels. Please consider this for inclusion.

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 0e67723..d74975d 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -333,7 +333,7 @@ static int msi_capability_init(struct pci_dev *dev)
 			msi_mask_bits_reg(pos, is_64bit_address(control)),
 			maskbits);
 	}
-	list_add(&entry->list, &dev->msi_list);
+	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
 	ret = arch_setup_msi_irqs(dev, 1, PCI_CAP_ID_MSI);
@@ -404,7 +404,7 @@ static int msix_capability_init(struct pci_dev *dev,
 		entry->dev = dev;
 		entry->mask_base = base;
 
-		list_add(&entry->list, &dev->msi_list);
+		list_add_tail(&entry->list, &dev->msi_list);
 	}
 
 	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
--------------------------------------------------------------------------------

This patch undoes my dirty little hack.

diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 26b5866..b70988d 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -70,8 +70,8 @@ struct ctlr_info
 	int 	highest_lun;
 	int	usage_count;  /* number of opens all all minor devices */
 #	define DOORBELL_INT	0
-#	define PERF_MODE_INT	2
-#	define SIMPLE_MODE_INT	1
+#	define PERF_MODE_INT	1
+#	define SIMPLE_MODE_INT	2
 #	define MEMQ_MODE_INT	3
 	unsigned int intr[4];
 	unsigned int msix_vector;
