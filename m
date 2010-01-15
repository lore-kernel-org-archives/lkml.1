Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab0AOVnL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513Ab0AOVnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:43:08 -0500
Received: from khc.piap.pl ([195.187.100.11]:33481 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758486Ab0AOVnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:43:05 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Seth Heasley <seth.heasley@intel.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel  Cougar Point DeviceIDs
References: <201001121700.18234.seth.heasley@intel.com>
	<4B4D4EAA.2010109@gmail.com> <4B4DAA68.60608@pobox.com>
	<m3my0i6nou.fsf@intrepid.localdomain> <4B4DFE1A.4000606@pobox.com>
	<m3iqb57ts7.fsf@intrepid.localdomain>
	<51f3faa71001131557n52e34260k13bf1fe3057bb0e@mail.gmail.com>
	<m3iqb4iwb4.fsf@intrepid.localdomain>
	<51f3faa71001141615n5776454cwbf6787b7a7fb0081@mail.gmail.com>
Date: Fri, 15 Jan 2010 22:43:00 +0100
In-Reply-To: <51f3faa71001141615n5776454cwbf6787b7a7fb0081@mail.gmail.com>
	(Robert Hancock's message of "Thu, 14 Jan 2010 18:15:08 -0600")
Message-ID: <m3iqb3rqmz.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockrwd@gmail.com> writes:

> It would be interesting to see what happens if you actually plug
> something into that port that's having the issues, and see what
> happens. I'm kind of inclined to suspect it's a hardware fault, though
> it would likely require a report from someone else with the same or
> similar board model to confirm that..

2.6.32.3 with the patch disabling JMB363 and "catch all AHCI" applied.
Nothing connected to SATA, only PATA in use.

I understand the following doesn't set the AHCI_HFLAG_IGN_IRQ_IF_ERR
and thus doesn't ignore PORT_IRQ_IF_ERR, but the latter doesn't seem to
be set.

# echo -n 197b 2363 > new_id

ahci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
ahci 0000:02:00.0: setting latency timer to 64
scsi9 : ahci
scsi10 : ahci
ata9: SATA max UDMA/133 abar m8192@0xfe9fe000 port 0xfe9fe100 irq 16
ata10: SATA max UDMA/133 abar m8192@0xfe9fe000 port 0xfe9fe180 irq 16
ata10: SATA link down (SStatus 0 SControl 300)
ata9: SATA link down (SStatus 0 SControl 300)

ata10: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
ata10: irq_stat 0x00000040, connection status changed
ata10: SError: { CommWake DevExch }
ata10: hard resetting link
ata10: SATA link down (SStatus 0 SControl 300)
ata10: EH complete
ata10: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
ata10: irq_stat 0x00000040, connection status changed
ata10: SError: { CommWake DevExch }
ata10: limiting SATA link speed to 1.5 Gbps
ata10: hard resetting link
ata10: SATA link down (SStatus 0 SControl 310)
ata10: EH complete
...

sometimes the two lines become:

ata10: exception Emask 0x10 SAct 0x0 SErr 0x4060000 action 0xe frozen
ata10: SError: { PHYInt CommWake DevExch }

Now plugging something into the mb connector (1.5 Gbps device, the same
which my VT6421A-based miniPCI card doesn't like):

ata10: exception Emask 0x10 SAct 0x0 SErr 0x4050000 action 0xe frozen
ata10: irq_stat 0x00400040, connection status changed
ata10: SError: { PHYRdyChg CommWake DevExch }
ata10: hard resetting link
ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata10.00: ATA-7: Kingston SSDNow V Series 64GB, B090428a, max UDMA/100
ata10.00: 125045424 sectors, multi 1: LBA
ata10.00: configured for UDMA/100
ata10: EH complete
scsi 10:0:0:0: Direct-Access     ATA      Kingston SSDNow  B090 PQ: 0 ANSI: 5
sd 10:0:0:0: Attached scsi generic sg8 type 0
sd 10:0:0:0: [sdh] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
sd 10:0:0:0: [sdh] Write Protect is off
sd 10:0:0:0: [sdh] Mode Sense: 00 3a 00 00
sd 10:0:0:0: [sdh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 10:0:0:0: [sdh] Attached SCSI disk

Absolutely no problems with fs access, expected linear transfer speed
etc.

Well, let's unplug it. Power down first:

ata10: exception Emask 0x10 SAct 0x0 SErr 0x990000 action 0xe frozen
ata10: irq_stat 0x00400000, PHY RDY changed
ata10: SError: { PHYRdyChg 10B8B Dispar LinkSeq }
ata10: hard resetting link
ata10: SATA link down (SStatus 0 SControl 300)
ata10: hard resetting link
ata10: SATA link down (SStatus 0 SControl 300)
ata10: limiting SATA link speed to 1.5 Gbps
ata10: hard resetting link
ata10: SATA link down (SStatus 0 SControl 310)
ata10.00: disabled
ata10: EH complete
ata10.00: detaching (SCSI 10:0:0:0)
sd 10:0:0:0: [sdh] Stopping disk
sd 10:0:0:0: [sdh] START_STOP FAILED
sd 10:0:0:0: [sdh] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK

Seems stable at this point, no additional messages.

Then removing the plug from (unpowered) SSD - IRQs start appearing again
every few seconds. Mostly:

ata10: exception Emask 0x10 SAct 0x0 SErr 0x4000000 action 0xe frozen
ata10: irq_stat 0x00000040, connection status changed
ata10: SError: { DevExch }
ata10: limiting SATA link speed to 1.5 Gbps
ata10: hard resetting link
ata10: SATA link down (SStatus 0 SControl 310)
ata10: EH complete

sometimes SErr 0x4060000 and 0x4040000

Fine, so let's connect it again (device still not powered):
Messages stopped.

Disconnected again, messages started, reconnected, stopped.

Am I to use the SSD as a passive SATA terminator?

Any further ideas welcome :-)
-- 
Krzysztof Halasa
