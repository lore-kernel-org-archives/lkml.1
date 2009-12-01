Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZLAC1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZLAC1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 21:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZLAC1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 21:27:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:39610 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZLAC1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 21:27:30 -0500
Message-ID: <4B147EE0.8080209@kernel.org>
Date: Mon, 30 Nov 2009 18:26:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Always set prefetchable base/limit upper32 registers
References: <20091130212228.7555.43533.stgit@debian.lart>	 <4B143AE5.7040702@kernel.org> <1259617381.8949.281.camel@8530w.home>	 <4B143E83.6020105@kernel.org> <1259618496.8949.290.camel@8530w.home>	 <4B144346.50608@kernel.org> <1259619578.8949.295.camel@8530w.home>	 <4B1455FD.90002@kernel.org> <1259625224.8949.319.camel@8530w.home>	 <4B145C9D.70601@kernel.org> <1259632564.10482.10.camel@2710p.home>
In-Reply-To: <1259632564.10482.10.camel@2710p.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Williamson wrote:
> On Mon, 2009-11-30 at 16:00 -0800, Yinghai Lu wrote:
>> Alex Williamson wrote:
>>  
>>> Ah, I think I see where you're going.  We only set IORESOURCE_MEM_64 if
>>> base <= limit, ie. the BIOS has programmed the prefetchable range.  This
>>> is not a requirement by the PCI spec.  In my case the BIOS has left base
>>>> limit, just as Linux would do if it disabled the range, so we never
>>> set this flag.
>>>
>>>> setup-bus.c::pci_bridge_check_ranges()
>>> This is only checking that the upper 32bits is actually implemented,
>>> should we have already set the IORESOURCE_MEM_64 from the function
>>> above, which we haven't.  
>>>
>>> So, in my case I have a 64bit capable prefetchable range, that the BIOS
>>> has not programmed and is not required to program.  We assign it to a
>>> 32bit window, and never touch the UPPER32 registers.
>> no.
>>
>> before assign range to that resource.
>> pci_bridge_check_ranges is called, it will check those two bit to make sure that is set correcly
>>
>>         if (pmem) {
>>                 b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
>>                 if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64)
>>                         b_res[2].flags |= IORESOURCE_MEM_64;
>>         }
> 
> Ok, sorry I missed this.  Yes, this is getting called, but when we get
> back to pci_setup_bridge() that flag is missing IORESOURCE_MEM_64.
> Perhaps these are different resources?  I'm still tracing the code to
> find out what happened to that flag.
> 
> Also, I'm running 64bit(x86_64), and if lspci is wrong, then so is
> setpci.  I don't think there's an "ignore upper32" anywhere, so the
> result of 0xffffffffabc00000 - 0x00000000abc00000 is that base > limit
> thus the range is disabled at the bridge and the ROM resource we
> assigned into the window behind the bridge is inaccessible.

can you check

---
 drivers/pci/setup-bus.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -397,10 +397,17 @@ static void pci_bridge_check_ranges(stru
 		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
 					       0xffffffff);
 		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &tmp);
-		if (!tmp)
+		if (!tmp) {
 			b_res[2].flags &= ~IORESOURCE_MEM_64;
-		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
-				       mem_base_hi);
+			dev_info(&bridge->dev, "%pR MEM_64 clearred\n", &b_res[2]);
+			/* not sure if we can clear it */
+			pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
+						 0);
+			pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32,
+						 0);
+		} else
+			pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
+					       mem_base_hi);
 	}
 }
 
