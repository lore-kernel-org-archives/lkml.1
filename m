Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYANAXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYANAXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 19:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbYANAXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 19:23:16 -0500
Received: from phunq.net ([64.81.85.152]:39266 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754705AbYANAXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 19:23:12 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFD] Incremental fsck
Date: Sun, 13 Jan 2008 16:22:36 -0800
User-Agent: KMail/1.9.5
Cc: Al Boldi <a1426z@gawab.com>, Valerie Henson <val.henson@gmail.com>,
       Rik van Riel <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200801090022.55589.a1426z@gawab.com> <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu>
In-Reply-To: <20080112145140.GB6751@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801131622.36975.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On Saturday 12 January 2008 06:51, Theodore Tso wrote:
> What is very hard to check is whether or not the link count on the
> inode is correct.  Suppose the link count is 1, but there are
> actually two directory entries pointing at it.  Now when someone
> unlinks the file through one of the directory hard entries, the link
> count will go to zero, and the blocks will start to get reused, even
> though the inode is still accessible via another pathname.  Oops. 
> Data Loss.
>
> This is why doing incremental, on-line fsck'ing is *hard*.  You're
> not going to find this while doing each directory one at a time, and
> if the filesystem is changing out from under you, it gets worse.  And
> it's not just the hard link count.  There is a similar issue with the
> block allocation bitmap.  Detecting the case where two files are
> simultaneously can't be done if you are doing it incrementally, and
> if the filesystem is changing out from under you, it's impossible,
> unless you also have the filesystem telling you every single change
> while it is happening, and you keep an insane amount of bookkeeping.

In this case I am listening to Chicken Little carefully and really do 
believe the sky will fall if we fail to come up with an incremental 
online fsck some time in the next few years.  I realize the challenge 
verges on insane, but I have been slowly chewing away at this question 
for some time.

Val proposes to simplify the problem by restricting the scope of block 
pointers and hard links.  Best of luck with that, the concept of fault 
isolation domains has a nice ring to it.  I prefer to stick close to 
tried and true Ext3 and not change the basic algorithms.

Rather than restricting pointers, I propose to add a small amount of new 
metadata to accelerate global checking.  The idea is to be able to 
build per-group reverse maps very quickly, to support mapping physical 
blocks back to inodes that own them, and mapping inodes back to the 
directories that reference them.

I see on-the-fly filesystem reverse mapping as useful for more than just 
online fsck.  For example it would be nice to be able to work backwards 
efficiently from a list of changed blocks such as ddsnap produces to a 
list of file level changes.

The amount of metadata required to support efficient on-the-fly reverse 
mapping is surprisingly small: 2K per block group per terabyte, in a 
fixed location at the base of each group.  This is consistent with my 
goal of producing code that is mergable for Ext4 and backportable to 
Ext3.

Building a block reverse map for a given group is easy and efficient.  
The first pass walks across the inode table and already maps most of 
the physical blocks for typical usage patterns, because most files only 
have direct pointers.  Index blocks discovered in the first pass go 
onto a list to be processed by subsequent passes, which may discover 
additional index blocks.  Just keep pushing the index blocks back onto 
the list and the algorithm terminates when the list is empty.  This 
builds a reverse map for the group including references to external 
groups.

Note that the recent metadata clustering patch from Abhishek Rai will 
speed up this group mapping algorithm significantly because (almost) 
all the index blocks can be picked up in one linear read.   This should 
only take a few milliseconds.  One more reason why I think his patch is 
an Important Patch[tm].

A data block may be up to four groups removed from its home group, 
therefore the reverse mapping process must follow pointers across 
groups and map each file entirely to be sure that all pointers to the 
group being checked have been discovered.  It is possible to construct 
a case where a group contains a lot of inodes of big files that are 
mostly stored in other groups.  Mapping such a group could possibly 
require examining all the index blocks on the entire volume.  That 
would be about 2**18 index blocks per terabyte, which is still within 
the realm of practicality.

To generate the inode reverse map for, walk each directory in the group, 
decoding the index blocks by hand.  Strictly speaking, directories 
ought to pass block level checking before being reverse mapped, but 
there could be many directories in the same group spilling over into a 
lot of external groups, so getting all the directory inodes to pass 
block level checks at the same time could be difficult with filesystem 
writing going on between fsck episodes.  Instead, just go ahead and 
assume a directory file is ok, and if this is not the case the 
directory walk will fail or a block level check will eventually pick up 
the problem.

The worst case for directory mapping is much worse than the worst case 
for block mapping.  A single directory could fill an entire volume.  
For such a large directory, reverse mapping is not possible without 
keeping the filesystem suspended for an unreasonable time.  Either make 
the reverse map incremental and maintained on the fly or fall back to a 
linear search of the entire directory when doing the checks below, the 
latter being easy but very slow.  Or just give up on fscking groups 
involving the directory.  Or maybe I am obsessing about this too much, 
because mapping a directory of a million files only requires reading 
about 60 MB, and such large directories are very rare.

The group cross reference tables have to be persistently recorded on 
disk in order to avoid searching the whole volume for some checks.  A 
per group bitmap handles this nicely, with as many bits as there are 
block groups.  Each one bit flags some external group as referencing 
the group in which the bitmap is stored.  With default settings, a 
cross reference bitmap is only 1K per terabyte.  Two such bitmaps are 
needed per group, one for external block pointers and the other for 
external hard links.  When needed for processing, a bitmap is converted 
into a list or hash table.  New cross group references need to be 
detected in the filesystem code and saved to disk before the associated 
transaction proceeds.  Though new cross group references should be 
relatively rare, the cross reference bitmaps can be logically 
journalled in the commit block of the associated transaction and 
batch-updated on journal flush so that there is very little new write 
overhead.

