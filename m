Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbYBZH1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbYBZH1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYBZH04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:26:56 -0500
Received: from mail2.shareable.org ([80.68.89.115]:33287 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbYBZH0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:26:54 -0500
Date: Tue, 26 Feb 2008 07:26:50 +0000
From: Jamie Lokier <jamie@shareable.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Chris Wedgwood <cw@f00f.org>
Subject: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20080226072649.GB30238@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel,

This is a proposal to add "proper" durable fsync() and fdatasync() to Linux.

First the problem, then a proposed solution "with benefits", so to speak.

I need feedback on the details, before implementing anything.  Or
(hopefully) someone else thinks it's very important and does it
themselves :-)

By durable, I mean that fsync() should actually commit writes to
physical stable storage, not just the disk write cache when that is
enabled.  Databases and guest VMs needs this, or an equivalent
feature, if they aren't to face occasional corruption after power
failure and perhaps some crashes.

The alternative is to disable the disk write cache.  But that isn't
modern practice or recommendation, since I/O write barriers were
implemented and they are much faster.

I was surprised that fsync() doesn't do this already.  There was a lot
of effort put into block I/O write barriers during 2.5, so that
journalling filesystems can force correct write ordering, using disk
flush cache commands.

After all that effort, I was very surprised to notice that Linux 2.6.x
doesn't use that capability to ensure fsync() flushes the disk cache
onto stable storage.

I noticed this following up discussions on the Qemu mailing list,
about guest VMs and how their IDE flush cache command should translate
to fsync() to avoid data loss.  (For guest VMs, fsync() isn't
necessary if the host machine is fine, and it isn't enough (on Linux
host) if the host machine loses power or the hard disk crashes another
way.)

Then I noticed it again, when I was designing a database engine with
filesystem characteristics.  I thought "how do I ensure ordered
journal writes; can I use fdatasync()?" and was surprised to find the
answer is no, I have to use hacks like calling hdparm, and the authors
of major SQL databases seem to brush the problem under a carpet.

(Interestingly, in the Linux 2.4 patches for write barriers, fsync()
seems to be fine, if a bit slow.)

It isn't the first time this topic has come up:

    http://groups.google.com.br/group/linux.kernel/browse_thread/thread/d343e51655b4ac7c/7ee9bca80977c2d1?#7ee9bca80977c2d1
    ("True fsync() in Linux (on IDE)")

In that thread, it was implied that would be fixed in 2.6.  So I bet
some people are under the illusion that it's fixed in 2.6...


For a while, I've been meaning to bring it up on linux-kernel...


The fsync problem
-----------------

Chris Wedgwood wrote:
> On Mon, Feb 25, 2008 at 08:50:40PM +0000, Jamie Lokier wrote:
> 
> > On Linux (and other host OSes), fdatsync() and fsync() don't always
> > commit data to hard storage; it sometimes only commits it to the hard
> > drive cache.
> 
> That's a filesystem bug IMO.  People should be able to use f[data]sync
> with some level onf confidence or else it's basically pointless.

I agree, I consider it a serious bug, and I would be pleased if
someone paid it some love and attention.

Right now, if you want a reliable database on Linux, you _cannot_
properly depend on fsync() or fdatasync().  Considering how much Linux
is used for critical databases, using these functions, this amazes me.

Also, if you have a guest VM, then the guest's filesystem journalling
is not reliable.  Not only can it lose data on power loss, it can
corrupt the guest filesystem too, due to reordering.  This is contrary
to what people expect, I think.

I'm not sure if a system reset can cause similar loss; I don't know
how disks react to that.

Also, for the person porting ZFS to run on FUSE, same applies...

Linux fsync is faulty in two ways:

   1. Database commits aren't _durable_ against power failure, because
      fsync doesn't flush the disk's cache.  This means data stored
      is not guaranteed to be stored at the expected durability.

   2. It's unsafe for write-ahead logging, because it doesn't really
      guarantee any _ordering_ for the writes at the hard storage
      level.  So aside from losing committed data, it can also corrupt
      structural metadata.

