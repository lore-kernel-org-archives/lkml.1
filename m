Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZI2AAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZI2AAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 20:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZI2AAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 20:00:46 -0400
Received: from sous-sol.org ([216.99.217.87]:37377 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753539AbZI2AAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 20:00:45 -0400
Date: Mon, 28 Sep 2009 17:00:41 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Allen Kay <allen.m.kay@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, matthew@wil.cx
Subject: Re: [PATCH ACS v3 1/1]
Message-ID: <20090929000041.GB3958@sequoia.sous-sol.org>
References: <1253231193-5753-1-git-send-email-allen.m.kay@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253231193-5753-1-git-send-email-allen.m.kay@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Allen Kay (allen.m.kay@intel.com) wrote:
> This patch enables P2P upstream forwarding in ACS capable PCIe switches.
> This solves two potential problems in virtualization environment where
> a PCIe device is assigned to a guest domain using a HW iommu such as VT-d:

This may negatively impact p2p traffic throughput for devices that don't
need it.  Have you considered this impact or attempted to measure it?

An alternative approach would be to enable this during device assignment.

Also, there is no checking that the relevant path through the topology has
the right capabilties.  Is there any reason you left that out?  It would
certainly simplify the filtering logic, for example.  And given some
states result in undefined behaviour, perhaps it makes sense to check
while enabling ACS.

> 1) Unintentional failure caused by guest physical address programmed
>    into the device's DMA that happens to match the memory address range
>    of other downstream ports in the same PCIe switch.  This causes the PCI
>    transaction to go to the matching downstream port instead of go to the
>    root complex to get translated by VT-d as it should be.
> 
> 2) Malicious guest software intentionally attacks another downstream
>    PCIe device by programming the DMA address into the assigned device
>    that matches memory address range of the downstream PCIe port.
> 
> We are in process of implementing device filtering software in KVM/XEN
> management software to allow device assignment of PCIe devices behind
> a PCIe switch only if it has ACS capability and with the P2P upstream
> forwarding bits enabled.  This patch is intended to work for both KVM
> and Xen environments.
> 
> Changes from initial to v1:
>         - removed #define ACS_ENABLE and dev_info() call
>         - changed ctrl value setting without using if-condition
>         - fixed ACS #defines in pci_regs.h
> 
> Changes from v2 to v3:
>         - change #define indention to 2 for PCI reg and 1 for bit
>           position
> 
> Signed-off-by: Allen Kay <allen.m.kay@intel.com>
> Reviewed--by: Mathew Wilcox <willy@linux.intel.com>
> ---
>  drivers/pci/pci.c        |   35 +++++++++++++++++++++++++++++++++++
>  drivers/pci/pci.h        |    1 +
>  drivers/pci/probe.c      |    3 +++
>  include/linux/pci_regs.h |   13 +++++++++++++
>  4 files changed, 52 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 6edecff..1171c6d 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1533,6 +1533,41 @@ void pci_enable_ari(struct pci_dev *dev)
>  }
>  
>  /**
> + * pci_acs_enable - enable ACS if hardware support it
> + * @dev: the PCI device
> + */
> +void pci_acs_init(struct pci_dev *dev)

I'd call it pci_enable_acs...in fact, the kdoc above tries something
close to that ;-)

