Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZBSNyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZBSNyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZBSNx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:53:56 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:45992 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZBSNxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:53:55 -0500
Date: Thu, 19 Feb 2009 13:53:52 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [SCSI][REGRESSION][BISECTED] Disk errors loop forever in 2.6.29
Message-ID: <20090219135352.GA28717@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There appears to be a regression from 2.6.28 in how disk errors are
handled in 2.6.29rc5 - rather than trying and eventually giving up, it
appears to try (and report) forever. 

Here is the output where it aborts in 2.6.28:

ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
ata2.01: BMDMA stat 0x65
ata2.01: cmd c8/00:00:f7:e2:9c/00:00:00:00:00/f1 tag 0 dma 131072 in
         res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
ata2: soft resetting link
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/66
ata2: EH complete
ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
ata2.01: BMDMA stat 0x65
ata2.01: cmd c8/00:00:f7:e2:9c/00:00:00:00:00/f1 tag 0 dma 131072 in
         res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
ata2: soft resetting link
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/66
ata2: EH complete
sd 1:0:0:0: [sda] 7880544 512-byte hardware sectors: (4.03 GB/3.75 GiB)
ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
ata2.01: BMDMA stat 0x65
ata2.01: cmd c8/00:00:f7:e2:9c/00:00:00:00:00/f1 tag 0 dma 131072 in
         res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
ata2: soft resetting link
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/66
ata2: EH complete
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
ata2.01: limiting speed to UDMA/44:PIO4
ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
ata2.01: BMDMA stat 0x65
ata2.01: cmd c8/00:00:f7:e2:9c/00:00:00:00:00/f1 tag 0 dma 131072 in
         res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
ata2: soft resetting link
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/44
ata2: EH complete
ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
ata2.01: BMDMA stat 0x65
ata2.01: cmd c8/00:00:f7:e2:9c/00:00:00:00:00/f1 tag 0 dma 131072 in
         res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
ata2: soft resetting link
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/44
ata2: EH complete
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sda: detected capacity change from 0 to 4034838528
ata2.01: limiting speed to UDMA/33:PIO4
ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
ata2.01: BMDMA stat 0x65
ata2.01: cmd c8/00:00:f7:e2:9c/00:00:00:00:00/f1 tag 0 dma 131072 in
         res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
ata2: soft resetting link
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/33
sd 1:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
sd 1:0:1:0: [sdb] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        00 00 00 00 
sd 1:0:1:0: [sdb] ASC=0x0 ASCQ=0x0
end_request: I/O error, dev sdb, sector 27058935
Buffer I/O error on device sdb2, logical block 444480
Buffer I/O error on device sdb2, logical block 444481
Buffer I/O error on device sdb2, logical block 444482
Buffer I/O error on device sdb2, logical block 444483
Buffer I/O error on device sdb2, logical block 444484
Buffer I/O error on device sdb2, logical block 444485
Buffer I/O error on device sdb2, logical block 444486
Buffer I/O error on device sdb2, logical block 444487
Buffer I/O error on device sdb2, logical block 444488
Buffer I/O error on device sdb2, logical block 444489
ata2: EH complete

It never gets to end_request on 2.6.29. I've bisected the problem down
to the following:

[b60af5b0adf0da24c673598c8d3fb4d4189a15ce] [SCSI] simplify scsi_io_completion()

Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Mon Nov 3 15:56:47 2008 -0500

    [SCSI] simplify scsi_io_completion()
    
    This patch (as1142b) consolidates a lot of repetitious code in
    scsi_io_completion().  It also fixes a few comments.  Most
    importantly, however, it clearly distinguishes among the three sorts
    of retries that can be done when a command fails to complete:
    
        Unprepare the request and resubmit it, so that a new
        command will be created for it.
    
        Requeue the request directly so that it will be retried
        immediately using the same command.
    
        Requeue the request so that it will be retried following
        a short delay.
    
        Complete the remainder of the request with an I/O error.
    
    [jejb: Updates
	 1. For several error conditions, we would now print the sense twice
            in slightly different ways, so unify the location of sense
            printing.
         2. I added more descriptions to actual failure conditions for
            better debugging
         3. according to spec, ABORTED_COMMAND is supposed to be retried
            (except on DIF failure).  Our old behaviour of erroring it looks
            to be a bug.
         4. I'd prefer not to default initialise the action variable because
            that ensures that every leg of the error handler has an
            associated action and the compiler will warn if someone later
            accidentally misses one or removes one.
    ]
    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

