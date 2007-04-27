Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbXD0WH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbXD0WH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbXD0WHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:07:24 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbXD0WHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:07:12 -0400
Date: Fri, 27 Apr 2007 15:07:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Message-Id: <20070427150703.293748d0.akpm@linux-foundation.org>
In-Reply-To: <1177700946.22145.9.camel@localhost>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	<alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
	<20070427113117.98c4f88b.akpm@linux-foundation.org>
	<1177700946.22145.9.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 13:09:06 -0600
Zan Lynx <zlynx@acm.org> wrote:

> On Fri, 2007-04-27 at 11:31 -0700, Andrew Morton wrote:
> [snip]
> > ext3's problem here is that a single fsync() requires that ext3 sync the
> > whole filesystem.  Because
> > 
> > - a journal commit can contain metadata from multiple files, and if we
> >   want to journal one file's metadata via fsync(), we unavoidably journal
> >   all the other file's metadata at the same time.
> > 
> > - ordered mode requires that we write a file's data blocks prior to
> >   journalling the metadata which refers to those blocks.
> > 
> > net result: syncing anything syncs the whole world.
> > 
> > There are a few areas in which this could conceivably be tuned up: if a
> > particular file doesn't currently have any metadata in the commit, we don't
> > actually need to sync its data blocks: we could just transfer them into
> > next commit.  Hard, unlikely to be of benefit.
> [snip]
> 
> How about mixing the ordered and data journal modes?  If the data blocks
> would fit, have fsync write them into the journal as is done in
> data=journal mode.  Then that file data is committed to disk as fsync
> requires, but it shouldn't require flushing all the previous metadata to
> get an ordered guarantee.

In some ways that would be quite neat: if a process does a small write then
fsyncs it, write it all into the journal.  That avoids a seek out to the
file's data blocks.

However it'd be quite hard to do, I expect: we don't know until commit time
how much data has been written to this file (actually, we don't even know
at commit-time, but we could, with quite some work, find out).

But none of this will solve the problem, because even with your optimised
fsync(), we still need to write out bonnie's large file at commit time,
when we fsync() your small write to a different file.

(And when I say "this problem" I refer to the known-about problem which
we're discussing here.  I suspect this in fact isn't Mike's problem - 20
minutes is crazy - it's not attributable to the fsync-syncs-everything
problem unless Mike's GUI is doing a huge numer of separate fsyncs)
