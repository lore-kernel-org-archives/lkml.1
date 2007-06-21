Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbXFUR1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbXFUR1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbXFUR1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:27:34 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:38821 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753516AbXFUR1d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:27:33 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Broadcom (bnx2) on PE1950/2950 failure
Date: Thu, 21 Jun 2007 13:26:59 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0128A22@ecqcmtlmail3.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Broadcom (bnx2) on PE1950/2950 failure
Thread-Index: Ace0KV+0Tbl0kUMNTMe5BuDPrP5Ckg==
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Jun 2007 17:26:59.0706 (UTC) FILETIME=[5FC9ADA0:01C7B429]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When trying manually to get the on-board broadcom adapter working I get
this:
Jun 21 16:50:47 urpdev1 kernel: [  184.528092] Broadcom NetXtreme II
Gigabit Ethernet Driver bnx2 v1.4.45 (September 29, 2006)
Jun 21 16:50:47 urpdev1 kernel: [  184.539831] ACPI: PCI Interrupt
0000:05:00.0[A] -> GSI 16 (level, low) -> IRQ 17
Jun 21 16:50:48 urpdev1 kernel: [  184.551805] eth0: Broadcom NetXtreme
II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz found at mem f8000000,
IRQ 17, node ad                 dr 0019b9c8eedc
Jun 21 16:50:48 urpdev1 kernel: [  184.576672] ACPI: PCI Interrupt
0000:09:00.0[A] -> GSI 17 (level, low) -> IRQ 16
Jun 21 16:50:48 urpdev1 kernel: [  184.590359] eth0: Broadcom NetXtreme
II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz found at mem f4000000,
IRQ 16, node ad                 dr 0019b9c8eede

Jun 21 16:50:52 urpdev1 dhclient: Internet Systems Consortium DHCP
Client V3.0.1
Jun 21 16:50:52 urpdev1 dhclient: Copyright 2004 Internet Systems
Consortium.
Jun 21 16:50:52 urpdev1 dhclient: All rights reserved.
Jun 21 16:50:52 urpdev1 dhclient: For info, please visit
http://www.isc.org/products/DHCP
Jun 21 16:50:52 urpdev1 dhclient:
Jun 21 16:50:53 urpdev1 dhclient: Bind socket to interface: No such
device

When I invoke "modprobe bnx2" it looks like both adapter fails to
initialise properly reason I think both are trying to bind on eth0
instead of eth0 & eth1.

I've removed the TOE jumper (has read on a gentoo list) with no effect
(except that it really is disabled in the BIOS now).

I've also tried loading the driver using disable_msi=1 option without
any effect.

The problem occurs on all tested kernels (2.6.18.8, 2.6.19.7, 2.6.20.14
& 2.6.21.5)

Here is part of the dmesg:
[root@localhost /root]# dmesg | grep -i eth
[  119.196375] Broadcom NetXtreme II Gigabit Ethernet Driver bnx2
v1.5.8.1 (May 7, 2007)
[  119.215023] eth0: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X
64-bit 133MHz found at mem f8000000, IRQ 17, node addr 0019b9c8eedc
[  119.246853] eth1: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X
64-bit 133MHz found at mem f4000000, IRQ 16, node addr 0019b9c8eede
[  119.458598] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network
Connection
[  119.654095] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network
Connection
[  266.513144] bnx2: eth3: using MSI
[  269.638237] bnx2: eth3 NIC Link is Up, 1000 Mbps full duplex, receive
& transmit flow control ON
[  290.242533] eth3: no IPv6 routers present

As you can notice it tried to use eth0 & eth1 for both broadcom adapters
but it did not worked properly since e1000 used them instead and finally
bnx2 got eth3 working using MSI ?
Here is the mii-tool output:
[root@urpdev1 /root]# mii-tool
eth0: no link
eth1: no link
SIOCGMIIPHY on 'eth2' failed: Resource temporarily unavailable
eth3: negotiated 100baseTx-FD flow-control, link ok

So by switching the network config from eth0 to eth3 made the on-board
port 1 working ?

Here is the lspci output:
05:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708
Gigabit Ethernet (rev 12)
        Subsystem: Dell Unknown device 01b2
        Control: I/O- Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 214
        Region 0: Memory at f8000000 (64-bit, non-prefetchable)
[size=32M]
        Capabilities: [40] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=512 OST=8
                Status: Dev=05:00.0 64bit+ 133MHz+ SCD- USC- DC=simple
DMMRBC=512 DMOST=8 DMCRS=32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable+
                Address: 00000000feeff00c  Data: 416a


09:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708
Gigabit Ethernet (rev 12)
        Subsystem: Dell Unknown device 01b2
        Control: I/O- Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (16000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f4000000 (64-bit, non-prefetchable)
[size=32M]
        Capabilities: [40] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=512 OST=8
                Status: Dev=09:00.0 64bit+ 133MHz+ SCD- USC- DC=simple
DMMRBC=512 DMOST=8 DMCRS=32 RSCEM- 266MHz- 533MHz-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 6feffffffdfffefc  Data: ffbf

Full dmesg:
http://linux-dev.qc.ec.gc.ca/kernel/debian/dmesg-2.6.21.5-bnx2-error.txt
Full lspci -vvv:
http://linux-dev.qc.ec.gc.ca/kernel/debian/lspci-2.6.21.5-bnx2-error.txt
Config (2.6.21.5):
http://linux-dev.qc.ec.gc.ca/kernel/debian/CONFIG-i686-2.6.21-005

Help would greatly be appreciated!

- vin


