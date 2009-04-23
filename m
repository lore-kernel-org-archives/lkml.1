Return-Path: <linux-kernel-owner+w=401wt.eu-S932333AbZDWWTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbZDWWTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbZDWWTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:19:21 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:46551 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbZDWWTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:19:20 -0400
Date: Fri, 24 Apr 2009 02:19:36 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [RFC PATCH 1/2] pci: don't assume pref memio are 64bit -v3
Message-ID: <20090423221936.GA24171@jurassic.park.msu.ru>
References: <20090420223305.GA15340@jurassic.park.msu.ru> <49ED0EBC.4070901@kernel.org> <20090421105629.GB17904@jurassic.park.msu.ru> <49EF9C10.6090107@kernel.org> <20090422154900.08f8f366@hobbes> <49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes> <49EFCE15.3030605@kernel.org> <20090423132202.GB13984@jurassic.park.msu.ru> <49F08580.9050407@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F08580.9050407@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 08:13:04AM -0700, Yinghai Lu wrote:
> at least the one in mm/memory_hotplug.c
> 
> /* add this memory to iomem resource */
> static struct resource *register_memory_resource(u64 start, u64 size)
> {
>         struct resource *res;
>         res = kzalloc(sizeof(struct resource), GFP_KERNEL);
>         BUG_ON(!res);
> 
>         res->name = "System RAM";
>         res->start = start;
>         res->end = start + size - 1;
>         res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
>         if (request_resource(&iomem_resource, res) < 0) {
>                 printk("System RAM resource %llx - %llx cannot be added\n",
>                 (unsigned long long)res->start, (unsigned long long)res->end);
>                 kfree(res);
>                 res = NULL;
>         }
>         return res;
> }

Indeed. It's a really strong argument against mem64 resource approach.

On the other hand, it shows that getting 64-bit allocations right is
indeed a very complex issue - without well defined root bus ranges
there is a high risk of unexpectedly breaking something, like that memory
hotplug. Oh well...

So if the main purpose is to prevent 32-bit allocations in the DAC
area, some mix of your v2 and v3 patches seems to be the way to go.
That is

- keep IORESOURCE_MEM_64 bits from -v3, but drop iomem32_resource
and iomem64_resource things;

- pass "max" argument to allocate_resource() like you did in -v2,
but *only* then allocating from iomem_resource (r == &iomem_resource).
Also, instead of max = 0xffffffff use something like max = PCIBIOS_MAX_MEM_32.

include/linux/pci.h:
#ifndef PCIBIOS_MAX_MEM_32
#define PCIBIOS_MAX_MEM_32	(-1)
#endif

This should preserve the current behaviour of pci_bus_alloc_resource()
on non-x86 arches; overridden in arch/x86/include/asm/pci.h:
#define PCIBIOS_MAX_MEM_32	0xffffffff

> check bits 0-3 and check PCI_PREF_BASE_UPPER32 register being r/w ?

Yes. If these bits are zero, no further checks are needed -
bridge is 32-bit. If they aren't, do additional check for
PCI_PREF_BASE_UPPER32 being non-zero or writable, but *only*
if this prefetch resource is not already allocated (res->parent == NULL),
just for safety reasons - we don't want to disconnect the allocated
range from the bus even for a short time.

Ivan.
