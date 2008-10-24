Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYJXC6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYJXC6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 22:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYJXC6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 22:58:38 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39377 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752707AbYJXC6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 22:58:37 -0400
Date: Thu, 23 Oct 2008 20:01:09 -0400
From: Theodore Tso <tytso@mit.edu>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: ext3: fix ext3_dx_readdir hash collision handling - Regression
Message-ID: <20081024000109.GD7842@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
	akpm@linux-foundation.org, torvalds@linux-foundation.org
References: <20081022093201.GA2227@gentoox2.trippelsdorf.de> <20081023032832.GE10369@mit.edu> <20081023063740.GA2438@gentoox2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023063740.GA2438@gentoox2.trippelsdorf.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 08:37:40AM +0200, Markus Trippelsdorf wrote:
> > I haven't been able to replicate this.  Does it matter which kernel
> > tarball you use?  And can you send me the output of "dumpe2fs -h
> > /dev/hdXX", where hdXX is the device of the filesystem where this was
> > failing?
> 
> No, it happens with _every_ tarball from a certain size on. 
> Ext4 is also affected due to d015641734cde55d2fce48a6db3983c8a029fe05 .

Sorry for not getting back to you right away; I've been in the Bay
Area the past few days, and so I haven't as much ext4 hacking time
this week.

I'm still not able to reproduce this, on a 2.6.27-git7 based kernel,
using either ext3 or ext4.  (My attempt to reproduce using ext3 shown
below; the debugfs -w commands were to replicate using a filesystem
with your hash_seed and hash algorithm as you sent in your dumpe2fs
output.  Probably not important if you say that it happens on any
kernel tarball; since I'm testing while on an airplane, I had to
generate a tar.gz file from the git repository of 2.6.27, as shown
below.)

So you're reproducing this on an unmodified kernel from Linus's tip
post 2.6.27, correct?  The funny thing is the git commit you've
identified was merged sometime just before and 2.6.27-rc5, and I
pretty sure it's in the Fedora 10 beta kernel, and so I'm a bit
surprised we haven't seen more reports of this problem than just
yours.  The question then is what is going on which means that you see
this problem rather easily, but for whatever reason it's not
reproducing easily for me.

Can you send me your .config?  Is there anything unusual about your
setup you can think of?  What distribution are you running?  You've
done an explicit revert of just that commit and it afterwards you were
unable to reproduce the problem, is that correct?

Can you reproduce it while running the "rm -rf" command under strace,
(i.e., "strace -o /tmp/strace.log rm -rf linux-2.6.27.2") and send me
the strace.log file?

Thanks, regards,

						- Ted


Script started on Thu 23 Oct 2008 07:39:57 PM EDT
Top-level shell (parent script)
Using forwarded ssh authentication socket
<tytso.root@closure> {/usr/projects/linux/linux-2.6}  [master]
497# git archive v2.6.27 | gzip > /tmp/v2.6.27.tar.gz
<tytso.root@closure> {/usr/projects/linux/linux-2.6}  [master]
498# mke2fs -t ext3 /dev/thunk/testext4
mke2fs 1.41.3 (12-Oct-2008)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
65536 inodes, 262144 blocks
13107 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=268435456
8 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376

Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 25 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
<tytso.root@closure> {/usr/projects/linux/linux-2.6}  [master]
499# debugfs -w /dev/thunk/testext4
debugfs 1.41.3 (12-Oct-2008)
debugfs:  ssv s_hash_seed c3188d40-b161-4458-b3f9-22ca7788110f
debugfs:  ssv s_def_hash_version tea
debugfs:  q
<tytso.root@closure> {/usr/projects/linux/linux-2.6}  [master]
500# mount /dev/thunk/testext4 /mnt
<tytso.root@closure> {/usr/projects/linux/linux-2.6}  [master]
501# mkdir /mnt/v2.6.27
<tytso.root@closure> {/usr/projects/linux/linux-2.6}  [master]
502# tar -C /mnt/v2.6.27 -x -z -f /tmp/v2.6.27.tar.gz 
<tytso.root@closure> {/usr/projects/linux/linux-2.6}  [master]
503# /bin/rm -rf /mnt/v2.6.27
<tytso.root@closure> {/usr/projects/linux/linux-2.6}  [master]
504# umount /mnt
<tytso.root@closure> {/usr/projects/linux/linux-2.6}  [master]
505# uname -a
Linux closure 2.6.27-05216-g0719d38 #86 SMP Fri Oct 17 11:53:34 EDT 2008 i686 GNU/Linux
<tytso.root@closure> {/usr/projects/linux/linux-2.6}  [master]
506# exit

Script done on Thu 23 Oct 2008 07:42:30 PM EDT
