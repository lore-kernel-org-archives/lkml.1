Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbZIRU0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbZIRU0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbZIRU0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:26:38 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:54892 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbZIRU0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:26:38 -0400
From: Berthold Gunreben <b.gunreben@web.de>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
Date: Fri, 18 Sep 2009 22:26:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
References: <clqON-2Xv-7@gated-at.bofh.it> <cnTWo-7bV-25@gated-at.bofh.it> <4A446998.4070508@gmail.com>
In-Reply-To: <4A446998.4070508@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
To: "linux.kernel" <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Niel Lambrechts <niel.lambrechts@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909182226.39660.b.gunreben@web.de>
X-Provags-ID: V01U2FsdGVkX18S0+ST1lhkalzkajJwahEz78swoKYpsta6Fstl
	iyF/FIi4YsyxzJfIO4U9kCbO7eGDMqb1Ptsfm36iW7s6oADXLm
	7MMowbYPI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 26 Juni 2009 schrieb Niel Lambrechts:
> On 06/26/2009 02:46 AM, Tejun Heo wrote:
> > Eh... if my analysis is correct the bug will be dependent on some
> > non-deterministic things including timing and layout of blocks of the
> > file which the filesystem touchs during suspend/resume.  I'm fairly
> > sure the problem is still there.  Oh well, it seems I'll have to
> > construct a synthetic case to test it.  Anyways, please let me know if
> > you encounter the problem again.  I'll keep you in loop with further
> > patches.

I am not quite sure if I am at the right place here, however, I get very
similar problems with a totally different setup. What I do is the following:

I added a fourth disk to a software raid5 array and did setup the raid
completely from scratch (the same disks have been running for about
1.5 years without any problems before, the difference is that previously
one of the disks was setup as hot spare).

After the software raid was in sync, I started to copy my data back to
the raid, and after a  less than 5 minutes time, one of the disks failed
(from /var/log/warn):

Sep 18 22:04:02 Bacchus kernel: ata3.00: exception Emask 0x10 SAct 0x0 SErr 0x10000 action 0xe frozen
Sep 18 22:04:02 Bacchus kernel: ata3.00: irq_stat 0x00400000, PHY RDY changed
Sep 18 22:04:02 Bacchus kernel: ata3: SError: { PHYRdyChg }
Sep 18 22:04:02 Bacchus kernel: ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Sep 18 22:04:02 Bacchus kernel:          res 40/00:0c:3f:6c:d5/00:00:15:00:00/40 Emask 0x10 (ATA bus error)
Sep 18 22:04:02 Bacchus kernel: ata3.00: status: { DRDY }
Sep 18 22:04:02 Bacchus kernel: ata3: hard resetting link
Sep 18 22:04:07 Bacchus kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Sep 18 22:04:12 Bacchus kernel: ata3.00: qc timeout (cmd 0xec)
Sep 18 22:04:12 Bacchus kernel: ata3.00: failed to IDENTIFY (I/O error, err_mask=0x5)
Sep 18 22:04:12 Bacchus kernel: ata3.00: revalidation failed (errno=-5)
Sep 18 22:04:12 Bacchus kernel: ata3: hard resetting link
Sep 18 22:04:12 Bacchus kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Sep 18 22:04:12 Bacchus kernel: ata3.00: configured for UDMA/133
Sep 18 22:04:12 Bacchus kernel: ata3: EH complete
Sep 18 22:04:12 Bacchus kernel: end_request: I/O error, dev sdc, sector 1953519853
Sep 18 22:04:12 Bacchus kernel: md: super_written gets error=-5, uptodate=0
Sep 18 22:04:12 Bacchus kernel: raid5: Disk failure on sdc1, disabling device.
Sep 18 22:04:12 Bacchus kernel: raid5: Operation continuing on 3 devices.
Sep 18 22:04:13 Bacchus kernel: RAID5 conf printout:
Sep 18 22:04:13 Bacchus kernel:  --- rd:4 wd:3
Sep 18 22:04:13 Bacchus kernel:  disk 0, o:1, dev:sda1
Sep 18 22:04:13 Bacchus kernel:  disk 1, o:1, dev:sdb1
Sep 18 22:04:13 Bacchus kernel:  disk 2, o:0, dev:sdc1
Sep 18 22:04:13 Bacchus kernel:  disk 3, o:1, dev:sdd1
Sep 18 22:04:13 Bacchus kernel: RAID5 conf printout:
Sep 18 22:04:13 Bacchus kernel:  --- rd:4 wd:3
Sep 18 22:04:13 Bacchus kernel:  disk 0, o:1, dev:sda1
Sep 18 22:04:13 Bacchus kernel:  disk 1, o:1, dev:sdb1
Sep 18 22:04:13 Bacchus kernel:  disk 3, o:1, dev:sdd1

The filesystem on /dev/md0 was XFS and there was no suspend/resume applied.
The raid is built with four 1TB disks, attached to a Intel ICH7 Controller:
00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA AHCI Controller (rev 01)

The system is a openSUSE11.1 with all patches applied. When I first
encountered this problem I had the original openSUSE kernel (2.6.27.29)
running, but I thought it was a good idea to go with a current upstream kernel
instead. The difference was, that with the openSUSE kernel, I could copy
several 100 GB before I lost the disk, while with the upstream kernel
(2.6.31 from ftp.kernel.org) I lost the disk after less than 4 GB. The result
however is the same.

smart does not tell me any problems with the disks, and I did not encounter
any problems during the build of the raid5 which took about 6 hours on
this machine. Thus I don't believe that there is a hardware problem.

Maybe you have an idea what I can do to provide more information.

Thanks in advance

Berthold


