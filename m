Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZDDIYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZDDIYy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 04:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbZDDIYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 04:24:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919AbZDDIYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 04:24:33 -0400
Date: Sat, 4 Apr 2009 01:18:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Mark Lord <lkml@rtr.ca>,
       torvalds@linux-foundation.org, tytso@mit.edu, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
Message-Id: <20090404011838.9c39a78a.akpm@linux-foundation.org>
In-Reply-To: <49D65C80.4080003@garzik.org>
References: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
	<20090326174704.cd36bf7b.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
	<20090326182519.d576d703.akpm@linux-foundation.org>
	<20090401210337.GB3797@csclub.uwaterloo.ca>
	<20090401143622.b1885643.akpm@linux-foundation.org>
	<20090401225737.GC3797@csclub.uwaterloo.ca>
	<49D6214A.9030204@rtr.ca>
	<20090403151648.GJ3795@csclub.uwaterloo.ca>
	<49D65C80.4080003@garzik.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Apr 2009 14:59:12 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> Lennart Sorensen wrote:
> > On Fri, Apr 03, 2009 at 10:46:34AM -0400, Mark Lord wrote:
> >> My Myth box here was running 2.6.18 when originally set up,
> >> and even back then it still took *minutes* to delete large files.
> >> So that part hasn't really changed much in the interim.
> >>
> >> Because of the multi-minute deletes, the distro shutdown scripts
> >> would fails, and power off the box while it was still writing
> >> to the drives.  Ouch.
> >>
> >> That system has had XFS on it for the past year and a half now,
> >> and for Myth, there's no reason not to use XFS.  It's great!
> > 
> > Mythtv has a 'slow delete' option that I believe works by slowly
> > truncating the file.  Seems they believe that ext3 is bad at handling
> > large file deletes, so they try to spread out the pain.  I don't remember
> > if that option is on by default or not.  I turned it off.
> 
> It's pretty painful for super-large files with lots of metadata.
> 

yeah.

There's a dirty hack you can do where you append one byte to the file
every 4MB, across 1GB (say).  That will then lay the file out on-disk as

one bitmap block
one data block
one bitmap block
one data block
one bitmap block
one data block
one bitmap block
one data block
<etc>
lots-of-data-blocks

So when the time comes to delete that gigabyte, the bitmaps blocks are
only one block apart, and reading them is much faster.

That was one of the gruesome hacks I did way back when I was in the
streaming video recording game.

Another was the slow-delete thing.

- open the file

- unlink the file

- now sit in a loop, slowly nibbling away at the tail with
  ftruncate() until the file is gone.

The open/unlink was there so that if the system were to crash midway,
ext3 orphan recovery at reboot time would fully delete the remainder of
the file.


Another was to add an ioctl to ext3 to extend the file outside EOF, but
only metadata - the corresponding data blocks are left uninitialised. 
That permitted large amount of data blocks to be allocated to the file
with high contiguity, fixing the block-intermingling problems when ext3
is writing multiple files (which reservations later addressed).

This is of course insecure, but that isn't a problem on an
embedded/consumer black box device.


ext3 sucks less nowadays, but it's still a hard vacuum.
