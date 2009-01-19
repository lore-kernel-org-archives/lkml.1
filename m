Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbZASG1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbZASG1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 01:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757885AbZASG1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 01:27:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47914 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbZASG1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 01:27:12 -0500
Message-ID: <49741D37.8070007@jp.fujitsu.com>
Date: Mon, 19 Jan 2009 15:27:03 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] PCI PCIe portdrv: Fix allocation of interrupts
References: <200901042346.42723.rjw@sisk.pl> <496EE7ED.10408@jp.fujitsu.com> <496F1078.5040904@jp.fujitsu.com> <200901151742.09227.rjw@sisk.pl>
In-Reply-To: <200901151742.09227.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday 15 January 2009, Kenji Kaneshige wrote:
>> Hidetoshi Seto wrote:
>>> Rafael J. Wysocki wrote:
>>>> On Wednesday 14 January 2009, Rafael J. Wysocki wrote:
>>>>> On Wednesday 14 January 2009, Kenji Kaneshige wrote:
>>>> [...]
>>>>>> I'm sorry but I don't understand what the problem is.
>>>>>> Do you mean pci_disable_msix() doesn't work on some platforms?
>>>>> No, I don't.  It was just confusion on my side, sorry.
>>>>>
>>>>> Please have a look at the new version of the patch I sent yesterday
>>>>> (http://marc.info/?l=linux-pci&m=123185510828181&w=4).
>>>> BTW, in your patch the first dummy pci_enable_msix() allocates just one
>>>> vector, which means that the contents of both
>>>> msix_entries[idx_hppme].entry and msix_entries[idx_aer].entry will be the same,
>>>> if my reading of the spec (PCI 3.0 in this case) is correct.
>>> According to PCI 3.0 implementation note "Handling MSI-X Vector Shortage,"
>>> it seems your reading is not correct.
>>>
>>> Assume that the port have 4 entries([0-3]) in MSI-X table, and that entry[2]
>>> for hotplug/PME and entry[3] for AER, and that kernel only allocates 2 vector.
>>> Spec says that the port could be designed for software to configure entries
>>> assigning vectors{A,B} to multiple entries as ABAB, AABB, ABBB etc. 
>>>
>>> So if there is just one vector, it could be AAAA.
> 
> Our pci_enable_msix() doesn't do that.  It will always do A---.
> 
>> BTW, I don't think pci_enable_msix() allows this kind of configuration.
>> With the dummy pci_enable_msix() in my patch, it would be A---, I think.
> 
> And that exactly is why I'm not sure it's correct.
> 
> Namely, if only the first entry is configured, the device is only able to use
> one vector, represented by this entry, for any purpose.  Now, for instance, for
> PCIE_CAPABILITIES_REG, there are two possibilities:
> (1) the value in the register always points to the _valid_ entry in the MSI-X
>     table and that would be the first one,
> (2) the value in the register may point to an _invalid_ entry (1 - 3).
> 
> You seem to assume that (2) is the case, but I'm not sure (that should follow
> from the PCI Express spec, but it clearly doesn't, at least I couldn't find
> any pointer in the spec).  IMO it wouldn't make sense, because the port
> wouldn't have been able to generate interrupts for this service if only one
> vector had been configured.

I don't understand what "valid" and "invalid" means. And I don't
imagine how the PCI Express chipset judges "valid" or "invalid".
If those mean "unmasked", "masked" respectively, we need to unmask
MSI-X before configuring MSI-X table entries. It doesn't look
correct behavior, I think.

After all, I think what we need to do at least for reading
Interrupt Message Number is that setting "MSI Enable"/"MSI-X Enable"
fields to 0b/1b. But it might exist some other things for enabling
MSI-X, quirk handling for example. And if we enable MSI-X by hand in
in port service driver, it would add the possibility of the race
condition between port service driver and existing pci_enable_msix().
That's why I used dummy pci_enable_msix() for reading Interrupt
Message Number. As you pointed out before, it's a little ugly, but
I think it's the simplest and most reliable way so far.

> 
> Still, even though (2) is the case, but both PCIE_CAPABILITIES_REG and
> PCI_ERR_ROOT_STATUS just happen to point to the same entry, which very well may
> be possible, the second pci_enable_msix() in your patch will fail.
> 

Oh, I understood. As you pointed out, my patch doesn't take into
account the case that HP/PME and AER share the same MSI-X entry.
This need to be fixed. Thanks!

> In any case, I think we should
> (a) get the number of the port's MSI-X table entries _first_, without enabling
>     MSI-X,
> (b) allocate as many MSI-X vectors as indicated by this number, even though
>     some of them may not be used,
> (c) use PCIE_CAPABILITIES_REG and PCI_ERR_ROOT_STATUS to check
>     which vector has been allocated to which service.
> 

This will cause unused vectors. We need to note that there can be
multiple PCIe ports in the system. So the number of unused vectors
can become large.

Thanks,
Kenji Kaneshige

