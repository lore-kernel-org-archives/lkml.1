Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886AbXBDB4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbXBDB4i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 20:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXBDB4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 20:56:38 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56075 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbXBDB4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 20:56:37 -0500
Date: Sat, 3 Feb 2007 17:56:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Karsten Keil <kkeil@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i4ldeveloper@listserv.isdn4linux.de, linux-serial@vger.kernel.org,
       Hansjoerg Lipp <hjlipp@web.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] drivers/isdn/gigaset: new M101 driver
Message-Id: <20070203175623.72a171a1.akpm@linux-foundation.org>
In-Reply-To: <45C537B9.7080704@imap.cc>
References: <200702012112.l11LCOO4016557@lx1.pxnet.com>
	<20070201171345.bd98ce30.akpm@osdl.org>
	<45C537B9.7080704@imap.cc>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Feb 2007 02:32:41 +0100 Tilman Schmidt <tilman@imap.cc> wrote:

> >> +	spin_lock_irqsave(&cs->cmdlock, flags);
> >> +	cb = cs->cmdbuf;
> >> +	spin_unlock_irqrestore(&cs->cmdlock, flags);
> > 
> > It is doubtful if the locking here does anything useful.
> 
> It assures atomicity when reading the cs->cmdbuf pointer.

I think it's bogus.  If the quantity being copied here is more than 32-bits
then yes, a lock is appropriate.  But if it's a single word then it's
unlikely that the locking does anything useful.  Or there might be a bug
here.

> >> +	spin_lock_irqsave(&cs->cmdlock, flags);
> >> +	cb->prev = cs->lastcmdbuf;
> >> +	if (cs->lastcmdbuf)
> >> +		cs->lastcmdbuf->next = cb;
> >> +	else {
> >> +		cs->cmdbuf = cb;
> >> +		cs->curlen = len;
> >> +	}
> >> +	cs->cmdbytes += len;
> >> +	cs->lastcmdbuf = cb;
> >> +	spin_unlock_irqrestore(&cs->cmdlock, flags);
> > 
> > Would the use of list_heads simplify things here?
> 
> I don't think so. The operations in list.h do not keep track of
> the total byte count, and adding that in a race-free way appears
> non-trivial.

Maintaining a byte count isn't related to maintaining a list.

> >> +			down(&cs->hw.ser->dead_sem);
> > 
> > Does this actually use the semaphore's counting feature?  If not, can we
> > switch it to a mutex?
> 
> I stole that code from the PPP line discipline. It is to assure all
> other ldisc methods have completed before the close method proceeds.
> This doesn't look like a case for a mutex to me, but I'm open to
> suggestions if it's important to avoid a semaphore here.

If a sleeping lock is being used as a mutex, please use a mutex.  We prefer
that semaphores only be used in those situations where their counting
feature is being used.

Reasons: a) mutexes have better runtime debugging support and b) Ingo had
some plans to reimplement semaphores in an arch-neutral way and for some
reason reducing the number of callers would help that.  I forget what the
reason was, actually.

> >> +	tail = atomic_read(&inbuf->tail);
> >> +	head = atomic_read(&inbuf->head);
> >> +	gig_dbg(DEBUG_INTR, "buffer state: %u -> %u, receive %u bytes",
> >> +		head, tail, count);
> >> +
> >> +	if (head <= tail) {
> >> +		n = RBUFSIZE - tail;
> >> +		if (count >= n) {
> >> +			/* buffer wraparound */
> >> +			memcpy(inbuf->data + tail, buf, n);
> >> +			tail = 0;
> >> +			buf += n;
> >> +			count -= n;
> >> +		} else {
> >> +			memcpy(inbuf->data + tail, buf, count);
> >> +			tail += count;
> >> +			buf += count;
> >> +			count = 0;
> >> +		}
> >> +	}
> > 
> > Perhaps the (fairly revolting) circ_buf.h can be used for this stuff.
> 
> It probably could, but IMHO readability would suffer rather than improve.
> 

How about kernel/kfifo.c?

