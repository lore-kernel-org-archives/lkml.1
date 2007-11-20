Return-Path: <linux-kernel-owner+w=401wt.eu-S1761964AbXKTTPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964AbXKTTPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 14:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761382AbXKTTPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 14:15:25 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:44823 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761380AbXKTTPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 14:15:23 -0500
Date: Tue, 20 Nov 2007 19:14:59 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: linux-kernel@vger.kernel.org
Subject: unionfs: several more problems
Message-ID: <Pine.LNX.4.64.0711201802480.9934@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think it may be time to move away from that by now misleading
"msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland" thread.
And I've cut most out of the Cc list, but by all means add any back.

On Saturday I said:
> I'm glad to report that this unionfs, not the one in 2.6.24-rc2-mm1
> but the one including those 9 patches you posted, now gets through
> my testing with tmpfs without a problem.  I do still get occasional
> "unionfs: new lower inode mtime (bindex=0, name=<directory>)"
> messages, but nothing worse seen yet: a big improvement.

I have seen worse now: details below.

> I deceived myself for a while that the danger of shmem_writepage
> hitting its BUG_ON(entry->val) was dealt with too; but that's wrong,
> I must go back to working out an escape from that one (despite never
> seeing it).

Once I tried a more appropriate test (fsx while swapping) I hit that
easily.  After some thought and testing, I'm happy with the mm/shmem.c
+mm/swap_state.c fixes I've arrived at for that; but since it's not
easy to reproduce in normal usage, and hasn't been holding you up,
I'd prefer for the moment to hold on to that patch.  I need to make
changes around the same pagecache<->swapcache area to solve some mem
cgroup issues: there might turn out to be some interaction, so I'd
rather finalize both patches in the same series if I can.

For a while I thought the further unionfs problems I'm seeing were
tmpfs ones, but now I seem to be seeing all(?) of them with ext2:
so I'd better spend no more time on them, hand them over to you.

Please try running LTP (e.g. ltp-full-20071031.tgz) after something like
mkfs -t ext2 /dev/sdb1
mount -t ext2 /dev/sdb1 /mnt
mount -t unionfs -o dirs=/mnt unionfs /tmp

That throws up quite a number of errors which don't occur
with a straightforward ext2 mounted on /tmp.  Notably, when it
embarks upon "MULTIPLE PROCESSES CREATING AND DELETING FILES",
mkdir seems to collapse into lots of
mkdir: cannot create directory `dirN': No space left on device
mkdir dirN FAILED
(the same happened when I was using a tmpfs instead of an ext2).

But perhaps before fixing up the several LTP tests, you'll want
to concentrate on a more directed test.  Please try this sequence:

			# Running with mem=512M, probably irrelevant
swapoff -a		# Merely to rule out one potential confusion
mkfs -t ext2 /dev/sdb1
mount -t ext2 /dev/sdb1 /mnt
df /mnt			# I have 2280 Used out of 1517920 KB
cp -a 2.6.24-rc3 /mnt	# Copy a kernel source tree into ext2
rm -rf /mnt/2.6.24-rc3	# Delete the copy
df /mnt			# Again 2280 Used, just as you'd expect
mount -t unionfs -o dirs=/mnt unionfs /tmp
cp -a 2.6.24-rc3 /tmp	# Copy a kernel source tree into unionfs
rm -rf /tmp/2.6.24-rc3	# Generates 176 unionfs: filldir error messages
df /mnt			# Now 68380 Used (df /tmp shows the same)
ls -a /mnt		# Shows .  ..  .wh.2.6.24-rc3  lost+found
echo 1 >/proc/sys/vm/drop_caches	# to free pagecache
df /mnt			# Still 68380 Used (df /tmp shows the same)
echo 2 >/proc/sys/vm/drop_caches	# to free dentries and inodes
df /mnt			# Now 2280 Used as it should be (df /tmp same)
ls -a /mnt		# But still shows that .wh.2.6.24-rc3
umount /tmp		# Restore
umount /mnt		# Restore
swapon -a		# Restore

Three different problems there:

1. Whiteouts seem to get left behind (at this top level anyway):
I'm getting an increasing number of .wh.run-crons.????? files there.
I'm not familiar with the correct behaviour for whiteouts (and it's
not clear to me why whiteouts are needed at all in this degenerate
case of a single directory in the union, but never mind).

2. Why does copying then deleting a tree leave blocks allocated,
which remain allocated indefinitely, until memory pressure or
drop_caches removes them?  Hmm, I should have done "df -i" instead,
that would be more revealing.  This may well be the same as the LTP
mkdir problem - inodes remaining half-allocated after they're unlinked.

3. The unionfs filldir error messages:
unionfs: filldir: possible I/O error: a file is duplicated in the same
 branch 0: page_offset.h
<... 174 more include/asm-* header files named until ...>
unionfs: filldir: possible I/O error: a file is duplicated in the same
 branch 0: sfafsr.h
It's tempting to suppose these are related to the unfreed inodes, but
retrying again gives me 176 messages, whereas inodes fall from 2672
to 30.  And I didn't see those messages with tmpfs, just with ext2.

Hugh
