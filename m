Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab0AOVPw (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261Ab0AOVPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:15:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:45139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758260Ab0AOVPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:15:48 -0500
Message-ID: <4B50DAB7.80209@kernel.org>
Date: Fri, 15 Jan 2010 13:14:31 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 10/14] pci: pciehp clean flow in pciehp_configure_device
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>	<1261522954-12591-11-git-send-email-yinghai@kernel.org> <20100115111445.4a1312d1@jbarnes-piketon>
In-Reply-To: <20100115111445.4a1312d1@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 11:14 AM, Jesse Barnes wrote:
> On Tue, 22 Dec 2009 15:02:30 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> move out bus_size_bridges and assign resources out of
>> pciehp_add_bridge() and at last do them all together one time
>> including slot bridge, to avoid to call assign resources several
>> times, when there are several bridges under the slot bridge.
>> use pci_assign_nassigned_bridge_resources
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/pci/hotplug/pciehp_pci.c |   23 +++++++++++++++++------
>>  1 files changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/pci/hotplug/pciehp_pci.c
>> b/drivers/pci/hotplug/pciehp_pci.c index 2173310..0a16444 100644
>> --- a/drivers/pci/hotplug/pciehp_pci.c
>> +++ b/drivers/pci/hotplug/pciehp_pci.c
>> @@ -53,17 +53,15 @@ static int __ref pciehp_add_bridge(struct pci_dev
>> *dev) busnr = pci_scan_bridge(parent, dev, busnr, pass);
>>  	if (!dev->subordinate)
>>  		return -1;
>> -	pci_bus_size_bridges(dev->subordinate);
>> -	pci_bus_assign_resources(parent);
>> -	pci_enable_bridges(parent);
>> -	pci_bus_add_devices(parent);
>> +
>>  	return 0;
>>  }
>>  
>>  int pciehp_configure_device(struct slot *p_slot)
>>  {
>>  	struct pci_dev *dev;
>> -	struct pci_bus *parent =
>> p_slot->ctrl->pcie->port->subordinate;
>> +	struct pci_dev *bridge = p_slot->ctrl->pcie->port;
>> +	struct pci_bus *parent = bridge->subordinate;
>>  	int num, fn;
>>  	struct controller *ctrl = p_slot->ctrl;
>>  
>> @@ -96,12 +94,25 @@ int pciehp_configure_device(struct slot *p_slot)
>>  				(dev->hdr_type ==
>> PCI_HEADER_TYPE_CARDBUS)) { pciehp_add_bridge(dev);
>>  		}
>> +		pci_dev_put(dev);
>> +	}
>> +
>> +	pci_assign_unassigned_bridge_resources(bridge);
>> +
>> +	for (fn = 0; fn < 8; fn++) {
>> +		dev = pci_get_slot(parent, PCI_DEVFN(0, fn));
>> +		if (!dev)
>> +			continue;
>> +		if ((dev->class >> 16) == PCI_BASE_CLASS_DISPLAY) {
>> +			pci_dev_put(dev);
>> +			continue;
>> +		}
>>  		pci_configure_slot(dev);
>>  		pci_dev_put(dev);
>>  	}
>>  
>> -	pci_bus_assign_resources(parent);
>>  	pci_bus_add_devices(parent);
>> +
>>  	return 0;
>>  }
> 
> This seems like a nice cleanup, can you rebase on the merged patches
> from 9/14 (including the master bit change Kenji-san wanted)?

that share some functions from 0 - 6...

YH
