Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbZHCRHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbZHCRHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZHCRHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:07:20 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:42705 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZHCRHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:07:18 -0400
Date: Mon, 3 Aug 2009 18:59:09 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
Message-ID: <20090803165909.GA12824@roarinelk.homelinux.net>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Sun, Aug 02, 2009 at 09:39:58AM -0700, Linus Torvalds wrote:
> ---
>  drivers/pci/setup-res.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index b711fb7..1898c7b 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -100,16 +100,16 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
>  {
>  	struct resource *res = &dev->resource[resource];
>  	struct resource *root;
> -	char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
>  	int err;
>  
>  	root = pci_find_parent_resource(dev, res);
>  
>  	err = -EINVAL;
>  	if (root != NULL)
> -		err = insert_resource(root, res);
> +		err = request_resource(root, res);
>  
>  	if (err) {
> +		const char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
>  		dev_err(&dev->dev, "BAR %d: %s of %s %pR\n",
>  			resource,
>  			root ? "address space collision on" :
> --


This patch introduces a warning on my system:

pci 0000:02:03.0: BAR 6: address space collision on of device [0xff680000-0xff69ffff]

Below are iomem and pci dev info in the bad and good cases (good = patch reverted).
This isn't fatal here:  the e1000's disabled expansion rom gets reassigned to elsewhere.

warning case:

00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved  
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000e0000-000fffff : reserved 
  000f0000-000fffff : System ROM
00100000-3ff3ffff : System RAM  
  01000000-013a4d48 : Kernel code
  013a4d49-0155bb93 : Kernel data
  0159c000-015f054b : Kernel bss 
3ff40000-3ff4ffff : ACPI Tables  
3ff50000-3fffffff : ACPI Non-volatile Storage
40000000-400003ff : 0000:00:1f.1
44000000-47ffffff : PCI CardBus 0000:03
48000000-4bffffff : PCI CardBus 0000:03
ce900000-de9fffff : PCI Bus 0000:01
  d0000000-d7ffffff : 0000:01:00.0 
dea00000-deafffff : PCI Bus 0000:02
  dea00000-dea1ffff : 0000:02:03.0 
e0000000-efffffff : 0000:00:00.0   
fec00000-fec00fff : pnp 00:09      
fee00000-fee00fff : pnp 00:09      
ff500000-ff5fffff : PCI Bus 0000:01
  ff5c0000-ff5dffff : 0000:01:00.0 
  ff5f0000-ff5fffff : 0000:01:00.0 
ff600000-ff6fffff : PCI Bus 0000:02
  ff600000-ff600fff : 0000:02:01.0 
    ff600000-ff600fff : yenta_socket
  ff6a0000-ff6bffff : 0000:02:03.0  
    ff6a0000-ff6bffff : e1000
  ff6c0000-ff6dffff : 0000:02:03.0
    ff6c0000-ff6dffff : e1000
  ff6f7000-ff6f7fff : 0000:02:04.0
    ff6f7000-ff6f7fff : ohci_hcd  
  ff6f8000-ff6fbfff : 0000:02:01.2
  ff6fc000-ff6fcfff : 0000:02:04.1
    ff6fc000-ff6fcfff : ohci_hcd  
  ff6fd000-ff6fdfff : 0000:02:02.0
    ff6fd000-ff6fdfff : ipw2200   
  ff6fe400-ff6fe4ff : 0000:02:04.2
    ff6fe400-ff6fe4ff : ehci_hcd  
  ff6fe800-ff6fefff : 0000:02:01.2
    ff6fe800-ff6fefff : firewire_ohci
  ff6ff000-ff6fffff : 0000:02:01.3   
ff7ff400-ff7ff4ff : 0000:00:1f.5     
  ff7ff400-ff7ff4ff : Intel 82801DB-ICH4
ff7ff800-ff7ff9ff : 0000:00:1f.5
  ff7ff800-ff7ff9ff : Intel 82801DB-ICH4
ff7ffc00-ff7fffff : 0000:00:1d.7
  ff7ffc00-ff7fffff : ehci_hcd  
ff800000-ffbfffff : pnp 00:08   
ffc00000-ffffffff : pnp 00:08

02:03.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet Controller
        Subsystem: Sony Corporation Device 818e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (63750ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 9
        Region 0: Memory at ff6c0000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at ff6a0000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at dc00 [size=64]
        Expansion ROM at dea00000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2   
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [e4] PCI-X non-bridge device
                Command: DPERE- ERO+ RBC=512 OST=1
                Status: Dev=00:00.0 64bit- 133MHz- SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=8 RSCEM- 266MHz- 533MHz-
        Kernel driver in use: e1000



And in the working case (the patch reverted):

00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved  
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000e0000-000fffff : reserved 
  000f0000-000fffff : System ROM
00100000-3ff3ffff : System RAM  
  01000000-013a4d48 : Kernel code
  013a4d49-0155bb93 : Kernel data
  0159c000-015f054b : Kernel bss 
3ff40000-3ff4ffff : ACPI Tables  
3ff50000-3fffffff : ACPI Non-volatile Storage
40000000-400003ff : 0000:00:1f.1
44000000-47ffffff : PCI CardBus 0000:03
48000000-4bffffff : PCI CardBus 0000:03
ce900000-de9fffff : PCI Bus 0000:01
  d0000000-d7ffffff : 0000:01:00.0 
dea00000-deafffff : PCI Bus 0000:02
e0000000-efffffff : 0000:00:00.0   
fec00000-fec00fff : pnp 00:09      
fee00000-fee00fff : pnp 00:09      
ff500000-ff5fffff : PCI Bus 0000:01
  ff5c0000-ff5dffff : 0000:01:00.0 
  ff5f0000-ff5fffff : 0000:01:00.0 
ff600000-ff6fffff : PCI Bus 0000:02
  ff600000-ff600fff : 0000:02:01.0 
    ff600000-ff600fff : yenta_socket
  ff680000-ff69ffff : 0000:02:03.0  
  ff6a0000-ff6bffff : 0000:02:03.0  
    ff6a0000-ff6bffff : e1000
  ff6c0000-ff6dffff : 0000:02:03.0
    ff6c0000-ff6dffff : e1000
  ff6f7000-ff6f7fff : 0000:02:04.0
    ff6f7000-ff6f7fff : ohci_hcd  
  ff6f8000-ff6fbfff : 0000:02:01.2
  ff6fc000-ff6fcfff : 0000:02:04.1
    ff6fc000-ff6fcfff : ohci_hcd  
  ff6fd000-ff6fdfff : 0000:02:02.0
    ff6fd000-ff6fdfff : ipw2200   
  ff6fe400-ff6fe4ff : 0000:02:04.2
    ff6fe400-ff6fe4ff : ehci_hcd  
  ff6fe800-ff6fefff : 0000:02:01.2
    ff6fe800-ff6fefff : firewire_ohci
  ff6ff000-ff6fffff : 0000:02:01.3   
ff7ff400-ff7ff4ff : 0000:00:1f.5     
  ff7ff400-ff7ff4ff : Intel 82801DB-ICH4
ff7ff800-ff7ff9ff : 0000:00:1f.5
  ff7ff800-ff7ff9ff : Intel 82801DB-ICH4
ff7ffc00-ff7fffff : 0000:00:1d.7
  ff7ffc00-ff7fffff : ehci_hcd  
ff800000-ffbfffff : pnp 00:08   
ffc00000-ffffffff : pnp 00:08

02:03.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet Controller
        Subsystem: Sony Corporation Device 818e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (63750ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 9
        Region 0: Memory at ff6c0000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at ff6a0000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at dc00 [size=64]
        Expansion ROM at ff680000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2   
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [e4] PCI-X non-bridge device
                Command: DPERE- ERO+ RBC=512 OST=1
                Status: Dev=00:00.0 64bit- 133MHz- SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=8 RSCEM- 266MHz- 533MHz-
        Kernel driver in use: e1000


Thanks!
	Manuel Lauss
