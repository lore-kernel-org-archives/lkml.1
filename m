Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbZAZM17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbZAZM17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 07:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZAZM1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 07:27:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56512 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZAZM1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 07:27:49 -0500
Message-ID: <497DAC37.5030002@jp.fujitsu.com>
Date: Mon, 26 Jan 2009 21:27:35 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       "Barnes, Jesse" <jesse.barnes@intel.com>, shaohua.li@intel.com
Subject: Re: ACPI hotplug panic with current git head
References: <alpine.LFD.2.00.0901151421110.4737@localhost.localdomain> <1232049269.5966.64.camel@localhost.localdomain> <1232050347.5966.66.camel@localhost.localdomain> <4970242C.4010404@jp.fujitsu.com> <1232115546.3224.5.camel@localhost.localdomain> <4973D2EE.3060203@jp.fujitsu.com> <1232328216.3247.68.camel@localhost.localdomain> <4973EF64.2050404@jp.fujitsu.com> <1232558780.736.24.camel@localhost.localdomain> <497D1BD7.9000609@jp.fujitsu.com> <20090126062132.GC4376@colo.lackof.org>
In-Reply-To: <20090126062132.GC4376@colo.lackof.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Mon, Jan 26, 2009 at 11:11:35AM +0900, Kenji Kaneshige wrote:
> ...
>> Thanks to you, I found the root cause of the
>> problem. The acpi_pci_get_bridge_handle() function assumes
>> pci_bus->self is NULL on the root bus.
> 
> Mea culpa: I contributed this mess too. This worked for PA-RISC
> and lacking better guidance, is what I used in 1/2 the places.
> 
>> But it is not true
>> and pci_bus->self can have a non-NULL value on some
>> platfroms (like yours). So it must check pci_bus->parent
>> instead.
> 
> It is true for PA-RISC and some other architectures.
> These architectures don't provide fake PCI devices
> (emulated PCI config space) for Host-PCI Bus controllers.
> 
>> I found some other code that has the same wrong assumption.
>> I'll make a fix for them and send it soon.
> 
> I would like to keep the code consistent. Attached is a patch
> for drivers/parisc. Please include with my
>     Signed-off-by: Grant Grundler <grundler@parisc-linux.org>
> 
> Or if you prefer, I can repost as a separate patch.
> 
> I've compiled the iosapic/lba changes and will test those shortly.
> I have no HW (by choice) to test the dino code change.
> 

Thank you for the patch for drivers/parisc.

I cannot change platform dependent code or driver for each hardware
because I don't have enough knowledge. Maybe all I can do is only
for generic pci code. So I'd like you to post it as a separate patch.

BTW, I'm wondering if a function something like below is useful
to keep the code consistent. What do you think about it?

/*
 * Returns true if the pci bus is root (behind host-pci brdige),
 * false otherwise
 */
static inline bool pci_is_root_bus(struct pci_bus *pbus)
{
       return !(pbus->parent);
}

Thanks,
Kenji Kaneshige



