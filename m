Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbZBDXSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbZBDXSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbZBDXSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:18:46 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:51533 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZBDXSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:18:46 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 4 Feb 2009 15:18:43 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
In-Reply-To: <20090204150507.665b5b7c.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com> <20090204150507.665b5b7c.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Andrew Morton wrote:

> On Wed, 4 Feb 2009 14:58:39 -0800 (PST)
> Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > People started using eventfd in scnarios where before where using pipes. 
> > Many of them use eventfds in a semaphore-like way, like they were before 
> > with pipes. The problem with eventfd is that a read() on the fd returns 
> > and wipes the whole counter, making the use of it as semaphore a little 
> > bit more cumbersome. You can do a read() followed by a write() of 
> > COUNTER-1, but IMO it's pretty easy and cheap to make this work w/out 
> > extra steps. This patch introduces a new eventfd flag that tells eventfd 
> > to only dequeue 1 from the counter, allowing simple read/write to make it 
> > behave like a semaphore.
> 
> Would be nice to spell out what "a sempahore-like way" is.

Counter-based resource access? Where a "wait()" returns immediately by 
decrementing the counter by one, if counter is greater than zero. 
Otherwise will wait. And where a "post(count)" will add count to the 
counter releasing the appropriate amount of waiters.
If eventfd the "post" (write) part is fine, while the "wait" (read) does 
not dequeue 1, but the whole counter value.




> > Simple test here:
> > 
> > http://www.xmailserver.org/eventfd-sem.c
> > 
> > 
> > Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> > 
> > +/*
> > + * CAREFUL: Check include/asm-generic/fcntl.h when defining
> > + * new flags, since they might collide with O_* ones. We want
> > + * to re-use O_* flags that couldn't possibly have a meaning
> > + * from eventfd, in order to leave a free define-space for
> > + * shared O_* flags.
> > + */
> > +#define EFD_SEMAPHORE (1 << 0)
> >  #define EFD_CLOEXEC O_CLOEXEC
> >  #define EFD_NONBLOCK O_NONBLOCK
> >  
> > +#define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
> > +#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
> 
> How would you recommend that userspace determine whether its kernel
> supports this feature, bearing in mind that someone might backport this
> patch into arbitrarily earlier kernel versions?
> 
> What should be userspace's fallback strategy if that support is not
> present?

#ifdef EFD_SEMAPHORE, maybe?



- Davide


