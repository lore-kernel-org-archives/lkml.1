Return-Path: <linux-kernel-owner+w=401wt.eu-S1759140AbZCXStW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbZCXStW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbZCXStN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:49:13 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:8430 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbZCXStM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:49:12 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	 <49C87B87.4020108@krogh.cc>
	 <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	 <20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	 <20090324093245.GA22483@elte.hu>
	 <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	 <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu>
	 <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain>
Date: Tue, 24 Mar 2009 14:41:59 -0400
Message-ID: <f73f7ab80903241141t358ab241qa377e709752a3cbf@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: Kyle Moffett <kyle@moffetthome.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 1:55 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, 24 Mar 2009, Theodore Tso wrote:
>> Try ext4, I think you'll like it.  :-)
>>
>> Failing that, data=writeback for single-user machines is probably your
>> best bet.
>
> Isn't that the same fix? ext4 just defaults to the crappy "writeback"
> behavior, which is insane.
>
> Sure, it makes things _much_ smoother, since now the actual data is no
> longer in the critical path for any journal writes, but anybody who thinks
> that's a solution is just incompetent.
>
> We might as well go back to ext2 then. If your data gets written out long
> after the metadata hit the disk, you are going to hit all kinds of bad
> issues if the machine ever goes down.

Not really...

Regardless of any journalling, a power-fail or a crash is almost
certainly going to cause "data loss" of some variety.  We simply
didn't get to sync everything we needed to (otherwise we'd all be
shutting down our computers with the SCRAM switches just for kicks).
The difference is, with ext3/4 (in any journal mode) we guarantee our
metadata is consistent.  This means that we won't double-allocate or
leak inodes or blocks, which means that we can safely *write* to the
filesystem as soon as we replay the journal.  With ext2 you *CAN'T* do
that at all, as somebody may have allocated an inode but not yet
marked it as in use.  The only way to safely figure all that out
without journalling is an fsck run.

That difference between ext4 and ext3-in-writeback-mode is this:  If
you get a crash in the narrow window *after* writing initial metadata
and before writing the data, ext4 will give you a zero length file,
whereas ext3-in-writeback-mode will give you a proper-length file
filled with whatever used to be on disk (might be the contents of a
previous /etc/shadow, or maybe somebody's finance files).

In that same situation, ext3 in data-ordered or data-journal mode will
"close" the window by preventing anybody else from making forward
progress until the data and the metadata are both updated.  The thing
is, even on ext3 I can get exactly the same kind of behavior with an
appropriately timed "kill -STOP $dumb_program", followed by a power
failure 60 seconds later.  It's a relatively obvious race condition...

When you create a file, you can't guarantee that all of that file's
data and metadata has hit disk until after an fsync() call returns.
The only *possible* exceptions are in cases like the
previously-mentioned (and now patched)
open(A)+write(A)+close(A)+rename(A,B), where the
rename-over-existing-file should act as an implicit filesystem
barrier.  It should ensure that all writes to the file get flushed
before it is renamed on top of an existing file, simply because so
much UNIX software expects it to act that way.

When you're dealing with programs that simply
open()+ftruncate()+write()+close(), however... there's always going to
be a window in-between the ftruncate and the write where the file *is*
an empty file, and in that case no amount of operating-system-level
cleverness can deal with application-level bugs.

Cheers,
Kyle Moffett
