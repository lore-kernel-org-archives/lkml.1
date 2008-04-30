Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbYD3JZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbYD3JZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYD3JZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:25:06 -0400
Received: from phunq.net ([64.81.85.152]:45869 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750983AbYD3JZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:25:04 -0400
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: ddsnap: Starting down the long road to the land of optimal
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 30 Apr 2008 02:24:58 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200804300224.59712.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Network storage these days entails not only storing files and serving 
them via NFS or Samba, but maintaining continuous live backups, user 
accessible volume snapshots and remote replicas.  The ddsnap 
snapshotting, replicating block device is the secret sauce of the 
Zumastor open source NAS project that does these things, and as far as 
we know, is the only way to do these things on Linux.

   http://zumastor.org/

Ddsnap uses a copy-before-write snapshot strategy similar to the 
existing LVM snapshot facility, but with a considerably more 
sophisticated metadata design that allows multiple snapshots to share 
data in a single snapshot volume.

The copy-before-write volume snapshot approach used by ddsnap has both 
strengths and a weaknesses.

  Strengths:
    1) The Kernel code is relatively simple and therefore easy to
       verify.

    2) Provides snapshotting and replication to all block-based
       Linux filesystems.

  Weaknesses:
    1) Worst case write performance is poor.

    2) Do not know which blocks are filesystem freespace and thus
       do not have to take up space in snapshot store.

Drawback number 2 has not proved to be a big problem in practice because 
as a filesystem ages less and less of it is free, and more of the 
freespace tends to belong to at least one snapshot.

Drawback number 1, poor worst case write performance, is a serious 
problem, especially because our current implementation fails to take 
advantage of opportunities to parallelize write traffic, among other 
things.

Worst case write performance is obtained for example by untarring a 
tarball immediately after setting a snapshot.  In this case, each write 
causes a copy-out of data to the snapshot store, and associated 
metadata updating.  The sequence of operations is:

  1) Copy the data to be overwritten to the snapshot store
  2) Update snapshot store metadata
  3) Allow the original write to proceed

Step 2 requires five separate metadata writes:

  a) Write bitmap block to journal
  b) Write btree leaf to journal
  c) Write commit block to journal
  d) Write bitmap block to snapshot store
  e) Write btree leaf to snapshot store

Altogether, there are eight IO operations performed (one read and seven 
writes) whereas a simple write to an unsnapshotted disk only is just a 
single operation.  Worse, there are eight seeks versus only one for an 
unsnapshotted write.  In practice, we see worst case write performance 
about nine times slower than a raw disk.  Which sounds pretty horrible, 
but actually is not that big a problem on a NAS box, simply because NFS 
write performance sucks pretty badly too.  NFS typical write overhead 
of 4.5 times the underlying filesystem makes our 9 times overhead seem 
like only twice as slow, and any read operations in the NFS traffic mix 
mask the problem further.

However.  As Zumastor and other systems relying on ddsnap become more 
popular and more non-NFS applications of ddsnap emerge, people will 
surely start to complain.  The good news is, there is a lot that can be 
done to improve the situation.

Here are some of the optimization possibilities we have identified:

  * Reduce metadata writes
  * Overlap write transactions instead of processing one at a time
  * Batch up contiguous writes into bigger transfers
  * Make synchronization primitives more efficient
  * Asynchronous journalling
  * Other more radical ideas on the way

Today I am happy to be able to announce that we have taken the first 
step down what we expect to be a long, arduous journey towards greatly 
improved write performance.  Today's optimization eliminates two of the 
five metadata writes listed above using an unlikely-sounding 
journalling technique: instead of immediately updating allocation 
bitmaps each time space is allocated in the snapshot store, we record 
the address of the allocation in the journal commit block and update 
the actual bitmaps later, in a batch.  This yields an overall worst 
case performance improvement of somewhere between 12 and 20 percent.

Here are the gory details as originally conceived back in November of 
last year:

   http://groups.google.com/group/zumastor/msg/8838de35aa6bf255

And here is the first demonstration of efficacy (by Jiaying Zhang, 
following an initial, spectacularly unsuccessful attempt by me):

   http://groups.google.com/group/zumastor/msg/889a39d4440164a4 

In pictures:

   http://zumastor.org/graphs/bitmap_dell2950.jpg
   http://zumastor.org/graphs/bitmap_hpx4100.jpg

These graphs show the effect of this optimization on a typical rackmount 
server with five scsi disks, and a typical desktop machine with a 
single IDE disk.

This simple benchmark ("nsnaps") successively untars a kernel tree, 
immediately setting a new snapshot on each of ten iterations.  Thus, 
the load is almost pure writing and nearly every write forces a 
copy-before-write.  We measure the wall clock time of each untar plus 
the associated sync.  Unsnapshotted disk performance is shown on the 
bottommost, reference line.

One nice thing we see in this graph is, number of snapshots does not 
slow down write performance except in the initial case going from zero 
to one snapshot.  In the initial case, we see that overhead of a 
virtual snapshot device with no snapshots held is negligible.  (Though 
we have known both these facts for some time, it is reassuring to see 
them reaffirmed.)

The important data point for today is the improvement in worst case of 
about 15% in the single spindle case and 20% in the multi-spindle case, 
not far off the original guess of 25% improvement.  Tada.

OK, so we made it a little faster, but it still kinda sucks.  What to 
do?  Another optimization of course, and repeat as necessary until it 
doesn't suck any more.

The next optimization coming down the pipe will be similar to this one: 
use a clever journalling trick to eliminate two of the remaining three 
metadata writes.  I think this will get us down to 6-7X performance 
overhead versus the initial 9X.  After that, we have to go mining for 
further improvements in other places.  Never fear!  There are a lot of 
things we currently do stupidly, and intentionally so, to reduce bugs.  
Now that we have gotten ddsnap to a largely bug-free state, we can 
afford to be a lot more aggressive about adding incremental complexity 
to gain performance.

Regards,

Daniel
