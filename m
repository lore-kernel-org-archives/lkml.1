Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0BAOPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:15:14 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:55507 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab0BAOPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:15:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQEANNuZktGHnlj/2dsb2JhbACBM9dygjmCDAQ
Date: Mon, 1 Feb 2010 09:10:10 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 1/3] Create spin lock/spin unlock with distinct memory
	barrier
Message-ID: <20100201141010.GB10894@Krystal>
References: <20100131205254.407214951@polymtl.ca> <20100131210013.265317204@polymtl.ca> <20100201072811.GG9085@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100201072811.GG9085@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:09:41 up 46 days, 22:28,  4 users,  load average: 0.74, 0.53,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin (npiggin@suse.de) wrote:
> On Sun, Jan 31, 2010 at 03:52:55PM -0500, Mathieu Desnoyers wrote:
> > +/*
> > + * X86 spinlock-mb mappings. Use standard spinlocks with acquire/release
> > + * semantics. Associated memory barriers are defined as no-ops, because the
> > + * spinlock LOCK-prefixed atomic operations imply a full memory barrier.
> > + */
> > +
> > +#define spin_lock__no_acquire			spin_lock
> > +#define spin_unlock__no_release			spin_unlock
> > +
> > +#define spin_lock_irq__no_acquire		spin_lock_irq
> > +#define spin_unlock_irq__no_release		spin_unlock_irq
> > +
> > +#define raw_spin_lock__no_acquire		raw_spin_lock
> > +#define raw_spin_unlock__no_release		raw_spin_unlock
> > +
> > +#define raw_spin_lock_irq__no_acquire		raw_spin_lock_irq
> > +#define raw_spin_unlock_irq__no_release		raw_spin_unlock_irq
> > +
> > +#define smp_acquire__after_spin_lock()		do { } while (0)
> > +#define smp_release__before_spin_unlock()	do { } while (0)
> > +
> > +#define smp_mb__after_spin_lock()		do { } while (0)
> > +#define smp_mb__before_spin_unlock()		do { } while (0)
> 
> Oh, and that one's wrong. loads can pass spin_unlock on x86 so it
> needs to be smp_mb().
> 

Good catch !

#if defined(CONFIG_X86_32) && \
        (defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE))
/*
 * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
 * (PPro errata 66, 92)
 */
# define UNLOCK_LOCK_PREFIX LOCK_PREFIX
#else
# define UNLOCK_LOCK_PREFIX
#endif

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
