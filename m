Return-Path: <linux-kernel-owner+w=401wt.eu-S1764943AbXKOQj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764943AbXKOQj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759057AbXKOQjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:39:05 -0500
Received: from rtr.ca ([76.10.145.34]:4678 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758729AbXKOQjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:39:02 -0500
Message-ID: <473C7625.2040300@rtr.ca>
Date: Thu, 15 Nov 2007 11:39:01 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Morrison, Tom" <tmorrison@empirix.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.1 - sata_mv (7042) hang with large file operations
References: <BD261180E6D35F4D9D32F3E44FD3D901053E84BD@EMPBEDEX.empirix.com> <45ED682A.9040408@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com> <4728A816.8020608@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010AAE852F@EMPBEDEX.empirix.com> <473B36D7.8000205@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE8585@EMPBEDEX.empirix.com> <473B44CB.6010209@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE89CA@EMPBEDEX.empirix.com> <473B76E0.7010500@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE911D@EMPBEDEX.empirix.com>
In-Reply-To: <BD261180E6D35F4D9D32F3E44FD3D9010AAE911D@EMPBEDEX.empirix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

Yes.  It's particularly nasty because, as of yet, I haven't seen anything
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
 

