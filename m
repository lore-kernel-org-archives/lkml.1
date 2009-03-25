Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZCYS7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZCYS7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZCYS7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:59:24 -0400
Received: from THUNK.ORG ([69.25.196.29]:32840 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbZCYS7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:59:22 -0400
Date: Wed, 25 Mar 2009 14:58:24 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090325185824.GO32307@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 10:29:48AM -0700, Linus Torvalds wrote:
> I suspect there is also some possibility of confusion with inter-file 
> (false) metadata dependencies. If a filesystem were to think that the file 
> size is metadata that should be journaled (in a single journal), and the 
> journaling code then decides that it needs to do those meta-data updates 
> in the correct order (ie the big file write _before_ the file write that 
> wants to be fsync'ed), then the fsync() will be delayed by a totally 
> irrelevant large file having to have its data written out (due to 
> data=ordered or whatever).

It's not just the file size; it's the block allocation decisions.
Ext3 doesn't have delayed allocation, so as soon as you issue the
write, we have to allocate the block, which means grabbing blocks and
making changes to the block bitmap, and then updating the inode with
those block allocation decisions.  It's a lot more than just i_size.
And the problem is that if we do this for the big file write, and the
small file write happens to also touch the same inode table block
and/or block allocation bitmap, when we fsync() the small file, when
we end up pushing out the metadata updates associated with the big
file write, and so thus we need to flush out the data blocks
associated with the big file write as well.

Now, there are three ways of solving this problem.  One is to use
delayed allocation, where we don't make the block allocation decisions
until the very last minute.  This is what ext4 and XFS does.  The
problem with this is that when we have unrelated filesystem operations
that end up causing zero length files before the file write (i.e.,
replace-via-truncate, where the application does open/truncate/write/
close) or the after the file write (i.e., replace-via-rename, where
the application does open/write/close/rename) and the application
omits the fsync().  So with ext4 we has workarounds that start pushing
out the data blocks in the for replace-via-rename and
replace-via-truncate cases, while XFS will do an implied fsync for
replace-via-truncate only, and btrfs will do an implied fsync for
replace-via-rename only.

The second solution is we could add a huge amount of machinery to try
track these logical dependencies, and then be able to "back out" the
changes to the inode table or block allocation bitmap for the big file
write when we want to fsync out the small file.  This is roughly what
the BSD Soft Updates mechanisms does, and it works, but at the cost of
a *huge* amount of complexity.  The amount of accounting data you have
to track so that you can partially back out various filesystem
operations, and then the state tables that make use of this accounting
data is not trivial.  One of the downsides of this mechanism is that
it makes it extremely difficult to add new features/functionality such
as extended attributes or ACL's, since very few people understand the
complexities needed to support it.  As a result Linux had acl and
xattr support long before Kirk McKusick got around to adding those
features in UFS2.

The third potential solution we can try doing is to make some tuning
adjustments to the VM so that we start pushing out these data blocks
much more aggressively out to the disk.  If we assume that many
applications aren't going to be using fsync, and we need to worry
about all sorts of implied dependencies where a small file gets pushed
out to disk, but a large file does not, you can have endless amounts
of fun in terms of "application level file corruption", which is
simply caused by the fact that a small file has been pushed out to
disk, and a large file hasn't been pushed out to disk yet.  If it's
going to be considered fair game that application programmers aren't
going to be required to use fsync() when they need to depend on
something being on stable storage after a crash, then we need to tune
the VM to much more aggressively clean dirty pages.  Even if we remove
the false dependencies at the filesystem level (i.e., fsck-detectable
consistency problems), there is no way for the filesystem to be able
to guess about implied dependencies between different files at the
application level.

Traditionally, the way applications told us about such dependencies
was fsync().  But if application programmers are demanding that
fsync() is no longer required for correct operation after a filesystem
crash, all we can do is push things out to disk much more
aggressively.

						- Ted
