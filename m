Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687Ab0ANXjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab0ANXjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585Ab0ANXjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:39:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:36997 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756809Ab0ANXjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:39:17 -0500
Message-ID: <4B4FAAE0.7080608@kernel.org>
Date: Thu, 14 Jan 2010 15:38:08 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jeff Garrett <jeff@jgarrett.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] x86/pci: intel ioh need to subtract mmconf range
References: <20100113053736.GA6720@jgarrett.org> <201001141108.03129.bjorn.helgaas@hp.com> <4B4F9ECB.4060805@kernel.org> <201001141609.19290.bjorn.helgaas@hp.com>
In-Reply-To: <201001141609.19290.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 03:09 PM, Bjorn Helgaas wrote:
> On Thursday 14 January 2010 03:46:35 pm Yinghai Lu wrote:
>>
>> Bjorn pointed out we need to remove mmconf range
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/pci/intel_bus.c |   29 +++++++++++++++++++++++++++--
>>  1 file changed, 27 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6/arch/x86/pci/intel_bus.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/pci/intel_bus.c
>> +++ linux-2.6/arch/x86/pci/intel_bus.c
>> @@ -46,6 +46,20 @@ static inline void print_ioh_resources(s
>>  
>>  #define RANGE_NUM 16
>>  
>> +static void __devinit subtract_mmconf(struct range *range, int nr)
>> +{
>> +#ifdef CONFIG_PCI_MMCONFIG
>> +	struct pci_mmcfg_region *cfg;
>> +
>> +	if (list_empty(&pci_mmcfg_list))
>> +		return;
>> +
>> +        list_for_each_entry(cfg, &pci_mmcfg_list, list)
>> +		subtract_range(range, nr, cfg->res.start,
>> +			 cfg->res.end + 1);
>> +#endif
> 
> This can't be right, can it?  Let's say the kernel was built with
> CONFIG_PCI_MMCONFIG turned off, or the user used "pci=nommconf",
> or the kernel decides not to use MMCONFIG for some other reason.
> 
> In that case, the hardware may still be configured to support
> MMCONFIG, but the pci_mmcfg_list will be empty, so your code will
> leave the window alone.  We might assign some of that MMCONFIG
> space to a device, but the hardware will route it to MMCONFIG,
> not to the device.

so if there is mmconf specified, we just skip the whole function?

YH