Cross group references may be updated lazily on delete, since the only 
harm caused by false positives is extra time spent building unneeded 
reverse maps.  The incremental fsck step "check group cross reference 
bitmaps" describes how redundant cross reference bits are detected.  
These can be batched up in memory and updated as convenient.

Cached reverse maps can be disturbed by write activity on the 
filesystem.  The lazy approach is to discard them on any change, which 
should work well enough to get started.  With additional work, cached 
reverse maps can be updated on the fly by the respective get_block, 
truncate and directory entry operations.

The incremental fsck algorithm works by checking a volume one block 
group at a time, with filesystem operations suspended during the check.  
The expected service interruption will be small compared to taking the 
volume offline but will occur more often, which might be an issue for 
interactive use.  Making the algorithm completely bumpless would 
require something like a temporary in-memory volume snapshot, followed 
by a clever merge of the changed blocks, taking advantage of the 
reverse maps to know which checked groups need to be changed back to 
unchecked.  Beyond the scope of the current effort.

Broadly, there are two layers of integrity to worry about:

    1) Block pointers (block level)
    2) Directory entries (inode level)

Luckily for lazy programmers, similar techniques and even identical data 
structures work for both.  Each group has one persistent bitmap to 
reference the group via block pointers, and another to show which 
groups reference the group via directory entries.  In memory, there is 
one cached reverse map per group to map blocks to inodes (one to one), 
and another to map inodes to directory inodes (one to many).   
Algorithms for block and inode level checks are similar, as detailed 
below.

With on-demand reverse maps to help us, we do something like:

    * Suspend filesystem, flushing dirty page cache to disk
    * Build reverse map for this group if needed
    * Build reverse maps for groups referencing this group as needed
    * Perform checks listed below
    * If the checks passed mark the group as checked
    * Resume filesystem

The order in which groups are checked can depend opportunistically on 
which reverse maps are already cached.  Some kind of userspace 
interface would let the operator know about checking progress and the 
nature of problems detected.  Each group records the time last checked, 
the time checked successfully, and a few bits indicating the nature of 
problems found.

Now for the specific integrity checks, and strategy for each.  There are 
two interesting kinds of potentially nonlocal checks:

   Downward check: this group may reference other groups that must be
      examined together with this group to complete the check.  Can be
      completed immediately when all references are local, otherwise
      make a list of groups needed to continue the check and defer
      until convenient to map those groups all at the same time.  

  Upward check: this group may be referenced by other groups that must
       be examined  together with this group in order to complete the
       check.  Need to check the maps of all groups referencing this
       group to find incoming references.

To prepare for checking a group, its reverse map is constructed if not 
already cached, and the reverse maps for all groups marked as 
referencing the group.  If that is too many reverse maps then just give 
up on trying to fsck that group, or do it very slowly by constructing 
each reverse map at the point it is actually needed in a check.

As online fsck works its way through groups a list of pending downward 
checks for certain inodes will build up.  When this list gets long 
enough, find a subset of it involving a reasonably small number of 
groups, map those groups and perform the needed checks.

A list of checks and correspondence to e2fsck passes follows.

Inode mode field size and block count (e2fsck pass 1)

Downward check.  Do the local inode checks, then walk the inode index 
structure counting the blocks.  Ensure that the rightmost block lies 
within the inode size.

Check block references (e2fsck pass 1)

Upward check.  Check that each block found to be locally referenced is 
not marked free in the block bitmap.  For each block found to have no 
local reference, check the maps of the groups referencing this group to 
ensure that exactly one of them points at the block, or none if the 
block is marked free in the group bitmap.

Check directory structure (e2fsck pass 2)

Downward check.  The same set of directory structure tests as e2fsck, 
such as properly formed directory entries, htree nodes, etc.

Check directory inode links (e2fsck pass 3)

Upward check.  While walking directory entries, ensure that each 
directory inode to be added to the reverse map is not already in the 
map and is not marked free in the inode bitmap.  For each inode 
discovered to have no local link after building the reverse map, check 
the reverse maps of the groups referring to this group to ensure that 
exactly one of them links to the inode, or that there are no external 
links if the block bitmap indicates the block is free.

Check inode reference counts (e2fsck pass 4)

Upward check.  While walking directory entries, ensure that each non 
directory inode to be added to the reverse map is not marked free in 
the inode bitmap.  Check that the inode reference count is equal to the 
number of references to the inode found in the local reverse map plus 
the number of references found in the maps of all groups referencing 
this group.

Check block bitmaps (e2fsck pass 5)

Checking block references above includes ensuring that no block in use 
is marked free.   Now check that no block marked free in the block 
bitmap appears in the local or external block reverse map.

Check inode bitmaps (e2fsck pass 5)

Checking inode references above includes ensuring that no inode in use 
is marked free.   Now check that no inode marked free in the inode 
bitmap appears in the local or external inode reverse map.

Check group cross reference bitmaps

Each time a group is mapped, check that for each external reference 
discovered the corresponding bit is set in the external bitmap.  Check 
that for all groups having an external reference bit set for this 
group, this group does in fact reference the external group.  Because 
cross reference bitmaps are so small they should all fit in cache 
comfortably.  The buffer cache is ideal for this.

Finally...

Total work required to get something working along these lines looks 
significant, but the importance is high, so work is quite likely to go 
ahead if the approach survives scrutiny.

Regards,

Daniel
