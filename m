Return-Path: <linux-kernel-owner+w=401wt.eu-S933944AbYEUH41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944AbYEUH41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 03:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757403AbYEUH4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 03:56:19 -0400
Received: from ozlabs.org ([203.10.76.45]:42766 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267AbYEUH4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 03:56:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Introduce down_nowait()
Date: Wed, 21 May 2008 17:56:04 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>
References: <200805211600.16415.rusty@rustcorp.com.au> <20080520232903.6756b1c1.akpm@linux-foundation.org>
In-Reply-To: <20080520232903.6756b1c1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805211756.04731.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2008 16:29:03 Andrew Morton wrote:
> On Wed, 21 May 2008 16:00:15 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Andrew suggested introducing "down_nowait" as a wrapper now, to make
> > the transition easier.
> > ...
> > +/**
> > + * down_nowait - try to down a semaphore, but don't block
> > + * @sem: the semaphore
> > + *
>
> Actually, I don't thing down_nowait() is a terribly good name, because it
> doesn't tell the reader anything about what to expect from the return
> value.  Does a non-zero return mean that down_wait() acquired the lock,
> or does it not?  Something like down_try() would be better, because if
> it returns 1 we can say "ah, the trying succeeded".'

I agree: that was my first name.  Christoph hated it.

> Except "down_nowait" doesn't have "try" in its name.  down_try() would
> be better?

What a great name!  You're a genius!

Subject: [PATCH] Introduce down_try()

I planned on removing the much-disliked down_trylock() (with its
backwards return codes) in 2.6.27, but it's creating something of a
logjam with other patches in -mm and linux-next.

Andrew suggested introducing "down_try" as a wrapper now, to make
the transition easier.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>

diff -r 92664ae4130b include/linux/semaphore.h
--- a/include/linux/semaphore.h	Wed May 21 14:54:40 2008 +1000
+++ b/include/linux/semaphore.h	Wed May 21 15:07:31 2008 +1000
@@ -48,4 +48,18 @@ extern int __must_check down_timeout(str
 extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
 extern void up(struct semaphore *sem);
 
+/**
+ * down_try - try to down a semaphore, but don't block
+ * @sem: the semaphore
+ *
+ * This is equivalent to down_trylock(), but has the same return codes as
+ * spin_trylock and mutex_trylock: 1 if semaphore acquired, 0 if not.
+ *
+ * down_trylock() with its confusing return codes will be deprecated
+ * soon.  It will not be missed.
+ */
+static inline int __must_check down_try(struct semaphore *sem)
+{
+        return !down_trylock(sem);
+}
 #endif /* __LINUX_SEMAPHORE_H */



