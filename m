Return-Path: <linux-kernel-owner+w=401wt.eu-S932909AbZGPRyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909AbZGPRyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932879AbZGPRyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:54:22 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:41569 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864AbZGPRyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:54:22 -0400
Message-ID: <4A5F6948.5010107@ece.cmu.edu>
Date: Thu, 16 Jul 2009 13:54:16 -0400
From: Raj Rajkumar <raj@ece.cmu.edu>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Raj Rajkumar <raj@ece.cmu.edu>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.5.5.374460, Antispam-Engine: 2.7.1.369594, Antispam-Data: 2009.7.16.174216
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_5000_5999 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __BOUNCE_CHALLENGE_SUBJ 0, __C230066_P1_5 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jim, Ted and others:

Let me first introduce myself.  I work on real-time systems at Carnegie 
Mellon Univ and am one of the authors on the papers that introduced the 
priority inheritance and priority ceiling protocols, and some of their 
follow-ons.  I was also a co-founder of TimeSys in 1996.  My PhD 
student, Karthik Lakshmanan, and an SEI Sr. Staff Member, Dr. Dionisio 
de Niz, and I have begun to revisit multiprocessor scheduling and 
synchronization thanks in part to the surging interest in multicore 
processors.

I just came to know about this message thread.  I hope, as Jim did, that 
I can add something to the ongoing discussion - if not, please bear with me.

First of all, let me agree completely with Jim that simplicity goes a 
very long way.  Two relevant examples follow.   First, fixed-priority 
scheduling has dominated most real-time systems over dynamic-priority 
scheduling) since (a) the practical performance differences are not 
significant (b) overheads are lower and (c) perhaps above all, less 
information is required.  Secondly, priority ceiling/ceiling emulation 
protocols have much better properties than basic priority inheritance 
protocols but the latter are more widely used.  The reason appears to be 
that PCP requires additional information which can also change at 
run-time.   Overall, simplicity does win.   

Secondly, let me fully agree with Ted in that Linux-RT extensions should 
support bandwidth control & isolation.   My group's work on "reserves" 
and "resource kernels" looked at isolating both temporal and spatial 
resources (please see 
http://www.ece.cmu.edu/~raj/publications.html#ResourceKernels) in the 
context of Linux.  Karthik's work extended Linux/RK to distributed 
systems (Distributed Linux/RK).

Thirdly, I also agree with Jim that non-preemptive locking and FIFO 
queueing are fine for mutexes in the kernel.  The primary reason is that 
critical sections in the kernel are written by experts and tend to be 
short.  And as it turns out, this is exactly how Linux SMP support has 
been for quite a few years.  

It looks to me like Jim and Bjoern name the kernel-mutex locking scheme 
(of non-preemption and FIFO queueing) as FMLP and advocate it for 
user-level mutexes.  Jim: Please correct me if my interpretation is 
incorrect.

I would like to propose a solution with 2 components.  First, priority 
inheritance protocols not just prevent (potentially) unbounded priority 
inversion but offer less blocking for higher-priority tasks with 
typically tighter timing constraints.   It is also well known that 
non-preemptive execution is an extreme/simplified form of the priority 
ceiling protocol, where every task is assumed to access every shared 
resource/mutex and hence every priority ceiling is the highest priority 
in the system.    There are cases when this is fine (e.g. when all 
critical sections are *relatively* small as in the Linux kernel) and 
there are cases when this is not (e.g. when some user-level critical 
sections accessed only by lower-criticality tasks are *relatively* long 
compared to the timing constraints of higher priority tasks.

Component 1: Let a priority ceiling be associated with each user-level 
mutex.   When the mutex is locked, the corresponding critical section is 
executed at the priority ceiling value.   The developer can choose this 
to be the highest priority in the system in which case it becomes a 
non-preemptive critical section.    In addition, we could allow mutexes 
to either pick basic priority inheritance (desirable for local mutexes?) 
or the priority ceiling version (desirable for global mutexes shared 
across processors/cores).

Component 2: The queueing discipline for tasks pending on locked mutexes 
is the second policy under discussion.   Jim argues that it should be 
FIFO.  Imagine a bunch of lower-priority tasks stuck in front of a 
higher-priority task, and the "priority inversion" time can be 
considerable.  (Some including me would argue that it goes against the 
grain of using priority-based scheduling for real-time systems in the 
first place.  Why not just use FIFO scheduling?).    However, a 
practical compromise is easy to reach as well.  Let the queueing policy 
(FIFO or priority-based) on mutexes be an option.  FIFO for a "local" 
mutex would not be very helpful.  And priority-queueing for a "global" 
mutex would help tasks with tight timing constraints.

Proposal Summary

   1. Associate a priority ceiling (priority at which critical sections 
are executed) with each (global) mutex.   A macro HIGHEST_CEILING could 
represent a value that is higher than any other application-level priority.
   2. Allow the developer to specify the queueing discipline on a 
(global) mutex.   MUTEX_FIFO_QUEUEING and MUTEX_PRIORITY_QUEUEING are 
allowed options.

I would appreciate any comments.   Thanks for reading through a lot (if 
you reached this far :-)

---
Raj
http://www.ece.cmu.edu/~raj


P.S.  Some relevant references from a couple of decades back.

[1] Rajkumar, R., "Real-Time Synchronization Protocols for Shared Memory 
Multiprocessors". The Tenth International Conference on Distributed 
Computing Systems, 1990.
[2] Rajkumar, R., Sha, L., and Lehoczky J.P. "Real-Time Synchronization 
Protocols for Multiprocessors". Proceedings of the
IEEE Real-Time Systems Symposium, December 1988, pp. 259-269.

Global locking is costly - global critical sections could be moved to a 
"global synchronization processor" (and is described in one of the 
articles above).

