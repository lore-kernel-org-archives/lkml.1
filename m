Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbZCSVpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbZCSVpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbZCSVpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:45:30 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60001 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756697AbZCSVp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:45:29 -0400
Message-ID: <49C2BCF4.50908@us.ibm.com>
Date: Thu, 19 Mar 2009 14:45:24 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: check *uaddr==val after queueing - without faulting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current futex_wait() code (I'm looking at tip/core/futexes)
conflicts with a warning in the comments about checking *uaddr==val
before the futex_q is queued on the hb list.  While userspace is able to
alter *uaddr at will and should expect to hang in the kernel forever
should it do so haphazardly, there are legitimate scenarios where the
futex value might change between the call to futex_wait() and when the
futex_q gets on the hb list.

For example, glibc protects access to the value of cond.__data.__futex
via the cond.__data.__lock.  However, before it can issue the syscall it
has to drop the cond.__data.__lock, leaving a small race window where
userspace might issue a signal or broadcast, which will modify the value
of cond.__data.__futex.  As I understand it, this will result in the
waiter having changed the value of the futex prior to entering the
kernel, but not enqueuing itself on the hb list until after the waiter
issues the broadcast that was intended to wake it up.

I was working up a patch to move the test to after the call to
queue_me(), but in order to do the test we also have to perform the
get_user() after the queue_me(), which might sleep if we still hold the
hb->lock.  If we let queue_me() drop the hb->lock before we call
get_user() then we may see a legitimate change in *uaddr that occured
after the queue_me() and before the get_user().

I'm at a loss for how to resolve the race without causing the false
positive inside the kernel.  It might be resolvable in glibc by looking
at the return code from futex_requeue and checking if the number 
woken_or_requeued agrees with the number it expected to be sleeping; 
this likely leaves other gaps for other waking calls, like FUTEX_WAKE.

Any thoughts?  Am I missing something that guards against this race?

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
