Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbXKCRNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbXKCRNU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 13:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbXKCRNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 13:13:12 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:57547 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbXKCRNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 13:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=EwndmwZ+uwu6eAM65xCEU79xNsMXV919/IEH/s8/GbttNOpsIQ1NFpPaVEhl/fGkN79oc4e7ucJ/dNUyOpmZlywRJ2IVUiZG84WZ/aqKlhIOrACIIy4BIh+zChzHP73LLvz9AT+XDiGCl46MrmL0lb8YLsoLORH9joakABaCwFI=
Date: Sat, 3 Nov 2007 18:13:10 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Subject: Regression: libata: implement ata_wait_after_reset()
Message-ID: <20071103171310.GA6601@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
latest git causes my extra disk controller to die with screaming
interrupts. Picture here:

http://img113.imageshack.us/my.php?image=im000708vj7.jpg

The controller card is this one (SATA port is not in use):

05:02.0 Mass storage controller: ALi Corporation ALi M5281 Serial ATA / RAID Host Controller (rev a4) (prog-if 85)
        Subsystem: ALi Corporation ALi M5281 Serial ATA / RAID Host Controller
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 128, Cache Line Size: 512 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at c000 [size=8]
        Region 1: I/O ports at bc00 [size=4]
        Region 2: I/O ports at b880 [size=8]
        Region 3: I/O ports at b800 [size=4]
        Region 4: I/O ports at b480 [size=16]
        Expansion ROM at ff7f0000 [disabled] [size=64K]

05:02.1 Mass storage controller: ALi Corporation M5228 ALi ATA/RAID Controller (rev c6) (prog-if 85)
        Subsystem: ALi Corporation Unknown device 5281
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 128
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at c880 [size=8]
        Region 1: I/O ports at c800 [size=4]
        Region 2: I/O ports at c480 [size=8]
        Region 3: I/O ports at c400 [size=4]
        Region 4: I/O ports at c080 [size=16]

The driver is pata_ali. I bisected it down to:

kronos:~/src/linux-2.6.git$ git bisect bad
88ff6eafbb2a1c55f0f0e2e16d72e7b10d8ae8a5 is first bad commit
commit 88ff6eafbb2a1c55f0f0e2e16d72e7b10d8ae8a5
Author: Tejun Heo <htejun@gmail.com>
Date:   Tue Oct 16 14:21:24 2007 -0700

    libata: implement ata_wait_after_reset()

    On certain device/controller combination, 0xff status is asserted
    after reset and doesn't get cleared during 150ms post-reset wait.  As
    0xff status is interpreted as no device (for good reasons), this can
    lead to misdetection on such cases.

    This patch implements ata_wait_after_reset() which replaces the 150ms
    sleep and waits upto ATA_TMOUT_FF_WAIT if status is 0xff.
    ATA_TMOUT_FF_WAIT is currently 800ms which is enough for
    HHD424020F7SV00 to get detected but not enough for Quantum GoVault
    drive which is known to take upto 2s.

    Without parallel probing, spending 2s on 0xff port would incur too
    much delay on ata_piix's which use 0xff to indicate empty port and
    doesn't have SCR register, so GoVault needs to wait till parallel
    probing.

    Signed-off-by: Tejun Heo <htejun@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

:040000 040000 44a0d6b9b2b0e7d4721c013d90a7ccd9656dcd2c 8587bfcf26176f1286bfab26cd6d150712dfd5f8 M      drivers
:040000 040000 2775bec0948fd2306c750b3a215f449c8b3d13ba 8c0fdbb87154af8fc804918a29e72060a2c6939c M      include

I can set up a serial console if you need further debug output.

Luca
-- 
Non sempre quello che viene dopo e` progresso.
Alessandro Manzoni
