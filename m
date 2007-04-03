Return-Path: <linux-kernel-owner+w=401wt.eu-S966122AbXDCAO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966122AbXDCAO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 20:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966113AbXDCAO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 20:14:58 -0400
Received: from rwcrmhc15.comcast.net ([204.127.192.85]:65472 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966088AbXDCAO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 20:14:57 -0400
From: "David Sperry" <dave_sperry@ieee.org>
To: "'Ingo Molnar'" <mingo@elte.hu>,
       "'dave_sperry@ieee.org'" <dasperry@comcast.net>
Cc: <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: Poor UDP performance using 2.6.21-rc5-rt5
Date: Mon, 2 Apr 2007 20:09:57 -0400
Message-ID: <001d01c77584$6a92ffe0$7901a8c0@dad>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20070402190445.GB2081@elte.hu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: Acd1Wc1IZ5gQoLn8QJG0wZ2uit9+egAKAyUg
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ingo Molnar [mailto:mingo@elte.hu]
> Sent: Monday, April 02, 2007 3:05 PM
> To: dave_sperry@ieee.org
> Cc: Dave Sperry; linux-rt-users@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: Poor UDP performance using 2.6.21-rc5-rt5
> 
> 
> * dave_sperry@ieee.org <dasperry@comcast.net> wrote:
> 
> > The Intel NIC seems to behave better under RT
> 
> yeah.
> 
> > I think there is some kind of bad behavior happening in the Nvidia
> > driver with respect to softirq-net-tx and IRQ-8406.
> 
> yes. Part of the problem is that the forcedeth.c driver does not fully
> support NAPI - today i've implemented those bits (see them below), based
> on your testcase. The other part is that the Intel NIC uses MSI, while
> foredeth uses fasteoi, correct? [you can see this in /proc/interrupts]

In my case forcedeth seems to be picking up MSI for eth2 & eth3

]$ cat /proc/interrupts
           CPU0       CPU1
  0:        110          0   IO-APIC-edge      timer
  1:          0         10   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          0        124   IO-APIC-edge      i8042
 20:          0          0   IO-APIC-fasteoi   libata
 21:          4       7755   IO-APIC-fasteoi   libata
 22:          0       5570   IO-APIC-fasteoi   ehci_hcd:usb2
 23:          0          1   IO-APIC-fasteoi   ohci_hcd:usb1, libata
8406:          7      15969   PCI-MSI-edge      eth3
8407:          8      17249   PCI-MSI-edge      eth2
8408:          0        131   PCI-MSI-edge      eth1
8409:          0         85   PCI-MSI-edge      eth0
NMI:          0          0
LOC:     201594     202389
ERR:          0

Could this be part of my problem?

The lspci for the device is:

00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a3)
        Subsystem: Super Micro Computer Inc Unknown device 1611
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (250ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 8407
        Region 0: Memory at fe9ba000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at a400 [size=8]
        Region 2: Memory at fe9be800 (32-bit, non-prefetchable) [size=256]
        Region 3: Memory at fe9be400 (32-bit, non-prefetchable) [size=16]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
        Capabilities: [70] MSI-X: Enable- Mask- TabSize=8
                Vector table: BAR=2 offset=00000000
                PBA: BAR=3 offset=00000000
        Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/3
Enable+
                Address: 00000000fee0300c  Data: 41b9
        Capabilities: [6c] HyperTransport: MSI Mapping

00:09.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a3)
        Subsystem: Super Micro Computer Inc Unknown device 1611
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (250ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 8406
        Region 0: Memory at fe9b9000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at a080 [size=8]
        Region 2: Memory at fe9be000 (32-bit, non-prefetchable) [size=256]
        Region 3: Memory at fe9b8c00 (32-bit, non-prefetchable) [size=16]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
        Capabilities: [70] MSI-X: Enable- Mask- TabSize=8
                Vector table: BAR=2 offset=00000000
                PBA: BAR=3 offset=00000000
        Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/3
Enable+
                Address: 00000000fee0300c  Data: 41c1
        Capabilities: [6c] HyperTransport: MSI Mapping


> 
> there are a few other things i'm working on to improve this. I've
> uploaded -rt9 which is the current state of affairs. Note that using
> -rt9 you'll likely only see IRQ-8406 overhead in the system, because
> i've added an optimization to do process the softirq-net-tx workload in
> the hardirq thread if the priority of the two is the same (which is the
> default behavior). But -rt9 is still work in progress that is not fully
> finished yet: in some cases i'm seeing 'fluctuating performance'
> problems on forcedeth that werent there before.

I tried -rt9 and saw some odd 'fluctuating performance'. I'll try it again
tomorrow when I am much closer to the box's power button.

Thanks again,
Dave



> 
> 	Ingo
> 
> --------------------->
> From: Ingo Molnar <mingo@elte.hu>
> Subject: [patch] forcedeth.c: improve NAPI handler
> 
> another forcedeth.c thing: i noticed that its NAPI handler does not do
> tx-ring processing. The patch below implements this - tested on
> DESC_VER_2 hardware, with CONFIG_FORCEDETH_NAPI=y.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Index: linux/drivers/net/forcedeth.c
> ===================================================================
> --- linux.orig/drivers/net/forcedeth.c
> +++ linux/drivers/net/forcedeth.c
> @@ -3118,9 +3118,17 @@ static int nv_napi_poll(struct net_devic
>  	int retcode;
> 
>  	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
> +		spin_lock_irqsave(&np->lock, flags);
> +		nv_tx_done(dev);
> +		spin_unlock_irqrestore(&np->lock, flags);
> +
>  		pkts = nv_rx_process(dev, limit);
>  		retcode = nv_alloc_rx(dev);
>  	} else {
> +		spin_lock_irqsave(&np->lock, flags);
> +		nv_tx_done_optimized(dev, np->tx_ring_size);
> +		spin_unlock_irqrestore(&np->lock, flags);
> +
>  		pkts = nv_rx_process_optimized(dev, limit);
>  		retcode = nv_alloc_rx_optimized(dev);
>  	}

