Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbYDPDJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbYDPDJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 23:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbYDPDJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 23:09:03 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43825 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbYDPDJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 23:09:02 -0400
Message-ID: <48056DC8.6040909@us.ibm.com>
Date: Tue, 15 Apr 2008 20:08:56 -0700
From: Badari Pulavarty <pbadari@us.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alex Chiang <achiang@hp.com>, linux-kernel@vger.kernel.org,
       anton@au1.ibm.com
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
References: <1207331616.5916.15.camel@badari-desktop> <20080404180518.GA12642@ldl.fc.hp.com> <1207340371.5916.23.camel@badari-desktop> <20080404224227.GA31436@ldl.fc.hp.com> <1207352128.5916.26.camel@badari-desktop> <20080407234255.GA22514@ldl.fc.hp.com> <20080415173656.218a6080.akpm@linux-foundation.org>
In-Reply-To: <20080415173656.218a6080.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 7 Apr 2008 17:42:55 -0600
> Alex Chiang <achiang@hp.com> wrote:
>
>   
>> Hi Badari,
>>
>>     
>>>>> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>>>>> rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
>>>>> rpaphp_register_slot registering slot:path[/pci@800000020000003/pci@2,4] index[22010003], name[U787E.001.AAA3015-P2-C1] pdomain[22010003] type[16]
>>>>> Unable to handle kernel paging request for data at address 0x00000070
>>>>>           
>>>> Hrm, this is a little more information, but still not quite
>>>> enough. I'm going to take a stab in the dark and say I'm probably
>>>> doing something wrong on this line, maybe dereferencing a pointer
>>>> incorrectly:
>>>>
>>>>         retval = pci_hp_register(php_slot, slot->bus,
>>>> 				 PCI_SLOT(PCI_DN(slot->dn->child)->devfn));
>>>>         
>>> Sorry. I thought you knew this already. Disassembly clearly showed
>>> that slot->dn->child is NULL. 
>>>
>>> I confirmed it by adding printk also.
>>>       
>> This patch is a complete guess on my part (since I've not been
>> able to understand pseries architecture) but I think it should
>> fix your issue.
>>
>> Can you give it a try and let me know? It applies on top of the
>> -mm tree that includes my physical pci_slot series.
>>
>> Also, I'm hoping Linas will speak up and let me know what the
>> real answer might be. ;)
>>
>> Thanks.
>>
>> /ac
>>
>> From: Alex Chiang <achiang@hp.com>
>> Subject: rpaphp: correctly call pci_hp_register for empty PCI slots
>>
>> Unpopulated device_node slots do not have children, and
>> attempting to dereference them will result in a panic.
>>
>> Instead, attempt to derive the PCI slot number from the bus
>> itself, and failing that, default to 0.
>>
>> Signed-off-by: Alex Chiang <achiang@hp.com>
>> ---
>> diff --git a/drivers/pci/hotplug/rpaphp_slot.c b/drivers/pci/hotplug/rpaphp_slot.c
>> index 0d4cfc7..91ce6a6 100644
>> --- a/drivers/pci/hotplug/rpaphp_slot.c
>> +++ b/drivers/pci/hotplug/rpaphp_slot.c
>> @@ -121,6 +121,7 @@ int rpaphp_register_slot(struct slot *slot)
>>  {
>>  	struct hotplug_slot *php_slot = slot->hotplug_slot;
>>  	int retval;
>> +	int slot_nr;
>>  
>>  	dbg("%s registering slot:path[%s] index[%x], name[%s] pdomain[%x] type[%d]\n", 
>>  		__FUNCTION__, slot->dn->full_name, slot->index, slot->name, 
>> @@ -132,8 +133,11 @@ int rpaphp_register_slot(struct slot *slot)
>>  		return -EAGAIN;
>>  	}	
>>  
>> -	retval = pci_hp_register(php_slot, slot->bus,
>> -				 PCI_SLOT(PCI_DN(slot->dn->child)->devfn));
>> +	if (slot->bus->self)
>> +		slot_nr = PCI_SLOT(slot->bus->self->devfn);
>> +	else
>> +		slot_nr = 0;
>> +	retval = pci_hp_register(php_slot, slot->bus, slot_nr);
>>  	if (retval) {
>>  		err("pci_hp_register failed with error %d\n", retval);
>>  		return retval;
>>     
>
> Did we hear back from Badari on this?
>
> Thanks.
>   
No. It didn't help. I had to hack "slot_nr = 0" all the time to boot my 
machine.

I was trying to get some ppc expert to review the patch, as Alex was not
comfortable with the fix/hack. Linas is no longer with IBM :(

Thanks,
Badari

