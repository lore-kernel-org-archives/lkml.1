Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbXA2OxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbXA2OxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 09:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXA2OxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 09:53:08 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:50086 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbXA2OxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 09:53:06 -0500
Date: Mon, 29 Jan 2007 17:52:28 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: libc-hacker@sources.redhat.com, libc-alpha@sources.redhat.com
Subject: [ANN] Userspace M-on-N threading model implementation. Alpha release.
Message-ID: <20070129145227.GA10524@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Mon, 29 Jan 2007 17:52:32 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline

Hello.

I'm pleased to announce initial userspace M-on-N threading model
implementation (for hackers) called NTL. 
This is first alpha release, which indeed has bugs and limitations.

Userspace M-on-N threading model is based on the idea, that when signal
is delivered, kernel saves all information related to previous context
in stack, so it is possible to find it and replace.

M-on-N threading model compared to usual NPTL 1-on-1 model has following
advantages and disadvantages:

Benefits. 

1. Fast scheduling. 
There is no need to cross userspace/kernelspace boundary to schedule new 
thread execution (just watch what happens with userspace network stack 
compared to kernel's one when there are a lot of syscalls performed for 
small packets receiving/sending).

2. Fast thread creation and destruction.
It just becomes an allocation of the structure in the userspace, no need
for full creation process which is performed in clone() syscall.

3. Smaller number of cache misses.
Since there is only one process instead of several threads, cache
locality is increased greatly with reduced number of misses.

Drawbacks.

1. Scheduling fairness.
Since kernel does not know about multiple threads behind given process,
it can not add it appropriate number of timeslices for execution.
Can be solved either by more tight collaboarion of the userspace and
kernelspace schedulers or simply by increasing process' nice value.

2. All communications are performed through one kevent pipe. (TODO)
All syscalls are going to be converted into non-blocking operations
(including nanosleep() and the like), and keep a track of what each
context performed. In practice glibc rewrite is not what I would like to
do, but instead some layer on top of it will be implemented, which will
convert syscalls into kevent operations, and become a rescheduling
point.

3. Complex code for good SMP scalability and userspace scheduler.
Not a problem. (TESTING)

SMP scalability in M-on-N threading model.

Since only kernel can schedule thread (actually not even thread or
process, but its own kernel's representation, so called kernel's virtual
process) to run on specified CPU, M-on-N threading model should have
several real threads (for example several current POSIX threads), its
number should be equal to number of real CPUs, and then library layer
will schedule execution of context of different real threads, each of
which in turn can run on separate CPU.

So, userspace will create new real threads when pthread_create() is
called until number of them is less than number of real CPUs, each real
thread in turn is a context in the global set of contexts, where fake
context will be added with all subsequent pthread_create() calls, and
userspace scheduler (backed by real threads) will pick up several
contexts from the tree and execute them on the real CPUs.

I would be possible to use existing Linux clone() syscall, but due to
complete absence of hte documentation (which is sometimes plain wrong)
and ery strong encryption of glibc sources it is quite complex task.

As NPTL, M-on-N threading library uses stack rlimit for thread stack
allocation.

Benchmarks.

I only ran simple benchmark of empty thread creation (its function just
exits).
After I started to use atomic locks ("lock" prefix on x86) instead of
semaphores, thread start/empty exec/stop was reduced down to 0.3
microseconds compared to 14 microsecods for POSIX NPTL case.

But there are problems.
First one is that I perform initial context setup through signal
invokation, which is at least two syscalls. They are slow.
Another one is that thread is really started only after rescheduling,
which is another signal, so another two syscalls.
Third on is that there must exist different locking primitives - for
signal context and for process context, which must block signals, which
in turn adds additional overhead of sigprocmask() syscall.

After I fixed all above issues (actually not fixed, but confirmed that
they must exist), performance reduced to 9 microseconds compared to 14
microsecods for POSIX NPTL case for empty thread creation/destruction.

(Test machine is Core Duo 2.4 Ghz (run at 3.7) with 2 GB of ram).

This can be fixed, if I would have created arch-specific
getcontext()-like calls, which would be mutually transformable into
signal context information (existing getcontext() and friends produces
different data than signal context has at least on x86). But I can not
right now, since I do not know enough x86 ABI (I learned a lot for past
several days, as you can notice from this blog, but it is still even
remotely not enough).

Currently M-on-N threading model uses ugly arch-specific hacks to start
new threads, which actually are something remotely similar to
makecontext().
So, the solution, which will rock M-on-N threading implementation is to
convert or create getcontext() and friends calls which can be used with
signal context information.

Another limitations are:
* x86 only (I do not have different test boxes to learn different asm)
* does not work if compiled with position-independent code support
* does not work if some functions are inlined (so -fno-inline flag)
* no support for run-time syscall substitution (to make it rescheduling
  point) yet
* looks like a real hack

Advantages:
* it is faster (noticebly faster)
* it is simpler
* code is not encrypted like in glibc sources

Sources and developement comments can be downloaded from NTL homepage at
http://tservice.net.ru/~s0mbre/old/?section=projects&item=threading

Archive is also attached for interested reader.

Thank you.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

-- 
	Evgeniy Polyakov

--uAKRQypu60I7Lcqm
Content-Type: application/x-tar-gz
Content-Disposition: attachment; filename="threading-2007_01_29.tar.gz"
Content-Transfer-Encoding: base64

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

--uAKRQypu60I7Lcqm--
