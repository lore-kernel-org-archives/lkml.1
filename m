Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab0APKMR (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 05:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455Ab0APKMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 05:12:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:34333 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab0APKMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 05:12:14 -0500
Message-ID: <4B5190AC.8080204@kernel.org>
Date: Sat, 16 Jan 2010 02:10:52 -0800
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
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org> <1263609721-3921-2-git-send-email-yinghai@kernel.org> <20100116035750.GB22215@ldl.fc.hp.com>
In-Reply-To: <20100116035750.GB22215@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 07:57 PM, Alex Chiang wrote:
> Hi Yinghai,
> 
> First, thank you very much for writing the summary in patch 0/11.
> I feel like I finally understand what you are trying to do with
> this series.
> 
>> +/*
>> + * try to release pci bridge resources that is from leaf bridge,
>> + * so we can allocate big new one later
>> + */
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
> 
> How about settting
> 
> 		is_leaf_bridge = false;
> 
> here, and then you don't need the repeated assignments below?
> 

no
that is AND

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
>> +
>> +	/* The root bus? */
>> +	if (!bus->self)
>> +		return;
> 
> Won't work correctly on a non-materialized root bridge.
> 
> Use pci_is_root_bus() instead.


OK

YH
