Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbXHBJRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbXHBJRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbXHBJRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:17:42 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40634 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbXHBJRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:17:40 -0400
X-Greylist: delayed 1218 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2007 05:17:40 EDT
Date: Thu, 2 Aug 2007 11:57:21 +0300 (EEST)
From: Timo Jantunen <jeti@welho.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.22.1: hang with forcedeth driver?
Message-ID: <Pine.LNX.4.64.0708021044260.6069@limbo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heip!

I have had few total hangs with 2.6.22.1 kernel. Everything suddenly 
freezes and nothing works (SysRq keys, pinging the machine from the 
network.) Neither syslog nor netconsole have any relevant messages. I'm 99% 
sure this didn't happen in 2.6.21.x kernels.

All hangs happened with relatively high network traffic (twice with mplayer 
using remote display, once with high network fs activity). I copied 
gigabytes of files over nfs but couldn't dupicatate the problem that way, 
but OTOH I have also watched hours of video without problems so the problem 
doesn't occur often. (In the mplayer case, the file I play is usually on 
remote nfs disk, too.)

I started using mplayer from a text console and today I finally managed to 
catch first bit of information. The machine hanged like before (even SysRq 
keys don't print anything) but there was one console message:

eth0: too many iterations (6) in nv_nic_irq.

Looking at the sources, it seems when too much works happens in a single 
interrupt, the driver tries to disable device interrupts (and prints above 
message). It doesn't seem to be expecting the machine to hang afterwards.

I guess the quick fix for me is to increase max_interrupt_work value so it 
doesn't get hit as easily.


I have nForce3 board and Athlon 64 X2 CPU (but using 32-bit kernel). I'm 
using the built in ethernet with forcedeth driver. I also have ATI/AMD 
binary drivers loaded, and at least in some of the cases, VMware host 
drivers, too.


parts of .config (full .config available on request)
===cut
CONFIG_NO_HZ=y
CONFIG_SMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
CONFIG_DETECT_SOFTLOCKUP=y
===cut


lspci
===cut
00:00.0 Host bridge: nVidia Corporation nForce3 250Gb Host Bridge (rev a1)
00:01.0 ISA bridge: nVidia Corporation nForce3 250Gb LPC Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation nForce 250Gb PCI System Management (rev a1)
00:02.0 USB Controller: nVidia Corporation CK8S USB Controller (rev a1)
00:02.1 USB Controller: nVidia Corporation CK8S USB Controller (rev a1)
00:02.2 USB Controller: nVidia Corporation nForce3 EHCI USB 2.0 Controller (rev a2)
00:05.0 Bridge: nVidia Corporation CK8S Ethernet Controller (rev a2)
00:06.0 Multimedia audio controller: nVidia Corporation nForce3 250Gb AC'97 Audio Controller (rev a1)
00:08.0 IDE interface: nVidia Corporation CK8S Parallel ATA Controller (v2.5) (rev a2)
00:09.0 IDE interface: nVidia Corporation CK8S Serial ATA Controller (v2.5) (rev a2)
00:0a.0 IDE interface: nVidia Corporation CK8S Serial ATA Controller (v2.5) (rev a2)
00:0b.0 PCI bridge: nVidia Corporation nForce3 250Gb AGP Host to PCI Bridge (rev a2)
00:0e.0 PCI bridge: nVidia Corporation nForce3 250Gb PCI-to-PCI Bridge (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:00.0 VGA compatible controller: ATI Technologies Inc R420 JP [Radeon X800XT]
01:00.1 Display controller: ATI Technologies Inc R420 [X800XT-PE] (Secondary)
02:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet (rev 10)
===cut

lspci -vvv, only eth0 device
===cut
00:05.0 Bridge: nVidia Corporation CK8S Ethernet Controller (rev a2)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 0250
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fe02c000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at f000 [size=8]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
===cut


//T

