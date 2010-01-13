Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897Ab0AMBZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab0AMBZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221Ab0AMBZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:25:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859Ab0AMBZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:25:04 -0500
Date: Tue, 12 Jan 2010 17:24:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86: avoid read-cycle on down_read_trylock
In-Reply-To: <alpine.LFD.2.00.1001121659220.17145@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001121708100.17145@localhost.localdomain>
References: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain> <4B4D1865.5000107@zytor.com> <alpine.LFD.2.00.1001121659220.17145@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We don't want to start the lock sequence with a plain read, since that 
will cause the cacheline to be initially brought in as a shared line, only 
to then immediately afterwards need to be turned into an exclusive one.

So in order to avoid unnecessary bus traffic, just start off assuming
that the lock is unlocked, which is the common case anyway.  That way,
the first access to the lock will be the actual locked cycle.

This speeds up the lock ping-pong case, since it now has fewer bus cycles.

The reason down_read_trylock() is so important is that the main rwsem 
usage is mmap_sem, and the page fault case - which is the most common case 
by far - takes it with a "down_read_trylock()". That, in turn, is because 
in case it is locked we want to do the exception table lookup (so that we 
get a nice oops rather than a deadlock if we happen to get a page fault 
while holding the mmap lock for writing).

So why "trylock" is normally not a very common operation, for rwsems it 
ends up being the _normal_ way to get the lock.

Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

This is on top of Peter's cleanup of my asm-cleanup patch.

On Hiroyuki-san's load, this trivial change improved his (admittedly 
_very_ artificial) page-fault benchmark by about 2%. The profile hit of 
down_read_trylock() went from 9.08% down to 7.73%. So the trylock itself 
seems to have improved by 15%+ from this.

All numbers above are meaningless, but the point is that the effect of 
this cacheline access pattern can be real.

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 4136200..e9480be 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -123,7 +123,6 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
 	__s32 result, tmp;
 	asm volatile("# beginning __down_read_trylock\n\t"
-		     "  mov          %0,%1\n\t"
 		     "1:\n\t"
 		     "  mov          %1,%2\n\t"
 		     "  add          %3,%2\n\t"
@@ -133,7 +132,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 		     "2:\n\t"
 		     "# ending __down_read_trylock\n\t"
 		     : "+m" (sem->count), "=&a" (result), "=&r" (tmp)
-		     : "i" (RWSEM_ACTIVE_READ_BIAS)
+		     : "i" (RWSEM_ACTIVE_READ_BIAS), "1" (RWSEM_UNLOCKED_VALUE)
 		     : "memory", "cc");
 	return result >= 0 ? 1 : 0;
 }
