Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0BAOIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:08:21 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:47822 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187Ab0BAOIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:08:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQEAORtZktGHnlj/2dsb2JhbACBM9duhEUE
Date: Mon, 1 Feb 2010 09:08:16 -0500
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
Message-ID: <20100201140816.GA10894@Krystal>
References: <20100131205254.407214951@polymtl.ca> <20100131210013.265317204@polymtl.ca> <20100201072506.GF9085@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100201072506.GF9085@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:02:30 up 46 days, 22:20,  4 users,  load average: 0.06, 0.27,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin (npiggin@suse.de) wrote:
> On Sun, Jan 31, 2010 at 03:52:55PM -0500, Mathieu Desnoyers wrote:
> > Create the primitive family:
> > 
> > spin_lock__no_acquire
> > spin_unlock__no_release
> > spin_lock_irq__no_acquire
> > spin_unlock_irq__no_release
> > 
> > raw_spin_lock__no_acquire
> > raw_spin_unlock__no_release
> > raw_spin_lock_irq__no_acquire
> > raw_spin_unlock_irq__no_release
> > 
> > smp_acquire__after_spin_lock()
> > smp_release__before_spin_unlock()
> > smp_mb__after_spin_lock()
> > smp_mb__before_spin_unlock()
> 
> Wow, someone who likes micro optimising things as much as I do.

:-)

> However, these have the wrong names.
> 
> smp_mb__after_x() means that calling that function after calling x()
> will give a smp_mb(), right?

Supposed to.

> 
> With your functions, this is giving a smp_mb() after calling
> x__no_acquire().

Good point.

> 
> I would suggest maybe just don't bother with the __no_acquire
> __no_release variants of spin locks, and stick with the expected
> semantics for the new smb_mb__xxx functions. x86 still gets the
> full benefit.

Well, most other architectures will get a gain by modifying the spin
lock/unlock itself and adding the full memory barriers separately. x86
is a special case here.

> 
> But, I don't know if this is even worthwhile, given where you are
> using it.

Given that it's used to modify the scheduler fast path, I try to keep it
as fast as possible.  But as you point out later in the thread, we might
just consider taking all the rq locks one after another when issuing a
sys_membarrier() instead. I did these modifications mostly to please
Peter who is concerned about the impact of taking these rq lock very
frequently in a DoS scenario (which you appropriately point out would
not be the first case in the kernel, and would actually generate a RoS
rather than DoS).

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
