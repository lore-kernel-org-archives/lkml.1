Return-Path: <linux-kernel-owner+w=401wt.eu-S1751057AbXA3Tyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057AbXA3Tyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXA3Tyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:54:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:60507 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbXA3Tys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:54:48 -0500
Date: Tue, 30 Jan 2007 20:57:20 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Denis Vlasenko <vda.linux@googlemail.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Linus Torvalds <torvalds@osdl.org>, Viktor <vvp01@inbox.ru>,
       Aubrey <aubreylee@gmail.com>, Hua Zhong <hzhong@gmail.com>,
       Hugh Dickins <hugh@veritas.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: O_DIRECT question
Message-ID: <20070130195720.GR8030@opteron.random>
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701270035.31285.vda.linux@googlemail.com> <45BCBECE.4080405@tmr.com> <200701281803.08201.vda.linux@googlemail.com> <20070129170056.GJ8030@opteron.random> <45BE7D99.70200@cfl.rr.com> <20070130023056.GN8030@opteron.random> <45BF65E3.6070102@cfl.rr.com> <20070130164806.GQ8030@opteron.random> <45BF9381.8010108@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BF9381.8010108@cfl.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 01:50:41PM -0500, Phillip Susi wrote:
> It should return the number of bytes successfully written before the 
> error, giving you the location of the first error.  Also using smaller 
> individual writes ( preferably issued in parallel ) also allows the 
> problem spot to be isolated.

When you have I/O errors during _writes_ (not Read!!)  the raid must
kick the disk out of the array before the OS ever notices. And if it's
software raid that you're using, the OS should kick out the disk
before your app ever notices any I/O error. when the write I/O error
happens, it's not a problem for the application to solve.

when the I/O error reaches the filesystem if you're lucky if the OS
won't crash (ext3 claims to handle it), if your app receives the I/O
error all you should be doing is to shutdown things gracefully sending
all errors you can to the admin.

It doesn't matter much where the error happend, all it matters is that
you didn't have a fault tolerant raid setup (your fault) and your
primary disk just died and you're now screwed(tm). If you could trust
that part of the disk is still sane you could perhaps attempt to avoid
a restore from the last backup, otherwise all you can do is the
equivalent of a e2fsck -f on the db metadata after copying what you
can still read to the new device.

The only time I got a I/O error on writes, about 1G of the disk was
gone, not very useful to know the first 512byte region that
failed... unreadable and unwriteable. Every other time, writing to the
disk actually solved the read I/O error (they weren't write I/O errors
of course).

Now if you're careful enough you can track down which data generated
the I/O error by queuing the blocks that you write in between every
fsync. So you can still know if perhaps only the journal has generated
write I/O errors, in such a case you could tell the user that he can
copy the data files and let the journal be regenerated on the new
disk. I doubt it will help much in practice though (in such a case, I
would always restore the last backup just in case).

> >>Typically you only want one sector of data to be written before you 
> >>continue.  In the cases where you don't, this might be nice, but as I 
> >>said above, you can't handle errors properly.
> >
> >Sorry but you're dreaming if you're thinking anything in real life
> >writes at 512bytes at time with O_SYNC. Try that with any modern
> >harddisk.
> 
> When you are writing a transaction log, you do; you don't need much 
> data, but you do need to be sure it has hit the disk before continuing. 
>  You certainly aren't writing many mb across a dozen write() calls and 
> only then care to make sure it is all flushed in an unknown order.  When 
> order matters, you can not use fsync, which is one of the reasons why 
> databases use O_DIRECT; they care about the ordering.

Sorry but as far as ordering is concerned, O_DIRECT, fsync and O_SYNC
offers exactly the same guarantees. Feel free to check the real life
db code. Even bdb uses fsync.

> >>>Just grep for fsync in the db code of your choice (try postgresql) and
> >>>then explain me why they ever call fsync in their code, if you know
> >>>how to do better with O_SYNC ;).
> >>Doesn't sound like a very good idea to me.
> >
> >Why not a good idea to check any real life app?
> 
> I meant it is not a good idea to use fsync as you can't properly handle 
> errors.

