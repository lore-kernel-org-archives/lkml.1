Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZCLJRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZCLJRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbZCLJQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:16:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35642 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZCLJQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:16:56 -0400
Message-ID: <49B8D2F4.1030206@jp.fujitsu.com>
Date: Thu, 12 Mar 2009 18:16:36 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/11] PCI: beef up pci_do_scan_bus()
References: <20090309052933.3918.86601.stgit@bob.kio> <20090309054900.3918.4473.stgit@bob.kio>
In-Reply-To: <20090309054900.3918.4473.stgit@bob.kio>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> We have a nice interface for re-scanning a PCI bus which will
> discover newly added devices, add them to the device tree, and
> enable them properly.
> 
> Ensure that the bridge resources are properly sized and assigned
> during the rescan.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/pci/hotplug-pci.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/hotplug-pci.c b/drivers/pci/hotplug-pci.c
> index 4d4a644..33ab2d2 100644
> --- a/drivers/pci/hotplug-pci.c
> +++ b/drivers/pci/hotplug-pci.c
> @@ -6,13 +6,21 @@
>  
>  unsigned int __devinit pci_do_scan_bus(struct pci_bus *bus)
>  {
> -	unsigned int max;
> +	unsigned int max, pass;
> +	struct pci_dev *dev;
>  
>  	max = pci_scan_child_bus(bus);
>  
> -	/*
> -	 * Make the discovered devices available.
> -	 */
> +	for (pass=0; pass < 2; pass++)
> +		list_for_each_entry(dev, &bus->devices, bus_list) {
> +			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
> +			    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
> +				if (pass && dev->subordinate)
> +					pci_bus_size_bridges(dev->subordinate);
> +		}
> +
> +	pci_bus_assign_resources(bus);
> +	pci_enable_bridges(bus);
>  	pci_bus_add_devices(bus);

The "for (pass=0; pass <2; pass++)" loop doesn't look necessary.

And I'm worrying that your change have some bad effect to the
existing user of pci_do_scan_bus(). Did you confirm that?

Thanks,
Kenji Kaneshige


