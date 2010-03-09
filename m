Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0CIVUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:20:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326Ab0CIVUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 16:20:18 -0500
Date: Tue, 9 Mar 2010 13:17:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [git patches] libata updates for 2.6.34
In-Reply-To: <20100301202330.GA14977@havoc.gtf.org>
Message-ID: <alpine.LFD.2.00.1003091304400.3583@i5.linux-foundation.org>
References: <20100301202330.GA14977@havoc.gtf.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jeff,
 this is a new machine, so I don't know when it started, but it was 
running a couple of Fedora 2.6.31/32 kernels for a while with no trouble. 
So I _think_ it's recent.

I'd guess it's due to commit 27943620cb ("libata: implement spurious irq 
handling for SFF and apply it to piix"), in fact.

With current -git I got a 30 second pause, and it was accompanied with 
this kernel log:

	Mar  9 12:51:05 i5 kernel: [    7.040194] ata4: clearing spurious IRQ
	Mar  9 12:51:05 i5 kernel: [   37.978933] ata4: lost interrupt (Status 0x50)
	Mar  9 12:51:05 i5 kernel: [   37.978948] ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0 frozen
	Mar  9 12:51:05 i5 kernel: [   37.978951] ata4.01: failed command: READ DMA
	Mar  9 12:51:05 i5 kernel: [   37.978954] ata4.01: cmd c8/00:08:ef:44:47/00:00:00:00:00/f0 tag 0 dma 4096 in
	Mar  9 12:51:05 i5 kernel: [   37.978955]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
	Mar  9 12:51:05 i5 kernel: [   37.978957] ata4.01: status: { DRDY }
	Mar  9 12:51:05 i5 kernel: [   37.978963] ata4.00: hard resetting link
	Mar  9 12:51:05 i5 kernel: [   38.306451] ata4.01: hard resetting link
	Mar  9 12:51:05 i5 kernel: [   38.785773] ata4.00: SATA link down (SStatus 0 SControl 300)
	Mar  9 12:51:05 i5 kernel: [   38.785787] ata4.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
	Mar  9 12:51:05 i5 kernel: [   38.809900] ata4.01: configured for UDMA/133
	Mar  9 12:51:05 i5 kernel: [   38.809903] ata4.01: device reported invalid CHS sector 0
	Mar  9 12:51:05 i5 kernel: [   38.809907] ata4: EH complete

and notice how it first complains about a spurious interrupt, and then 
thirty seconds later the timeout for a _lost_ interrupt happens. Looks 
like a race condition in SATA irq handling.

This is a Core i5 with intel controller and intel SSD:

	Mar  9 12:51:05 i5 kernel: [    1.431579] ata_piix 0000:00:1f.2: PCI INT D -> GSI 21 (level, low) -> IRQ 21
	Mar  9 12:51:05 i5 kernel: [    1.431607] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
	Mar  9 12:51:05 i5 kernel: [    1.431698] scsi3 : ata_piix
	Mar  9 12:51:05 i5 kernel: [    1.431760] scsi4 : ata_piix
	Mar  9 12:51:05 i5 kernel: [    1.432800] ata4: SATA max UDMA/133 cmd 0x9880 ctl 0x9800 bmdma 0x9080 irq 21
	Mar  9 12:51:05 i5 kernel: [    1.432829] ata5: SATA max UDMA/133 cmd 0x9480 ctl 0x9400 bmdma 0x9088 irq 21
	...
	Mar  9 12:51:05 i5 kernel: [    2.236210] ata4.00: SATA link down (SStatus 0 SControl 300)
	Mar  9 12:51:05 i5 kernel: [    2.237724] ata4.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
	Mar  9 12:51:05 i5 kernel: [    2.256250] ata4.01: ATA-7: INTEL SSDSA2M160G2GC, 2CV102HA, max UDMA/133
	Mar  9 12:51:05 i5 kernel: [    2.257747] ata4.01: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
	Mar  9 12:51:05 i5 kernel: [    2.268256] ata4.01: configured for UDMA/133

yeah, yeah, I realize it's ata_piix, and I need to go into the BIOS and 
turn it into AHCI mode, but I thought I'd make a report about this before 
I do anything else.

The 30 second pause was annoying, but then half an hour later it just hung 
entirely, with the disk light blinking at 1Hz. Which I assume is related.

Oh, just happened again:

	Mar  9 13:12:29 i5 kernel: [  540.453163] ata4: clearing spurious IRQ
	Mar  9 13:12:59 i5 kernel: [  571.133725] ata4: lost interrupt (Status 0x50)
	Mar  9 13:12:59 i5 kernel: [  571.133749] ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0 frozen
	Mar  9 13:12:59 i5 kernel: [  571.133755] ata4.01: failed command: READ DMA
	Mar  9 13:12:59 i5 kernel: [  571.133764] ata4.01: cmd c8/00:08:c7:9a:47/00:00:00:00:00/f5 tag 0 dma 4096 in
	Mar  9 13:12:59 i5 kernel: [  571.133766]          res 40/00:00:00:4f:c2/00:00:00:00:00/10 Emask 0x4 (timeout)
	Mar  9 13:12:59 i5 kernel: [  571.133771] ata4.01: status: { DRDY }
	Mar  9 13:12:59 i5 kernel: [  571.133783] ata4.00: hard resetting link
	Mar  9 13:13:00 i5 kernel: [  571.453215] ata4.01: hard resetting link
	Mar  9 13:13:00 i5 kernel: [  571.928512] ata4.00: SATA link down (SStatus 0 SControl 300)
	Mar  9 13:13:00 i5 kernel: [  571.928526] ata4.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
	Mar  9 13:13:00 i5 kernel: [  571.952699] ata4.01: configured for UDMA/133
	Mar  9 13:13:00 i5 kernel: [  571.952707] ata4.01: device reported invalid CHS sector 0
	Mar  9 13:13:00 i5 kernel: [  571.952716] ata4: EH complete

so I really think PIIX is screwed up in current -git. And it really must 
be fairly recent, since none of this happened with the Fedora kernels, and 
it's clearly not a one-time event.

In fact, grepping for this, it's happened at least four times since I 
upgraded the machine to 2.6.34-rc1-00005-g522dba7. 

		Linus
