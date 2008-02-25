Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbYBYCTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbYBYCTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 21:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYBYCTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 21:19:07 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3362 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754959AbYBYCTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 21:19:06 -0500
Date: Sun, 24 Feb 2008 21:19:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
In-Reply-To: <20080224214253.GE18908@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0802242109130.31164-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008, Pavel Machek wrote:

> > > At the very least, you'd need rmb() before reading it and wmb() after
> > > writing to it, but I'm not sure if that's enough on every obscure
> > > architecture out there.
> > 
> > No, neither one is needed because of the way suspending_task is used.  
> > 
> > It's not necessary for a reader R to see the variable's actual value;  
> > all R needs to know is whether or not suspending_task is equal to R.  
> > Since the only process which can set suspending_task to R is R itself,
> > and since R will set suspending_task back to NULL before releasing the
> > write lock on pm_sleep_rwsem, there's never any ambiguity.
> 
> Subtle.
> 
> Very subtly wrong ;-).
> 
> imagine suspending_task == 0xabcdef01. Now task "R" with current ==
> 0xabcd0000 reads suspending_task while the other cpu is writing to it,
> and sees 0xabcd0000 (0xef01 was not yet written) -- and mistakenly
> believes that  "R" == suspending_task.

I always thought that reads and writes of pointers are atomic, just 
like reads and writes of longs.  Is that wrong?

Now if pointers were the same size as long long then I would agree with 
you.

> I agree it is very unlikely, and it will not happen on i386. But what
> about just using atomic_t suspending_task, and store current->pid into
> it?

That would work just as well.  Except that it wouldn't need to be
atomic_t, because current->pid is always an integer (not guaranteed, I
suppose, but that's what it is on all current architectures) and
reads/writes of ints _are_ atomic.

Alan Stern

