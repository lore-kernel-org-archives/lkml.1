Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZDWUob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZDWUob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZDWUoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:44:17 -0400
Received: from mail2.shareable.org ([80.68.89.115]:54062 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZDWUoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:44:16 -0400
Date: Thu, 23 Apr 2009 21:44:11 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Valerie Aurora Henson <vaurora@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Eric Sandeen <sandeen@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>, Nick Piggin <npiggin@suse.de>
Subject: fsync_range_with_flags() - improving sync_file_range()
Message-ID: <20090423204411.GF13326@shareable.org>
References: <20090423001257.GA16540@shell> <20090422221748.8c9022d1.akpm@linux-foundation.org> <20090423112105.GA1589@shareable.org> <20090423124230.GF2723@mit.edu> <20090423164330.GA9399@shareable.org> <20090423172925.GL2723@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090423172925.GL2723@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> > sync_file_range() itself is just too weird to use.  Reading the man
> > page many times, I still couldn't be sure what it does or is meant to
> > do until asking on l-k a few years ago.  My guess, from reading the
> > man page, turned out to be wrong.  The recommended way to use it for a
> > database-like application was quite convoluted and required the app to
> > apply its own set of mm-style heuristics.  I never did find out if it
> > commits data-locating metadata and file size after extending a file or
> > filling a hole.  It never seemed to emit I/O barriers.
> 
> Have you looked at the man page for sync_file_range()?  It's gotten a
> lot better.  My version says it was last updated 2008-05-27, and it
> now answers your question about whether it commits data-locating
> metadata (it doesn't).  It now has a bunch of examples how how to use
> the flags in combination.

Yes that's the page I've read and didn't find useful :-)
The data-locating metadata is explained thus:

     None  of  these  operations  write out the file’s metadata.  Therefore,
     unless the application is strictly performing  overwrites  of  already-
     instantiated disk blocks, there are no guarantees that the data will be
     available after a crash.

First, "the file's metadata".  On many OSes, fdatasync() and O_DSYNC
are documented to not write out "the file's metadata" _but_ that often
means inode attributes such as time and mode, not data-locating
metadata which is written, including file size if it increases.  Some
are explicit about that (e.g. VxFS), some don't make it clear.
Clearly that is a useful behaviour for fdatasync(), and not writing
data-locating metadata is a lot less useful.

So given what I know of fdatasync() in other OSes documentation, does
"metadata" mean fdatasync() and/or sync_file_range() exclude all
metadata, or just non-data-locating metadata, and what about size changes?

But it's not that bad.  sync_file_range() says a bit more, about
overwrites to instantiated data blocks.

Or does it?  What about filesystems which don't overwrite all
instantiated data in place?  There are a few of those.  ext3 with
data=journalling.  All flash filesystems.  nilfs.  Btrfs I'm not sure
about, seems likely.  They all involve _some_ kind of metadata just to
update instantiated data.

Does the text mean sync_file_range() might be unreliable for
crash-resistant commits on those filesystems, or do _they_ have
another kind of metadata that is not excluded "the file's metadata"?

I can't tell from the man page what happens on those filesystems.

But a kernel thread from Feb 2008 revealed the truth:
sync_file_range() _doesn't_ commit data on such filesystems.

So sync_file_range() is basically useless as a data integrity
operation.  It's not a substitute for fdatasync().  Therefore why
would you ever use it?

> In terms of making it easier to use, some predefined bitfield
> combinations is all that's necessary.

See above.  It doesn't work on some filesystems for integrity.  It may
still be useful for application-directed writeout scheduling, but I
don't imagine many apps using it for that when we have
fadvise/madvise.

The flag examples aren't as helpful as they first look.  Unless you
already know about Linux dirty page writeouts, it's far from clear why
SYNC_FILE_RANGE_WRITE|SYNC_FILE_RANGE_WAIT_AFTER is not a data
integrity sync.

(After all, an aio_fsync_range + aio_suspend _would_ be a data
integrity sync.)

It's obvious when you know about the kernel's queued writeout concept
and pages dirtied after beginning writeout, but that's missing from
the man page.

Also it does too much writing, if a page has been queued for writeout,
then dirtied, _but_ that queued writeout had not reached the I/O
driver when the page was re-dirtied.  In that case, it will write the
page twice but once is enough.  With long writeout queues in the
kernel and a small file being regularly updated, or simply with normal
background writeout occurring as well, those unnecessary double writes
are a realistic scenario.

So in a nutshell:

   The man page could do with an explanation of the writeout queue,
   and why SYNC_FILE_RANGE_WAIT_BEFORE is needed for
   dirtied-after-queued-for-writeout pages.

   The man page could do with defining "metadata", and the
   implemention should follow.

   Preferably change it to behave like useful fdatasync()
   implementations claim to: Exclude inode metadata such as times and
   permissions, and include all relevant data-locating metadata
   including file size (if in the range), indirection blocks in simple
   filesystems, and tree/journal updates in modern ones.

   Until the implementation follows, the man page should note that on
   COW filesystems it currently guarantees nothing.

   The implemention blocks too much when sYNC_FILE_RANGE_WAIT_BEFORE
   has to wait for a single page, while it could be queuing others.

   With a large range and SYNC_FILE_RANGE_WRITE only - which looks
   like it could be asynchronous - does it block because the writeout
   queue is full?  Or is there no limit on the writeout queue size?
   If it can block arbitrarily - how is that any better than
   fsync_range() with obvious semantics?

   It might be less efficient than fdatasync(), if setting all three
   flags means it writes a page twice which was dirtied since the last
   writeout was queued but has not hit the I/O driver.  The
   implementation _might_ be smarter than that (or fdatasync() have
   the same inefficiency), but the optimisation is not allowed if you
   treat the man page as a specification.

I'll be more than happy to submit man page improvements if we can
agree what it should really do :-)

Btw, I've Cc'd Nick Piggin who introduced a good thread proposing
fsync_range a few months ago.  Imho, fsync_range with a flags
argument, and its AIO equivalent, would be great.

> As far as extending the implementation so it calls into filesystem to
> commit data-locating metadata, and other semantics such as "flush on
> next commit, or "flush-when-upcoming-metadata-changes-such-as-a-rename", 
> we might need to change the implementation somewhat (or a lot).

Yes I agree.  It must be allowed to return ENOTSUP for unsupportable
or unimplemented combinations - after doing all that it can anyway.

For example, SYNC_HARD (disk cache barrier) won't be supportable if
the disk doesn't do barriers, or if it's some device-mapper devices,
or if it's NFS, for example.  Unless you configured the filesystem to
lie, or told it the NFS server does hardware-level commit, say.

> But the interface does make a lot of sense.  (But maybe that's because
> I've spent too much time staring at all of the page writeback call
> paths, and compared to that even string theory is pretty simple.  :-)

Yeah, sounds like you have studied both and gained the proper perspective :-)

I suspect all the fsync-related uncertainty about whether it really
works, including interactions with filesystem quirks, reliable and
potential bugs in filesystems, would be much easier to get right if we
only had a way to repeatably test it.

Just like other filesystem stress/regression tests.

I'm thinking running a kernel inside a VM invoked and
stopped/killed/branched is the only realistic way to test that all
data is committed properly, with/without necessary I/O barriers, and
recovers properly after a crash and resume.  Fortunately we have good
VMs now, such a test seems very doable.  It would help with testing
journalling & recovery behaviour too.

Is there such a test or related tool already?

-- Jamie
