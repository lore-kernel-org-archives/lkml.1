Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbYJVOYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbYJVOYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYJVOY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:24:27 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:35363 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbYJVOY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:24:26 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yu Zhao <yu.zhao@intel.com>
Subject: Re: [PATCH 2/16 v6] PCI: define PCI resource names in an 'enum'
Date: Wed, 22 Oct 2008 08:24:19 -0600
User-Agent: KMail/1.9.9
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084041.GB3773@yzhao12-linux.sh.intel.com>
In-Reply-To: <20081022084041.GB3773@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810220824.21356.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008 02:40:41 am Yu Zhao wrote:
> This patch moves all definitions of the PCI resource names to an 'enum',
> and also replaces some hard-coded resource variables with symbol
> names. This change eases introduction of device specific resources.

Thanks for removing a bunch of magic numbers from the code.

>  static void
>  pci_restore_bars(struct pci_dev *dev)
>  {
> -	int i, numres;
> -
> -	switch (dev->hdr_type) {
> -	case PCI_HEADER_TYPE_NORMAL:
> -		numres = 6;
> -		break;
> -	case PCI_HEADER_TYPE_BRIDGE:
> -		numres = 2;
> -		break;
> -	case PCI_HEADER_TYPE_CARDBUS:
> -		numres = 1;
> -		break;
> -	default:
> -		/* Should never get here, but just in case... */
> -		return;
> -	}
> +	int i;
>  
> -	for (i = 0; i < numres; i++)
> +	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++)
>  		pci_update_resource(dev, i);
>  }

The behavior of this function used to depend on dev->hdr_type.  Now
we don't look at hdr_type at all, so we do the same thing for all
devices.

For example, for a CardBus device, we used to call pci_update_resource()
only for BAR 0; now we call it for BARs 0-6.

Maybe this is safe, but I can't tell from the patch, so I think you
should explain *why* it's safe in the changelog.

> +/*
> + *  For PCI devices, the region numbers are assigned this way:
> + */
> +enum {
> +	/* #0-5: standard PCI regions */
> +	PCI_STD_RESOURCES,
> +	PCI_STD_RESOURCES_END = 5,
> +
> +	/* #6: expansion ROM */
> +	PCI_ROM_RESOURCE,
> +
> +	/* address space assigned to buses behind the bridge */
> +#ifndef PCI_BRIDGE_RES_NUM
> +#define PCI_BRIDGE_RES_NUM 4
> +#endif
> +	PCI_BRIDGE_RESOURCES,
> +	PCI_BRIDGE_RES_END = PCI_BRIDGE_RESOURCES + PCI_BRIDGE_RES_NUM - 1,

Since you used "PCI_STD_RESOURCES_END" above, maybe you should use
"PCI_BRIDGE_RESOURCES_END" instead of "PCI_BRIDGE_RES_END".

Bjorn
