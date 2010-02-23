Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0BWNUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 08:20:49 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:39368 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592Ab0BWNUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 08:20:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAP9hg0tGGOM5/2dsb2JhbACbCnSuIAiNXYJeCIIGBIMV
Date: Tue, 23 Feb 2010 08:15:44 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/21] v6 add lockdep-based diagnostics to
	rcu_dereference()
Message-ID: <20100223131543.GA19174@Krystal>
References: <20100223010435.GA666@linux.vnet.ibm.com> <201002231359.07910.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <201002231359.07910.arnd@arndb.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:08:59 up 68 days, 21:27,  5 users,  load average: 0.03, 0.14,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann (arnd@arndb.de) wrote:
> On Tuesday 23 February 2010, Paul E. McKenney wrote:
> > This patch series adds lockdep-based checking to the rcu_dereference()
> > primitive in order to flag misuses of RCU.
> 
> While I haven't looked much at this series, I've been thinking about
> adding static diagnostics for rcu_dereference misuse, in the form of
> an __rcu address space qualifier for pointers. Such a patch would
> obviously conflict with this series, so I'd wait for yours to go
> in first, but maybe you like the idea enough to do it yourself ;-).
> 
> The observation is that all accesses to an RCU protected pointer
> are either through rcu_dereference, rcu_assign_pointer or one of their
> variants. so it should be possible to add a new address space like we
> have for __iomem, __user and soon __percpu and have sparse check that
> we use RCU consistently on pointers that need it.

Just to make myself the devil's advocate: how should we consider
initialization of RCU pointers at boot time that happens before any
possible concurrent reader is allowed to run ? I think this case is an
example of valid RCU-pointer access that is not done through the RCU
primitives. It seems valid to perform these RCU-pointer accesses when
serialized by a different exclusion mechanism, in this case being the
guarantee that no concurrent reader are running at early boot. The same
applies to stop_machine(), and, as I come to think of it, we could
probably think of a scheme that dynamically switch from an RCU read-lock
to, e.g., a mutex for all users, wait for RCU quiescent state, and then
serialize all users on the mutex during the update. So while some of
these cases are a bit far-fetched, I think they are valid, and I wonder
how the address space validation would take them into account.

Thanks,

Mathieu

> 
> 	Arnd

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
