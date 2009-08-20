Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZHTTaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZHTTaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZHTTaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:30:21 -0400
Received: from lo.gmane.org ([80.91.229.12]:42810 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbZHTTaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:30:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: e1000e: why does pci_enable_pcie_error_reporting() fail on my hp2510p?
Followup-To: gmane.linux.network
Date: Thu, 20 Aug 2009 21:25:56 +0200
Organization: m
Message-ID: <878whethh7.fsf@nemi.mork.no>
References: <200908201714.30638.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: nemi.mork.no
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
Cancel-Lock: sha1:J88ABfKN36ko0qSQCL6AE8rhskE=
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop <elendil@planet.nl> writes:

> - if broken hardware is common, should the kernel complain at all,
>   or at least maybe show a slightly "friendlier" message?

FWIW, I see the same message on resume on slighly different hardware, so
it's at least more common than just a single configuration:

[80885.498749] e1000e 0000:00:19.0: PCI INT A disabled
[80885.498755] e1000e 0000:00:19.0: PME# enabled
[80885.498763] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[80887.614545] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[80887.614548] e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
[80887.614554] e1000e 0000:00:19.0: setting latency timer to 64
[80887.614559] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[80887.614565] e1000e 0000:00:19.0: PME# disabled
[80887.614567] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[80887.614572] e1000e 0000:00:19.0: PME# disabled
[80887.614626] e1000e 0000:00:19.0: irq 26 for MSI/MSI-X

nemi:/etc/apt# lspci -vvnns 00:19.0
00:19.0 Ethernet controller [0200]: Intel Corporation 82567LM Gigabit Network Connection [8086:10f5] (rev 03)
        Subsystem: Lenovo Device [17aa:20ee]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 26
        Region 0: Memory at f0600000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at f0625000 (32-bit, non-prefetchable) [size=4K]
        Region 2: I/O ports at 1840 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
                Address: 00000000fee0300c  Data: 41b2
        Capabilities: [e0] PCIe advanced features <?>
        Kernel driver in use: e1000e
        Kernel modules: e1000e


The system is a Lenovo Thinkpad X301. The chipset is ICH9M.

I guess the "non-fatal, continue" comment is a pretty strong indication
that dev_err() is overkill here?


	/* AER (Advanced Error Reporting) hooks */
	err = pci_enable_pcie_error_reporting(pdev);
	if (err) {
		dev_err(&pdev->dev, "pci_enable_pcie_error_reporting failed "
		        "0x%x\n", err);
		/* non-fatal, continue */
	}




Bjørn

