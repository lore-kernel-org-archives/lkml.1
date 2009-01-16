Return-Path: <linux-kernel-owner+w=401wt.eu-S1764053AbZAPGH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764053AbZAPGH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 01:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbZAPGHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 01:07:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59027 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbZAPGHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 01:07:45 -0500
Message-ID: <4970242C.4010404@jp.fujitsu.com>
Date: Fri, 16 Jan 2009 15:07:40 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       "Barnes, Jesse" <jesse.barnes@intel.com>, shaohua.li@intel.com
Subject: Re: ACPI hotplug panic with current git head
References: <1231604250.3642.33.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>	 <1231807693.27151.21.camel@localhost.localdomain>	 <1232046108.5966.57.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901151421110.4737@localhost.localdomain>	 <1232049269.5966.64.camel@localhost.localdomain> <1232050347.5966.66.camel@localhost.localdomain>
In-Reply-To: <1232050347.5966.66.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Thu, 2009-01-15 at 14:54 -0500, James Bottomley wrote:
>> On Thu, 2009-01-15 at 14:22 -0500, Len Brown wrote:
>>> On Thu, 15 Jan 2009, James Bottomley wrote:
>>>
>>>> On Mon, 2009-01-12 at 18:48 -0600, James Bottomley wrote:
>>>>> On Mon, 2009-01-12 at 16:16 -0500, Len Brown wrote:
>>>>>>> This is on an IBM Maia system with the calgary IOMMU enabled. It's a
>>>>>>> fatal boot up panic.
>>>>>>>
>>>>>> James,
>>>>>> A guided bisect...
>>>>>> Please let me know which of these fail
>>>>>>
>>>>>> a3a798c88a14b35e5d4ca30716dbc9eb9a1ddfe2 is 2.6.29 at ACPI merge
>>>>>> efcb3cf7f00c3c424db012380a8a974c2676a3c8 is 2.6.29 before ACPI merge
>>>>> Didn't try these (being after the failure)
>>>>>
>>>>>> ec9f168fcc344d2ffec1c8c822076bf22dab5c33 is 2.6.28 with most ACPI
>>>>> This is the failing one.
>>>>>
>>>>>> e8443c358c34f3fe65236e24147ddf0cd0e61b08 is 2.6.28 plus just ACPICA
>>>>> This one boots fine.
>>>>>
>>>>>> Please test the "2.6.28+ACPICA" one first.
>>>>>> If it fails, we are close so you can skip the others above
>>>>>> and bisect between that and 2.6.28.
>>>>> I'll try bisecting between ec9f168fcc344d2ffec1c8c822076bf22dab5c33 and
>>>>> e8443c358c34f3fe65236e24147ddf0cd0e61b08.
>>>> OK, bisection complete.  It's not actually coming from the ACPI tree but
>>>> from the PCI one (appropriate CC's added).
>>>>
>>>> The commit causing the boot panic is:
>>>>
>>>> commit e8c331e963c58b83db24b7d0e39e8c07f687dbc6
>>>> Author: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
>>>> Date:   Wed Dec 17 12:09:12 2008 +0900
>>>>
>>>>     PCI hotplug: introduce functions for ACPI slot detection
>>>>
>>>> I'm still not sure why, though
>>> Nothing jumped out at me in the patch.
>>> Does reverting e8c331e963c58b83db24b7d0e39e8c07f687dbc6
>>> make the boot crash go away?
>> Yes, but then it would ... the call sequence is through the reverted
>> code.
> 
> It looks like acpi_pci_get_bridge_handle() is returning NULL, so this is
> the fix that works for me.
> 

I'm sorry for troubling you, and thank you for your patience.

The patch seems to avoid the kernel panic, but I still don't know
why acpi_pci_get_bridge_handle() returns NULL here. I assumed
it should return non-NULL value here. So I'd like to investigate
it more.

Thanks,
Kenji Kaneshige


> James
> 
> ---
> 
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index f09b101..803d9dd 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -266,6 +266,8 @@ static int detect_ejectable_slots(struct pci_bus *pbus)
>  	int found = acpi_pci_detect_ejectable(pbus);
>  	if (!found) {
>  		acpi_handle bridge_handle = acpi_pci_get_bridge_handle(pbus);
> +		if (!bridge_handle)
> +			return 0;
>  		acpi_walk_namespace(ACPI_TYPE_DEVICE, bridge_handle, (u32)1,
>  				    is_pci_dock_device, (void *)&found, NULL);
>  	}
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


