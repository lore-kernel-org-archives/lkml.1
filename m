Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZKWNPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZKWNPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbZKWNPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:15:51 -0500
Received: from lazybastard.de ([212.112.238.170]:59170 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbZKWNPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:15:50 -0500
Date: Mon, 23 Nov 2009 14:15:47 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/17] [LogFS] readwrite.c
Message-ID: <20091123131547.GA18889@logfs.org>
References: <20091120181113.GA2159@logfs.org> <E1NBZJ5-0003hL-Qc@longford.logfs.org> <84144f020911230433q5fd90321m9b463cb425fafe7d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020911230433q5fd90321m9b463cb425fafe7d@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pekka!

On Mon, 23 November 2009 14:33:15 +0200, Pekka Enberg wrote:
> 
> (Dunno who to CC, really, so lets see if I can trick Andrew or Hugh
> into looking at the issue.)

That would be nice.

> On Fri, Nov 20, 2009 at 9:38 PM, Joern Engel <joern@logfs.org> wrote:
> > +static void logfs_lock_write_page(struct page *page)
> > +{
> > +       int loop = 0;
> > +
> > +       while (unlikely(!trylock_page(page))) {
> > +               if (loop++ > 0x1000) {
> > +                       /* Has been observed once so far... */
> > +                       printk(KERN_ERR "stack at %p\n", &loop);
> > +                       BUG();
> > +               }
> > +               if (PagePreLocked(page)) {
> > +                       /* Holder of page lock is waiting for us, it
> > +                        * is safe to use this page. */
> > +                       break;
> > +               }
> > +               /* Some other process has this page locked and has
> > +                * nothing to do with us.  Wait for it to finish.
> > +                */
> > +               schedule();
> > +       }
> > +       BUG_ON(!PageLocked(page));
> > +}
> 
> What's the purpose of PagePreLocked()? The above function looks pretty
> fragile for a filesystem to me.

Avoiding deadlocks.  Garbage collection is the cause of almost all
headaches in logfs, including this.  Any write may require some amount
of garbage collection to free up some space.  Garbage collection
consists of basically random reads followed by random writes.  So in
order to write any page, it may be required to first read and write some
other inconvenient page.

Simple case:
	Thread A writes page 1, GC then reads/writes page 1.
More complicated:
	Thread A writes page 1, thread B writes page 2.
	Thread A gets the write lock, thread B blocks on write lock.
	Thread A does GC which reads/writes page 2.

The more complicated case requires that any thread holding the write
lock must be able to read/write any page belonging to this filesystem.
If those pages are locked by someone else, it should wait it out and
only use the page when the page lock is released.  But if the pages are
locked in a logfs write path, that would cause a deadlock.

So PagePreLocked(page) indicates that this page is in a logfs write
path.  It won't change until the current thread releases the logfs write
lock and is fair game for GC.

Jörn

-- 
The cheapest, fastest and most reliable components of a computer
system are those that aren't there.
-- Gordon Bell, DEC labratories
