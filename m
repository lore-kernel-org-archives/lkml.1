Return-Path: <linux-kernel-owner+w=401wt.eu-S1765971AbZDCX7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765971AbZDCX7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 19:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759893AbZDCX7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 19:59:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759255AbZDCX7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 19:59:33 -0400
Date: Fri, 3 Apr 2009 16:52:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Mark Lord <lkml@rtr.ca>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
       drees76@gmail.com, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49D69BD5.4060901@garzik.org>
Message-ID: <alpine.LFD.2.00.0904031642370.3915@localhost.localdomain>
References: <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> <20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca>
 <49D625A0.1030202@rtr.ca> <49D66A40.5020503@garzik.org> <20090403212847.GC25887@aniel> <49D68631.4030706@garzik.org> <20090403223218.GD25887@aniel> <49D69BD5.4060901@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Apr 2009, Jeff Garzik wrote:
> 
> If all you want to do is _start_ the write-out from kernel to disk, and let
> the kernel handle it asynchronously, SYNC_FILE_RANGE_WRITE will do that for
> you, eliminating the need for a separate thread.

It may not eliminate the need for a separate thread.

SYNC_FILE_RANGE_WRITE will still block on things. It just will block on 
_much_ less than fsync.

In particular, it will block on:

 - actually queuing up the IO (ie we need to get the bio, request etc all 
   allocated and queued up)

 - if a page is under writeback, and has been marked dirty since that 
   writeback started, we'll wait for that IO to finish in order to start a 
   new one.

and depending on load, both of these things _can_ be issues and you might 
still want to do the SYNC_FILE_RANGE_WRITE as a async thread separate 
from the main loop so that the latency of the main loop is not 
affected by that.

But the latencies will be _much_ smaller issues than with f[data]sync(), 
though, especially if you're not ever really hitting the limits on the 
disk subsystem. Because those will additionally

 - wait for all old writeback to complete (whether the page was dirtied 
   after the writeback started or not)

 - additionally, wait for all the new writeback it started.

 - wait for the metadata too (fsync()).

so they are pretty much _guaranteed_ to sleep for actual IO to complete 
(unless you didn't write anything at all to the file ;)

> On a related subject, reads:  consider posix_fadvise(POSIX_FADV_SEQUENTIAL)
> and/or readahead(2) for optimizing the reading side of things.

I doubt POSIX_FADV_SEQUENTIAL will do very much. The kernel tends to 
figure out the read patterns on its own pretty well. Of course, explicit 
readahead() can be noticeable for the right patterns.

		Linus
