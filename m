Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbZGCOGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbZGCOGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758466AbZGCOEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:04:04 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:58996 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758554AbZGCOEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:04:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoFAL+rTUpMQWU3/2dsb2JhbACBUcxIhBIFgTo
Date: Fri, 3 Jul 2009 10:04:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       jarkao2@gmail.com, oleg@redhat.com, davidel@xmailserver.org,
       eric.dumazet@gmail.com, Paul McKenney <Paul.McKenney@us.ibm.com>
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
Message-ID: <20090703140401.GA10256@Krystal>
References: <20090703081219.GE2902@jolsa.lab.eng.brq.redhat.com> <20090703081445.GG2902@jolsa.lab.eng.brq.redhat.com> <20090703090606.GA3902@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090703090606.GA3902@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:49:36 up 125 days, 10:15,  3 users,  load average: 0.12, 0.40,
	0.41
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > +++ b/arch/x86/include/asm/spinlock.h
> > @@ -302,4 +302,7 @@ static inline void __raw_write_unlock(raw_rwlock_t *rw)
> >  #define _raw_read_relax(lock)	cpu_relax()
> >  #define _raw_write_relax(lock)	cpu_relax()
> >  
> > +/* The {read|write|spin}_lock() on x86 are full memory barriers. */
> > +#define smp_mb__after_lock() do { } while (0)
> 

Hm. Looking at http://lkml.org/lkml/2009/6/23/192, a very basic question
comes to my mind :

Why don't we create a read_lock without acquire semantic instead (e.g.
read_lock_nomb(), or something with a better name like __read_lock()) ?
On architectures where memory barriers are needed to provide the acquire
semantic, it would be faster to do :

__read_lock();
smp_mb();

than :

read_lock(); <- e.g. lwsync + isync or something like that
smp_mb(); <- full sync.

Second point : __add_wait_queue/waitqueue_active/wake_up_interruptible
would probably benefit from adding comments about their combined use
with other checks and how nice memory barriers are.

Mathieu


> Two small stylistic comments, please make this an inline function:
> 
> static inline void smp_mb__after_lock(void) { }
> #define smp_mb__after_lock
> 
> (untested)
> 
> > +/* The lock does not imply full memory barrier. */
> > +#ifndef smp_mb__after_lock
> > +#define smp_mb__after_lock() smp_mb()
> > +#endif
> 
> ditto.
> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
