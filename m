Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339AbZEIHea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbZEIHea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZEIHeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:34:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:54737 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZEIHeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:34:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Bqbv8BM+xeoRNe/0zKwACdzN3b/rfVmOShnvBHoCWT9vqnl00xKRfaBIAm3qwcCJU6
         bjsjisSoV7mIdMUOrYLvqJrlUetw4Gwgl4yHcbmuxUblOV4fdLvWGUDKLKxZKOz74wYB
         FSyq8BaT75rEkGcxmIFDrwqUbPzfsBLkL+VZc=
Subject: Re: SATA disks resets in a md setup
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: v.virvilis@biovista.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200905081739.46206.v.virvilis@biovista.com>
References: <200905081739.46206.v.virvilis@biovista.com>
Content-Type: text/plain
Date: Sat, 09 May 2009 00:34:25 -0700
Message-Id: <1241854465.1876.10.camel@unix>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 17:39 +0300, Vassilis Virvilis wrote:
> Hi,
> 
> I have spent the better part of the day looking for this and I didn't came up with anything so I thought to ask here in case this is a bug.
> 
> Setup:
> ------
> The system is amd64bit running debian unstable stock with kernel 2.6.29 (debian package). full dmesg is attached
> I have 2 250GB disks (/dev/sda, /dev/sdb) that I used to assemble a md array (/dev/md0)
> 
> Homework:
> ---------
> Please note that the two disk are tested via smart long selftest and via $dd bs=256M if=/dev/sd? of=/dev/null without any problem.
> I researched in web and followed advices:
> 	I have checked / exchanged cables
> 	I disabled smartd.
> 
> The actual Problem:
> -------------------
> Then I start the following stress test. From the other disks of the machine /dev/hda, /dev/hdb, /dev/sdc I start copying (via rsync) to /dev/md0 to a newly formated ext3 filesystem.
> 
> Everything goes fine for a while and then the system freezes and I am getting the first
> 
> [ 9351.377903] ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x1b0000 action 0xe frozen
> [ 9351.377941] ata2.00: irq_stat 0x04400000, PHY RDY changed
> [ 9351.377961] ata2: SError: { PHYRdyChg PHYInt 10B8B Dispar }
> [ 9351.377983] ata2.00: cmd b0/d5:01:09:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
> [ 9351.377985]          res 50/00:00:b6:46:6a/00:00:13:00:00/e0 Emask 0x10 (ATA bus error)
> [ 9351.378006] ata2.00: status: { DRDY }
> [ 9351.378026] ata2: hard resetting link
> [ 9357.659634] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [ 9389.345002] ata2.00: qc timeout (cmd 0xec)
> [ 9389.345013] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> [ 9389.345017] ata2.00: revalidation failed (errno=-5)
> [ 9389.345037] ata2: failed to recover some devices, retrying in 5 secs
> [ 9395.548107] ata2: hard resetting link
> [ 9396.033100] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [ 9396.034245] ata2.00: configured for UDMA/133
> [ 9396.034275] ata2: EH complete
> [ 9396.098216] sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
> [ 9396.114211] sd 1:0:0:0: [sdb] Write Protect is off
> [ 9396.114217] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [ 9396.130212] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
> This happens 2 or 3 times more (sometimes even sda gives the same message)
> 
> At the end what happens is the following. Please note the
>  **** [10671.430120] ata2.00: n_sectors mismatch 488397168 != 268435455 *****
> 
> 
> [10665.354196] ata2: limiting SATA link speed to 1.5 Gbps
> [10665.354196] ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x6 frozen
> [10665.354196] ata2.00: irq_stat 0x08000000, interface fatal error
> [10665.354196] ata2: SError: { UnrecovData Handshk }
> [10665.354196] ata2.00: cmd 35/00:00:27:ae:7a/00:04:01:00:00/e0 tag 0 dma 524288 out
> [10665.354196]          res 50/00:00:26:ae:7a/00:00:01:00:00/e0 Emask 0x10 (ATA bus error)
> [10665.354196] ata2.00: status: { DRDY }
> [10665.354196] ata2: hard resetting link
> [10665.846071] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [10665.846071] ata2.00: n_sectors mismatch 488397168 != 268435455
> [10665.846071] ata2.00: revalidation failed (errno=-19)
> [10665.846071] ata2: failed to recover some devices, retrying in 5 secs
> [10670.878898] ata2: hard resetting link
> [10671.429184] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [10671.430120] ata2.00: n_sectors mismatch 488397168 != 268435455
> [10671.430124] ata2.00: revalidation failed (errno=-19)
> [10671.430145] ata2.00: disabled
> [10671.934174] ata2: hard resetting link
> [10672.462213] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [10672.463130] ata2.00: ATA-0: WDC WD2500JS-00MVB1, 10.02E01, max MWDMA2
> [10672.463134] ata2.00: 268435455 sectors, multi 0: LBA
> [10672.463137] ata2.00: applying bridge limits
> [10672.463683] ata2.00: failed to set xfermode (err_mask=0x1)
> [10672.463706] ata2: failed to recover some devices, retrying in 5 secs
> [10677.749459] ata2: hard resetting link
> [10678.272486] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [10678.273961] ata2.00: failed to set xfermode (err_mask=0x1)
> [10678.273987] ata2: limiting SATA link speed to 1.5 Gbps
> [10678.273989] ata2.00: limiting speed to PIO3
> [10678.273992] ata2: failed to recover some devices, retrying in 5 secs
> [10683.430922] ata2: hard resetting link
> [10683.920364] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [10683.921839] ata2.00: failed to set xfermode (err_mask=0x1)
> [10683.921863] ata2.00: disabled
> [10684.424389] sd 1:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> [10684.424397] sd 1:0:0:0: [sdb] Sense Key : Aborted Command [current] [descriptor]
> [10684.424402] Descriptor sense data with sense descriptors (in hex):
> [10684.424404]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
> [10684.424410]         01 7a ae 26
> [10684.424413] sd 1:0:0:0: [sdb] Add. Sense: No additional sense information
> [10684.424417] end_request: I/O error, dev sdb, sector 24817191
> [10684.424440] Buffer I/O error on device md0, logical block 64151117
> [10684.424459] lost page write due to I/O error on md0
> [10684.424465] Buffer I/O error on device md0, logical block 64151118
> 
> and my filesystem is dead. /dev/sdb is deleted from /dev. I have to reboot and even then linux can't find the ata2 /dev/sdb.
> I have to remove power for 1-2 min for the disk to become accessible again.
> 
> Do you think the disk is bad or something?
> 
> Please make sure you cc me as I am not subscribed in this list.
> 
>   .bill

Have you tried 2.6.29?
i.g. I've noticed that /dev/hd*
was changed to /dev/sd* with some distro's,
(or maybe it was the kernel(who knows!!))
which in some cases, causes some confusion between 
grub/lilo etc..

regards,

Justin P. Mattock

