Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940Ab0ASWMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab0ASWMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558Ab0ASWMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:12:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:33670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428Ab0ASWMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:12:02 -0500
Message-ID: <4B562DFE.7020006@kernel.org>
Date: Tue, 19 Jan 2010 14:11:10 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/11] pci: add pci_bridge_release_unused_res and	pci_bus_release_unused_bridge_res
References: <1263640037-24134-1-git-send-email-yinghai@kernel.org> <1263640037-24134-2-git-send-email-yinghai@kernel.org> <20100119212608.GF11010@ldl.fc.hp.com>
In-Reply-To: <20100119212608.GF11010@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 01:26 PM, Alex Chiang wrote:
>> +static void __ref pci_bus_release_bridge_resources(struct pci_bus *bus,
>> +						   unsigned long type,
>> +						   enum release_type rel_type)
>> +{
>> +	struct pci_dev *dev;
>> +	bool is_leaf_bridge = true;
>> +
>> +	list_for_each_entry(dev, &bus->devices, bus_list) {
>> +		struct pci_bus *b = dev->subordinate;
>> +		if (!b)
>> +			continue;
>> +
>> +		switch (dev->class >> 8) {
>> +		case PCI_CLASS_BRIDGE_CARDBUS:
>> +			is_leaf_bridge = false;
>> +			break;
>> +
>> +		case PCI_CLASS_BRIDGE_PCI:
>> +		default:
>> +			is_leaf_bridge = false;
>> +			if (rel_type == whole_subtree)
>> +				pci_bus_release_bridge_resources(b, type,
>> +							 whole_subtree);
>> +			break;
>> +		}
>> +	}
> 
> I still don't understand this loop. Can't you write it like this:
> 
> 	list_for_each_entry(dev, &bus->devices, bus_list) {
> 		struct pci_bus *b = dev->subordinate;
> 		if (!b)
> 			continue;
> 
> 		is_leaf_bridge = false;
> 
> 		if ((dev->class >> 8) == PCI_CLASS_BRIDGE_CARDBUS)
> 			continue;
> 
> 		if (rel_type == whole_subtree)
> 			pci_bus_release_bridge_resources(b, type,
> 						whole_subtree);
> 	}
> 
> I'm looking at that 'default' label in your switch() statement
> which causes us to always set is_leaf_bridge = false after 'b' is
> valid.

ok
