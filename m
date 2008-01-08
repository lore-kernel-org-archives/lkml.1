Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbYAHAaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYAHAaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 19:30:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYAHA3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 19:29:51 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:62336 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbYAHA3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 19:29:50 -0500
Date: Mon, 07 Jan 2008 18:29:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM: I/O scheduler problem with an 8 SATA disks raid 5 under
 heavy load  ?
In-reply-to: <fa.NcJePXcdrF+7E7oXv5ULIxogTYI@ifi.uio.no>
To: =?ISO-8859-1?Q?Guillaume_Laur=E8s?= <guillaume-laures@neuf.fr>
Cc: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Message-id: <4782C3DB.1090201@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.NcJePXcdrF+7E7oXv5ULIxogTYI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurès wrote:
> Hello,
> 
> Dear kernel developers, my dmesg asked me to report this, so here I go ;)
> Here is what I found in my dmesg: "anticipatory: forced dispatching is 
> broken (nr_sorted=1), please report this".
> 
> - First, let's talk about the machine: it's quite pushed so maybe the 
> cause is me doing something wrong rather than a bug in the kernel.
> 
> I got this alert on a dual core amd64 xen host. It has 8 SATA drives 
> making a raid 5 array. This array makes a virtual block device for one 
> of the virtual machines:  an Openfiler appliance. Openfiler then manages 
> logical volumes on this device including an XFS partition shared via 
> NFS. 2 MythTV hosts continuously write MPEG2 tv shows on it (1 to 4Gb 
> each).
> Still following ? Here is a summary: MPEG2 files -> NFS -> XFS -> LVM -> 
> Xen VBD -> RAID 5 -> 8x SATA disks.
> 
> - Next, the symptoms.
> 
> This setup is only 2 weeks old. Behavior was quite good, except for some 
> unexplained failures from the sata_nv attached disks. Not always from 
> the same disk. Never from any disks attached through the sata_sil HBA.
> Eventually a second disk would go down before the end of the raid 
> reconstruction (still a sata_nv attached one).
> Since the disks showed nothing wrong with smartmontools I re-added them 
> each time. So far the raid array was strong enough to be fully 
> recovered, mdadm --force and xfs_check are my friends ;-)
> It seems to happen more often now that the XFS partition is quite 
> heavily fragmented, and I can't even run the defragmenter without a 
> quick failure.
> I didn't payed big attention to the logs and quickly decided to buy a 
> SATA Sil PCI card to get rid of the Nvidia SATA HBA.
> 
> - Now the problem.
> 
> Yesterday, however, the MPEG2 streams hanged for a few tens of seconds 
> just as usual. But there were no disk failure. The array was still in 
> good shape, although dmesg showed the same "ata[56]: Resetting port", 
> "SCSI errors" etc. fuss.
> However this was new in dmesg: "anticipatory: forced dispatching is 
> broken (nr_sorted=1), please report this". Got 4 identical in a row.
> Maybe managing 8 block devices queues under load with the anticipatory 
> scheduler is too much ? I immediately switched to deadline on the 8 
> disks, and I'll see if it it happens again by stressing the whole system 
> more and more.
> I have no clue if anticipatory is a good choice or definitely not in my 
> case, anyone can point some documentation or good advices ?
> 
> - How to reproduce.
> 
> Here is what I would do:
> Harness a small CPU with lots of sata/scsi drives.
> Do raid 5 with big block size (1-4Mb) on it.
> Make a 50G XFS file system with sunit/swidth options
> Trigger bonnie++ with 1G<files<4G and fill the FS to 80-95%, trying to 
> achieve 98%+ fragmentation.
> Defrag !
> 
> - Finally the usual bug report stuff is attached.

 From your report:

ata5: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 
status 0x400
ata5: CPB 0: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 1: ctl_flags 0x1f, resp_flags 0x2
ata5: CPB 2: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 3: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 4: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 5: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 6: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 7: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 8: ctl_flags 0x1f, resp_flags 0x2
ata5: CPB 9: ctl_flags 0x1f, resp_flags 0x2
ata5: CPB 10: ctl_flags 0x1f, resp_flags 0x2
ata5: CPB 11: ctl_flags 0x1f, resp_flags 0x2
ata5: CPB 12: ctl_flags 0x1f, resp_flags 0x2
ata5: CPB 13: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 14: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 15: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 16: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 17: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 18: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 19: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 20: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 21: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 22: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 23: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 24: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 25: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 26: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 27: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 28: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 29: ctl_flags 0x1f, resp_flags 0x1
ata5: CPB 30: ctl_flags 0x1f, resp_flags 0x1
ata5: Resetting port
ata5.00: exception Emask 0x0 SAct 0x1f02 SErr 0x0 action 0x2 frozen
ata5.00: cmd 60/40:08:8f:eb:67/00:00:03:00:00/40 tag 1 cdb 0x0 data 32768 in
          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:40:17:eb:67/00:00:03:00:00/40 tag 8 cdb 0x0 data 4096 in
          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/18:48:47:eb:67/00:00:03:00:00/40 tag 9 cdb 0x0 data 12288 in
          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:50:77:eb:67/00:00:03:00:00/40 tag 10 cdb 0x0 data 4096 in
          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/08:58:87:eb:67/00:00:03:00:00/40 tag 11 cdb 0x0 data 4096 in
          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 60/48:60:d7:eb:67/00:00:03:00:00/40 tag 12 cdb 0x0 data 
36864 in
          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: soft resetting port

The CPB resp_flags 0x2 entries are ones where the drive has been sent 
the request and the controller is waiting for a response. The timeout is 
30 seconds, so that means the drive failed to service those queued 
commands for that length of time.

It may be that your drive has a poor NCQ implementation that can starve 
some of the pending commands for a long time under heavy load?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

