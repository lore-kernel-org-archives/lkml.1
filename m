Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbXAaC0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbXAaC0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 21:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXAaC0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 21:26:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbXAaC0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 21:26:05 -0500
Date: Wed, 31 Jan 2007 03:28:47 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Denis Vlasenko <vda.linux@googlemail.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Linus Torvalds <torvalds@osdl.org>, Viktor <vvp01@inbox.ru>,
       Aubrey <aubreylee@gmail.com>, Hua Zhong <hzhong@gmail.com>,
       Hugh Dickins <hugh@veritas.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: O_DIRECT question
Message-ID: <20070131022847.GU8030@opteron.random>
References: <45BCBECE.4080405@tmr.com> <200701281803.08201.vda.linux@googlemail.com> <20070129170056.GJ8030@opteron.random> <45BE7D99.70200@cfl.rr.com> <20070130023056.GN8030@opteron.random> <45BF65E3.6070102@cfl.rr.com> <20070130164806.GQ8030@opteron.random> <45BF9381.8010108@cfl.rr.com> <20070130195720.GR8030@opteron.random> <45BFCFA2.6000701@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BFCFA2.6000701@cfl.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 06:07:14PM -0500, Phillip Susi wrote:
> It most certainly matters where the error happened because "you are 
> screwd" is not an acceptable outcome in a mission critical application. 

An I/O error is not an acceptable outcome in a mission critical app,
all mission critical setups should be fault tolerant, so if raid
cannot recover at the first sign of error the whole system should
instantly go down and let the secondary takeover from it. See slony
etc...

Trying to recover the recoverable by mucking up with data making even
_more_ writes on a failing disk before doing physical mirror image of
the disk (the readable part) isn't a good idea IMHO. At best you could
retry writing on the same sector hoping somebody disconnected the scsi
cable by mistake.

>  A well engineered solution will deal with errors as best as possible, 
> not simply give up and tell the user they are screwed because the 
> designer was lazy.  There is a reason that read and write return the 
> number of bytes _actually_ transfered, and the application is supposed 
> to check that result to verify proper operation.

You can track the range where it happened with fsync too like said in
previous email, and you can take the big database lock and then
read-write read-write every single block in that range until you find
the failing place if you really want to. read-write in place should be
safe.

> No, there is a slight difference.  An fsync() flushes all dirty buffers 
> in an undefined order.  Using O_DIRECT or O_SYNC, you can control the 
> flush order because you can simply wait for one set of writes to 
> complete before starting another set that must not be written until 
> after the first are on the disk.  You can emulate that by placing an 
> fsync between both sets of writes, but that will flush any other
> dirty 

Doing fsync after every write will provide the same ordering
guarantee as O_SYNC, thought it was obvious what I meant here.

The whole point is that most of the time you don't need it, you need
an fsync after a couple of writes. All smtp servers uses fsync for the
same reason, they also have to journal their writes to avoid losing
email when there is a power loss.

If you use writev or aio pwrite you can do well with O_SYNC too though.

> buffers whose ordering you do not care about.  Also there is no aio 
> version of fsync.

please have a second look at aio_abi.h:

	IOCB_CMD_FSYNC = 2,
	IOCB_CMD_FDSYNC = 3,

there must be a reason why they exist, right?

> sync has no effect on reading, so that test is pointless.  direct saves 
> the cpu overhead of the buffer copy, but isn't good if the cache isn't 
> entirely cold.  The large buffer size really has little to do with it, 

direct bypasses the cache so the cache is freezing not just cold.

> rather it is the fact that the writes to null do not block dd from 
> making the next read for any length of time.  If dd were blocking on an 
> actual output device, that would leave the input device idle for the 
> portion of the time that dd were blocked.

The objective was to measure the pipeline stall, if you stall it for
other reason anyway what's the point?

> In any case, this is a totally different example than your previous one 
> which had dd _writing_ to a disk, where it would block for long periods 
> of time due to O_SYNC, thereby preventing it from reading from the input 
> buffer in a timely manner.  By not reading the input pipe frequently, it 
> becomes full and thus, tar blocks.  In that case the large buffer size 
> is actually a detriment because with a smaller buffer size, dd would not 
> be blocked as long and so it could empty the pipe more frequently 
> allowing tar to block less.

It would run slower with smaller buffer size because it would block
too and it would read and write slower too. For my backup usage
keeping tar blocked is actually a feature, so the load of the backup
decreases. To me it's important the MB/sec of the writes and the
MB/sec of the reads (to lower the load), I don't care too much about
how long it takes as far as things runs as efficiently as possible
when they run. The rate limiting effect of the blocking isn't a
problem to me.

> You seem to have missed the point of this thread.  Denis Vlasenko's 
> message that you replied to simply pointed out that they are 
> semantically equivalent, so O_DIRECT can be dropped provided that O_SYNC 
> + madvise could be fixed to perform as well.  Several people including 
> Linus seem to like this idea and think it is quite possible.

I answered to that email to point out the fundamental differences
between O_SYNC and O_DIRECT, if you don't like what I said I'm sorry
but that's how things are running today and I don't see quite possible
to change (unless of course we remove performance from the equation,
then indeed they'll be much the same).

Perhaps a IOCB_CMD_PREADAHEAD plus MAP_SHARED backed by lagepages
loaded with a new syscall that reads a piece at time into the large
pagecache, could be an alternative design, or perhaps splice could
obsolete O_DIRECT. I've just a very hard time to see how
O_SYNC+madvise could ever obsolete O_DIRECT.
