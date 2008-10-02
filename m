Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYJBUZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYJBUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 16:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYJBUZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 16:25:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753533AbYJBUZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 16:25:17 -0400
Date: Thu, 2 Oct 2008 13:24:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-Id: <20081002132457.46ad8d05.akpm@linux-foundation.org>
In-Reply-To: <20081002061236.3c71c877@infradead.org>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<20081002062736.GR19428@kernel.dk>
	<20081001235501.2b7f50fe.akpm@linux-foundation.org>
	<20081002061236.3c71c877@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 06:12:36 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> On Wed, 1 Oct 2008 23:55:01 -0700
> > 
> > I've forgotten where that code is now, but I don't think it was ever
> > revisited.  It should be.
> > 
> > So.  Where are these atime updaters getting blocked?
> 
> my reproducer is sadly very simple (claws-mail is my mail client that uses maildir)
> 
> Process claws-mail (4896)                  Total: 2829.7 msec 
> EXT3: Waiting for journal access                  2491.0 msec         88.4 % 
> Writing back inodes				   160.9 msec          5.7 % 
> synchronous write                                   78.8 msec          3.0 %
> 
> is an example of such a trace (this is with patch, without patch the numbers are about 3x bigger)
> 
> Waiting for journal access is "journal_get_write_access"
> Writing back inodes is "writeback_inodes"
> synchronous write is "do_sync_write"
> 

Right.  Probably the lock_buffer() in do_get_write_access().  kjournald
is checkpointing the committing transaction (writing metadata buffers
back into the fs) and a user process operating on the current
transaction is trying to get access to one of those buffers but has to
wait for the writeout to complete first.

It wasn't always thus.  Back in, umm, 2.5.0 we did

	/*
	 * The buffer_locked() || buffer_dirty() tests here are simply an
	 * optimisation tweak.  If anyone else in the system decides to
	 * lock this buffer later on, we'll blow up.  There doesn't seem
	 * to be a good reason why they should do this.
	 */
	if (jh->b_cp_transaction &&
	    (buffer_locked(jh2bh(jh)) || buffer_dirty(jh2bh(jh)))) {
		unlock_journal(journal);
		lock_buffer(jh2bh(jh));

and I _think_ it was the loss of that which hurt us a lot. 
773fc4c63442fbd8237b4805627f6906143204a8 or thereabouts in the old git
tree.

It would be very good if we could again decouple the committing and
current transactions, but I fear that none of us remember sufficiently
well how it all works (or, more importantly, how it all doesn't work
when you make a change).

Of course, that could all be wrong and we could be stuck somewhere
else.  A good way to diagnose this stuff would be

--- a/kernel/sched.c~a
+++ a/kernel/sched.c
@@ -5567,10 +5567,14 @@ EXPORT_SYMBOL(yield);
 void __sched io_schedule(void)
 {
 	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	unsigned long in, out;
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	in = jiffies;
 	schedule();
+	out = jiffies;
+	WARN_ON(time_after(out, in + 1 * HZ));
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 }
_

perhaps for varying values of "1".
