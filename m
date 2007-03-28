Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbXC1EqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbXC1EqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 00:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbXC1EqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 00:46:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35453 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbXC1EqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 00:46:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 9/21] MSI: Expand pci_msi_supported()
References: <20070322105340.53827DDF65@ozlabs.org>
Date: Tue, 27 Mar 2007 22:45:07 -0600
In-Reply-To: <20070322105340.53827DDF65@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:39 +1100")
Message-ID: <m1slbqrn70.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> pci_enable_msi() and pci_enable_msix() both search for the MSI/MSI-X
> capability, we can fold this into pci_msi_supported() by passing the
> type in.
>
> Update the code to match the comment for pci_msi_supported(). That is
> it returns 0 on success, and anything else indicates an error.

Ok.  Looking at this one I don't see a bug exactly but there
is one very confusing piece.

Currently we have a function pci_msi_supported that sounds like it
sounds like it should return a boolean value.

However instead it returns 0 for success and -EINVAL for failure.

Reading through the code before this patch it is clear it does this
weird thing because we check for < 0.

After this patch we are simply checking to see if there was a
return value at all.

Can we please change the return value here so it is actually boolean.
1 for supported 0 for not supported.

There aren't any useful return values anyway so this would just make
the code easier to read and maintain.

Eric


>
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> ---
>
>  drivers/pci/msi.c |   19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
>
> Index: msi-new/drivers/pci/msi.c
> ===================================================================
> --- msi-new.orig/drivers/pci/msi.c
> +++ msi-new/drivers/pci/msi.c
> @@ -433,12 +433,13 @@ static int msix_capability_init(struct p
>  /**
>   * pci_msi_supported - check whether MSI may be enabled on device
>   * @dev: pointer to the pci_dev data structure of MSI device function
> + * @type: are we checking for MSI or MSI-X ?
>   *
>   * Look at global flags, the device itself, and its parent busses
>   * to return 0 if MSI are supported for the device.
>   **/
>  static
> -int pci_msi_supported(struct pci_dev * dev)
> +int pci_msi_supported(struct pci_dev * dev, int type)
>  {
>  	struct pci_bus *bus;
>  
> @@ -456,6 +457,9 @@ int pci_msi_supported(struct pci_dev * d
>  		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
>  			return -EINVAL;
>  
> +	if (!pci_find_capability(dev, type))
> +		return -EINVAL;
> +
>  	return 0;
>  }
>  
> @@ -471,13 +475,9 @@ int pci_msi_supported(struct pci_dev * d
>   **/
>  int pci_enable_msi(struct pci_dev* dev)
>  {
> -	int pos, status;
> -
> -	if (pci_msi_supported(dev) < 0)
> -		return -EINVAL;
> +	int status;
>  
> -	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
> -	if (!pos)
> +	if (pci_msi_supported(dev, PCI_CAP_ID_MSI))
>  		return -EINVAL;
>  
>  	WARN_ON(!!dev->msi_enabled);
> @@ -580,13 +580,10 @@ int pci_enable_msix(struct pci_dev* dev,
>  	int i, j;
>  	u16 control;
>  
> -	if (!entries || pci_msi_supported(dev) < 0)
> +	if (!entries || pci_msi_supported(dev, PCI_CAP_ID_MSIX))
>   		return -EINVAL;
>  
>  	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
> -	if (!pos)
> - 		return -EINVAL;
> -
>  	pci_read_config_word(dev, msi_control_reg(pos), &control);
>  	nr_entries = multi_msix_capable(control);
>  	if (nvec > nr_entries)
