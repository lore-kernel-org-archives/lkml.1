Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZDUBwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZDUBwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZDUBwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:52:36 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:24842 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbZDUBwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:52:35 -0400
Date: Mon, 20 Apr 2009 18:52:34 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6.30-rc2] CD-R: wodim intermittent failures: [sr0] Add. Sense: Logical block address out of range, sector 0
Message-ID: <20090421015234.GA7014@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running 2.6.30-rc2-00446-ga939b96 on a Dell E4300 with a
upgraded-to-Jaunty-mostly Ubuntu install.  Using 2.6.28 and 2.6.29.1,
I've successfully burned a dozen CDRs, but since updating to .30-rc1
I've noticed intermittent failures to burn CDRs using wodim at the Gnome
desktop.  (Switching back to .29.1 makes wodim reliable again.)  There
have been a few different failure modes, but all of them seem to be
associated with these messages in dmesg, which I haven't seen before:

[  360.740810] sr 1:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  360.740816] sr 1:0:0:0: [sr0] Sense Key : Illegal Request [current] 
[  360.740820] sr 1:0:0:0: [sr0] Add. Sense: Logical block address out of range
[  360.740826] end_request: I/O error, dev sr0, sector 0
[  360.740830] Buffer I/O error on device sr0, logical block 0

(repeated a few dozen times).

I haven't been able to reproduce these messages running wodim at the
console (after "/etc/init.d/gdm stop") so I suspect there's some
interference between wodim and Gnome's desktop device detection.

I've seen the following behavior running wodim under gnome:

1. wodim blocked in D state for >10 minutes, system showing interactive
lagginess.  Unfortunately I've not been able to reproduce this to get
wchan info, but I *think* it was showing blk_execute_rq.

2. running wodim triggers DID_OK messages, but wodim seems to be able to
complete writing the ISO and the resulting CDR reads OK.

3. running wodim triggers DID_OK messages, and wodim fails:  (but I
think this is just due to the media having been partially written by a
previous iteration of wodim.)

% wodim ubuntu-9.04-rc-desktop-amd64.iso
wodim: No write mode specified.
wodim: Asuming -tao mode.
wodim: Future versions of wodim may have different drive dependent defaults.
wodim: Operation not permitted. Warning: Cannot raise RLIMIT_MEMLOCK limits.Device was not specified. Trying to find an appropriate drive...
Looking for a CD-R drive to store 698.17 MiB...
Detected CD-R drive: /dev/cdrw
Using /dev/cdrom of unknown capabilities
Device type    : Removable CD-ROM
Version        : 5
Response Format: 2
Capabilities   : 
Vendor_info    : 'TSSTcorp'
Identification : 'DVD+-RW TS-U633A'
Revision       : 'D200'
Device seems to be: Generic mmc2 DVD-R/DVD-RW.
Using generic SCSI-3/mmc   CD-R/CD-RW driver (mmc_cdr).
Driver flags   : MMC-3 SWABAUDIO BURNFREE 
Supported modes: TAO PACKET SAO SAO/R96P SAO/R96R RAW/R16 RAW/R96P RAW/R96R
Speed set to 4234 KB/s
Starting to write CD/DVD at speed  24.0 in real TAO mode for single session.
Last chance to quit, starting real write in    0 seconds. Operation starts.
Errno: 5 (Input/output error), write_g1 scsi sendcmd: no error
CDB:  2A 00 FF FF FF FF 00 00 1F 00
status: 0x2 (CHECK CONDITION)
Sense Bytes: 70 00 05 00 00 00 00 0A 00 00 00 00 21 00 00 00
Sense Key: 0x5 Illegal Request, Segment 0
Sense Code: 0x21 Qual 0x00 (logical block address out of range) Fru 0x0
Sense flags: Blk 0 (not valid) 
cmd finished after 0.003s timeout 40s
write track data: error after 0 bytes
wodim: The current problem looks like a buffer underrun.
wodim: It looks like 'driveropts=burnfree' does not work for this drive.
wodim: Please report.
wodim: Make sure that you are root, enable DMA and check your HW/OS set up.
Errno: 5 (Input/output error), close track/session scsi sendcmd: no error
CDB:  5B 00 02 00 00 00 00 00 00 00
status: 0x2 (CHECK CONDITION)
Sense Bytes: 70 00 05 00 00 00 00 0A 00 00 00 00 72 03 00 00
Sense Key: 0x5 Illegal Request, Segment 0
Sense Code: 0x72 Qual 0x03 (session fixation error - incomplete track in session) Fru 0x0
Sense flags: Blk 0 (not valid) 
cmd finished after 0.340s timeout 480s
cmd finished after 0.340s timeout 480s
wodim: Cannot fixate disk.

I'm running "wodim ubuntu-9.04-rc-desktop-amd64.iso" as a regular user
with group write permissions to /dev/sr0.

I've seen /lib/udev/vol_id running *after* wodim has opened the device,
so I wonder if there's some race condition there.

This is with udev 140-2 and wodim 9:1.1.9-1ubuntu1.  .config and
additional information available at:

http://web.hexapodia.org/~adi/sysinfo/1240274989_cvpe4300_2.6.30-rc2-00446-ga939b96/

-andy
