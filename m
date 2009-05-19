Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbZESJkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbZESJkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZESJkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:40:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:36766 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZESJkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:40:08 -0400
Date: Tue, 19 May 2009 09:39:31 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, peterz@infradead.org, yinghai.lu@kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai.lu@kernel.org, yinghai@kernel.org, steiner@sgi.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A119990.9020606@kernel.org>
References: <4A119990.9020606@kernel.org>
Subject: [tip:irq/numa] x86, io-apic: Don't mark pin_programmed early
Message-ID: <tip-46e842ccbe38be910bb2928258850b6178ce00e1@git.kernel.org>
Git-Commit-ID: 46e842ccbe38be910bb2928258850b6178ce00e1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 19 May 2009 09:39:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46e842ccbe38be910bb2928258850b6178ce00e1
Gitweb:     http://git.kernel.org/tip/46e842ccbe38be910bb2928258850b6178ce00e1
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 18 May 2009 10:23:28 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 19 May 2009 11:35:59 +0200

x86, io-apic: Don't mark pin_programmed early

Peter bisected that:

| commit b9c61b70075c87a8612624736faf4a2de5b1ed30
| Date:   Wed May 6 10:10:06 2009 -0700
|
|     x86/pci: update pirq_enable_irq() to setup io apic routing
|
|     So we can set io apic routing only when enabling the device irq.

wrecked his opteron box, ata1 interrupts fail to get through.

ata1 is using irq 11:

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

We should not set bits in pin_programmed here, so that those bit could
be set later via io_apic_set_pci_routing().

[ Impact: fix boot hang on certain systems ]

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
Cc: Jack Steiner <steiner@sgi.com>
LKML-Reference: <4A119990.9020606@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ce1ac74..ac7f3b6 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1537,7 +1537,10 @@ static void __init setup_IO_APIC_irqs(void)
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
