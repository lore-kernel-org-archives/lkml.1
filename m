Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbXEVXVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbXEVXVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757546AbXEVXVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:21:09 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:34484 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbXEVXVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:21:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=S2lxUgEP7ma8yi78h5hKCn+VzuLM3ess1Y4BS9C0a2O4acLvKYPm/5lGd0HZWNzRDAiJosaoTWwWNTTP6yIGhy3qaoPfvPWLuGB819z5QTeqo7I7kleFyTPUtt3Iu81hSylOfBN4wj3pAj48zDwJm3u2Bxf6mviApy1MCl62WtE=
Message-ID: <46537ADE.1060103@gmail.com>
Date: Tue, 22 May 2007 16:21:02 -0700
From: Wayne Sherman <wsherman@gmail.com>
Organization: System Design Works
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: PCI device problem - MMCONFIG, cannot allocate resource region,
 resource collisions
References: <46524A6D.5050601@gmail.com> <200705211903.46678.jbarnes@virtuousgeek.org> <46525710.7050803@gmail.com> <200705220858.51604.jbarnes@virtuousgeek.org>
In-Reply-To: <200705220858.51604.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> Can you dump the memory BAR for this device?  I guess lspci hides it by 
> default.  You may also be able to see it using 'od -t 
> x4 /sys/devices/pci0000\:00/0000:02:02.0/config'.

The D-Link NIC is sitting behind this bridge:
   "00:14.4 PCI bridge: ATI Technologies Inc SB600 PCI to PCI Bridge"

These are the devices behind the bridge:
0000:02:00.0 - FireWire (IEEE 1394): VIA Technologies,
	Inc. IEEE 1394 Host Controller (rev c0)
0000:02:02.0 - D-Link NIC
0000:02:06.0 - Ethernet controller: Realtek Semiconductor Co., Ltd.
	Unknown device 8167 (rev 10)

Here is the D-LINK NIC:
# od -t x4 /sys/devices/pci0000:00/0000:00:14.4/0000:02:02.0/config

0000000 49011186 80b00117 00000011 00004010
0000020 fd5f8000 0000b801 00000000 00000000
0000040 00000000 00000000 00000000 49011186
0000060 fd5c0000 00000048 00000000 1d17010b
0000100 05f00000 01a08000 fc025001 11002000
0000120 80000003 01000000 01040000 00000000
0000140 00000000 00000000 00000000 00000000

# cat /sys/devices/pci0000:00/0000:00:14.4/0000:02:02.0/resource
0x0000000000000000 0x0000000000003fff 0x0000000000000200
0x000000000000b800 0x000000000000b8ff 0x0000000000000101
0x0000000000000000 0x0000000000000000 0x0000000000000000
0x0000000000000000 0x0000000000000000 0x0000000000000000
0x0000000000000000 0x0000000000000000 0x0000000000000000
0x0000000000000000 0x0000000000000000 0x0000000000000000
0x0000000000000000 0x000000000001ffff 0x0000000000007200

In that same folder, "resource0" is 16384 bytes long and "resource1" is 
256 bytes.

I assume my error "Cannot allocate resource region 0" refers to the 
first base address register (config space offset 0x10).  That value 
indicates it is supposed to be memory mapped at address 0xfd5f8000.  I 
am guessing here, but does the length of "resource0" represent how long 
this region is supposed to be (16384 bytes)?

Now looking at the system memory map:
# cat /proc/iomem
00000000-00097fff : System RAM
00098000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cefff : Video ROM
000cf000-000cffff : Adapter ROM
000f0000-000fffff : System ROM
00100000-3dfbffff : System RAM
   00100000-003dd103 : Kernel code
   003dd104-004de0ff : Kernel data
3dfc0000-3dfcdfff : ACPI Tables
3dfce000-3dffffff : ACPI Non-volatile Storage
40000000-400fffff : PCI Bus #02
   40000000-4001ffff : 0000:02:06.0
fab00000-feafffff : PCI Bus #01		<<< offending memory region
   fc000000-fdffffff : 0000:01:05.0	<<< offending memory region
fed00000-fed003ff : HPET 2
ff400000-ff4fffff : PCI Bus #01
   ff4c0000-ff4dffff : 0000:01:05.0
   ff4f0000-ff4fffff : 0000:01:05.0
ff500000-ff5fffff : PCI Bus #02
   ff5ff400-ff5ff4ff : 0000:02:06.0
     ff5ff400-ff5ff4ff : r8169
   ff5ff800-ff5fffff : 0000:02:00.0
     ff5ff800-ff5fffff : ohci1394
ff6fa000-ff6fafff : 0000:00:13.4
   ff6fa000-ff6fafff : ohci_hcd
ff6fb000-ff6fbfff : 0000:00:13.3
   ff6fb000-ff6fbfff : ohci_hcd
ff6fc000-ff6fcfff : 0000:00:13.2
   ff6fc000-ff6fcfff : ohci_hcd
ff6fd000-ff6fdfff : 0000:00:13.1
   ff6fd000-ff6fdfff : ohci_hcd
ff6fe000-ff6fefff : 0000:00:13.0
   ff6fe000-ff6fefff : ohci_hcd
ff6ff800-ff6ff8ff : 0000:00:13.5
   ff6ff800-ff6ff8ff : ehci_hcd
ff6ffc00-ff6fffff : 0000:00:12.0
   ff6ffc00-ff6fffff : ahci
ff780000-ffffffff : reserved

So these devices are already occupying the space that the D-Link wants:

00:01.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
01:05.0 VGA compatible controller: ATI Technologies Inc RS482 [Radeon 
Xpress 200]

But, the D-Link NIC is behind the bridge at
	ff500000-ff5fffff : PCI Bus #02

Is a PCI device behind a bridge supposed to be mapped into memory that 
its bridge encompasses?  If so, the D-Link is not being mapped into the 
right region, and the bridge it is behind does not have enough memory 
assigned to it (ff500000-ff5fffff : PCI Bus #02).

Thanks,

Wayne
