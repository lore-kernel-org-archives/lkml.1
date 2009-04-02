Return-Path: <linux-kernel-owner+w=401wt.eu-S933905AbZDBQ4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905AbZDBQ4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758139AbZDBQ4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:56:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760794AbZDBQ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:56:14 -0400
Date: Thu, 2 Apr 2009 09:51:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rees <drees76@gmail.com>
Cc: Janne Grunau <j@jannau.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-Id: <20090402095139.c2ff4f06.akpm@linux-foundation.org>
In-Reply-To: <72dbd3150904020933y515c7185p5726323c430c339b@mail.gmail.com>
References: <20090325183011.GN32307@mit.edu>
	<alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
	<20090326174704.cd36bf7b.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
	<20090326182519.d576d703.akpm@linux-foundation.org>
	<20090401210337.GB3797@csclub.uwaterloo.ca>
	<20090402110532.GA5132@aniel>
	<20090402090912.cac200bb.akpm@linux-foundation.org>
	<72dbd3150904020933y515c7185p5726323c430c339b@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 09:33:44 -0700 David Rees <drees76@gmail.com> wrote:

> On Thu, Apr 2, 2009 at 9:09 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Thu, 2 Apr 2009 13:05:32 +0200 Janne Grunau <j@jannau.net> wrote:
> >> MythTV calls fsync every few seconds on ongoing recordings to prevent
> >> stalls due to large cache writebacks on ext3.
> >
> > It should use sync_file_range(SYNC_FILE_RANGE_WRITE). __That will
> >
> > - have minimum latency. __It tries to avoid blocking at all.
> > - avoid writing metadata
> > - avoid syncing other unrelated files within ext3
> > - avoid waiting for the ext3 commit to complete.
> 
> MythTV actually uses fdatasync, not fsync (or at least that's what it
> did last time I looked at the source).  Not sure how the behavior of
> fdatasync compares to sync_file_range.

fdatasync() will still trigger the bad ext3 behaviour.

> Either way - forcing the data to be synced to disk a couple times
> every second is a hack and causes fragmentation in filesystems without
> delayed allocation.  Fragmentation really goes up if you are recording
> multiple shows at once.

The file layout issue is unrelated to the frequency of fdatasync() -
the block allocation is done at the time of write().

ext3 _should_ handle this case fairly well nowadays - I thought we fixed that.
However it would probably benefit from having the size of the block reservation
window increased - use ioctl(EXT3_IOC_SETRSVSZ).  That way, each file gets a
decent-sized hunk of disk "reserved" for its ongoing appending.  Other
files won't come in and intermingle their blocks with it.