With ext3 it's quite easy to verify that fsync/fdatasync don't always
write a journal entry.  (Apart from looking at the kernel code :-)

Just write some data, fsync(), and observe the number of writes in
/proc/diskstats.  If the current mtime second _hasn't_ changed, the
inode isn't written.  If you write data, say, 10 times a second to the
same place followed by fsync(), you'll see a little more than 10 write
I/Os, and less than 20.

By the way, this shows a trick for fixing #2 (ordering): use fchmod()
to toggle the file attributes, and that will force the next fsync() to
write a journal entry, which _does_ issue a write barrier.  If you do
that with each write as above (write, fchmod change, fsync 10 times a
second), you will clearly see more write I/Os, and you'll hear the
disk behaving differently: it's seeking more.

However, even this ugly trick has problems:

  3. Using the fchmod() trick or good fortune, fsync() issues a write
     barrier.  Right now, this does commit data (if the device can).
     But, if the SCSI mid-layer is fixed to use tag ordering, this
     won't commit data!  Therefore, the fchmod() trick with fsync() is
     good enough for ordering writes for, e.g. a database journal, but
     not for reporting that data is committed to hard storage,
     i.e. it's not durable.

  4. Again using the trick or good fortune, now you have two writes at
     different parts of the disk, with a great big seek.  This is a
     disaster for database-style journalling.  One of the writes is
     technically unnecessary, and the seeks add hugely to the commit
     time and disk wear, and break any attempt to optimise journal
     placement.

Linux has not only fsync(), but fdatasync() and sync_file_range().

Someone clearly put thought into a reasonably performant API for
database like applications.  (It would be nicer if sync_file_range()
took a vector of ranges for better elevator scheduling, but let's
ignore that :-)

Yet, it isn't safe for the simplest of journalling applications.

If you think this isn't a problem, I can tell you: it is.  Power
failures happen, sometimes by design.  I've seen filesystem corruption
in ext3 filesystems before journalling barriers were added; it wasn't
pretty, and it was enough of a problem that a lot of work was done to
add them cleanly.

The same corruption can happen to databases and guest VM filesystems
with current kernels.


Implementation proposal - block layer
-------------------------------------

Solving this, i.e. implementing fsync() and friends properly, isn't
trivial, but it isn't huge either.

Firstly, we have to look at the elevator and block driver APIs.  It's
worth reading Documentation/block/barrier.txt.  You can queue a
request with HARDBARRIER.  On devices which use ordering tags
(i.e. none because of SCSI driver limitations at present, according to
that doc), it uses ordering tags.  On other devices, if possible, it
uses cache flush commands and/or sets the FUA ("force unit access")
bit on the request.

Now imagine a database (guest VM, etc.) issues some writes.  Time
passes.  The writes are written to the disk's cache.  Then the
database calls fsync().  What kind of request shall we sent to the
block device?  We have _no_ outstanding read or write requests to
attach HARDBARRIER to.

So, that's the first thing: the block API needs a way to send that
fsync flush _without_ an associated read or write, and for the fsync()
system call to return when that flush indicates completion.  Let's
call this request HARDFLUSH (similar to HARDBARRIER).

The second thing is that the flush cannot be equivalent to a
HARDBARRIER attached to a NOP request, because HARDBARRIER provides
ordering only, at least in principle.  It must be a real flush.

Sometimes, there _are_ writes pending.  If there's only one since the
last flush, it could be optimised into a HARDBARRIER-FUA request,
which (assuming FUA is ever useful) is good for databases which have
exactly this pattern for their journal writes.

So, that's the third thing: we'd like to coalesce an fsync flush
request with a preceding undispatched write request if there is only
one write pending since the last flush.  Note: it must use
HARDBARRIER-FLUSH or HARDBARRIER-FUA, not HARDBARRIER-TAG alone.  If
tag ordering is used, follow it with HARDFLUSH.  Tag ordering before
the write is fine, but not enough after.


I/O request queue optimisations
-------------------------------

If there's only one write since the last flush, it may be possible to
set the FUA bit on that write instead of flushing after it.

There's no need to send a HARDFLUSH request if there have been no
write requests since the last flush (FUA or explicit), but non-flush
ordering tags don't count.

