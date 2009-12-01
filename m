Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbZLAABS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbZLAABS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZLAABR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:01:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:58164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbZLAABQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:01:16 -0500
Message-ID: <4B145C9D.70601@kernel.org>
Date: Mon, 30 Nov 2009 16:00:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Always set prefetchable base/limit upper32 registers
References: <20091130212228.7555.43533.stgit@debian.lart>	 <4B143AE5.7040702@kernel.org> <1259617381.8949.281.camel@8530w.home>	 <4B143E83.6020105@kernel.org> <1259618496.8949.290.camel@8530w.home>	 <4B144346.50608@kernel.org> <1259619578.8949.295.camel@8530w.home>	 <4B1455FD.90002@kernel.org> <1259625224.8949.319.camel@8530w.home>
In-Reply-To: <1259625224.8949.319.camel@8530w.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Williamson wrote:
> On Mon, 2009-11-30 at 15:32 -0800, Yinghai Lu wrote:
>> Alex Williamson wrote:
>>> On Mon, 2009-11-30 at 14:12 -0800, Yinghai Lu wrote:
>>>> Alex Williamson wrote: 
>>>>> I don't believe the PCI spec dictates whether the upper 32bit base
>>>>> should be 0 or -1, so it's purely a BIOS initialization choice and Linux
>>>>> should properly handle both.  If the hardware only supports 32bit
>>>>> prefetchable windows, the hardware will drop the write, just as it did
>>>>> for every 2.6 kernel before 1f82de10.  Thanks,
>>>> current code:
>>>>
>>>> #define  PCI_PREF_RANGE_TYPE_MASK 0x0fUL
>>>> #define  PCI_PREF_RANGE_TYPE_32 0x00     
>>>> #define  PCI_PREF_RANGE_TYPE_64 0x01
>>>> #define  PCI_PREF_RANGE_MASK    (~0x0fUL)
>>>>
>>>> if the HW state the pref mmio is 64bit, we will touch upper 32bit. otherwise we will not touch it.
>>> Really, where?  Please paste the code that writes to
>>> PCI_PREF_BASE_UPPER32 in the case of hardware supporting a 64bit
>>> prefetchable window.  I only see this happening if we are assigning it
>>> to an IORESOURCE_MEM_64 resources.
>> IORESOURCE_MEM_64 get set when PCI_PREF_RANGE_TYPE_64 is set.
>>
>> in probe.c::pci_read_bridge_bases()
> 
> Ah, I think I see where you're going.  We only set IORESOURCE_MEM_64 if
> base <= limit, ie. the BIOS has programmed the prefetchable range.  This
> is not a requirement by the PCI spec.  In my case the BIOS has left base
>> limit, just as Linux would do if it disabled the range, so we never
> set this flag.
> 
>> setup-bus.c::pci_bridge_check_ranges()
> 
> This is only checking that the upper 32bits is actually implemented,
> should we have already set the IORESOURCE_MEM_64 from the function
> above, which we haven't.  
> 
> So, in my case I have a 64bit capable prefetchable range, that the BIOS
> has not programmed and is not required to program.  We assign it to a
> 32bit window, and never touch the UPPER32 registers.

no.

before assign range to that resource.
pci_bridge_check_ranges is called, it will check those two bit to make sure that is set correcly

        if (pmem) {
                b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
                if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64)
                        b_res[2].flags |= IORESOURCE_MEM_64;
        }

        /* double check if bridge does support 64 bit pref */
        if (b_res[2].flags & IORESOURCE_MEM_64) {
                u32 mem_base_hi, tmp;
                pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32,
                                         &mem_base_hi);
                pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
                                               0xffffffff);
                pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &tmp);
                if (!tmp)
                        b_res[2].flags &= ~IORESOURCE_MEM_64;
                pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
                                       mem_base_hi);
        }

so even with 32 bit window in 64bit BAR, that upper32 bit still get cleared.

YH
