Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbXGVXea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbXGVXea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760682AbXGVXeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:34:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43059 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbXGVXeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:34:21 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46A3E973.6090701@s5r6.in-berlin.de>
Date: Mon, 23 Jul 2007 01:34:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Andreas Messer <andreas.messer@stud-mail.uni-wuerzburg.de>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [BUG] firewire: mass-storage i/o-problems
References: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de>
In-Reply-To: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(quoting in full for linux1394-devel, Cc added)

Andreas Messer wrote at LKML:
> Hello,
> 
> I tried the new firewire stack with a external harddisc and a external dvd 
> writer and get massive i/o problems. Here is the kernel output for the 
> harddisc. Please cc me for further questions. I hope its not too much output 
> for lkml email. 
> 
> --------------------------------------------------------------
> firewire_core: created new fw device fw1 (0 config rom retries)
> firewire_core: phy config: card 0, new root=ffc0, gap_count=5
> scsi2 : SBP-2 IEEE-1394
> firewire_sbp2: management write failed, rcode 0x14
> firewire_sbp2: orb reply timed out, rcode=0x11
> firewire_sbp2: management write failed, rcode 0x10
> message repeated 2 times
> firewire_sbp2: management write failed, rcode 0x14
> firewire_sbp2: failed to login to fw1.0
> firewire_sbp2: management write failed, rcode 0x13

#define RCODE_SEND_ERROR		0x10
#define RCODE_GENERATION		0x13
#define RCODE_NO_ACK			0x14

There are multiple bus resets happening while fw-sbp2 tries to log in.
Normally I would say that this is a sign of an electrically unstable
bus.  But since the old drivers don't show anything like that at all,
there must be problems in the new drivers.

> firewire_sbp2: removed sbp2 unit fw1.0
> firewire_core: phy config: card 0, new root=ffc1, gap_count=5
> scsi3 : SBP-2 IEEE-1394
> firewire_core: created new fw device fw1 (0 config rom retries)

Here even the device fw1 vanished from fw-core's point of view, then
came back.

