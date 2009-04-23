Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbZDWPQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbZDWPQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759209AbZDWPPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:15:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:38980 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759207AbZDWPPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:15:06 -0400
Message-ID: <49F08580.9050407@kernel.org>
Date: Thu, 23 Apr 2009 08:13:04 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [RFC PATCH 1/2] pci: don't assume pref memio are 64bit -v3
References: <20090419090208.GA30211@elte.hu> <20090419090615.GA30631@elte.hu> <20090420223305.GA15340@jurassic.park.msu.ru> <49ED0EBC.4070901@kernel.org> <20090421105629.GB17904@jurassic.park.msu.ru> <49EF9C10.6090107@kernel.org> <20090422154900.08f8f366@hobbes> <49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes> <49EFCE15.3030605@kernel.org> <20090423132202.GB13984@jurassic.park.msu.ru>
In-Reply-To: <20090423132202.GB13984@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> On Wed, Apr 22, 2009 at 07:10:29PM -0700, Yinghai Lu wrote:
>> also on AMD system with two ht chain, or other system with pci=use_crs to get correct root default res,
>> will get anonying
>>
>> PCI: allocations above 4G disabled
>>
>> even the system does support that.
> 
> Yep, but it's easy to fix (patch applies on the top of the previous one).

another case: one system with 8g ram install, one device on bus 0 does get res assigned, but one res from it does support
64bit mmio. and at that case the assign_unassigned code still could assign 64 res to it.
but kernel will still print out that warning.

> 
>> also will have problem with some calling like request_resource(&iomem_resource, ....)
> 
> I don't think so. All critical resources are inserted much earlier than
> mem64 one, and request_resource(&iomem_resource, ...) at later stages
> would most likely fail regardless of mem64 thing.
> Or am I missing something?

at least the one in mm/memory_hotplug.c

/* add this memory to iomem resource */
static struct resource *register_memory_resource(u64 start, u64 size)
{
        struct resource *res;
        res = kzalloc(sizeof(struct resource), GFP_KERNEL);
        BUG_ON(!res);

        res->name = "System RAM";
        res->start = start;
        res->end = start + size - 1;
        res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
        if (request_resource(&iomem_resource, res) < 0) {
                printk("System RAM resource %llx - %llx cannot be added\n",
                (unsigned long long)res->start, (unsigned long long)res->end);
                kfree(res);
                res = NULL;
        }
        return res;
}



> 
> Ivan.
> 
> diff --git a/arch/x86/pci/dac_64bit.c b/arch/x86/pci/dac_64bit.c
> index ee03c4a..35ffee3 100644
> --- a/arch/x86/pci/dac_64bit.c
> +++ b/arch/x86/pci/dac_64bit.c
> @@ -33,12 +33,16 @@ void pcibios_pci64_setup(void)
>  void pcibios_pci64_verify(void)
>  {
>  	struct pci_bus *b;
> +	int disabled = 0;
>  
>  	if (mem64.flags & IORESOURCE_MEM64)
>  		return;		/* presumably DAC works */
>  	list_for_each_entry(b, &pci_root_buses, node) {
> -		if (b->resource[2] == &mem64)
> +		if (b->resource[2] == &mem64) {
>  			b->resource[2] = NULL;
> +			disabled = 1;
> +		}
>  	}
> -	printk(KERN_INFO "PCI: allocations above 4G disabled\n");
> +	if (disabled)
> +		printk(KERN_INFO "PCI: allocations above 4G disabled\n");
>  }

