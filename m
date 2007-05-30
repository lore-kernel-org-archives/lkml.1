Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbXE3PNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbXE3PNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbXE3PNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:13:33 -0400
Received: from outbound-mail-76.bluehost.com ([69.89.22.25]:53548 "HELO
	outbound-mail-76.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750890AbXE3PNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:13:32 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH -mm] 2/2: PCI: disable decode of IO/memory during BAR sizing
Date: Wed, 30 May 2007 08:13:26 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <465CF804.9070907@shaw.ca>
In-Reply-To: <465CF804.9070907@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705300813.26542.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 29, 2007 9:05:24 Robert Hancock wrote:
> Change PCI BAR sizing to disable the decode of memory or IO, as
> appropriate, while we are writing the all-ones value to the BAR to
> determine the size. If this is not done, the device may spuriously decode
> accesses to memory areas it should not. On some Intel PCI Express chipsets,
> this breaks MMCONFIG configuration space access, since the memory the
> graphics card ends up decoding during this period overlaps the MMCONFIG
> area, and thus it steals the accesses to the area to do any other
> configuration space access, including changing the BAR back to its previous
> value.
>
> However, don't do this disabling on host bridge devices, as it is reported
> that some of them do silly things like disable CPU to RAM access if this is
> done.
>
> Based on an original patch by Jesse Barnes.
>
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
>
> --- linux-2.6.22-rc2-mm1/drivers/pci/probe.c	2007-05-23 21:21:05.000000000
> -0600 +++ linux-2.6.22-rc2-mm1edit/drivers/pci/probe.c	2007-05-29
> 21:31:47.000000000 -0600 @@ -180,6 +180,58 @@ static inline int
> is_64bit_memory(u32 ma
>  	return 0;
>  }
>
> +#define BAR_IS_MEMORY(bar) (((bar) & PCI_BASE_ADDRESS_SPACE) ==	\
> +			    PCI_BASE_ADDRESS_SPACE_MEMORY)
> +
> +/**
> + * pci_bar_size - get raw PCI BAR size
> + * @dev: PCI device
> + * @reg: BAR to probe
> + *
> + * Use basic PCI probing:
> + *   - save original BAR value
> + *   - disable MEM or IO decode in PCI_COMMAND reg if appropriate
> + *   - write all 1s to the BAR
> + *   - read back value
> + *   - reenble MEM or IO decode as necessary
> + *   - write original value back
> + *
> + * Returns raw BAR size to caller.
> + */
> +static u32 pci_bar_size(struct pci_dev *dev, unsigned int reg)
> +{
> +	u32 orig_reg, sz;
> +	u16 orig_cmd;
> +
> +	pci_read_config_dword(dev, reg, &orig_reg);
> +	pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
> +
> +	/*
> +	 * Disable memory or IO decode on the device while writing the test
> +	 * value to the BAR. This prevents possible spurious decoding
> +	 * of random addresses by the device. Don't do this for host bridges,
> +	 * however, since some of them do silly things like disable CPU to RAM
> +	 * access if this is done.
> +	 */
> +	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST) {
> +		if (BAR_IS_MEMORY(orig_reg))
> +			pci_write_config_word(dev, PCI_COMMAND,
> +					      orig_cmd & ~PCI_COMMAND_MEMORY);
> +		else
> +			pci_write_config_word(dev, PCI_COMMAND,
> +					      orig_cmd & ~PCI_COMMAND_IO);
> +	}
> +
> +	pci_write_config_dword(dev, reg, 0xffffffff);
> +	pci_read_config_dword(dev, reg, &sz);
> +	pci_write_config_dword(dev, reg, orig_reg);
> +
> +	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST)
> +		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
> +
> +	return sz;
> +}
> +
>  static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int
> rom) {
>  	unsigned int pos, reg, next;
> @@ -196,16 +248,13 @@ static void pci_read_bases(struct pci_de
>  		res->name = pci_name(dev);
>  		reg = PCI_BASE_ADDRESS_0 + (pos << 2);
>  		pci_read_config_dword(dev, reg, &l);
> -		pci_write_config_dword(dev, reg, ~0);
> -		pci_read_config_dword(dev, reg, &sz);
> -		pci_write_config_dword(dev, reg, l);
> +		sz = pci_bar_size(dev, reg);
>  		if (!sz || sz == 0xffffffff)
>  			continue;
>  		if (l == 0xffffffff)
>  			l = 0;
>  		raw_sz = sz;
> -		if ((l & PCI_BASE_ADDRESS_SPACE) ==
> -				PCI_BASE_ADDRESS_SPACE_MEMORY) {
> +		if (BAR_IS_MEMORY(l)) {
>  			sz = pci_size(l, sz, (u32)PCI_BASE_ADDRESS_MEM_MASK);
>  			/*
>  			 * For 64bit prefetchable memory sz could be 0, if the
> @@ -229,9 +278,7 @@ static void pci_read_bases(struct pci_de
>  			u32 szhi, lhi;
>
>  			pci_read_config_dword(dev, reg+4, &lhi);
> -			pci_write_config_dword(dev, reg+4, ~0);
> -			pci_read_config_dword(dev, reg+4, &szhi);
> -			pci_write_config_dword(dev, reg+4, lhi);
> +			szhi = pci_bar_size(dev, reg+4);
>  			sz64 = ((u64)szhi << 32) | raw_sz;
>  			l64 = ((u64)lhi << 32) | l;
>  			sz64 = pci_size64(l64, sz64, PCI_BASE_ADDRESS_MEM_MASK);

Looks good to me, though like I said, this probing code could be redone to be 
a little clearer, but that could be done in a separate patch.

Signed-off-by:  Jesse Barnes <jbarnes@intel.com>
