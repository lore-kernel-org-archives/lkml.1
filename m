Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZERRYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZERRYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZERRYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:24:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:38111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbZERRYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:24:33 -0400
Message-ID: <4A119990.9020606@kernel.org>
Date: Mon, 18 May 2009 10:23:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: tip: patches in git for irq and numa
References: <4A05269D.8000701@kernel.org> <20090511095022.GA23121@elte.hu>	 <20090511163158.c4e4d334.akpm@linux-foundation.org>	 <20090512090704.GC18004@elte.hu> <4A0A6700.3070100@kernel.org>	 <20090513133635.GB7384@elte.hu> <4A0AFA6E.5050200@kernel.org>	 <20090515173521.GA29647@elte.hu> <4A0DE0ED.6090402@kernel.org>	 <20090518072952.GA12460@elte.hu> <1242654650.26820.429.camel@twins>	 <4A1178D5.5050900@kernel.org> <1242659477.26820.433.camel@twins>
In-Reply-To: <1242659477.26820.433.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check following patch

Thanks

YH

Subject: [PATCH] x86: don't mark pin_programmed early

Peter bisected that
| commit b9c61b70075c87a8612624736faf4a2de5b1ed30
| Date:   Wed May 6 10:10:06 2009 -0700
|
|     x86/pci: update pirq_enable_irq() to setup io apic routing
|
|     So we can set io apic routing only when enabling the device irq.
wrecked his opteron box, ata1 interrupts fail to get through

and that ata1 is using irq 11
[    1.451839] sata_svw 0000:01:0e.0: version 2.3
[    1.456333] sata_svw 0000:01:0e.0: PCI INT A -> GSI 11 (level, low) -> IRQ 11
[    1.463639] scsi0 : sata_svw
[    1.466949] scsi1 : sata_svw
[    1.470022] scsi2 : sata_svw
[    1.473090] scsi3 : sata_svw
[    1.476112] ata1: SATA max UDMA/133 mmio m8192@0xff3fe000 port 0xff3fe000 irq 11
[    1.483490] ata2: SATA max UDMA/133 mmio m8192@0xff3fe000 port 0xff3fe100 irq 11
[    1.490870] ata3: SATA max UDMA/133 mmio m8192@0xff3fe000 port 0xff3fe200 irq 11
[    1.498247] ata4: SATA max UDMA/133 mmio m8192@0xff3fe000 port 0xff3fe300 irq 11

that pin is overlapped with pin with legacy ones.
We should not set bits in pin_programmed here, so that those bit could be set later
via io_apic_set_pci_routing()

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6b7913b..ed6a91c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1538,7 +1538,10 @@ static void __init setup_IO_APIC_irqs(void)
 		}
 		cfg = desc->chip_data;
 		add_pin_to_irq_node(cfg, node, apic_id, pin);
-		set_bit(pin, mp_ioapic_routing[apic_id].pin_programmed);
+		/*
+		 * don't mark it in pin_programmed, so later acpi could
+		 * set it correctly when irq < 16
+		 */
 		setup_IO_APIC_irq(apic_id, pin, irq, desc,
 				irq_trigger(idx), irq_polarity(idx));
 	}
