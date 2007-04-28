Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbXD1AlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbXD1AlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 20:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbXD1AlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 20:41:20 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757970AbXD1AlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 20:41:18 -0400
Date: Fri, 27 Apr 2007 17:40:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Lang <david.lang@digitalinsight.com>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <Pine.LNX.4.63.0704271638150.11000@qynat.qvtvafvgr.pbz>
Message-ID: <alpine.LFD.0.98.0704271728460.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <200704280041.17617.rjw@sisk.pl>  <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org>
  <200704280145.26253.rjw@sisk.pl> <1177718250.4737.222.camel@nigel.suspend2.net>
 <Pine.LNX.4.63.0704271638150.11000@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, David Lang wrote:
> 
> all that's needed for the snapshot is to prevent userspace from scheduling,

Strictly speaking, all you *really* want to make sure is not so much that 
user-space isn't scheduling, as the fact that all device IO buffers must 
be empty.

We can trivially snapshot an active user-space, and in fact it would 
probably be hard to do a snapshot in a way that it could even *know* or 
care about whether there are user-space processes running at the time of 
the snapshot.

So that's not the real problem.

What we obviously *cannot* snapshot is if some particular device is in the 
middle of being written to or read from, and has outstanding commands on 
the device itself (as opposed to just queued to the driver). So what we do 
want to make sure happens is that there are no IO queues that are active.

And the best way to make sure that there are no IO queues active is to 
make sure that there are no new read or write-requests. And *that* you can 
do two ways:

 - actually intercepting the read/write requests. Probably not too hard, 
   we could literally do it in the IO scheduler (and probably much more 
   easily than doing it in the process scheduler), but the easy cases will 
   only cover the block device layer, and character devices don't have the 
   same kind of scheduler you can trap IO in.

 - we also don't want to generate new data that needs to be snapshotted, 
   so we want to trap people who write even just to the page cache and 
   turn pages dirty. Again, we could probably do it at *that* point (ie 
   trapping them when they try to dirty a page), and it would be more 
   logical, but again, there are other cases of people who generate more 
   data (just any memory allocation obviously is a special case of 
   generating more data to be snapshotted),

so I do agree that we want to stop producing new data to be snapshotted, 
and we want to stop producing new read-requests. But kernel threads really 
do neither: in an idle system, kernel threads are idle too. A kernel 
thread is not like a user program that actually generates data - they only 
tend to act on behalf of other processes' needs.

So I think that what snapshotting really *wants* to stop is not schedulign 
per se, but IO. And stopping user processes (as opposed to kernel threads) 
is probably a good way to get there.

In fact, I'd argue that you want to stop user space and then encourage 
some kernel threads to *start* running, notably things like bdflush should 
probably be kicked to clean up some dirty stuff as part of the "shrink 
data to be snapshotted" part. Trying to free memory will do that on its 
own, of course.

			Linus

