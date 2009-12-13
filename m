Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZLMUEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZLMUEh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 15:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZLMUEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 15:04:36 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:45078 "HELO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754064AbZLMUEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 15:04:35 -0500
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0912131116360.13952@localhost.localdomain>
References: <20091212023603.93768833.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
	 <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain>
	 <20091212214235.31429790@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain>
	 <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain>
	 <alpine.LFD.2.00.0912121513190.3535@localhost.localdomain>
	 <20091213065844.GA20244@elte.hu>
	 <alpine.LFD.2.00.0912130941050.5516@localhost.localdomain>
	 <20091213181726.GA14558@elte.hu>  <20091213190410.GA7297@nowhere>
	 <1260731354.2612.14.camel@localhost>
	 <alpine.LFD.2.00.0912131116360.13952@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Dec 2009 15:04:12 -0500
Message-Id: <1260734652.2612.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 9 msgs/h 1 sum rcpts/h 19 sum msgs/h 2 total rcpts 2040 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 6140DD4EE76378E3FC2B795A326D057E0960414A
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 41 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-13 at 11:19 -0800, Linus Torvalds wrote: 
> 
> On Sun, 13 Dec 2009, Trond Myklebust wrote:
> 
> > On Sun, 2009-12-13 at 20:04 +0100, Frederic Weisbecker wrote: 
> > > In the above cases we have the following comment:
> > > 
> > > /* Protect inode->i_flock using the BKL */
> > > 
> > > And really it doesn't seem to protect anything else,
> > > fortunately it is acquired in a short path.
> > 
> > As I said in my reply, this is the tough one, because the BKL protection
> > is imposed by the VFS locking scheme used in fs/locks.c.
> > 
> > There is a similar dependency imposed upon fs/lockd/
> 
> Note that since NFS seems to be the only one who really cares, I think the 
> appropriate course of action is to just replace the BKL - preferably with 
> a spinlock that you just drop before you do anything that blocks.
> 
> Not only does the BKL already do that (so the locking doesn't change), but 
> I think most _users_ of the BKL actually already do the explicit dropping 
> of the lock (rather than the implicit one done by schedule()) because it's 
> already been a scalability issue and we've had some history of trying 
> alternative approaches that didn't do that whole auto-dropping anyway 
> (whether those alternate approaches be semaphores or spinlocks).
> 
> So don't worry about the "imposed by the VFS" thing. I think you can 
> fairly easily change the VFS side. 

That comment applies to the NFSv4 code, which applies the BKL only
because we need to traverse the inode->i_flock list. There is no
recursive use of the BKL there, and we can trivially replace it with
whichever new lock that that is chosen to replace the BKL in fs/locks.c.

To fix the lockd module, we have to backport some of the lessons we
learned when writing the NFSv4 file locking code. It won't be a huge
job, but I'd feel uncomfortable if I were to do it in a hurry just in
order to meet the merge window deadline.

  Trond

