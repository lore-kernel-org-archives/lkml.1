Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbXAZWia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbXAZWia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 17:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbXAZWia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 17:38:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:7462 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbXAZWi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 17:38:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,244,1167638400"; 
   d="scan'208"; a="173483373:sNHT22249094"
Message-ID: <45BA82DA.6050201@intel.com>
Date: Fri, 26 Jan 2007 14:38:18 -0800
From: Auke Kok <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ebiederm@xmission.com
CC: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Possible regression: MSI vector leakage since 2.6.18-rc5ish (Unable
 to repeatedly allocate/free MSI interrupt)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2007 22:38:18.0639 (UTC) FILETIME=[ACFD29F0:01C7419A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I've established a regression in the MSI vector/irq allocation routine for both 
i386 and x86_64. Our test labs repeatedly modprobe/rmmod the e1000 driver for 
serveral minutes which allocates msi vectors and frees them. These tests have 
been running fine until 2.6.19.

git-bisecting I've established that in between commit 
04b9267b15206fc902a18de1f78de6c82ca47716 "Eric W. Biederman -- genirq: x86_64 
irq: Remove the msi assumption that irq == vector" and commit 
f29bd1ba68c8c6a0f50bd678bbd5a26674018f7c "Ingo Molnar -- genirq: convert the 
x86_64 architecture to irq-chips" the behaviour broke.

The revisions in between seem to be dependent and give all sorts of other 
issues, so it's rather hard for me to bisect that and give trustworthy results.

the e1000 driver hits the 256-mark cycle (I think - it consistently refuses to 
do 500 msi irq/vector allocations which is my test case) and throws:

e1000: eth4: e1000_request_irq: Unable to allocate MSI interrupt Error: -16

which is caused by a `if ((err = pci_enable_msi(adapter->pdev))) {` call from 
the e1000 driver. It's rather easy to hit this mark with the new 4-port e1000 
adapters :).

as for the e1000 code, I can say that even our oldest msi-enabled e1000 driver 
works fine with 2.6.18 and under. All kernels from 2.6.19 fail consistently.

I mostly suspect commit 7bd007e480672c99d8656c7b7b12ef0549432c37 at the moment. 
Perhaps Eric Biederman can help?

Cheers,

Auke


---
PS After the msi enable fails, things go horribly wrong (of course...) if we 
still try to disable+enable more new msi interrupts, but this may just be the 
e1000 driver cleanup missing something. perhaps it's relevant:

e1000: 0000:04:00.1: e1000_probe: (PCI Express:2.5Gb/s:32-bit) 00:15:17:0c:0c:7f
e1000: eth5: e1000_probe: Intel(R) PRO/1000 Network Connection
ADDRCONF(NETDEV_UP): eth1: link is not ready
ADDRCONF(NETDEV_UP): eth2: link is not ready
ADDRCONF(NETDEV_UP): eth3: link is not ready
e1000: eth4: e1000_request_irq: Unable to allocate MSI interrupt Error: -16
ADDRCONF(NETDEV_UP): eth4: link is not ready
ADDRCONF(NETDEV_UP): eth5: link is not ready
ACPI: PCI interrupt for device 0000:04:00.1 disabled
ACPI: PCI interrupt for device 0000:04:00.0 disabled
ACPI: PCI interrupt for device 0000:03:00.1 disabled
ACPI: PCI interrupt for device 0000:03:00.0 disabled
ACPI: PCI interrupt for device 0000:00:19.0 disabled
Intel(R) PRO/1000 Network Driver - version 7.2.9-k4-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:19.0 to 64
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 88:88:88:88:87: 
                                  88
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:03:00.0 to 64
e1000: 0000:03:00.0: e1000_probe: (PCI Express:2.5Gb/s:32-bit) 00:15:17:0c:0c:7c
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.1 to 64
e1000: 0000:03:00.1: e1000_probe: (PCI Express:2.5Gb/s:32-bit) 00:15:17:0c:0c:7d
e1000: eth3: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:04:00.0 to 64
e1000: 0000:04:00.0: e1000_probe: (PCI Express:2.5Gb/s:32-bit) 00:15:17:0c:0c:7e
e1000: eth4: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:04:00.1[B] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:04:00.1 to 64
e1000: 0000:04:00.1: e1000_probe: (PCI Express:2.5Gb/s:32-bit) 00:15:17:0c:0c:7f
e1000: eth5: e1000_probe: Intel(R) PRO/1000 Network Connection
ADDRCONF(NETDEV_UP): eth1: link is not ready
ADDRCONF(NETDEV_UP): eth2: link is not ready
ADDRCONF(NETDEV_UP): eth3: link is not ready
ADDRCONF(NETDEV_UP): eth4: link is not ready
ADDRCONF(NETDEV_UP): eth5: link is not ready
irq 214: nobody cared (try booting with the "irqpoll" option)
  [<c015b25a>] __report_bad_irq+0x2a/0x90
  [<c015b38f>] note_interrupt+0xaf/0xe0
  [<c015bcf3>] handle_edge_irq+0xd3/0x160
  [<c0105dd8>] do_IRQ+0x68/0xd0
  [<c0103e0a>] common_interrupt+0x1a/0x20
  [<c015007b>] snapshot_write_next+0x5b/0x220
  [<c012e862>] __do_softirq+0x62/0x100
  [<c012e935>] do_softirq+0x35/0x40
  [<c012e985>] irq_exit+0x45/0x50
  [<c0105ddd>] do_IRQ+0x6d/0xd0
  [<c0103e0a>] common_interrupt+0x1a/0x20
  =======================
handlers:
[<f89df160>] (e1000_intr+0x0/0x110 [e1000])
Disabling IRQ #214
ACPI: PCI interrupt for device 0000:04:00.1 disabled
ACPI: PCI interrupt for device 0000:04:00.0 disabled
ACPI: PCI interrupt for device 0000:03:00.1 disabled
irq 214, desc: c05cc120, depth: 1, count: 0, unhandled: 0
->handle_irq():  c015a050, handle_bad_irq+0x0/0x380
->chip(): c05453c0, 0xc05453c0
->action(): 00000000
   IRQ_DISABLED set
    IRQ_PENDING set
     IRQ_MASKED set
unexpected IRQ trap at vector d6
irq 214, desc: c05cc120, depth: 1, count: 0, unhandled: 0
->handle_irq():  c015a050, handle_bad_irq+0x0/0x380
->chip(): c05453c0, 0xc05453c0
->action(): 00000000
   IRQ_DISABLED set
    IRQ_PENDING set
     IRQ_MASKED set

which repeats ad infinitum... perhaps this rings some bells for someone.
