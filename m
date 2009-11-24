Return-Path: <linux-kernel-owner+w=401wt.eu-S934114AbZKXVYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114AbZKXVYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933441AbZKXVYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:24:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:53673 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933426AbZKXVYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:24:13 -0500
Message-ID: <4B0C4E69.4090402@kernel.org>
Date: Tue, 24 Nov 2009 13:21:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Yu Zhao <yu.zhao@intel.com>, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] x86/pci: claim SR-IOV bar in pcibios_allocate_resource
References: <4AFFB1E6.9040300@kernel.org> <20091124131912.2aabb852@jbarnes-piketon>
In-Reply-To: <20091124131912.2aabb852@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Sat, 14 Nov 2009 23:46:46 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> so use correct allocation from BIOS, instead of later assign another
>> one.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/pci/i386.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6/arch/x86/pci/i386.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/pci/i386.c
>> +++ linux-2.6/arch/x86/pci/i386.c
>> @@ -155,7 +155,9 @@ static void __init pcibios_allocate_reso
>>  
>>  	for_each_pci_dev(dev) {
>>  		pci_read_config_word(dev, PCI_COMMAND, &command);
>> -		for (idx = 0; idx < PCI_ROM_RESOURCE; idx++) {
>> +		for (idx = 0; idx < PCI_BRIDGE_RESOURCES; idx++) {
>> +			if (idx == PCI_ROM_RESOURCE)
>> +				continue;
>>  			r = &dev->resource[idx];
>>  			if (r->parent)		/* Already
>> allocated */ continue;
> 
> I'm worried this might have side effects beyond just allocating SR-IOV
> BARs, since it looks like we'll walk through all the bridge resources
> all the time?

/*
 *  For PCI devices, the region numbers are assigned this way:
 */
enum {
        /* #0-5: standard PCI resources */
        PCI_STD_RESOURCES,
        PCI_STD_RESOURCE_END = 5,

        /* #6: expansion ROM resource */
        PCI_ROM_RESOURCE,

        /* device specific resources */
#ifdef CONFIG_PCI_IOV
        PCI_IOV_RESOURCES,
        PCI_IOV_RESOURCE_END = PCI_IOV_RESOURCES + PCI_SRIOV_NUM_BARS - 1,
#endif

        /* resources assigned to buses behind the bridge */
#define PCI_BRIDGE_RESOURCE_NUM 4

        PCI_BRIDGE_RESOURCES,

so will only add IOV BAR related.

YH
