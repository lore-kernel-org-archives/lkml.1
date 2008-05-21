Return-Path: <linux-kernel-owner+w=401wt.eu-S934142AbYEUG3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142AbYEUG3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbYEUG3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:29:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbYEUG3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:29:22 -0400
Date: Tue, 20 May 2008 23:29:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Introduce down_nowait()
Message-Id: <20080520232903.6756b1c1.akpm@linux-foundation.org>
In-Reply-To: <200805211600.16415.rusty@rustcorp.com.au>
References: <200805211600.16415.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 16:00:15 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> I planned on removing the much-disliked down_trylock() (with its
> backwards return codes) in 2.6.27, but it's creating something of a
> logjam with other patches in -mm and linux-next.
> 
> Andrew suggested introducing "down_nowait" as a wrapper now, to make
> the transition easier.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> diff -r 92664ae4130b include/linux/semaphore.h
> --- a/include/linux/semaphore.h	Wed May 21 14:54:40 2008 +1000
> +++ b/include/linux/semaphore.h	Wed May 21 15:07:31 2008 +1000
> @@ -48,4 +48,18 @@ extern int __must_check down_timeout(str
>  extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
>  extern void up(struct semaphore *sem);
>  
> +/**
> + * down_nowait - try to down a semaphore, but don't block
> + * @sem: the semaphore
> + *
> + * This is equivalent to down_trylock(), but has the same return codes as
> + * spin_trylock and mutex_trylock: 1 if semaphore acquired, 0 if not.
> + *
> + * down_trylock() with its confusing return codes will be deprecated
> + * soon.  It will not be missed.
> + */
> +static inline int __must_check down_nowait(struct semaphore *sem)
> +{
> +        return !down_trylock(sem);
> +}
>  #endif /* __LINUX_SEMAPHORE_H */

Actually, I don't thing down_nowait() is a terribly good name, because it
doesn't tell the reader anything about what to expect from the return
value.  Does a non-zero return mean that down_wait() acquired the lock,
or does it not?  Something like down_try() would be better, because if
it returns 1 we can say "ah, the trying succeeded".

otoh if all the kernel's "try" functions now return true on successful
acquisition then there won't be any confusion any more so the name
problably doesn't matter.

Except "down_nowait" doesn't have "try" in its name.  down_try() would
be better?

