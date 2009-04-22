Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZDVVvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZDVVvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZDVVuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:50:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752761AbZDVVus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:50:48 -0400
Date: Wed, 22 Apr 2009 14:49:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Isaacson <adi@hexapodia.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [2.6.30-rc2] CD-R: wodim intermittent failures: [sr0] Add.
 Sense: Logical block address out of range, sector 0
Message-Id: <20090422144904.407df635.akpm@linux-foundation.org>
In-Reply-To: <20090421015234.GA7014@hexapodia.org>
References: <20090421015234.GA7014@hexapodia.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 18:52:34 -0700
Andy Isaacson <adi@hexapodia.org> wrote:

> I'm running 2.6.30-rc2-00446-ga939b96 on a Dell E4300 with a
> upgraded-to-Jaunty-mostly Ubuntu install.  Using 2.6.28 and 2.6.29.1,
> I've successfully burned a dozen CDRs, but since updating to .30-rc1
> I've noticed intermittent failures to burn CDRs using wodim at the Gnome
> desktop.  (Switching back to .29.1 makes wodim reliable again.)  There
> have been a few different failure modes, but all of them seem to be
> associated with these messages in dmesg, which I haven't seen before:
> 
> [  360.740810] sr 1:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [  360.740816] sr 1:0:0:0: [sr0] Sense Key : Illegal Request [current] 
> [  360.740820] sr 1:0:0:0: [sr0] Add. Sense: Logical block address out of range
> [  360.740826] end_request: I/O error, dev sr0, sector 0
> [  360.740830] Buffer I/O error on device sr0, logical block 0
> 
> (repeated a few dozen times).
> 
> I haven't been able to reproduce these messages running wodim at the
> console (after "/etc/init.d/gdm stop") so I suspect there's some
> interference between wodim and Gnome's desktop device detection.
> 
> I've seen the following behavior running wodim under gnome:
> 
> 1. wodim blocked in D state for >10 minutes, system showing interactive
> lagginess.  Unfortunately I've not been able to reproduce this to get
> wchan info, but I *think* it was showing blk_execute_rq.
> 
> 2. running wodim triggers DID_OK messages, but wodim seems to be able to
> complete writing the ISO and the resulting CDR reads OK.
> 
> 3. running wodim triggers DID_OK messages, and wodim fails:  (but I
> think this is just due to the media having been partially written by a
> previous iteration of wodim.)
> 
> % wodim ubuntu-9.04-rc-desktop-amd64.iso
> wodim: No write mode specified.
> wodim: Asuming -tao mode.
> wodim: Future versions of wodim may have different drive dependent defaults.
> wodim: Operation not permitted. Warning: Cannot raise RLIMIT_MEMLOCK limits.Device was not specified. Trying to find an appropriate drive...
> Looking for a CD-R drive to store 698.17 MiB...
> Detected CD-R drive: /dev/cdrw
> Using /dev/cdrom of unknown capabilities
> Device type    : Removable CD-ROM
> Version        : 5
> Response Format: 2
> Capabilities   : 
> Vendor_info    : 'TSSTcorp'
> Identification : 'DVD+-RW TS-U633A'
> Revision       : 'D200'
> Device seems to be: Generic mmc2 DVD-R/DVD-RW.
> Using generic SCSI-3/mmc   CD-R/CD-RW driver (mmc_cdr).
> Driver flags   : MMC-3 SWABAUDIO BURNFREE 
> Supported modes: TAO PACKET SAO SAO/R96P SAO/R96R RAW/R16 RAW/R96P RAW/R96R
> Speed set to 4234 KB/s
> Starting to write CD/DVD at speed  24.0 in real TAO mode for single session.
> Last chance to quit, starting real write in    0 seconds. Operation starts.
> Errno: 5 (Input/output error), write_g1 scsi sendcmd: no error
> CDB:  2A 00 FF FF FF FF 00 00 1F 00
> status: 0x2 (CHECK CONDITION)
> Sense Bytes: 70 00 05 00 00 00 00 0A 00 00 00 00 21 00 00 00
> Sense Key: 0x5 Illegal Request, Segment 0
> Sense Code: 0x21 Qual 0x00 (logical block address out of range) Fru 0x0
> Sense flags: Blk 0 (not valid) 
> cmd finished after 0.003s timeout 40s
> write track data: error after 0 bytes
> wodim: The current problem looks like a buffer underrun.
> wodim: It looks like 'driveropts=burnfree' does not work for this drive.
> wodim: Please report.
> wodim: Make sure that you are root, enable DMA and check your HW/OS set up.
> Errno: 5 (Input/output error), close track/session scsi sendcmd: no error
> CDB:  5B 00 02 00 00 00 00 00 00 00
> status: 0x2 (CHECK CONDITION)
> Sense Bytes: 70 00 05 00 00 00 00 0A 00 00 00 00 72 03 00 00
> Sense Key: 0x5 Illegal Request, Segment 0
> Sense Code: 0x72 Qual 0x03 (session fixation error - incomplete track in session) Fru 0x0
> Sense flags: Blk 0 (not valid) 
> cmd finished after 0.340s timeout 480s
> cmd finished after 0.340s timeout 480s
> wodim: Cannot fixate disk.
> 
> I'm running "wodim ubuntu-9.04-rc-desktop-amd64.iso" as a regular user
> with group write permissions to /dev/sr0.
> 
> I've seen /lib/udev/vol_id running *after* wodim has opened the device,
> so I wonder if there's some race condition there.
> 
> This is with udev 140-2 and wodim 9:1.1.9-1ubuntu1.  .config and
> additional information available at:
> 
> http://web.hexapodia.org/~adi/sysinfo/1240274989_cvpe4300_2.6.30-rc2-00446-ga939b96/
> 

Is seems unreasonably hard (to me) to work out what low-level driver is
in use when we see bug reports like this.

Trolling your dmesg
(http://web.hexapodia.org/~adi/sysinfo/1240274989_cvpe4300_2.6.30-rc2-00446-ga939b96/dmesg.out)
I see 

[    2.184016] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.198709] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-U633A, D200, max UDMA/100, ATAPI AN
[    2.198774] ata2.00: applying bridge limits
[    2.214107] ata2.00: configured for UDMA/100
[    2.230305] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-U633A D200 PQ: 0 ANSI: 5
[    2.548015] ata5: SATA link down (SStatus 0 SControl 300)
[    2.884014] ata6: SATA link down (SStatus 0 SControl 300)

so I guess that it's serial ATA, at least.

But which lower-level ata driver is being used under that?

[    0.717960] ahci 0000:00:1f.2: version 3.0
[    0.717968] ahci 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.718057] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    0.718097] ahci: SSS flag set, parallel bus scan disabled
[    0.718176] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl RAID mode
[    0.718236] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
[    0.718298] ahci 0000:00:1f.2: setting latency timer to 64

ahci, I guess.


Probably this is all perfectly obvious to the initiated, but for those
whose life revolves around telling the initiated about their bugs, this
is all unreasonably hard :(

Oh well, let's tentatively assume that we have a post-2.6.29 regression
in the libata ahci driver.

