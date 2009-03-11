Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZCKWZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZCKWZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZCKWZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:25:08 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:57723 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbZCKWZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:25:06 -0400
X-Greylist: delayed 1962 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2009 18:25:06 EDT
To: linux-kernel@vger.kernel.org
Cc: "Theodore Y. Ts'o" <theotso@us.ibm.com>,
       Martin Watson <mjwatsonuk@yahoo.co.uk>
Subject: 2.6.28.7/ext2/e2fsprogs-1.41.3: apparently irreparable filesystem damage, filesystem not imageable
From: Nix <nix@esperi.org.uk>
Emacs: there's a reason it comes with a built-in psychotherapist.
Date: Wed, 11 Mar 2009 21:52:15 +0000
Message-ID: <87prgnpw1c.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC--Metrics: hades 1356; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[The weird kernel stuff is at the bottom of this email. First, some
 weird e2fsprogs stuff. We're using an upstream kernel, and a Debian
 1.41.3-1 e2fsprogs. Everything sits atop LVM.]

So we had a pile of power cuts recently (the National Grid isn't what it
used to be), and the system came back up with, er, problems:

,----
| [/sbin/fsck.ext2 (1) -- /home] fsck.ext2 -a -C0 /dev/disks/home
| home contains a file system with errors, check forced.
| home: Group 625's inode table at 10240002 conflicts with some other fs block.
| 
| 
| home: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
|         (i.e., without -a or -p options)
`----

So we ran fsck manually, and we saw:

,----
| root@beast:/# e2fsck /dev/disks/home
| e2fsck 1.41.3 (12-Oct-2008)
| e2fsck: Group descriptors look bad... trying backup blocks...
| e2fsck: Bad magic number in super-block while trying to open /dev/disks/home-snap
| 
| The superblock could not be read or does not describe a correct ext2
| filesystem.  If the device is valid and it really contains an ext2
| filesystem (and not swap or ufs or something else), then the superblock
| is corrupt, and you might try running e2fsck with an alternate superblock:
|     e2fsck -b 8193 <device>
| 
| root@beast:/# e2fsck -b 8193 /dev/disks/home
| e2fsck 1.41.3 (12-Oct-2008)
| e2fsck: Bad magic number in super-block while trying to open /dev/disks/home-snap
| 
| The superblock could not be read or does not describe a correct ext2
| filesystem.  If the device is valid and it really contains an ext2
| filesystem (and not swap or ufs or something else), then the superblock
| is corrupt, and you might try running e2fsck with an alternate superblock:
|     e2fsck -b 8193 <device>
`----

Yet the fs mounts OK, and even when mounted, tune2fs is happy to read
its allegedly-bad superblock:

,----
| root@beast:/# tune2fs -l /dev/disks/home
| tune2fs 1.41.3 (12-Oct-2008)
| Filesystem volume name:   home
| Last mounted on:          <not available>
| Filesystem UUID:          b60d2703-5746-4019-83db-b895a7447702
| Filesystem magic number:  0xEF53
| Filesystem revision #:    1 (dynamic)
| Filesystem features:      filetype sparse_super
| Default mount options:    (none)
| Filesystem state:         not clean with errors
| Errors behavior:          Continue
| Filesystem OS type:       Linux
| Inode count:              13205504
| Block count:              26411008
| Reserved block count:     1056440
| Free blocks:              16856460
| Free inodes:              13022470
| First block:              0
| Block size:               2048
| Fragment size:            2048
| Blocks per group:         16384
| Fragments per group:      16384
| Inodes per group:         8192
| Inode blocks per group:   512
| Filesystem created:       Mon Nov 17 21:42:48 2003
| Last mount time:          Sat Jan 24 19:49:31 2009
| Last write time:          Wed Mar 11 21:36:57 2009
| Mount count:              28
| Maximum mount count:      22
| Last checked:             Sat Jul 26 09:52:29 2008
| Check interval:           15552000 (6 months)
| Next check after:         Thu Jan 22 08:52:29 2009
| Reserved blocks uid:      0 (user root)
| Reserved blocks gid:      0 (group root)
| First inode:              11
| Inode size:               128
| Default directory hash:   tea
| Directory Hash Seed:      4c90bba3-40f5-4c12-b7f8-91cbc035e1fe
`----

Is this an e2fsprogs bug? (I don't see how it could be anything else,
but I also don't see how tune2fs and e2fsck, which use the same library
to determine if something is an ext2 filesystem or not, could disagree
like this.)


OK, time to image it to another ext2 filesystem with enough space (there
isn't enough unpartitioned space, we have to put it in a file). We imaged
from an LVM snapshot to ensure that nothing could possibly futz with the fs
while we imaged it:

,----
| root@beast:/var/log/fsck# dd if=/dev/disks/home-snap of=/mnt/horizon/home.img bs=10240000 & DDPID=$!
| [1] 2821
| [...]
| root@beast:/var/log/fsck# while sleep 30; do kill -USR1 $DDPID; done
| 1665+0 records in
| 1664+0 records out
| 17039360000 bytes (17 GB) copied, 1611.98 s, 10.6 MB/s
| dd: writing `/mnt/horizon/home.img': File too large
| 1685+0 records in
| 1684+0 records out
| 17247252480 bytes (17 GB) copied, 1630.96 s, 10.6 MB/s
| [1]+  Exit 1                  dd if=/dev/disks/home-snap of=/mnt/horizon/home.img bs=10240000
`----

The only phrase that springs to mind now is 'WTF'? I've never heard of a
17Gb -EFBIG limit before. Certainly it's not O_LARGEFILE-related: a
quick strace shows dd(1) opening both inputs and outputs with
O_LARGEFILE, as everyone has since the year dot. Some completely weird
kernel bug?

What on earth is going on?


(Of course, there is *sigh* no backup of this filesystem, nor enough
space to back this fs up onto. There never is when something goes
wrong. And, no, I don't control this machine's backup schedule. Or lack
of schedule. My own machines are backed up with outright fanatical
fervour.)
