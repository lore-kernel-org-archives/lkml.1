Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZLMTET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZLMTET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 14:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbZLMTES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 14:04:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47713 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753845AbZLMTER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 14:04:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MnQmd1jlla7aWBdDIHHCirdBfXnzrQ+G/jvAiMzsJEPT5905+dyz0Qq0H26gGq1J84
         KMbYBV86SiBbyGqp8LklLk6nkewmKKzkmUz4dTKBthYnyVx8ZPqOA76xv+4/LopiKqWC
         IbqYUeBn6C348fcLNcaVac9lfEahUXTpNzJ58=
Date: Sun, 13 Dec 2009 20:04:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091213190410.GA7297@nowhere>
References: <20091212023603.93768833.akpm@linux-foundation.org> <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain> <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain> <20091212214235.31429790@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain> <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain> <alpine.LFD.2.00.0912121513190.3535@localhost.localdomain> <20091213065844.GA20244@elte.hu> <alpine.LFD.2.00.0912130941050.5516@localhost.localdomain> <20091213181726.GA14558@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091213181726.GA14558@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 07:17:26PM +0100, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Sun, 13 Dec 2009, Ingo Molnar wrote:
> > > 
> > > In the last ~4.5 years:
> > > 
> > >  earth4:~/tip> git checkout v2.6.12
> > >  Date:   Fri Jun 17 12:48:29 2005 -0700
> > >  earth4:~/tip> git grep -w unlock_kernel | wc -l
> > >  713
> > > 
> > >  earth4:~/tip> git checkout linus
> > >  Date:   Fri Dec 11 20:58:20 2009 -0800
> > >  earth4:~/tip> git grep -w unlock_kernel | wc -l
> > >  841
> > 
> > Git hint of the day: you don't need to check out a kernel to do "git 
> > grep".
> > 
> > Do this:
> > 
> > 	git grep -w unlock_kernel v2.6.12 | wc
> > 
> > and it will JustWork(tm).
> 
> /me adds it to the metal toolbox
> 
> > > Also, a lot of BKL use was hidden before, and due to the BKL removal 
> > > activities (by Thomas, Frederic, Jon, Alan and others) the remaining BKL using 
> > > sites are a lot more well defined, a lot more isolated and thus a lot more 
> > > removable than ever before.
> > 
> > That's the main thing. We've been pushing them down a lot.
> > 
> > We still have a few annoying core ones, though. I hate the execve() and file 
> > locking ones.
> 
> When we did the BKL-as-a-mutex trick and let lockdep loose on it, three areas 
> were particularly tricky: tty, reiser3 and NFS. tty and reiserfs should be ok 
> now, but i havent seen much activity on the NFS front.
> 
> 	Ingo


Nfs was a problem in the BKL-as-a-mutex tree because it is acquired
recursively and then locked up. And I suspect this recursion happens
only on mount time because vfs acquires it too there.

But looking at it more closely, it doesn't look that dramatic at
a first glance.

git-grep unlock_kernel fs/nfs

fs/nfs/callback.c:      unlock_kernel();
fs/nfs/callback.c:      unlock_kernel();

In nfs4_callback_svc() it embraces the socket
listening/processing callback thread.

svc_recv() might sleep so the bkl can be
lost in the middle.

And then svc_process().

This doesn't seem to protect anything there.

In nfs4_callback_svc() it's about the same thing, plus
a list manipulation but protected by a spinlock.


fs/nfs/delegation.c:            unlock_kernel();
fs/nfs/delegation.c:    unlock_kernel();
fs/nfs/nfs4state.c:             unlock_kernel();
fs/nfs/nfs4state.c:     unlock_kernel();



In the above cases we have the following comment:

/* Protect inode->i_flock using the BKL */

And really it doesn't seem to protect anything else,
fortunately it is acquired in a short path.


fs/nfs/super.c: unlock_kernel();
fs/nfs/super.c: unlock_kernel();

Protect the mount/unmount path, a bit trickier there.

But really that looks way much easier to fix than it was
with reiserfs.

