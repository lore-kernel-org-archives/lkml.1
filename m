Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbYCFV0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbYCFV0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYCFV0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:26:06 -0500
Received: from smtp.seznam.cz ([77.75.72.43]:42420 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752626AbYCFV0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:26:05 -0500
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Thu, 06 Mar 2008 22:25:59 +0100
MIME-Version: 1.0
Subject: block layer / FS question: x86_32bit with LBD, 20 TB RAID volume => funny issues
Message-ID: <47D06F77.29711.A05566EC@Frantisek.Rysanek.post.cz>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.32@12660
X-Seznam-User: frantisek.rysanek@post.cz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear everyone,

I've got another silly question, rather vaguely formulated...

I have a homebrew Fedora 5 - based live CD with some basic system 
utilities and FS support, that I'm using to test various sorts of 
hardware and subsystems. Call it hardware debugging, in a PC hardware 
assembly shop...
Today I have "external storage" under the magnifier glass.

In the past, the biggest block devices I've met so far have been some 
14TB RAID volumes (16x 1TB disk in RAID 6). These are connected to 
the host PC via a SCSI/SAS/FC HBA, and essentially appear as a single 
huge SCSI disk. Such RAID units work pretty fine against Linux, 
preferably using LBA64/CDB16. Abnormal sector sizes are less 
appropriate, but also seem to work with some FS.

A few days ago, I've had my first opportunity to put my hands on a 
24bay RAID unit - configured for RAID 60, that's 20 TB of space in a 
single chunk. I know that RAID units capable of this sort of capacity 
have been on the market for some time now, so I was somewhat 
surprised to discover that there are pending issues against Linux...

The block device is detected/reported just fine.
I didn't even try Ext3, I know it's not appropriate for this sort of 
capacity. I've tried Reiser3, and already mkfs.reiserfs (user-space 
util) refused to create such a big FS. Then I tried XFS. The user-
space mkfs.xfs had no objections - so far so good. But when I tried 
to mount the volume thus created, the kernel-space XFS driver 
(including the one in 2.6.24.2) refused to mount the FS, complaining 
about the FS being too big to be mounted on this platform.

Okay, those are FS quirks, some of them even implied by the spec 
(=RTFM) or at least located in user space. Hang on a second,
there's more.

If I try 
  dd if=/dev/zero of=/dev/sda bs=4096
it never runs until the very end. It always seems to hang somewhere 
halfway through, sometimes at 7 TB, sometimes at 4 TB... it's weird.
The dd process stays alive, but data transfer stops (as seen in 
iostat and by the RAID unit's LED's), and the write() or whatever 
syscall inside dd just keeps sleeping blocked forever. The RAID seems 
perfectly happy, there are no timeout messages from the SCSI layer. 
If I terminate the dd process (CTRL+C) and start it again, everything 
looks perfectly allright again.

I also have a simple test app that runs in a loop, reading a whole 
raw block device (/dev/sda) from start to end. It open()s the device 
node with O_LARGEFILE and just read()s 64kB chunks until EOF.
This one always terminates halfway through, and the cause seems to be 
that the read() call returns EINVAL.


So far I've been using kernels compiled for 32bit mode x86.
Obviously I have LBD support enabled, and it's always worked 
flawlessly. Would it be any help if I switched to 64bit mode?
My machines have been capable of that for a few years now, but so far 
I had no reason to switch, as the memory capacities installed hardly 
ever reached 4 GB...

Any ideas would be welcome :-)

Frank Rysanek

