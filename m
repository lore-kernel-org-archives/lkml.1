Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZJ1TNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZJ1TNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 15:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZJ1TNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 15:13:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:60961 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbZJ1TNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 15:13:07 -0400
Message-ID: <4AE897B4.9030206@kernel.org>
Date: Wed, 28 Oct 2009 12:12:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] pci: pciehp update the slot bridge res to get big range
 for pcie devices
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com>	<4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com>	<4AE55D12.30403@kernel.org> <4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org> <4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com> <4AE88305.8020207@kernel.org> <m1ljivibrt.fsf@fess.ebiederm.org>
In-Reply-To: <m1ljivibrt.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
>> Kenji Kaneshige wrote:
>>> Yinghai Lu wrote:
>>>> Yinghai Lu wrote:
>>>>> Kenji Kaneshige wrote:
>>>>>> I understand you need to touch I/O base/limit and Mem base/limit. But
>>>>>> I don't understand why you also need to update bridge's BARs. Could
>>>>>> you please explain a little more about it?
>>>>>>
>>>>>> Just in case, my terminology "bridge's BARs" is Base Address Register
>>>>>> 0 (offset 0x10) and Base Address Register 1 (offset 0x14) in the
>>>>>> (type 1) configuration space header of the bridge.
>>>>> i mean 0x1c, 0x20, 0x28
>>>>>
>>>>> did not notice that bridge device's 0x10, 0x14 are used...
>>>>> if port service need to use 0x10, 0x14, and the device is enabled, we
>>>>> should touch 0x10, and 0x14.
>>>> after check the code, if
>>>> pci_bridge_assign_resources ==> pdev_assign_resources_sorted ==> 
>>>> pdev_sort_resources
>>>>
>>>> will not touch 0x10 and 0x14, if those resource is claimed by port
>>>> service.
>>>>
>>>> /* Sort resources by alignment */
>>>> void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
>>>> {               int i;
>>>>                         for (i = 0; i < PCI_NUM_RESOURCES; i++) {
>>>>                 struct resource *r;
>>>>                 struct resource_list *list, *tmp;
>>>>                 resource_size_t r_align;
>>>>                                 r = &dev->resource[i];
>>>>                                         if (r->flags &
>>>> IORESOURCE_PCI_FIXED)
>>>>                         continue;
>>>>                         if (!(r->flags) || r->parent)
>>>>                         continue;
>>>>                
>>>> r->parent != NULL, will make it skip those two.
>>>>
>>>> So -v3 should be safe.
>>>>
>>> Thank you for the clarification.
>>>
>>> But I still don't understand the whole picture of your set of
>>> changes. Let me ask some questions.
>>>
>>> In my understanding of your set of changes, if there is a PCIe
>>> switch with some hot-plug slots and all of those slots are empty,
>>> I/O and Memory resources assigned by BIOS are all released at
>>> the boot time. For example, suppose the following case.
>>>
>>>                bridge(A)
>>>                   |
>>>        -----------------------
>>>        |                     |
>>>     bridge(B)             bridge(C)
>>>        |                     |
>>>      slot(1)               slot(2)
>>>      (empty)               (empty)
>>>
>>>   bridge(A): P2P bridge for switch upstream port
>>>   bridge(B): P2P bridge for switch downstream port
>>>   bridge(C): P2P bridge for switch downstream port
>>>
>>> In the above example, I/O and Mem resource assigned to bridge(A),
>>> bridge(B) and bridge(C) are all released at the boot time. Correct?
>>>
>>> Then, when a adapter card is hot-added to slot(1), I/O and Mem
>>> resources enough for enabling the hot-added adapter card is assigned
>>> to bridge(A), bridge(B) and the adapter card. Correct?
>>>
>>> Then, when an another adpater card is hot-added to slot(2), we
>>> need to assign enough resource to bridge(C) and the new card.
>>> But bridge(A) doesn't have enough resource for bridge(C) and
>>> the new card. In addition, all bridge(A) and bridge(B) and the
>>> adapter card on slot(1) are already working. How do you assign
>>> resource to bridge(C) and the card on slot(2)?
>>>
>> thanks, will update the patches to only handle leaf bridge, and don't touch min_size etc.
> 
> Tell me what is your expected behavior if I plug a bridge with hotplug
> slots into a leaf hotplug slot?  Will you assign me enough resources so
> that I can plug in additional devices?

no.

you need to plug device in those slots and then insert it into a leaf hotplug slot.

> 
> Today I make plugging in a hotplug bridge work by having the firmware
> reserve at one level and having the kernel reserve at the next level.
> 
> Windows handles the issue in theory by performing some kind of
> hot-unplugging of drivers that already have assigned resources and
> then replugging them.  Which allows a full renumbering of busses.
> We don't have the infrastructure to do that safely today.

that will take some drivers offline at first ?

YH
