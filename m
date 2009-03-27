Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbZC0RVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbZC0RVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZC0RVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:21:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57707 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752361AbZC0RVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:21:16 -0400
Date: Fri, 27 Mar 2009 17:19:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327171955.78662c1e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090327170208.GA27646@srcf.ucam.org>
References: <20090327051338.GP6239@mit.edu>
	<20090327055750.GA18065@srcf.ucam.org>
	<20090327062114.GA18290@srcf.ucam.org>
	<20090327112438.GQ6239@mit.edu>
	<20090327145156.GB24819@srcf.ucam.org>
	<20090327150811.09b313f5@lxorguk.ukuu.org.uk>
	<20090327152221.GA25234@srcf.ucam.org>
	<20090327161553.31436545@lxorguk.ukuu.org.uk>
	<20090327162841.GA26860@srcf.ucam.org>
	<20090327165150.7e69d9e1@lxorguk.ukuu.org.uk>
	<20090327170208.GA27646@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> If user applications should always check errors, and if errors can't be 
> reliably produced unless you fsync() before close(), then the correct 
> behaviour for the kernel is to always flush buffers to disk before 
> returning from close(). The reason we don't is that it would be an 

You make a few assumptions here

Unfortunately:
- close() occurs many times on a file
- the kernel cannot tell which close() calls need to commit data
- there are many cases where data is written and there is a genuine
  situation where it is acceptable over a crash to lose data providing
  media failure is rare (eg log files in many situations - not banks
  obviously)

The kernel cannot tell them apart, while fsync/close() as a pair allows
the user to correctly indicate their requirements.

Even "fsync on last close" can backfire horribly if you happen to have a
handle that is inherited by a child task or kept for reading for a long
period.

For an event driven app you really want some kind of threaded or async
fsync then close (fbarrier isn't quite enough because you don't get told
when the barrier is passed). That could be implemented using threads in
the relevant desktops libraries with the thread doing

	fsync()
	poke event thread
	exit

(or indeed for most cases as part of the more general
write-file-interact-with-user-etc call)

> If every application that does a clobbering rename has to call 
> fbarrier() first, then the kernel should just guarantee to do so on the 

Rename is a different problem - and a nastier one. Unfortunately even in
posix fsync says nothing about how metadata updating is handled or what
the ordering rules are between two fsync() calls on different files.

There were problems with trying to order rename against data writeback.
fsync ensures the file data and metadata is valid but doesn't (and
cannot) connect this with the directory state. So if you need to implement

	write data
	ensure it is committed
	rename it
	after the rename is committed then ...

you can't do that in POSIX. Linux extends fsync() so you can fsync a
directory handle but that is an extension to fix the problem rather than
a standard behaviour.

(Also helpful here would be fsync_range, fdatasync_range and
fbarrier_range)

> application's behalf. ext3, ext4 and btrfs all effectively do this, so 
> we should just make it explicit that Linux filesystems are expected to 
> behave this way. 

> If people want to make their code Linux specific then  that's their problem, not the kernel's.

Agreed - which is why close should not happen to do an fsync(). That's
their problem for writing code thats specific to some random may happen
behaviour on certain Linux releases - and unfortunately with no obvious
cheap cure.

--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds
