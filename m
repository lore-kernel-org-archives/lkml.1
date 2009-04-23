Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbZDWWDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbZDWWDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbZDWWDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:03:25 -0400
Received: from mail2.shareable.org ([80.68.89.115]:36469 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbZDWWDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:03:24 -0400
Date: Thu, 23 Apr 2009 23:03:19 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Valerie Aurora Henson <vaurora@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Eric Sandeen <sandeen@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: fsync_range_with_flags() - improving sync_file_range()
Message-ID: <20090423220319.GM13326@shareable.org>
References: <20090423001257.GA16540@shell> <20090422221748.8c9022d1.akpm@linux-foundation.org> <20090423112105.GA1589@shareable.org> <20090423124230.GF2723@mit.edu> <20090423164330.GA9399@shareable.org> <20090423172925.GL2723@mit.edu> <20090423204411.GF13326@shareable.org> <20090423211305.GN2723@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090423211305.GN2723@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Thu, Apr 23, 2009 at 09:44:11PM +0100, Jamie Lokier wrote:
> > Yes that's the page I've read and didn't find useful :-)
> > The data-locating metadata is explained thus:
> > 
> >      None of these operations write out the file’s metadata.
> >      Therefore, unless the application is strictly performing
> >      overwrites of already- instantiated disk blocks, there are no
> >      guarantees that the data will be available after a crash.
> 
> Well, I thought that was clear.  Today, sync_file_range(2) only works
> if the data-localting metadata is already on the disk.  This is useful
> for databases where the tablespace is allocated ahead of time, but not
> much else.

The text is clear to me, except for the ambiguity about whether
"strictly performing overwrites of already-instantiated disk blocks"
means in-place file overwrites on all filesystems, or strictly depends
on the filesystem's disk format.

It turns out "already-instantiated disk blocks" really does mean disk
blocks and not file blocks, and that low-level dependency looks so out
of place as generic file system call that I wondered if it was just a
poorly worded reference to file blocks.

> > But a kernel thread from Feb 2008 revealed the truth:
> > sync_file_range() _doesn't_ commit data on such filesystems.
> 
> Because we could very easily add a flag which would cause it to commit
> the data-locating metadata blocks --- or maybe we change it so that it
> does commit the data-locating metadata, on the assumption that if the
> data-locating metadata is already committed, which would be true for
> all of its existing users, it's a no-op, and if it isn't, we should
> just comit the data-locating metadata and add a call from the existing
> implementation to a filesystem-provided method function.

I can't think of any reason why you'd not want to commit the
data-locating metadata, except for performance tweaking.  And that
lives better in the kernel than the app, because it's filesystem
dependent anyway.  And there are better ways to tweak performance - a
good implementation of aio_fdatasync springs to mind :-)

> > So sync_file_range() is basically useless as a data integrity
> > operation.  It's not a substitute for fdatasync().  Therefore why
> > would you ever use it?
> 
> It's not useful *today*.  But we could make it useful.  The power of
> the existing bit flags is useful, although granted it can be confusing
> for the users who aren't haven't meditated deeply upon the writeback
> code paths.  I thought it was clear, but if it isn't we can improve
> the documentation.
> 
> More to the point, given that we already have sync_file_range(2), I
> would argue that it would be unfortunate to create a new system call
> that has overlapping functionality but which is not a superset of
> sync_file_range(2).  Maybe Nick has a good reason for starting with an
> entirely new system call, but if so, it would be nice if it at least
> have the power of sync_file_range(2), in addition to having new
> functionality.

I agree on all these points.  There might be slight improvements
possible to the API, such as multiple ranges, but most things should
be doable with new flags.

I'm not sure what "power" sync_file_range has over fsync_range.  I
used to think it must be better because you can separate out the
phases and let the application be clever.  But since it can block
arbitrarily with none of the WAIT flags set, and since you can request
range writeout with fadvise() anyway, I'm not seeing any extra
expressive power in its current form.

> > I suspect all the fsync-related uncertainty about whether it really
> > works, including interactions with filesystem quirks, reliable and
> > potential bugs in filesystems, would be much easier to get right if we
> > only had a way to repeatably test it.
> 
> The answer today is sync_file_range(2) is purely a creature of the MM
> subsystem, and doesn't do anything with respect to filesystem metadata
> or barriers.  Once you understand that, the rest of the man page is
> pretty simple, I think.  :-)   

Heh.  If only I knew the MM subsystem well enough to understand it
then :-)  Right now, with all those writeback hooks, I'm not sure if
sync_file_range results in data-locating metadata being sync'd on, say,
Btrfs or not :-)

> > I'm thinking running a kernel inside a VM invoked and
> > stopped/killed/branched is the only realistic way to test that all
> > data is committed properly, with/without necessary I/O barriers, and
> > recovers properly after a crash and resume.  Fortunately we have good
> > VMs now, such a test seems very doable.  It would help with testing
> > journalling & recovery behaviour too.
> > 
> > Is there such a test or related tool already?
> 
> I don't know of one.  I agree it would be a useful thing to have.  It
> won't test barriers at the driver level, but it would be good for
> testing the everything above that.

With a VM like QEMU/KVM it would be quite easy to test barriers at the
driver level too, including SCSI and ATA.  To thoroughly test, you
could simulate an infinitely large drive cache, flushed to the backing
file only on barrier requests.  To avoid lots of reboots, just take
lots of snapshots without stopping the guest and check the snapshots
while the test continues.  Nowadays you can make snapshots appear as
block devices in the host kernel for fscking and looking at the
contents.

Hmm.  Looks like that harness could also test your rename-over logic
in ext3, test that journalling works in general, and to test userspace
such as databases always call fsync (or sync_file_range) at the right
times.  Hmm.

-- Jamie
