Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbYJHCXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbYJHCXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 22:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYJHCXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 22:23:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:5145 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbYJHCXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 22:23:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,376,1220252400"; 
   d="scan'208";a="56534042"
From: "Zhao, Yu" <yu.zhao@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Wed, 8 Oct 2008 10:23:18 +0800
Subject: RE: [PATCH 1/6 v3] PCI: export some functions and macros
Thread-Topic: [PATCH 1/6 v3] PCI: export some functions and macros
Thread-Index: AckgoOnstgYNQgUST+mT/dAiSk92ggISGy+g
Message-ID: <D8078B8B3B09934AA9F8F2D5FB3F28CE08A3D2432C@pdsmsx502.ccr.corp.intel.com>
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F0@pdsmsx502.ccr.corp.intel.com>
 <20080927125927.GL27204@parisc-linux.org>
In-Reply-To: <20080927125927.GL27204@parisc-linux.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 27, 2008 8:59 PM, Matthew Wilcox wrote:
>On Sat, Sep 27, 2008 at 04:27:44PM +0800, Zhao, Yu wrote:
>> Export some functions and move some macros from c file to header file.
>
>That's absolutely not everything this patch does.  You need to split
>this into smaller pieces and explain what you're doing and why for each
>of them.

Sure, I'll split it.

>
>> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
>> index d807cd7..596efa6 100644
>> --- a/drivers/pci/pci.h
>> +++ b/drivers/pci/pci.h
>> @@ -1,3 +1,9 @@
>> +#ifndef DRIVERS_PCI_H
>> +#define DRIVERS_PCI_H
>
>Do we really need header guards on this file?

Maybe it's not necessary, but we use guards in almost all private headers. So I added this to make this file look not so different.

>
>> -/*
>> - * If the type is not unknown, we assume that the lowest bit is 'enable'.
>> - * Returns 1 if the BAR was 64-bit and 0 if it was 32-bit.
>> +/**
>> + * pci_read_base - read a PCI BAR
>> + * @dev: the PCI device
>> + * @type: type of the BAR
>> + * @res: resource buffer to be filled in
>> + * @pos: BAR position in the config space
>> + *
>> + * Returns 1 if the BAR is 64-bit, or 0 if 32-bit.
>>   */
>> -static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>> +int pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>
>The original intent here was to have a pci_read_base() that called
>__pci_read_base() and then did things like translate physical BAR
>addresses to virtual ones.  That patch is in the archives somewhere.
>We ended up not including that patch because my user found out he could
>get the address he wanted from elsewhere.  I'm not sure we want to
>remove the __ at this point.

I've studied your patch that adds wrapper of __pci_read_base. If you are going to push it again, I'm ok with keeping the name unchanged.

>
>The eventual goal is to fix up the BARs at this point, but there's
>several architectures that will break if we do this now.  It's on my
>long-term todo list.
>
>>                         struct resource *res, unsigned int pos)
>>  {
>>         u32 l, sz, mask;
>>
>> -       mask = type ? ~PCI_ROM_ADDRESS_ENABLE : ~0;
>> +       mask = (type == pci_bar_rom) ? ~PCI_ROM_ADDRESS_ENABLE : ~0;
>
>What's going on here?  Why are you adding pci_bar_rom?  For the rom we
>use pci_bar_mem32.  Take a look at, for example, the MCHBAR in the 965
>spec (313053.pdf).  That's something that uses the pci_bar_mem64 type
>and definitely wants to use the PCI_ROM_ADDRESS_ENABLE mask.

Thanks for pointing this out. I wonder how the PC_ROM_ADDRESS_ENABLE mask is set for those non-standard BARs like MCHBAR after the probe stage -- I don't think pci_update_resource will take care of them. So how about adding BAR type checking again pci_bar_mem32 in pci_update_resource so we can set the bit there?

>
>>
>> -       if (type == pci_bar_unknown) {
>> +       if (type == pci_bar_rom) {
>> +               res->flags |= (l & IORESOURCE_ROM_ENABLE);
>> +               l &= PCI_ROM_ADDRESS_MASK;
>> +               mask = (u32)PCI_ROM_ADDRESS_MASK;
>> +       } else {
>
>This looks wrong too.
>
>>         if (rom) {
>> @@ -344,7 +340,7 @@ static void pci_read_bases(struct pci_dev *dev, unsigned
>int howmany, int rom)
>>                 res->flags = IORESOURCE_MEM | IORESOURCE_PREFETCH |
>>                                 IORESOURCE_READONLY | IORESOURCE_CACHEABLE
>|
>>                                 IORESOURCE_SIZEALIGN;
>> -               __pci_read_base(dev, pci_bar_mem32, res, rom);
>> +               pci_read_base(dev, pci_bar_mem32, res, rom);
>>         }
>
>And you don't even change the type here ... have you tested this code on
>a system which has a ROM?

Oh, you caught it.

>
>>
>> -       for(i=0; i<3; i++)
>> -               child->resource[i] =
>&dev->resource[PCI_BRIDGE_RESOURCES+i];
>> -
>
>Er, this is rather important.  Why can you just delete it?

I guess pci_alloc_child_bus has done this so we don't have to do it again.

>
>--
>Matthew Wilcox                          Intel Open Source Technology Centre
>"Bill, look, we understand that you're interested in selling us this
>operating system, but compare it to ours.  We can't possibly take such
>a retrograde step."
>--
>To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
