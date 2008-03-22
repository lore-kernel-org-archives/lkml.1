Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbYCVTEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbYCVTEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 15:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYCVTDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 15:03:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53973 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbYCVTDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 15:03:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E557D5.9020604@s5r6.in-berlin.de>
Date: Sat, 22 Mar 2008 20:02:45 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de>
In-Reply-To: <47E54FA6.3060809@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Thomas Meyer wrote:
>> Stefan Richter schrieb:
>>>   - Is the "WARNING: at arch/x86/mm/ioremap.c" still there?
>> No. I couldn't reproduce this warning, yet.
>>
>>>   - Can you reproduce it without the atheros driver?
>> Yes.
>>
>> See http://bugzilla.kernel.org/show_bug.cgi?id=10080.
> 
> Thanks.  Summary from today's bugzilla comments:
> No ioremap warning, but MMIO reads still give bogus values and let 
> ohci1394 fail.  ohci1394 still got the MMIO region 0x1'0000'0000 - 
> 0x1'0000'07ff, FWIW.  The length of the region is correct, but its 
> contents bogus.

Can an MMIO region reside above 0x1'0000'0000 on x86-32? ... Apparently 
yes, if CONFIG_RESOURCES_64BIT=y.

 From Thomas' dmesg:
http://bugzilla.kernel.org/attachment.cgi?id=15397

BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000ede00 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000007f0c8000 (usable)
  BIOS-e820: 000000007f0c8000 - 000000007f2c9000 (ACPI NVS)
  BIOS-e820: 000000007f2c9000 - 000000007feb9000 (ACPI data)
  BIOS-e820: 000000007feb9000 - 000000007feef000 (ACPI NVS)
  BIOS-e820: 000000007feef000 - 000000007ff00000 (ACPI data)
  BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
1136MB HIGHMEM available.
896MB LOWMEM available.
...
ACPI: RSDP 000FE020, 0024 (r2 APPLE )
ACPI: XSDT 7FEFD120, 0074 (r1 APPLE   Apple00       55       1000013)
ACPI: FACP 7FEFB000, 00F4 (r3 APPLE   Apple00       55 Loki       5F)
ACPI: DSDT 7FEF0000, 48C0 (r1 APPLE  MacBookP    10001 INTL 20050309)

 From Thomas' .config:
http://bugzilla.kernel.org/attachment.cgi?id=15396
CONFIG_RESOURCES_64BIT=y

I have a Mac mini but run x86-64 on it.  However, I've got another 
i945GM based PC with x86-32 and three OHCI-1394 controllers in it.
I always had CONFIG_RESOURCES_64BIT switched off.  I shall try 
CONFIG_RESOURCES_64BIT=y on that PC.

Thomas, did you use CONFIG_RESOURCES_64BIT=y already under Linux 2.6.24?

All, is there anything special that drivers need to take care of for 
CONFIG_RESOURCES_64BIT=y?

We use resource_size_t ohci_base to request the MMIO region in 
drivers/ieee1394/ohci1394.c::ohci1394_pci_probe().  And we use struct 
ti_ohci::void __iomem *registers to store the MMIO base we get from 
ioremap, and readl(ohci->registers + (int)offset) and writel((u32)data, 
ohci->registers + (int)offset) to peek and poke in them; see 
drivers/ieee1394/ohci1394.h.
-- 
Stefan Richter
-=====-==--- --== =-==-
http://arcgraph.de/sr/
