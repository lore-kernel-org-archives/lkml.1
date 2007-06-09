Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbXFIHAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbXFIHAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbXFIHAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:00:08 -0400
Received: from colo.lackof.org ([198.49.126.79]:47719 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbXFIHAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:00:03 -0400
Date: Sat, 9 Jun 2007 00:59:53 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       gregkh@suse.de
Subject: Re: [PATCH 1/2] [RFC] PCI: read revision ID by default
Message-ID: <20070609065953.GA1747@colo.lackof.org>
References: <20070608224630.31777.17807.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608224630.31777.17807.stgit@localhost.localdomain>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 03:46:30PM -0700, Auke Kok wrote:
> Currently there are 97 occurrences where drivers need the pci
> revision ID. We can do this once for all devices. Even the pci
> subsystem needs the revision several times for quirks. The extra
> u8 member pads out nicely in the pci_dev struct.

Good idea. I always wondered why we read the invariants so often
in the code.

> 
> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> ---
> 
>  drivers/pci/probe.c |    3 +++
>  include/linux/pci.h |    1 +
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index e48fcf0..0fdb71d 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -918,6 +918,9 @@ pci_scan_device(struct pci_bus *bus, int devfn)
>  	dev->cfg_size = pci_cfg_space_size(dev);
>  	dev->error_state = pci_channel_io_normal;
>  
> +	/* read the PCI revision: 1 byte */
> +	pci_read_config_byte(dev, PCI_REVISION_ID, &dev->revision);

probe.c:pci_setup_device() is also reading this byte but discards it:
	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
	class >>= 8;                                /* upper 3 bytes */
	dev->class = class;

Can you use "class & 0xff"? Or is pci_setup_device() too late?
Or can you read the whole 32-bits in pci_scan_device() and remove
the pci_read_config() in pci_setup_device()?

> +
>  	/* Assume 32-bit PCI; let 64-bit PCI cards (which are far rarer)
>  	   set this higher, assuming the system even supports it.  */
>  	dev->dma_mask = 0xffffffff;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index fbf3766..9847936 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -138,6 +138,7 @@ struct pci_dev {
>  	unsigned short	subsystem_vendor;
>  	unsigned short	subsystem_device;
>  	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
> +	u8		revision;	/* PCI revision, low byte of class word */

If anyone doesn't want to add this, "class" really only uses 24 bits.
ie could be packed together with revision field like they are in
PCI configuration header.

thanks,
grant

>  	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
>  	u8		rom_base_reg;	/* which config register controls the ROM */
>  	u8		pin;  		/* which interrupt pin this device uses */
