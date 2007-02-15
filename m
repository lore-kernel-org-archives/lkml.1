Return-Path: <linux-kernel-owner+w=401wt.eu-S932629AbXBOEc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbXBOEc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 23:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932618AbXBOEc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 23:32:59 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:12444 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181AbXBOEc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 23:32:58 -0500
Date: Wed, 14 Feb 2007 22:30:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: sata_nv ADMA controller lockup investigation
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Allen Martin <AMartin@nvidia.com>
Cc: nas@arctrix.com, B.Steinbrink@gmx.de
Message-id: <45D3E1FF.3080606@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While testing out some libata FUA changes I was working on, I was 
inadvertently able to reproduce the kind of NCQ command timeouts in 
sata_nv that a few people have reported. I since verified that the FUA 
stuff had nothing to do with it as it still happens even with FUA 
disabled. However I'm somewhat at a loss as to how to further debug 
this, so I'm posting my findings in the hope that somebody has some more 
ideas (or anyone at NVIDIA decides to come forth with a tip or two).

The conditions in which I can reproduce this are with:

ext3 filesystem mounted with -o barrier=1
Two instances of a program which truncates a file, then writes single bytes
to it, fsyncing after each one.
Simultaneously, repeatedly writing 100MB from /dev/zero to a file
using dd.

A command timeout usually happens within a few minutes. With my working copy
loaded up with a ton of extra debugging, the exception report for one of
these looks like this. My comments are indented.

ata4: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400 cpb count 0x0 next cpb idx 0x0
	This is just dumping all of the ADMA registers when the timeout
	happened.
ata4: last intr at 1171511467:501179, status 0x1540
	This shows the time of the last interrupt in seconds:microseconds and the
	ADMA status register contents at that time.
ata4: cmd 61/08:00:40:36:75/00:00:0c:00:00/40 tag 0 at 1171511467:360525 done 1171511467:393064, stat before 0x400 after 0x400
ata4: cmd 61/40:00:80:a1:64/00:00:0a:00:00/40 tag 0 at 1171511467:393928 done 1171511467:394345, stat before 0x500 after 0x400
ata4: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 at 1171511467:394400 done 1171511467:425548, stat before 0x500 after 0x400
ata4: cmd 61/08:00:c0:a1:64/00:00:0a:00:00/40 tag 0 at 1171511467:425556 done 1171511467:425694, stat before 0x500 after 0x400
ata4: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 at 1171511467:425699 done 1171511467:433896, stat before 0x500 after 0x400
ata4: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 at 1171511467:433958 done 1171511467:433971, stat before 0x500 after 0x400
ata4: cmd 61/08:00:c8:a1:64/00:00:0a:00:00/40 tag 0 at 1171511467:433978 done 1171511467:434152, stat before 0x500 after 0x400
ata4: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 at 1171511467:434160 done 1171511467:442326, stat before 0x500 after 0x400
ata4: cmd 61/08:00:d0:a1:64/00:00:0a:00:00/40 tag 0 at 1171511467:442389 done 1171511467:442843, stat before 0x500 after 0x400
ata4: cmd 61/08:08:88:7e:75/00:00:0c:00:00/40 tag 1 at 1171511467:442395 done 1171511467:442846, stat before 0x400 after 0x400
ata4: cmd 61/e8:10:08:58:77/01:00:0c:00:00/40 tag 2 at 1171511467:442419 done 1171511467:445010, stat before 0x400 after 0x400
ata4: cmd 61/e8:18:f0:59:77/01:00:0c:00:00/40 tag 3 at 1171511467:442437 done 1171511467:447182, stat before 0x0 after 0x0
ata4: cmd 61/e8:20:d8:5b:77/01:00:0c:00:00/40 tag 4 at 1171511467:442455 done 1171511467:449343, stat before 0x0 after 0x0
ata4: cmd 61/e8:28:c0:5d:77/01:00:0c:00:00/40 tag 5 at 1171511467:442475 done 1171511467:451543, stat before 0x0 after 0x0
ata4: cmd 61/30:30:a8:5f:77/00:00:0c:00:00/40 tag 6 at 1171511467:442481 done 1171511467:451833, stat before 0x0 after 0x0
ata4: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 at 1171511467:451858 done 1171511467:492486, stat before 0x500 after 0x400
ata4: cmd 61/08:00:d8:a1:64/00:00:0a:00:00/40 tag 0 at 1171511467:492498 done 1171511467:492666, stat before 0x500 after 0x400
ata4: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 at 1171511467:492671 done 1171511467:500909, stat before 0x500 after 0x400
ata4: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 at 1171511467:501167 done 1171511467:501181, stat before 0x500 after 0x400
ata4: cmd 61/08:00:e0:a1:64/00:00:0a:00:00/40 tag 0 at 1171511467:501187 done 0:0, stat before 0x500 after 0x400
	These lines show the last 20 commands issued, the contents of the
	taskfile, the tag, the time in sec:usec they were issued,
	the time in sec:usec they completed (0:0 for still incomplete),
	the ADMA status register contents before issuing the command,
	and the register contents after issuing the command.
ata4: CPB 0: ctl_flags 0x1f, resp_flags 0x0
	Contents of the outstanding CPB's flags, showing that the controller
	seems not to have touched it, released and done flags are clear.
ata4: timeout waiting for ADMA IDLE, stat=0x400
ata4: timeout waiting for ADMA LEGACY, stat=0x400
	As part of error handling we try to switch the controller back to
	legacy mode. We time out waiting for the controller to show
	IDLE, and then clear the GO bit, and then time out waiting for it
	to show the LEGACY state. Right after this we beat it over the head
	with NV_ADMA_CTL_CHANNEL_RESET which finally seems to restore its
	senses, until one of these happens again.
ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
ata4.00: cmd 61/08:00:e0:a1:64/00:00:0a:00:00/40 tag 0 cdb 0x0 data 4096 out
         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4: soft resetting port
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: configured for UDMA/133
ata4: EH complete
SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

The pattern of the hang always seems to be that it's an NCQ command that
immediately follows a cache flush. When that NCQ command is issued, the
IDLE bit clears as we would expect, but then it stays like that
with just the STOPPED bit set. No interrupt is raised and the CPB response
flags are not updated to indicate the command was released (i.e. received
by the drive) or completed. It's like the controller accepted the command
and then stalled before actually doing anything with it.

My guess it's either a bug in the controller that needs to be somehow
worked around, or we're somehow not operating the controller "properly".
The latter is very difficult for me to determine since the only
documentation I have other than the original NVIDIA-provided driver for
this controller is the ADMA standard, which this controller only vaguely
follows (for example, not all of the status bits on this controller
are in the ADMA standard and some of the meanings for those that are
there seem to be different).

My only real clue at this point is maybe there's something wrong with
the way we are giving the commands to the controller, using the
APPEND register. That's another thing that's not in the ADMA standard.
It's curious that only the post-cache-flush command is having issues,
and normal NCQ operation seems fine. Maybe it's related to that tag 0
being reused repeatedly?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/