"Only one write pending" and "no write requests" can actually count
writes which originated from the file being synced; they don't need to
consider writes for other files.

When fsync() issues HARDFLUSH, the POSTFLUSH which is _currently_
issued with HARDBARRIER filesystem requests won't be required any
longer.  It could be deferred, safely and maybe profitably, until
before the next write.  This doesn't compromise filesystem integrity
(it's equivalent behaviour to tagged ordering), and it doesn't
compromise fsync() when fsync() does force the flushing.


Ordering of HARDFLUSH and HARDBARRIER
-------------------------------------

At first it may seem that HARDFLUSH is always stronger than
HARDBARRIER; i.e. that one includes the effect of the other.  This is
not true: writes can be moved before a HARDFLUSH, if the elevator
wants, but writes cannot be moved before a HARDBARRIER.  Another point
of view is that a HARDFLUSH can be safely delayed while other writes
proceed, perhaps to coalesce it with something.

Therefore, when queuing a request, both flags must be used together if
that's intended.  There are scenarios where either flag alone is
useful, or both together.

When a request has both HARDFLUSH and HARDBARRIER flags, it is
permitted to split it into two requests, to move later writes before
the HARDFLUSH but not before the HARDBARRIER.  This might be
advantageous in some scenarios using tagged ordering: delaying
flushes, perhaps to coalesce them, can be a useful.  It is obviously
useless when barriers are implemented using flush.


Block drivers
-------------

These need the ability to receive a HARDFLUSH request by itself or
combined with a write (after it).  HARDFLUSH must have the option of
being combined with the HARDBARRIER flag, just like other requests.
When HARDBARRIER is itself implemented using a flush or FUA, they
simply combine.  But when HARDBARRIER is using ordered tags, then this
ordering still must apply to the flush command.


Software RAID (etc.) drivers
----------------------------

HARDFLUSH can optionally be confined to a subset of the underlying
devices.  Thus it is reasonable for HARDFLUSH to be associated with a
sector range, which these drivers can use to select which devices to
flush.

HARDBARRIER can optionally be associated with a sector range too.  For
certain purposes, that means to wait for writes before the barrier
only in the corresponding range.  But be careful: it still orders
_all_ writes after the barrier, regardless of which underlying device
they reach.  Thus there are cross-device barriers.

To implement cross-device barriers, HARDBARRIERs must convert to
flushes, when followed by writes to other underlying devices, but can
used tagged ordering when followed only by writes to the same
underlying device, if there is only one.  Here be dragons, take care.

The easy way out, albeit not quite optimal, is to always convert
barriers to flushes on all underlying devices, which I think the
existing implementation does.


Filesystems
-----------

The fsync() methods should issue a HARDFLUSH after/with the journal
write, in addition to HARDBARRIER as is used now.  This may involve
adding a flag to the journalling code of each filesystem.

The proposed sync_page_range() enhancements might have interesting
consequences for how and when filesystem metadata is written, when new
blocks are allocated.


Userspace API enhancements
--------------------------

It is questionable whether fsync() and fdatasync() should always
implement hard flushes.  Immediately, there will be complaints that
Linux got much slower with some databases.

I read rumours that Mac OS X encountered this, and because it looks
bad, decided to keep hard flushes separate, using fcntl(F_FULLFSYNC).
I don't think there is a hard flush equivalent to fdatasync().

I'm thinking it should be a per-filesystem (and/or system wide
default, and or file descriptor) flag whether fsync() and fdatasync()
implement hard flushes.

For proper application control, we have the flags in
sync_file_range().  I propose that additional flags be added.

Just to be a bit cheeky and versatile, I propose that the additional
flags indicate when hard flushing is required, when it's explicitly
not required (overriding a system default for fsync), and orthogonally
(since it is orthogonal) do the same for hard barriers.  I'm sure some
databases and userspace filesystems would appreciate the various options.

Too add to the cheekiness, I propose that the API _allow_ but not
require that individual pages (actually bytes) keep track of whether
they have been followed by a hard barrier and/or hard flush.  The
implementation doesn't have to do that: it can be much coarser.  It's
nice if the API allows the possibility to refine the implementation
later.

