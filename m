Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbYACEZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbYACEZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 23:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759877AbYACEZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 23:25:35 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:38917 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756981AbYACEZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 23:25:24 -0500
Message-ID: <477C63AA.8080006@tlinx.org>
Date: Wed, 02 Jan 2008 20:25:14 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: SATA kernel-buffered read VERY slow (not raid, Promise TX300
 card); 2.6.23.1(vanilla)
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no> <4777E08C.4000603@shaw.ca> <4779870E.5070507@tlinx.org> <20080101015812.59e9ebf0@the-village.bc.nu> <477BEF8D.8090307@tlinx.org> <477C2B71.7040504@shaw.ca>
In-Reply-To: <477C2B71.7040504@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Linda Walsh wrote:
>> Alan Cox wrote:
>>>> rate began falling; at 128k block-reads-at-a-time or larger, it 
>>>> drops below
>>>> 20MB/s (only on buffered SATA).
>>> Try disabling NCQ - see if you've got a drive with the 'NCQ = no
>>> readahead' flaw.
> http://linux-ata.org/faq.html#ncq
---
    When drive initializes, dmesg says it has NCQ (depth 0/32)
    Reading the queue_depth under /sys, shows a queuedepth of "1".

But more importantly -- I notice a chronic error message associate
with this drive that may be causing some or all of the problem:
---
Jan  2 20:06:10 Ishtar kernel: ata1.00: exception Emask 0x0 SAct 0x0 
SErr 0x0 action 0x2
Jan  2 20:06:10 Ishtar kernel: ata1.00: port_status 0x20080000
Jan  2 20:06:10 Ishtar kernel: ata1.00: cmd 
c8/00:10:30:06:03/00:00:00:00:00/e0 tag 0 cdb 0x0 data 8192 in
Jan  2 20:06:10 Ishtar kernel:          res 
50/00:00:3f:06:03/00:00:00:00:00/e0 Emask 0x2 (HSM violation)
Jan  2 20:06:13 Ishtar kernel: ata1: limiting SATA link speed to 1.5 Gbps
Jan  2 20:06:13 Ishtar kernel: ata1.00: exception Emask 0x0 SAct 0x0 
SErr 0x0 action 0x6
Jan  2 20:06:13 Ishtar kernel: ata1.00: port_status 0x20080000
Jan  2 20:06:13 Ishtar kernel: ata1.00: cmd 
c8/00:10:00:8b:04/00:00:00:00:00/e0 tag 0 cdb 0x0 data 8192 in
Jan  2 20:06:13 Ishtar kernel:          res 
50/00:00:0f:8b:04/00:00:00:00:00/e0 Emask 0x2 (HSM violation)
Jan  2 20:06:14 Ishtar kernel: ata1: exception Emask 0x10 SAct 0x0 SErr 
0x0 action 0x3
Jan  2 20:06:14 Ishtar kernel: ata1: hotplug_status 0x80
Jan  2 20:06:15 Ishtar kernel: ata1: exception Emask 0x10 SAct 0x0 SErr 
0x0 action 0x3
Jan  2 20:06:15 Ishtar kernel: ata1: hotplug_status 0x80
---
What da heck?  Note, this is with NCQ-queuing set to "1".  Only 
reference I could find for this error referred to "older drives", but 
this is a
2007-model year drive with ATA-7 and udma-6.

> I don't think you can get or get the multi count currently, it just 
> uses the best supported value.
ok
>
>> 2) Drive Advanced Power Management setting("-B") (write-only):
>> "HDIO_DRIVE_CMD failed: Input/output error"
>> 3) Drive Acoustic ("-M"), read = " acoustic      = not supported",
>> write = " HDIO_DRIVE_CMD:ACOUSTIC failed: Input/output error"
>
> Not sure about these ones.. Does anything show up in dmesg when you do 
> this?
---
    Yes:
    (for "-B", power-management)
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: port_status 0x20200000
ata1.00: cmd ef/05:fe:00:00:00/00:00:00:00:00/40 tag 0 cdb 0x0 data 0
         res 51/04:fe:00:00:00/00:00:00:00:00/40 Emask 0x1 (device error)
ata1.00: configured for UDMA/133
ata1: EH complete
sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
----
   (for "-M" acoustic management):
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: port_status 0x20200000
ata1.00: cmd ef/42:fe:00:00:00/00:00:00:00:00/40 tag 0 cdb 0x0 data 0
         res 51/04:fe:00:00:00/00:00:00:00:00/40 Emask 0x1 (device error)
ata1.00: configured for UDMA/133
ata1: EH complete
sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA


