Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbXEaXfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbXEaXfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbXEaXfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:35:14 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241AbXEaXfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:35:12 -0400
Date: Thu, 31 May 2007 16:34:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2/4] 2.6.22-rc3: known regressions
Message-Id: <20070531163403.6f845c84.akpm@linux-foundation.org>
In-Reply-To: <adalkf4oa6r.fsf@cisco.com>
References: <465C188F.9000900@googlemail.com>
	<465C22F4.8080505@googlemail.com>
	<alpine.LFD.0.98.0705301918450.26602@woody.linux-foundation.org>
	<20070531220833.GA10867@beardog.cca.cpqcorp.net>
	<alpine.LFD.0.98.0705311516350.26602@woody.linux-foundation.org>
	<20070531223908.GA12325@beardog.cca.cpqcorp.net>
	<20070531155018.a8226075.akpm@linux-foundation.org>
	<alpine.LFD.0.98.0705311610440.26602@woody.linux-foundation.org>
	<adalkf4oa6r.fsf@cisco.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 16:17:00 -0700
Roland Dreier <rdreier@cisco.com> wrote:

> What about the changes to fix the order that MSI-X irqs are returned
> in (iirc, list_add had to be changed to list_add_tail in a couple of
> places).  Without that change, multiple MSI-X interrupts seem to be
> broken: the kernel programs the MSI-X table in the opposite order that
> it gives the irq numbers to the driver.  The net effect is that if I
> request, say, 3 MSI-X interrupts for a device, then when the device
> generates the first interrupt, the driver thinks it generated the
> third interrupt, and things go fairly haywire.
> 

That's msi-fix-the-ordering-of-msix-irqs.patch, which is also queued for
the next batch.


"next batch" == around 40 patches atm.  Some of these need maintainer acks
so they will be further delayed, or more likely just merged without the
appropriate ack.



From: "Eric W. Biederman" <ebiederm@xmission.com>

"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> writes:

Found what seems the problem with our vectors being listed backward.  In
drivers/pci/msi.c we should be using list_add_tail rather than list_add to
preserve the ordering across various kernels.  Please consider this for
inclusion.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Screwed-up-by: Michael Ellerman <michael@ellerman.id.au>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: Andi Kleen <ak@suse.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pci/msi.c~msi-fix-the-ordering-of-msix-irqs drivers/pci/msi.c
--- a/drivers/pci/msi.c~msi-fix-the-ordering-of-msix-irqs
+++ a/drivers/pci/msi.c
@@ -333,7 +333,7 @@ static int msi_capability_init(struct pc
 			msi_mask_bits_reg(pos, is_64bit_address(control)),
 			maskbits);
 	}
-	list_add(&entry->list, &dev->msi_list);
+	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
 	ret = arch_setup_msi_irqs(dev, 1, PCI_CAP_ID_MSI);
@@ -404,7 +404,7 @@ static int msix_capability_init(struct p
 		entry->dev = dev;
 		entry->mask_base = base;
 
-		list_add(&entry->list, &dev->msi_list);
+		list_add_tail(&entry->list, &dev->msi_list);
 	}
 
 	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
_

