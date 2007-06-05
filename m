Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbXFEVcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbXFEVcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933051AbXFEVcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:32:13 -0400
Received: from aun.it.uu.se ([130.238.12.36]:54484 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933109AbXFEVcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:32:11 -0400
Date: Tue, 5 Jun 2007 23:31:46 +0200 (MEST)
Message-Id: <200706052131.l55LVkYN000191@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: akpm@linux-foundation.org, david@dgreaves.com, htejun@gmail.com,
       jean.luc.coulon@gmail.com, jgarzik@pobox.com,
       michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org
Subject: Re: Linux 2.6.22-rc4 - sata_promise regression since -rc3
Cc: linux-kernel@vger.kernel.org, mikpe@it.uu.se
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jun 2007 17:14:46 +0100, David Greaves <david@dgreaves.com> wrote:
>[Tejun, Jeff, added you since the bisect points to your patch.]
>
>Sorry, mail glitch means I lost a couple of emails...
>
>I said:
>Compile warnings and a new regression: hang on boot during sata_promise
>detection...
>
>It turns out that the hang times out; it does boot after a while. It's missing 4
>of my SATA disks though.
>[in turn this means I can't test the hibernate regression against -rc4. But
>testing that regression against a862b5c8cd5d847779a049a5fc8cf5b1e6f5fa07 shows
>it is still there. Do I get a bonus for finding 2 regressions?]]
>
>I also bisected and got:
>Bisecting: 0 revisions left to test after this
>[464cf177df7727efcc5506322fc5d0c8b896f545] libata: always use polling SETXFER
>
>According to marc, Mikail said:

That's Mikael, not Mikail.

>Please give us some details about your sata_promise problem:
>- describe your hardware (Promise chip version, mainboard, chipset, etc)
>I have a Promise TX-4 and onboard via-sata.
>0000:00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP] Host
>Bridge (rev 80)
>0000:00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
>0000:00:0d.0 Unknown mass storage controller: Promise Technology, Inc. PDC20318
>(SATA150 TX4) (rev 02)
>0000:00:0f.1 IDE interface: VIA Technologies, Inc.
>VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
>
>- which was the last kernel version prior to 2.6.22-rc4 that worked
>2.6.22-rc3
>- the kernel messages up to the hang, if you can capture them
>Easier once I learned patience...
>
>sata_promise 0000:00:0d.0: version 2.07
>ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 16 (level, low) -> IRQ 17
>scsi0 : sata_promise
>scsi1 : sata_promise
>scsi2 : sata_promise
>scsi3 : sata_promise
>ata1: SATA max UDMA/133 cmd 0xf880a200 ctl 0xf880a238 bmdma 0x00000000 irq 0
>ata2: SATA max UDMA/133 cmd 0xf880a280 ctl 0xf880a2b8 bmdma 0x00000000 irq 0
>ata3: SATA max UDMA/133 cmd 0xf880a300 ctl 0xf880a338 bmdma 0x00000000 irq 0
>ata4: SATA max UDMA/133 cmd 0xf880a380 ctl 0xf880a3b8 bmdma 0x00000000 irq 0
>ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>ata1.00: ata_hpa_resize 1: sectors = 490234752, hpa_sectors = 490234752
>ata1.00: ATA-7: Maxtor 6B250S0, BANC19J0, max UDMA/133
>ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 0/32)
>ata1.00: qc timeout (cmd 0xef)
>ata1.00: failed to set xfermode (err_mask=0x4)

http://bugzilla.kernel.org/show_bug.cgi?id=8587 has a similar
report: it lists 2.6.22-rc3-git7 as OK but 2.6.22-rc4 as broken.

I can easily reproduce the problem in 2.6.22-rc4. There are no
sata_promise changes between rc3 and rc4, but Tejun's libata
polling SETXFER change was included in rc4. Reverting it makes
sata_promise work again for me.

I suspect that sata_promise.c:pdc_interrupt() should detect
a qc w/ ATA_TFLAG_POLLING, treat the interrupt as spurious,
and just call ata_chk_status(qc), similar to how sata_inic162x.c,
sata_nv.c, sata_sil.c, and sata_vsc.c do things.

Jeff/Tejun: comments?

/Mikael
