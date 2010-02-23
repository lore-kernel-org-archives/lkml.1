Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab0BWPy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:54:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0BWPyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:54:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH tip/core/rcu 0/21] v6 add lockdep-based diagnostics to rcu_dereference()
Date: Tue, 23 Feb 2010 16:54:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
References: <20100223010435.GA666@linux.vnet.ibm.com> <201002231359.07910.arnd@arndb.de> <20100223131543.GA19174@Krystal>
In-Reply-To: <20100223131543.GA19174@Krystal>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002231654.09724.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18lZu7y4Xr8kPQh7sSMhuchNJHrWq35KXnzkCB
 UkyYMfuQKkK8DYwFW0jLR1kKz0frMYiyMOm1JQuyvIoDdhV1CD
 8uPUTcbjqPUk+p7Un+29A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 February 2010, Mathieu Desnoyers wrote:
> Just to make myself the devil's advocate: how should we consider
> initialization of RCU pointers at boot time that happens before any
> possible concurrent reader is allowed to run ? I think this case is an
> example of valid RCU-pointer access that is not done through the RCU
> primitives. It seems valid to perform these RCU-pointer accesses when
> serialized by a different exclusion mechanism, in this case being the
> guarantee that no concurrent reader are running at early boot.

Like the annotations adding __rcu to each rcu protected pointer, we'd
also have to add annotations to static initialization of those. E.g.
something like 

#define DEFINE_RCU_VAR(type, name, pointer) \
	type __rcu *name = (__force type)pointer

should do for simple initializations, and I guess I can come up
with similar solutions if we need something more fancy.

> The same applies to stop_machine(), and, as I come to think of it, we could
> probably think of a scheme that dynamically switch from an RCU read-lock
> to, e.g., a mutex for all users, wait for RCU quiescent state, and then
> serialize all users on the mutex during the update. So while some of
> these cases are a bit far-fetched, I think they are valid, and I wonder
> how the address space validation would take them into account.

I assume that it's never wrong to do a pointer assignment using
rcu_assign_pointer, or to do a dereference using rcu_dereference,
even if you hold a mutex or stop_machine. I would also guess that
the performance impact of doing so is not measurable. If both are
true for all corner cases, we could just use the rcu primitives
for any access on those variables for consistency reasons.

If there are cases where it does not work, we need to come up with
names for new primitives that just do the assignment or dereference
with __force but no actual synchronization.

	Arnd
