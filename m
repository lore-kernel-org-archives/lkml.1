Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZLMTUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZLMTUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 14:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZLMTUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 14:20:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33753 "HELO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753988AbZLMTUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 14:20:42 -0500
Date: Sun, 13 Dec 2009 11:19:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
In-Reply-To: <1260731354.2612.14.camel@localhost>
Message-ID: <alpine.LFD.2.00.0912131116360.13952@localhost.localdomain>
References: <20091212023603.93768833.akpm@linux-foundation.org>  <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>  <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain>  <20091212214235.31429790@lxorguk.ukuu.org.uk> 
 <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain>  <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain>  <alpine.LFD.2.00.0912121513190.3535@localhost.localdomain>  <20091213065844.GA20244@elte.hu>  <alpine.LFD.2.00.0912130941050.5516@localhost.localdomain>
  <20091213181726.GA14558@elte.hu>  <20091213190410.GA7297@nowhere> <1260731354.2612.14.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Dec 2009, Trond Myklebust wrote:

> On Sun, 2009-12-13 at 20:04 +0100, Frederic Weisbecker wrote: 
> > In the above cases we have the following comment:
> > 
> > /* Protect inode->i_flock using the BKL */
> > 
> > And really it doesn't seem to protect anything else,
> > fortunately it is acquired in a short path.
> 
> As I said in my reply, this is the tough one, because the BKL protection
> is imposed by the VFS locking scheme used in fs/locks.c.
> 
> There is a similar dependency imposed upon fs/lockd/

Note that since NFS seems to be the only one who really cares, I think the 
appropriate course of action is to just replace the BKL - preferably with 
a spinlock that you just drop before you do anything that blocks.

Not only does the BKL already do that (so the locking doesn't change), but 
I think most _users_ of the BKL actually already do the explicit dropping 
of the lock (rather than the implicit one done by schedule()) because it's 
already been a scalability issue and we've had some history of trying 
alternative approaches that didn't do that whole auto-dropping anyway 
(whether those alternate approaches be semaphores or spinlocks).

So don't worry about the "imposed by the VFS" thing. I think you can 
fairly easily change the VFS side. 

			Linus