Finally, support for flushes and/or barriers between O_DIRECT writes
are essential for some applications.


Proposal for sync_file_range()
------------------------------

Logically, associate with each page (or byte, block, file...) some flags:

     hardbarrier = { needed, pending, done }
     hardflush = { needed, pending, clean }

These flags are maintained at whatever granularity is convenient.

In addition, flags are maintained at whatever granularity is
convenient with O_DIRECT too.  This might be the file or file
descriptor, and/or the flags may be associated with each underlying
device in a software RAID.

Note: this is not as invasive as it sounds.  A simple implementation
can maintain those two flags for the file as a whole (not per page),
or even just the block device as a whole; that's easy.  We describe it
with fine granularity conceptually, to allow it in principle, as it
appears in the new API description of sync_file_range().

When a dirty page is scheduled for write-out (by any mechanism), and
the write-out completes, it is marked as clean.  When this occurs,
mark the page as "hardbarrier-needed" and "hardflush-needed", to
indicate it is written to the block device, but not committed to hard
storage.

When a HARDBARRIER or HARDFLUSH request is enqueued to a device (not
when it's issued), for all pages backed by the device, change the
flags to "hardbarrier-pending" and/or "hardflush-pending" if they were
"-needed".  When such a request completes (successfully?), set the
appropriate flags to "hardbarrier-clean" and/or "hardflush-clean".

New flags:

    SYNC_FILE_RANGE_HARD_FLUSH
        If SYNC_FILE_RANGE_WRITE is set, if any dirty page write-outs
        are initiated, queue a hard flush following the last one.  If
        there are no dirty pages, check the "hardflush" flags
        corresponding to all pages in the range, and corresponding to
        O_DIRECT for this file descriptor.  If any are
        "hardflush-needed", or the page range is empty, queue a hard
        flush soon.  In the empty page range case, set
        "hardflush-needed" in the flags corresponding to O_DIRECT,
        so that waiting for an empty page range will wait for it.

        If SYNC_FILE_RANGE_WAIT_BEFORE and/or
        SYNC_FILE_RANGE_WAIT_AFTER are set, after waiting for all
        write-outs to complete, check the "hardflush" flags
        corresponding to all pages in the range, and corresponding to
        O_DIRECT for this file descriptor.  If any are set to
        "hardflush-needed", queue a hard flush, then wait until they
        are all "hardflush-clean".

    SYNC_FILE_RANGE_HARD_BARRIER
        Same as SYNC_FILE_RANGE_HARD_FLUSH, except that "hardbarrier"
        is used instead of "hardflush", and hard barrier requests are
        queued instead of hard flushes.

        Important: SYNC_FILE_RANGE_HARD_BARRIER is a barrier only for
        writes in the specified range _before_ the barrier, but it
        controls _all_ writes to any offset after the barrier.  This
        is because there's no point in the barrier controlling offsets
        other than those where write-outs have been explicitly
        requested, and this has the practical benefit of reducing
        flushes in multi-device configurations, but acting as a
        barrier against later writes for other offsets is very useful.

        Note that this flag is not normally used if
        SYNC_FILE_RANGE_HARD_FLUSH is used in conjunction with
        SYNC_FILE_RANGE_WAIT_AFTER or SYNC_FILE_RANGE_FSYNC.  Those
        combinations wait until data is written and hard flushed
        before returning, so there is no way for the caller to issue
        more requests logically after the barrier, until the data is
        flushed anyway.  In these cases, using a barrier only
        penalises other processes for no gain.  However, you can do
        so; it is not forbidden.

    SYNC_FILE_RANGE_NO_FLUSH
        If the system is administratively set to issue hard flushes
        for fsync(), fdatasync() and sync_file_range(), which means it
        implicitly sets SYNC_FILE_RANGE_FLUSH, this flags _disables_
        the implicit setting of that flag.  This does not guarantee no
        hard flush occurs; it merely disables asking for it.  This has
        no effect on SYNC_FILE_RANGE_BARRIER.

    SYNC_FILE_RANGE_NO_BARRIER
        Same as SYNC_FILE_RANGE_NO_FLUSH, except it affects implicit
        SYNC_FILE_RANGE_BARRIER instead.  This has no effect on
        SYNC_FILE_RANGE_FLUSH.

    SYNC_FILE_RANGE_FSYNC
        Write any additional metadata that fsync() would include over
        fdatasync(), and wait for those writes to complete.  It might,
        potentially, do everything that fsync() does, including
        writing all data and waiting for it, even without setting any
        other flags.  Or it might just write the metadata.

        This flags allows you to combine SYNC_FILE_RANGE_FSYNC with
        SYNC_FILE_RANGE_{,NO_}HARD_{FLUSH,BARRIER}, to have more
        fine-grained control over the behaviour of fsync().

    SYNC_FILE_RANGE_HARD_FSYNC
        This forces a hard flushing fsync().  You should set the page
        range to cover all possible offsets, to get the full effect of
        fsync().

        It is an alias for SYNC_FILE_RANGE_FSYNC |
        SYNC_FILE_RANGE_HARD_FLUSH | SYNC_FILE_RANGE_WAIT_BEFORE |
        SYNC_FILE_RANGE_WRITE | SYNC_FILE_RANGE_WAIT_AFTER.

        SYNC_FILE_RANGE_HARD_BARRIER is omitted, because this waits
        for the flush to complete before returning, so there is
        nothing gained by a hard barrier and it can penalise other
        processes.


Usage notes for journalling filesystem in userspace
---------------------------------------------------

For something like ext3, the pattern for a non-flushing metadata
journal update is: write to journal, write barrier, write journal
commit record, write barrier, write metadata elsewhere.

In this API, you could write (whether using O_DIRECT or not):

    pwrite(fd, journal_data, journal_length, journal_offset)
    sync_file_range(fd, journal_offset, journal_length,
                    (SYNC_FILE_RANGE_WRITE
                     | SYNC_FILE_RANGE_WAIT_AFTER
                     | SYNC_FILE_RANGE_HARD_BARRIER));
    pwrite(fd, commit_data, commit_length, commit_offset)
    sync_file_range(fd, commit_offset, commit_length,
                    (SYNC_FILE_RANGE_WRITE
                     | SYNC_FILE_RANGE_WAIT_AFTER
                     | SYNC_FILE_RANGE_HARD_BARRIER));
    pwrite(fd, metadata, metadata_length, metadata_offset);

If you wanted to request a durable commit (i.e. hard flush, fsync()
from filesystem user's perspective), then you could add
SYNC_FILE_RANGE_HARD_FLUSH to the second sync_file_range() call.  The
barrier from the first call ensures the journal entry is implicitly
flushed before the commit record, making the whole commit durable.

Alternatively, you could use a third sync_file_range() just for the
flush, after the data write.  Probably the first method is better: if
there is an advantage to reordering the requests to move the flush
later, the elevator is free to do that.

(By the way, if the commit record is a single device sector and
O_DIRECT is used, and everything is aligned just so, you may feel it
doesn't require a checksum, such is your confidence in a disk's
ability to write whole sectors or not.  If the commit record is any
other size, or O_DIRECT isn't used (which makes it a page size at
least), a checksum should be used.  Also, without O_DIRECT, be careful
of writing partial pages or misaligned pages as they are converted to
full page writes, and power failure may corrupt data that you didn't
explicitly write to.  There are many issues besides barriers and
flushing to get right when journalling for data integrity.)
    

Request for comments
--------------------

I'm not 100% sure of this API, but on the face of it, it seems it
could be quite versatile while being not too hard to implement, and
with performance improvements in future.

I expect the call should work with block devices, as well as files.
Does it provide sufficiently full access to the elevator barrier
capabilities in a tidy package?

Is this sufficient for correct and efficient behaviour over software
RAID and similar things?

Database, virtual machine and filesystem implementors,
please take a look at the API and see if it makes sense.

If one or two other people are interested to help, even if it's only
testing (and you're not in a rush...) I am willing to help implement
this.

-- Jamie
