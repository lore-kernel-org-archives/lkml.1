Return-Path: <linux-kernel-owner+w=401wt.eu-S932717AbZDBQuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbZDBQuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932506AbZDBQuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:50:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932404AbZDBQuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:50:05 -0400
Date: Thu, 2 Apr 2009 09:46:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Rees <drees76@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Janne Grunau <j@jannau.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <72dbd3150904020933y515c7185p5726323c430c339b@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904020942181.4130@localhost.localdomain>
References: <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>  <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>  <20090326174704.cd36bf7b.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>  <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca>  <20090402110532.GA5132@aniel> <20090402090912.cac200bb.akpm@linux-foundation.org>
 <72dbd3150904020933y515c7185p5726323c430c339b@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Apr 2009, David Rees wrote:
> 
> MythTV actually uses fdatasync, not fsync (or at least that's what it
> did last time I looked at the source).  Not sure how the behavior of
> fdatasync compares to sync_file_range.

fdatasync() _waits_ for the data to hit the disk.

sync_file_range() just starts writeout.

It _can_ do more - you can also ask for it to wait for previous write-out 
in order to start _new_ writeout, or wait for the result, but you wouldn't 
want to, not for something like this.

sync_file_range() is really a much nicer interface, and is a more extended 
fdatasync() that actually matches what the kernel does internally.

You can think of fdatasync(fd) as a 

	sync_file_range(fd, 0, ~0ull,
		SYNC_FILE_RANGE_WAIT_BEFORE | SYNC_FILE_RANGE_WRITE | SYNC_FILE_RANGE_WAIT_AFTER);

and then you see why fdatasync is such a horrible interface.

		Linus
