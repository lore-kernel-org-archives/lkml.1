Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbZBRHNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbZBRHNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 02:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZBRHMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 02:12:54 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47182 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbZBRHMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 02:12:53 -0500
Message-ID: <499BB4EB.6020602@jp.fujitsu.com>
Date: Wed, 18 Feb 2009 16:12:43 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp:  Handle interrupts that happen during initialization.
References: <m1pri623g9.fsf@fess.ebiederm.org>	<49815BF6.7060402@jp.fujitsu.com>	<200902131129.09523.jbarnes@virtuousgeek.org>	<m11vu1wtk6.fsf@fess.ebiederm.org> <49991D3A.7090001@jp.fujitsu.com> <m1mycktw5t.fsf@fess.ebiederm.org>
In-Reply-To: <m1mycktw5t.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> writes:
> 
>> Eric W. Biederman wrote:
>>> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
>>>
>>>> Any update here, Eric?  Sounds like you're using hotplug in real environments
>>>> with complex topologies (based on your earlier messages), so we're interested
>>>> in what you're seeing here...
>>> Yes.
>>>
>>> Currently I have a test system that is a subset of what I'm worried
>>> about and will shortly have the real hardware, so my immediate goal is
>>> to get things working well enough so my internal users won't get
>>> blocked by bugs.  Currently I only have the pcie hotplug and pcie
>>> hotplug surprise case.  My basic topology is 16 hotplug slots into
>>> which I will be plugging in pci express switches with a couple of
>>> additional hotplug slots.  As for the firmware, I will have it reserving
>>> bus numbers and mmio space on each of the first 16 slots and the rest
>>> is going to be up to the linux kernel.  This is an embedded design
>>> so no ACPI is appears more pain than it is worth to implement.
>>>
>> Very interesting. Can I ask you some questions?
>>
>> - On hot-insertion of pci express switches with a additional hotplug
>>   slots, who initialize HwInit registers (for example, physical slot
>>   number field in the Slot Capabilities register)? OS, firmware,
>>   hardware or others?
> 
> It happens before the linux kernel gets to see it.  Call it firmware.
> 
>> - Bus numbers and MMIO space that needs to be reserved is depending
>>   on platform design. How do you tell kernel (or hotplug drivers) how
>>   many resources need to be reserved, in your current design?
> 
> So far it looks like I can get away without telling the kernel
> anything, and just perform reservations at the layer of the
> firmware on the primary board, and have the kernel see those
> reservations when it boots up, and just subdivide them.
> 
> I have some thoughts on how to do things better but I'm not at a point
> where it makes a difference right now.
> 

In the current pciehp implementation, minimum resources enough to
enable devices under the bridge are assigned when P2P bridge is
hot-added. My concern is that enough resources are NOT assigned to
the bridge if an additional slot is empty. As a result, hot-add
adapter card on the additional slot won't work because of resource
shortage.

>>> I need to revisit the pciehp driver but my first pass through it
>>> looked like every corner case appeared to get something wrong. So I
>>> have written myself a little 430 line replaces that handles the case
>>> that I currently care about.  Part of what I was seeing before is that
>>> we don't clear pending events in the pciehp driver before we enable
>>> interrupts.  So if booting the system has left some pending and you
>>> have CONFIG_DEBUG_SHIRQ enabled you get a nice oops because p_slot has
>>> not been initialized and so the interrupts can't be handled.
>>>
>> I've made a fix (c4635eb06af700820d658a163f06aff12e17cfb2) for a similar
>> problem several months ago. With this fix, pciehp had been changed to
>> initialize p_slot before installing interrupt service routine. So I still
>> don't understand what is happening. Could you please tell me the details
>> about "p_slot has not been initialized..."?
> 
> kobject_name is not initialized, and slot_name(p_slot) calls
> hoptlug_slot_name which calls pci_slot_name which kobj_name. 
> It looks like this problem was introduced in commit 
> e1acb24f059defdaa0264e925f19cc21b0a3e592

Thank your for the information. I understood what is happening.
This needs to be fixed. But, as I mentioned before, I think
software notification mechanism should be initialized before
sysfs entries are created. I'll consider alternative fix.

Thanks,
Kenji Kaneshige

