Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYFYGE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYFYGE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 02:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYFYGES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 02:04:18 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:14306 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYFYGER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 02:04:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ITBRzUQDKBHUgarYeLr7X5rCm1ehUH58Y5c7x21D8eGn1JKjTGFUc3yLVSH7MMgG8J
         ei294fGo9tZKpycYov/qXMlsaMlfBYvr0CwhD53fPOCS9g8s8AubbG2rh+4YkwRLVqLz
         hSpiucdPKkPpg1A04RNP50Br4sDQ6vX7jGUyI=
Message-ID: <35f686220806242304q43987059xb203dd1ac75b7583@mail.gmail.com>
Date: Tue, 24 Jun 2008 23:04:13 -0700
From: "Alok kataria" <alokkataria1@gmail.com>
To: "Zhao Yakui" <yakui.zhao@intel.com>
Subject: Re: [PATCH 2/2] acpi based pci gap caluculation v2
Cc: akataria@vmware.com, lenb@kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1214372365.9800.42.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214333326.27577.28.camel@promb-2n-dhcp368.eng.vmware.com>
	 <1214362159.9800.28.camel@yakui_zhao.sh.intel.com>
	 <35f686220806242117p4a442982hb459a6b76312f391@mail.gmail.com>
	 <1214372365.9800.42.camel@yakui_zhao.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yakui,

On Tue, Jun 24, 2008 at 10:39 PM, Zhao Yakui <yakui.zhao@intel.com> wrote:
> On Tue, 2008-06-24 at 21:17 -0700, Alok kataria wrote:
>> On Tue, Jun 24, 2008 at 7:49 PM, Zhao Yakui <yakui.zhao@intel.com> wrote:
>> > On Tue, 2008-06-24 at 11:48 -0700, Alok Kataria wrote:
>> >> Evaluates the _CRS object under PCI0 looking for producer resources.
>> >> Then searches the e820 memory space for a gap within these producer resources.
>> >>
>> >> Allows us to find a gap for the unclaimed pci resources or MMIO resources
>> >> for hotplug devices within the BIOS allowed pci regions.
>> >>
>> > It seems reasonable.
>> > But if the resource obtained from the PCI0 _CRS method is incorrect, we
>> > will get the incorrect pci_mem_start.
>>
>> Hi Yakui,
>>
>> What do you mean by the PCI0 _CRS being incorrect ? Why would the BIOS
>> give a incorrect _CRS object ?
>> Also we don't just take the value given from the _CRS method, we still
>> read the e820_map to search for an unallocated resource. So even if
>> (by chance) the _CRS method returns incorrect value we would still
>> figure out if there is a collision with an already allocated resource.
> In the patch the address obtained from the _CRS object will be passed
> into the function of e820_search_gap. In such case maybe we will get the
> pci_mem_start different with the e820_setup_gap.

True..the whole idea behind doing this patch was to get a correct
(different) value for pci_mem_start.
We read the _CRS object over here to make sure that we assign the
pci_mem_start from the address range which is reserved by the BIOS for
PCI devices.

Also this reading of _CRS object would be done before we start
initializing the pci devices, i.e. before we start using the value of
pci_mem_start, so the original value assigned by pci_setup_gap is just
overwritten by this function. So that should be fine IMHO.
Also we would still want the call for e820_setup_gap because there can
be systems with no acpi support or acpi disabled


>
>> >
>> > At the same time after the patch is applied, pci_mem_start will be
>> > parsed in two different ways.
>>
>> Yes pci_mem_start would be initialized in 2 different ways but we
>> still have to parse the e820_map the old way because there could be
>> systems without ACPI.
>>
>> > If the result is different, maybe the
>> > incorrect pci_mem_start will be used.
>>
>> Yeah, The result is different in my case. Though my BIOS reserves
>> hotpluggable memory region, kernel doesn't respect that right now and
>> just parses the e820_map to calculate the gap and pci_mem_start value.
>> I have explained the problem in this mail.
>>
>> http://marc.info/?l=linux-acpi&m=121391675711763&w=2
>>
>> Maybe nobody has seen this problem yet, because there are no systems
>> out there with less than 4GB memory to start with and which allow
>> memory hotplug.
>>
>> But still i don't understand what do you mean by, we can get incorrect
>> pci_mem_start, in which case ?
>
> In the function of setup_arch the pci_mem_start will be parsed by
> searching the e820 table.  After the patch is applied, we will parse the
> pci_mem_start again in the function of pci_acpi_scan_init and it will
> override the value parsed in the function of setup_arch. If the
> pci_mem_start is incorrect in the second case, maybe it will have side
> effect.

Yes it will override. But how can the value be incorrect in the second
case. As explained in my previous mail we still parse the e820_map to
check if we have unclaimed resources between start_address (that read
from  _CRS) to 2^32.  So even if this start_address is wrong we would
catch that during parsing e820_map. But again why would the _CRS
return incorrect values, are you talking about errors in BIOS ?

Thanks,
Alok
