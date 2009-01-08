Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZAHHOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZAHHOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 02:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZAHHOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 02:14:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49519 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbZAHHOX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 02:14:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH 5/8] PCI PCIe portdrv: Fix allocation of interrupts
Date: Thu, 8 Jan 2009 08:13:47 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl> <200901042355.55724.rjw@sisk.pl> <49656CB9.9070806@jp.fujitsu.com>
In-Reply-To: <49656CB9.9070806@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901080813.47650.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009, Kenji Kaneshige wrote:
> Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > If MSI-X interrupt mode is used by the PCI Express port driver, too
> > many vectors are allocated and it is not ensured that the right
> > vectors will be used for various services.  Namely, the PCI Express
> > specification states that both PCI Express native PME and PCI Express
> > hotplug will always use the same MSI or MSI-X message for signalling
> > interrupts, which implies that the same vector will be used by both
> > of them.  Also, the VC service does not use interrupts at all.
> > Moreover, is not clear which of the vectors allocated by
> > pci_enable_msix() will be used for PME and hotplug and which of them
> > will be used for AER if all of these services are configured.
> > 
> > For these reasons, rework the allocation of interrupts for PCI
> > Express ports so that at most two vectors are allocated and ensure
> > that the right vector will be used for the right purpose.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/pci/pcie/portdrv.h      |    1 
> >  drivers/pci/pcie/portdrv_core.c |  155 +++++++++++++++++++++++++++++-----------
> >  2 files changed, 117 insertions(+), 39 deletions(-)
> > 
> > Index: linux-2.6/drivers/pci/pcie/portdrv.h
> > ===================================================================
> > --- linux-2.6.orig/drivers/pci/pcie/portdrv.h
> > +++ linux-2.6/drivers/pci/pcie/portdrv.h
> > @@ -25,6 +25,7 @@
> >  #define PCIE_CAPABILITIES_REG		0x2
> >  #define PCIE_SLOT_CAPABILITIES_REG	0x14
> >  #define PCIE_PORT_DEVICE_MAXSERVICES	4
> > +#define PORT_MSI_VECTOR_MASK		0x1f
> >  
> >  #define get_descriptor_id(type, service) (((type - 4) << 4) | service)
> >  
> > Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
> > +++ linux-2.6/drivers/pci/pcie/portdrv_core.c
> > @@ -30,55 +30,120 @@ static void release_pcie_device(struct d
> >  }
> >  
> >  /**
> > + * fix_up_vectors - ensure the right ordering of MSI-X interrupt vectors
> > + * @dev: PCI Express port that is going to use the vectors
> > + * @vectors: Array of interrupt vectors to check (2 entries)
> > + *
> > + * Return value:
> > + * 0 on success, error code if the values read from config registers are not as
> > + * expected
> > + *
> > + * If this function is called, we are going to use two interrupt vectors which
> > + * may be different, but we have to make sure they are in the right order such
> > + * that the vector to be used for PME and hotplug signalling is the first one.
> > + *
> > + * NOTE: The assumption here is that MSI message offset (with respect to the
> > + * base Message Data) equal to N corresponds to index N in the array of vectors
> > + * returned by pci_enable_msix().
> > + */
> 
> I've posted the similar patch recently, which doesn't have this
> assumption.

Actually, this assumption is in agreement with PCI Express Base Specification
2.0, which very clearly states in Section 7.8.2 that:

"[...] Interrupt Message Number – This field indicates which
MSI/MSI-X vector is used for the interrupt message generated in
association with any of the status bits of this Capability structure.

[...]

For MSI-X, the value in this field indicates which MSI-X Table
entry is used to generate the interrupt message. The entry must
be one of the first 32 entries even if the Function implements
more than 32 entries. For a given MSI-X implementation, the
entry must remain constant."

Well, I have to update the comment. :-)

> Please take a look.
> 
> http://marc.info/?l=linux-pci&m=122992792507715&w=2

OK, thanks.  I can easily change my patch to follow this behavior, although
I don't really think it's necessary given the above.

> NOTE: I've confirmed MSI and INTx still work with my patch, but it
> is not tested on the machine with MSI-X capable port, since I don't
> have such environment.

I also have tested my patch with both MSI and INTx, but I also don't have
MSI-X capable root ports in any of my test boxes.

Thanks,
Rafael
