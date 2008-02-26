Return-Path: <linux-kernel-owner+w=401wt.eu-S1762057AbYBZPIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057AbYBZPIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYBZPH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:07:57 -0500
Received: from mail2.shareable.org ([80.68.89.115]:55710 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYBZPHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:07:55 -0500
Date: Tue, 26 Feb 2008 15:07:45 +0000
From: Jamie Lokier <jamie@shareable.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20080226150745.GA18118@shareable.org>
References: <20080226072649.GB30238@shareable.org> <20080225234319.f4589ae4.akpm@linux-foundation.org> <20080226075921.GG30238@shareable.org> <200802262016.11297.nickpiggin@yahoo.com.au> <20080226140925.GB20428@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080226140925.GB20428@lazybastard.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Tue, 26 February 2008 20:16:11 +1100, Nick Piggin wrote:
> > 
> > Yeah, sync_file_range has slightly unusual semantics and introduce
> > the new concept, "writeout", to userspace (does "writeout" include
> > "in drive cache"? the kernel doesn't think so, but the only way to
> > make sync_file_range "safe" is if you do consider it writeout).
> 
> If sync_file_range isn't safe, it should get replaced by a noop
> implementation.  There really is no point in promising "a little"
> safety.
> 
> One interesting aspect of this comes with COW filesystems like btrfs or
> logfs.  Writing out data pages is not sufficient, because those will get
> lost unless their referencing metadata is written as well.  So either we
> have to call fsync for those filesystems or add another callback and let
> filesystems override the default implementation.

fdatasync() is required to write data pages _and_ the necessary
metadata to reference those changed pages (btrfs tree etc.), but not
non-data metadata.

It's the filesystem's responsibility to interpret that correctly.
In-place writes don't need anything else.  Phase-tree style writes do.
Some kinds of logged writes don't.

I'm under the impression that sync_file_range() is a sort of
restricted-range asynchronous fdatasync().

By limiting the range of file date which must be written out, it
becomes more refined for database and filesystem-in-a-file type
applications.  Just as fsync() is more refined than sync() - it's
useful to sync less - same goes for syncing just part of a file.

It's still the filesystem's responsibility to sync data access
metadata appropriately.  It can sync more if it wants, but not less.

That's what I understand by
   sync_file_range(fd, start,length, SYNC_FILE_RANGE_WRITE_BEFORE
                   | SYNC_FILE_RANGE_WRITE
                   | SYNC_FILE_RANGE_WRITE_AFTER);
Largely because the manual says to use that combination of flags for
an equivalent to fdatasync().

The concept of "write-out" is not defined in the manual.  I'm assuming
it to mean this, as a reasonable guess:

SYNC_FILE_RANGE_WRITE scans all pages in the range, looking for dirty
pages which aren't already queued for write-out.  It marks those with
a "write-out" flag, and starts write I/Os at some unspecified time in
the near future; it can be assumed writes for all the pages will
complete eventually if there's no errors.  When I/O completes on a
page, it cleans the page and also clears the write-out flag.

SYNC_FILE_RANGE_WAIT_AFTER waits until all pages in the range don't
have the "write-out" flag set.

SYNC_FILE_RANGE_WAIT_BEFORE does the same wait, but before marking
pages for write-out.  I don't actually see the point in this.  Isn't a
preceding call with SYNC_FILE_RANGE_WAIT_AFTER equivalent, making
BEFORE a redundant flag?

The manual says it is something to do with data-integrity, but it's
not clear to me what that means.

All this implies that "write-out" flag is a concept userspace can rely
on.  That's not so peculiar: WRITE seems to be equivalent to AIO-style
fdatasync() on a limited range of offsets, and WAIT_AFTER seems to be
equivalent to waiting for any previously issued such ops to complete.

Any data access metadata updates that btrfs must make for fdatasync(),
it must also make for sync_file_range(), for the limited range of
offsets.

-- Jamie