Reverting this made the endless looping go away. Here is the bisection
log:

git-bisect start
# bad: [38c8e6180939e5619140b2e9e479cb26029ff8b1] do_mpage_readpage():
# don't submit lots of small bios on boundary
git-bisect bad 38c8e6180939e5619140b2e9e479cb26029ff8b1
# good: [4a6908a3a050aacc9c3a2f36b276b46c0629ad91] Linux 2.6.28
git-bisect good 4a6908a3a050aacc9c3a2f36b276b46c0629ad91
# good: [3c92ec8ae91ecf59d88c798301833d7cf83f2179] Merge branch 'next'
# of git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc
git-bisect good 3c92ec8ae91ecf59d88c798301833d7cf83f2179
# bad: [590cf28580c999c8ba70dc39b40bab09d69e2630] Merge
# git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
git-bisect bad 590cf28580c999c8ba70dc39b40bab09d69e2630
# good: [14a3c4ab0e58d143c7928c9eb2f2610205e13bf2] Merge branch 'devel'
# of master.kernel.org:/home/rmk/linux-2.6-arm
git-bisect good 14a3c4ab0e58d143c7928c9eb2f2610205e13bf2
# good: [121520a7084b48cb26437c6e89d4b491c3e4d4d5] V4L/DVB (9853):
# gspca: Webcam 093a:2622 added in pac7311.
git-bisect good 121520a7084b48cb26437c6e89d4b491c3e4d4d5
# good: [9414de39e8e07d90bdb6524be501fae0e013d37b] V4L/DVB (10079):
# sh_mobile_ceu: use new pixel format translation code
git-bisect good 9414de39e8e07d90bdb6524be501fae0e013d37b
# bad: [dedbc2b3cb8404c618975bd2811c7605a4ccb51e] [SCSI] zfcp: Simplify
# SBAL allocation to fix sparse warnings
git-bisect bad dedbc2b3cb8404c618975bd2811c7605a4ccb51e
# bad: [ae15f80172d95f978b60d40408353943d5bc099b] [SCSI] libiscsi:
# handle init task failures.
git-bisect bad ae15f80172d95f978b60d40408353943d5bc099b
# good: [dd7c34e9a27be521d480e5b84c84e92de2ea7b95] [SCSI] fusion: use
# ARRAY_SIZE
git-bisect good dd7c34e9a27be521d480e5b84c84e92de2ea7b95
# bad: [b29f841378460c37e99a2398d0015d9bd7901a09] [SCSI] remove timeout
# from struct scsi_device
git-bisect bad b29f841378460c37e99a2398d0015d9bd7901a09
# good: [67e6d58d812ec3e95918266076d4c836cdec849a] [SCSI] ibmvfc: Driver
# version 1.0.4
git-bisect good 67e6d58d812ec3e95918266076d4c836cdec849a
# bad: [09e13e91670b69736b5da0a869a076a55a326394] [SCSI] m68k: mac_esp
# asm fix
git-bisect bad 09e13e91670b69736b5da0a869a076a55a326394
# bad: [749af3d54a6d5619088ecadb1010c6ab7766f519] [SCSI] qla2xxx: Code
# changes for vport bus reset
git-bisect bad 749af3d54a6d5619088ecadb1010c6ab7766f519
# bad: [b60af5b0adf0da24c673598c8d3fb4d4189a15ce] [SCSI] simplify
# scsi_io_completion()
git-bisect bad b60af5b0adf0da24c673598c8d3fb4d4189a15ce

-- 
Sitsofe | http://sucs.org/~sits/
