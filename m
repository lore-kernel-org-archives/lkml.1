Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbZDBQq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbZDBQq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbZDBQqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:46:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765703AbZDBQqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:46:31 -0400
Date: Thu, 2 Apr 2009 09:42:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rees <drees76@gmail.com>
Cc: Janne Grunau <j@jannau.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-Id: <20090402094247.9d7ac19f.akpm@linux-foundation.org>
In-Reply-To: <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com>
References: <20090325183011.GN32307@mit.edu>
	<20090325220530.GR32307@mit.edu>
	<alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
	<20090326174704.cd36bf7b.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
	<20090326182519.d576d703.akpm@linux-foundation.org>
	<20090401210337.GB3797@csclub.uwaterloo.ca>
	<20090402110532.GA5132@aniel>
	<72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 09:29:59 -0700 David Rees <drees76@gmail.com> wrote:

> On Thu, Apr 2, 2009 at 4:05 AM, Janne Grunau <j@jannau.net> wrote:
> >> Current kernels just have too much IO latency
> >> with ext3 it seems.
> >
> > MythTV calls fsync every few seconds on ongoing recordings to prevent
> > stalls due to large cache writebacks on ext3.
> 
> Personally that is also one of my MythTV pet peeves.  A hack added to
> MythTV to work around a crappy ext3 latency bug that also causes these
> large files to get heavily fragmented.  That and the fact that yo have
> to patch MythTV to eliminate those forced fdatasyncs - there is no
> knob to turn it off if you're running MythTV on a filesystem which
> doesn't suffer from ext3's data=ordered fsync stalls.
> 

For any filesystem it is quite sensible for an application to manage
the amount of dirty memory which the kernel is holding on its behalf,
and based upon the application's knowledge of its future access
patterns.

But MythTV did it the wrong way.

A suitable design for the streaming might be, every 4MB:

- run sync_file_range(SYNC_FILE_RANGE_WRITE) to get the 4MB underway
  to the disk

- run fadvise(POSIX_FADV_DONTNEED) against the previous 4MB to
  discard it from pagecache.

