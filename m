Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZDERFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZDERFW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 13:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZDERFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 13:05:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbZDERFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 13:05:04 -0400
Date: Sun, 5 Apr 2009 10:01:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Arjan van de Ven <arjan@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
In-Reply-To: <20090405001005.GA7553@mit.edu>
Message-ID: <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain>
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
 <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org> <20090405001005.GA7553@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Apr 2009, Theodore Tso wrote:
> 
> It may be that it's easier from an less-lines-of-the-kernels-to-change
> point of view to add a WRITE_SYNC_PLUGGED which doesn't do the unplug,
> and keep WRITE_SNYC as having the implicit unplug.  Or maybe it would
> be better to completely separate the "send a write which is marked as
> SYNC" from the "implicit unplug" in the API.

Well, the block layer internally already separates the two, it's just 
WRITE_SYNC that ties them together. So a trivial patch like the appended 
would make WRITE_SYNC just mean "this is synchronous IO" without the 
unplugging, and then WRITE_UNPLUG would mark it both as synchronous _and_ 
unplug it.

(Or you could do the WRITE_SYNC_PLUGGED model too, but I think WRITE_SYNC 
and WRITE_UNPLUG actually would be better names, since they talk about the 
effects more directly).

The question is more of a "who really wants the unplugging". Presumably 
the direct-io code-path really does (on the assumption that if you are 
doing direct-io, the caller had better done all the coalescing it wants).

Non-rotational media would tend to want the unplugging, but the block 
layer already does that (ie in __make_request() we already do:

        if (unplug || blk_queue_nonrot(q))
                __generic_unplug_device(q);

so non-rotational devices get unplugged whether the request was a 
unplugging request or not).

Of course, different IO schedulers react differently to that whole "sync 
vs unplug" thing. I think CFQ is the only one that actually cares about 
the "sync" bit (using different queues for sync vs async). The other 
schedulers only care about the plugging. So the patch below really doesn't 
make much sense as-is, because as things are right now, the scheduler 
behaviors are so different for the unplug-vs-sync thing that no sane user 
can ever know whether they should use WRITE_SYNC (== higher priority 
queueing for CFQ, no-op for others) or WRITE_UNPLUG (unplug on all, and 
additionally higher priority for CFQ).

So I'm not serious about this patch, because as things are right now, I 
don't think it's sensible, but I do think that this just generally shows 
the confusion of what we should do. When is plugging right, when isn't it?

Also, one of the issues seems to literally be that the higher-level 
request handling doesn't care AT ALL about the priority. Allocating the 
request itself does keep reads and writes separated, but if the request is 
a SYNCIO request, and non-sync writes have filled up th write requests, 
we'll have to wait for the background writes to free up requests.

That is quite possibly the longest wait we have in the system.

See get_request():

	const int rw = rw_flags & 0x01;

(That should _really_ be RW_MASK instead of 0x01, I suspect) and how the 
request allocation itself is done.

I think this is broken.

			Linus

---
 include/linux/fs.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index a09e17c..a144377 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -95,7 +95,8 @@ struct inodes_stat_t {
 #define SWRITE 3	/* for ll_rw_block() - wait for buffer lock */
 #define READ_SYNC	(READ | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define READ_META	(READ | (1 << BIO_RW_META))
-#define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
+#define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNCIO))
+#define WRITE_UNPLUG	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define SWRITE_SYNC	(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define WRITE_BARRIER	(WRITE | (1 << BIO_RW_BARRIER))
 #define DISCARD_NOBARRIER (1 << BIO_RW_DISCARD)
