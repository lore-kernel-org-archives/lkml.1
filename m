Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYBYLlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYBYLlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYBYLlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:41:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbYBYLlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:41:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Mon, 25 Feb 2008 12:40:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0802242109130.31164-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802242109130.31164-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802251240.24386.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 of February 2008, Alan Stern wrote:
> On Sun, 24 Feb 2008, Pavel Machek wrote:
> 
> > > > At the very least, you'd need rmb() before reading it and wmb() after
> > > > writing to it, but I'm not sure if that's enough on every obscure
> > > > architecture out there.
> > > 
> > > No, neither one is needed because of the way suspending_task is used.  
> > > 
> > > It's not necessary for a reader R to see the variable's actual value;  
> > > all R needs to know is whether or not suspending_task is equal to R.  
> > > Since the only process which can set suspending_task to R is R itself,
> > > and since R will set suspending_task back to NULL before releasing the
> > > write lock on pm_sleep_rwsem, there's never any ambiguity.
> > 
> > Subtle.
> > 
> > Very subtly wrong ;-).
> > 
> > imagine suspending_task == 0xabcdef01. Now task "R" with current ==
> > 0xabcd0000 reads suspending_task while the other cpu is writing to it,
> > and sees 0xabcd0000 (0xef01 was not yet written) -- and mistakenly
> > believes that  "R" == suspending_task.
> 
> I always thought that reads and writes of pointers are atomic, just 
> like reads and writes of longs.  Is that wrong?

That depends on the architecture.  It may be wrong on alpha, IIRC.

> Now if pointers were the same size as long long then I would agree with 
> you.

That certainly is true on x86-64.  On alpha probably too.

> > I agree it is very unlikely, and it will not happen on i386. But what
> > about just using atomic_t suspending_task, and store current->pid into
> > it?
> 
> That would work just as well.  Except that it wouldn't need to be
> atomic_t, because current->pid is always an integer (not guaranteed, I
> suppose, but that's what it is on all current architectures) and
> reads/writes of ints _are_ atomic.

That also depends on the arch, I'm afraid, and in general if we assume
something to be atomic, it's better to make the code reflect that assumption.

Thanks,
Rafael
