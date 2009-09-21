Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbZIUUKC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbZIUUKC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 16:10:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbZIUUKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 16:10:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753851AbZIUUKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 16:10:00 -0400
Date: Mon, 21 Sep 2009 13:09:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: kilroyd@googlemail.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] spinlocks: check spinlock_t/rwlock_t argument type
 on non-SMP builds
Message-Id: <20090921130941.e68c4bdb.akpm@linux-foundation.org>
In-Reply-To: <20090921074352.GA22122@elte.hu>
References: <200909181957.n8IJv94X001996@imap1.linux-foundation.org>
	<20090921074352.GA22122@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 09:43:52 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> 
> > From: David Kilroy <kilroyd@googlemail.com>
> > 
> > When writing code for UP without CONFIG_DEBUG_SPINLOCK it's easy to get
> > the first argument to the spinlock/rwlock functions wrong.  This is
> > because the parameter is not actually used in this configuration.
> > 
> > Typically you will only find out it's wrong
> >  * by rebuilding with CONFIG_SMP or CONFIG_DEBUG_SPINLOCK
> >  * after you've submitted your beautiful patch series.
> > 
> > The first means a long wait, and the latter is a bit late.
> > 
> > Change the intermediate macros into inline functions.
> > 
> > Signed-off-by: David Kilroy <kilroyd@googlemail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  include/linux/spinlock.h        |    6 -
> >  include/linux/spinlock_api_up.h |  118 ++++++++++++++++++++++--------
> >  2 files changed, 92 insertions(+), 32 deletions(-)
> > 
> > diff -puN include/linux/spinlock.h~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds include/linux/spinlock.h
> > --- a/include/linux/spinlock.h~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds
> > +++ a/include/linux/spinlock.h
> > @@ -240,17 +240,17 @@ static inline void smp_mb__after_lock(vo
> >  #define spin_lock_irqsave(lock, flags)			\
> >  	do {						\
> >  		typecheck(unsigned long, flags);	\
> > -		_spin_lock_irqsave(lock, flags);	\
> > +		_spin_lock_irqsave(lock, &flags);	\
> >  	} while (0)
> >  #define read_lock_irqsave(lock, flags)			\
> >  	do {						\
> >  		typecheck(unsigned long, flags);	\
> > -		_read_lock_irqsave(lock, flags);	\
> > +		_read_lock_irqsave(lock, &flags);	\
> >  	} while (0)
> 
> these bits broke the Alpha build:
> 
> /home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 't2_readb':
> /home/mingo/tip/arch/alpha/include/asm/core_t2.h:451: error: '_spin_lock_irqsave' is static but used in inline function 't2_readb' which is not static

hm.  What the heck does that mean?

__EXTERN_INLINE u8 t2_readb(const volatile void __iomem *xaddr)

Something to do with the extern-inline?


Do you have the .config?  My alpha builds went OK.



