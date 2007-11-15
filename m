Return-Path: <linux-kernel-owner+w=401wt.eu-S933278AbXKOVrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbXKOVrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbXKOVqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:46:55 -0500
Received: from empbedex1.empirix.com ([12.38.203.54]:29808 "EHLO
	empbedex1.empirix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbXKOVqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:46:53 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.23.1 - sata_mv (7042) hang with large file operations
Date: Thu, 15 Nov 2007 16:46:46 -0500
Message-ID: <BD261180E6D35F4D9D32F3E44FD3D9010AB2CFF0@EMPBEDEX.empirix.com>
In-Reply-To: <473C7625.2040300@rtr.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.23.1 - sata_mv (7042) hang with large file operations
Thread-Index: AcgnphXoE+ssdgM9QVmtKbMWrNAvDwAJ9HEA
References: <BD261180E6D35F4D9D32F3E44FD3D901053E84BD@EMPBEDEX.empirix.com> <45ED682A.9040408@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com> <4728A816.8020608@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010AAE852F@EMPBEDEX.empirix.com> <473B36D7.8000205@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE8585@EMPBEDEX.empirix.com> <473B44CB.6010209@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE89CA@EMPBEDEX.empirix.com> <473B76E0.7010500@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE911D@EMPBEDEX.empirix.com> <473C7625.2040300@rtr.ca>
From: "Morrison, Tom" <tmorrison@empirix.com>
To: "Mark Lord" <liml@rtr.ca>
Cc: "Jeff Garzik" <jeff@garzik.org>, <linux-ide@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Nov 2007 21:46:52.0570 (UTC) FILETIME=[089527A0:01C827D1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The plot thickens - it looks like it might be some type 
of problem interacting with the setup of my 4Gig DDR memory
and how I setup some translation windows in my MPC8548E

I realized this morning that I have an inbound/ output PEX window
Translation Setup for mapping all from/to PEX bus to outside 
the physical 4GIG memory space (i.e.: up at 0xC_xxxx_xxxx). Thus,
all output operations that translation from 0xC_xxxx_xxxx to 
the pci 32 bit address of xxxx_xxxx) - and vice versa for for
the inbound. Note: we also have a straight 1:1 translation mapping 
as well for the lower 4Gig - so that's why this worked without
the below mentioned change...

So, I changed the Request & Response Hi Addresses (which were
Being shifted by 32 bits down anyways) and 'OR' that with my 
0xC (so the effective 64bit DMA address is 0xC_xxxx_xxxx (where 
Xxxx_xxxx is the effective address). This was what we did to 
solve the problem with the Marvel Linux driver that we got from
the Marvel site....

This all works just fine with ONLY 2 gig of memory in the system
(and still have these inbound/output pex translation windows), 
but fails when I put back the 4 Gig (and the 8Gig) DDR memory.

Unfortunately, this still hasn't solved the problem though - 
so there is something else which I am not seeing?

I have a couple more ideas - but this is a toughy



-----Original Message-----

Morrison, Tom wrote:
> Additional information - the ~file size this is caused 
> is somewhere close to 260Mbytesfiles. 
> 
> If I create a ~260Mbytes file - my program finishes creating
> the file - but ~5 seconds later (I timed this by hitting enter
> on the console every second after completion of the command 
> that should have done a fsync of the created file before exiting)...
> It hangs...
> 
> I did a little playing around with /proc/sys/dev/scsi/logging_level
> (set to 0x7) - and it seems that the kernel/box locks up after
> this line:
> 
>>> scsi_add_timer: scmd: efca83c0, time: 7500, (c0160660)
>>> scsi_delete_timer: scmd: efca83c0, rtn: 1
>>> scsi_add_timer: scmd: efca8840, time: 7500, (c0160660)
> 
> 
> Further analysis (setting logging level to 65535 (0xFFFF) 
> Has the following behavior down low) - 
> 
>>> scsi_add_timer: scmd: efca8960, time: 7500, (c0160660)
>>> sd 0:0:0:0: [sda] Send: 0xefca8960
>>> sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 00 47 92 27 00 01 48 00
>>> buffer = 0xc0553040, bufflen = 167936, done = 0xc016b194,
> queuecommand
>       0xc017ed34
>>> leaving scsi_dispatch_cmnd()
>>> scsi_delete_timer: scmd: efca8960, rtn: 1
>>> sd 0:0:0:0: [sda] Done: 0xefca8960 SUCCESS
>>> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK,SUGGEST_OK
>>> sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 00 47 92 27 00 01 48 00
>>> sd 0:0:0:0: [sda] scsi host busy 1 failed 0
>>> sd 0:0:0:0: Notifying upper driver of completion (result 0)
>>>
>>> scsi_add_timer: scmd: efca82a0, time: 7500, (c0160660)
>>> sd 0:0:0:0: [sda] Send: 0xefca82a0
>>> sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 00 47 93 6f 00 02 40 00
>>> buffer = 0xef5734c0, bufflen = 294912, done = 0xc016b194,
> queuecommand
>       0xc017ed34
>>> leaving scsi_dispatch_cmnd()
> 
> Nothing more - it hangs!
> 
> This is really a nasty problem!!!!
..

Yes.  It's particularly nasty because, as of yet, I haven't seen
anything
to lead me to conclude *which* kernel subsystem is locking up.

It could be the block layer.
It could be some PPC arch bug.
It could be mm.
It could even be the CPU scheduler.

Those messages above could help.
Now we just need somebody to interpret them,
and examine the code paths that follow to see
where it might be possible to get stuck.

The SCSI/libata layers by themselves could lock up the I/O,
but not the entire machine..

Cheers
 

