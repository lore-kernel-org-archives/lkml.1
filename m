Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbZKYRiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbZKYRiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758990AbZKYRiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:38:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:37265 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbZKYRiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:38:50 -0500
Message-ID: <4B0D6B62.6080500@kernel.org>
Date: Wed, 25 Nov 2009 09:37:38 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 1/2] pciehp: remove redundancy in bridge resource allocation
References: <4ADEB601.8020200@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel.org> <4B0D13EB.9010403@jp.fujitsu.com> <4B0D1435.1040106@jp.fujitsu.com>
In-Reply-To: <4B0D1435.1040106@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenji Kaneshige wrote:
> Current pciehp driver configures bridge's child bus each time the
> bridge is found on the hot-added PCIe adapter card. It is redundant
> and strange because pciehp tryies to add devices on the child bus
> before adding its parent bridge. It should be done at one time on the
> slot's parent bus.
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> ---
>  drivers/pci/hotplug/pciehp_pci.c |   28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> Index: 20091125/drivers/pci/hotplug/pciehp_pci.c
> ===================================================================
> --- 20091125.orig/drivers/pci/hotplug/pciehp_pci.c
> +++ 20091125/drivers/pci/hotplug/pciehp_pci.c
> @@ -34,30 +34,26 @@
>  #include "../pci.h"
>  #include "pciehp.h"
>  
> -static int __ref pciehp_add_bridge(struct pci_dev *dev)
> +static void __ref pciehp_scan_bridge(struct pci_dev *dev)
>  {
>  	struct pci_bus *parent = dev->bus;
> -	int pass, busnr, start = parent->secondary;
> -	int end = parent->subordinate;
> +	int pass, busnr, start, end;
>  
> +	start = parent->secondary;
> +	end = parent->subordinate;
>  	for (busnr = start; busnr <= end; busnr++) {
>  		if (!pci_find_bus(pci_domain_nr(parent), busnr))
>  			break;
>  	}
> +
>  	if (busnr-- > end) {
>  		err("No bus number available for hot-added bridge %s\n",
> -				pci_name(dev));
> -		return -1;
> +		    pci_name(dev));
> +		return;
>  	}
> +
>  	for (pass = 0; pass < 2; pass++)
>  		busnr = pci_scan_bridge(parent, dev, busnr, pass);
> -	if (!dev->subordinate)
> -		return -1;
> -	pci_bus_size_bridges(dev->subordinate);
> -	pci_bus_assign_resources(parent);
> -	pci_enable_bridges(parent);
> -	pci_bus_add_devices(parent);
> -	return 0;
>  }
>  
>  int pciehp_configure_device(struct slot *p_slot)
> @@ -93,14 +89,16 @@ int pciehp_configure_device(struct slot 
>  			continue;
>  		}
>  		if ((dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
> -				(dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)) {
> -			pciehp_add_bridge(dev);
> -		}
> +		    (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS))
> +			pciehp_scan_bridge(dev);
> +
>  		pci_configure_slot(dev);
>  		pci_dev_put(dev);
>  	}
>  
> +	pci_bus_size_bridges(parent);
>  	pci_bus_assign_resources(parent);
> +	pci_enable_bridges(parent);
>  	pci_bus_add_devices(parent);
>  	return 0;
>  }

you comment on my patch2, that we should move pci_configure_slot later?


YH