> firewire_sbp2: logged in to sbp2 unit fw1.0 (0 retries)
> firewire_sbp2: - management_agent_address: 0xfffff0010000
> firewire_sbp2: - command_block_agent_address: 0xfffff0010020
> firewire_sbp2: - status write address: 0x000100000000
> scsi 3:0:0:0: Direct-Access-RBC SAMSUNG HD300LD PQ: 0 ANSI: 4
> sd 3:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
> firewire_sbp2: sbp2_scsi_abort
> firewire_sbp2: sbp2_scsi_abort
> sd 3:0:0:0: scsi: Device offlined - not ready after error recovery
> sd 3:0:0:0: [sdb] Write Protect is off
> sd 3:0:0:0: [sdb] Mode Sense: 00 00 00 00
> sd 3:0:0:0: rejecting I/O to offline device
> sd 3:0:0:0: [sdb] Asking for cache data failed
> sd 3:0:0:0: [sdb] Assuming drive cache: write through
> sd 3:0:0:0: [sdb] Attached SCSI disk
> sd 3:0:0:0: Attached scsi generic sg3 type 14
> firewire_sbp2: management write failed, rcode 0x13
> firewire_sbp2: removed sbp2 unit fw1.0
> 
> replugged hdd:
> 
> firewire_core: phy config: card 0, new root=ffc1, gap_count=5
> scsi4 : SBP-2 IEEE-1394
> firewire_core: created new fw device fw1 (0 config rom retries)
> firewire_sbp2: logged in to sbp2 unit fw1.0 (0 retries)
> firewire_sbp2: - management_agent_address: 0xfffff0010000
> firewire_sbp2: - command_block_agent_address: 0xfffff0010020
> firewire_sbp2: - status write address: 0x000100000000
> scsi 4:0:0:0: Direct-Access-RBC SAMSUNG HD300LD PQ: 0 ANSI: 4
> sd 4:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
> sd 4:0:0:0: [sdb] Write Protect is off
> sd 4:0:0:0: [sdb] Mode Sense: 11 00 00 00
> sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
> DPO or FUA
> sd 4:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
> sd 4:0:0:0: [sdb] Write Protect is off
> sd 4:0:0:0: [sdb] Mode Sense: 11 00 00 00
> sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
> DPO or FUA
> sdb: sdb1
> sd 4:0:0:0: [sdb] Attached SCSI disk
> sd 4:0:0:0: Attached scsi generic sg3 type 14
> firewire_sbp2: sbp2_scsi_abort
> firewire_sbp2: sbp2_scsi_abort
> sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
> sd 4:0:0:0: [sdb] Result: hostbyte=DID_BUS_BUSY 
> driverbyte=DRIVER_OK,SUGGEST_OK
> end_request: I/O error, dev sdb, sector 518
> sd 4:0:0:0: rejecting I/O to offline device
> sd 4:0:0:0: rejecting I/O to offline device
> sd 4:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT 
> driverbyte=DRIVER_OK,SUGGEST_OK
> end_request: I/O error, dev sdb, sector 286153
> FAT: FAT read failed (blocknr 455)
> sd 4:0:0:0: rejecting I/O to offline device
> FAT: Directory bread(block 286090) failed
> sd 4:0:0:0: rejecting I/O to offline device
> 
> .... (many lines of that)
> 
> Buffer I/O error on device sdb1, logical block 143073
> lost page write due to I/O error on sdb1
> firewire_sbp2: management write failed, rcode 0x13
> sd 4:0:0:0: [sdb] Synchronizing SCSI cache
> sd 4:0:0:0: [sdb] Result: hostbyte=DID_BUS_BUSY 
> driverbyte=DRIVER_OK,SUGGEST_OK
> firewire_sbp2: removed sbp2 unit fw1.0
> 
> replugged again:
> 
> firewire_core: phy config: card 0, new root=ffc1, gap_count=5
> scsi5 : SBP-2 IEEE-1394
> firewire_core: created new fw device fw1 (0 config rom retries)
> firewire_sbp2: orb reply timed out, rcode=0x11
> firewire_sbp2: management write failed, rcode 0x12
> message repeated 4 times
> firewire_sbp2: failed to login to fw1.0
> firewire_sbp2: status write for unknown orb
> firewire_sbp2: management write failed, rcode 0x13
> firewire_sbp2: removed sbp2 unit fw1.0
> 
> replugged again:
> 
> firewire_core: phy config: card 0, new root=ffc1, gap_count=5
> scsi6 : SBP-2 IEEE-1394
> firewire_core: created new fw device fw1 (0 config rom retries)
> firewire_sbp2: orb reply timed out, rcode=0x11
> firewire_sbp2: management write failed, rcode 0x12
> message repeated 4 times
> firewire_sbp2: failed to login to fw1.0
> firewire_sbp2: status write for unknown orb
> 
> using old fw stack, everything fine:
> 
> ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19] MMIO=[ee001000-ee0017ff] Max 
> Packet=[2048] IR/IT contexts=[4/8]
> ieee1394: The root node is not cycle master capable; selecting a new root node 
> and resetting...
> ieee1394: Node added: ID:BUS[0-00:1023] GUID[0050770e0000002e]
> ieee1394: Host added: ID:BUS[0-01:1023] GUID[000a480000000edf]
> scsi2 : SBP-2 IEEE-1394
> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: sbp2: Node 0-00:1023: Max speed [S400] - Max payload [2048]
> scsi 2:0:0:0: Direct-Access-RBC SAMSUNG HD300LD PQ: 0 ANSI: 4
> sd 2:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 11 00 00 00
> sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
> DPO or FUA
> sd 2:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 11 00 00 00
> sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
> DPO or FUA
> sdb: sdb1
> sd 2:0:0:0: [sdb] Attached SCSI disk
> sd 2:0:0:0: Attached scsi generic sg3 type 14
> -------------------------------------------
> 
> Hardware: 
> Via ohci1394 FW Controller (PCI), nforce2 chipset, Athlon XP-M

Are you sure the FireWire controller is from VIA?  Check with lscpi.
The NVidia nForce2 chipset has an own FireWire controller, and that one
is only "supported" by a gross hack in ohci1394 and at the moment
unsupported in firewire-ohci.  There is even a bug report in Red Hat's
bugzilla where fw-ohci hung up when trying to initialize an nForce2 chip.

> Software:
> Kernel Vanilla 2.6.22, gcc 4.1.2. 
> 
> On another PC same problem, but replugging one or two times get the thing 
> working. 

Which controller does this other PC have?

BTW, the GUID of the host in the above ieee1394 log is from Albatron
Technology, and th GUID of the disk is from Prolific Technology, Inc.
Some (many?) Prolific based devices were and maybe still are sold with
outdated buggy firmware.
-- 
Stefan Richter
-=====-=-=== -=== =-===
http://arcgraph.de/sr/