See above.

> >>The stalling is caused by cache pollution.  Since you did not specify a 
> >>block size dd uses the base block size of the output disk.  When 
> >>combined with sync, only one block is written at a time, and no more 
> >>until the first block has been flushed.  Only then does dd send down 
> >>another block to write.  Without dd the kernel is likely allowing many 
> >>mb to be queued in the buffer cache.  Limiting output to one block at a 
> >>time is not good for throughput, but allowing half of ram to be used by 
> >>dirty pages is not good either.
> >
> >Throughput is perfect. I forgot to tell I combine it with ibs=4k
> >obs=16M. Like it would be perfect with odirect too for the same
> >reason. Stalling the I/O pipeline once every 16M isn't measurable in
> 
> Throughput is nowhere near perfect, as the pipeline is stalled for quite 
> some time.  The pipe fills up quickly while dd is blocked on the sync 
> write, which then blocks tar until all 16 MB have hit the disk.  Only 
> then does dd go back to reading from the tar pipe, allowing it to 
> continue.  During the time it takes tar to archive another 16 MB of 
> data, the write queue is empty.  The only time that the tar process gets 
> to continue running while data is written to disk is in the small time 
> it takes for the pipe ( 4 KB isn't it? ) to fill up.

Please try yourself, it's simple enough:

       time dd if=/dev/hda of=/dev/null bs=16M count=100
       time dd if=/dev/hda of=/dev/null bs=16M count=100 iflag=sync
       time dd if=/dev/hda of=/dev/null bs=16M count=100 iflag=direct

if you can measure any slowdown in the sync/direct you're welcome (it
runs faster here... as it should). The pipeline stall is not
measurable when it's so infrequent, and actually the pipeline stall is
not a big issue when the I/O is contigous and the dma commands are
always large.

aio is mandatory only while dealing with small buffers, especially
while seeking to take advantage of the elevator.

> No, semantics have nothing to do with performance.  Semantics deals with 
> the state of the machine after the call, not how quickly it got there. 
> Semantics is a question of correct operation, not optimal.

This whole thing is about performance, if you remove performance
factors from the equation, you can stick to your O_SYNC 512bytes at
time to the journal design. You're perfectly right that when you
remove performance from the equation you can claim that O_DIRECT is
much the same as O_SYNC.

> With both O_DIRECT and O_SYNC, the machine state is essentially the same 
> after the call: the data has hit the disk.  Aside from the performance 
> difference, the application can not tell the difference between O_DIRECT 
> and O_SYNC, so if that performance difference can be resolved by 
> changing the implementation, Linus can be happy and get rid of O_DIRECT.

Guess what, if O_SYNC could run as fast as O_DIRECT by still passing
through pagecache, O_DIRECT wouldn't exist. You can't pretend to
describe the semantics of any kernel API if you remove performance
considerations from it. It must be some not useful university theory
if they thought you that performance evaluation must not be present in
the semantics. If that's the case, it's best you stop talking about
semantics when you discuss about any kernel APIs. A ton of kernel APIs
are all about improving performance, so they'll all be the same if you
only look at your performance agnostic semantics, it's not just
O_DIRECT that would become the same as O_SYNC.

The thing I could imagine to avoid bypassing the pagecache, would be
to make MAP_SHARED asynchronous with a new readahead AIO method,
combined with a trick to fill pagetables scattered all over the
address space of the task with a single entry in the kernel (like
mlock does but with SG and w/o pte pinning), and then you would need
to find a way to map ext3/4 pagecache using largepages but without
triggering 2M or 1G reads at every largepte fill. If you think about
it, you'll probably realize O_DIRECT+hugetlbfs is much cleaner and
probably still faster ;). And still MAP_SHARED of ext4 wouldn't be the
same as MAP_SHARED of tmpfs, as it forbids to build logical indexes in
place (you'd need to cow before you can modify the cache).
