Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYHOMVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYHOMVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbYHOMTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:19:17 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:53214
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753399AbYHOMS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:18:56 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH RT RFC v2 0/8] Priority Inheritance enhancements
To: mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       tglx@linutronix.de, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com, David.Holmes@sun.com
Date: Fri, 15 Aug 2008 08:08:10 -0400
Message-ID: <20080815120722.24722.66516.stgit@dev.haskins.net>
In-Reply-To: <20080801210945.3469.1183.stgit@lsg.lsg.lab.novell.com>
References: <20080801210945.3469.1183.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

** RFC for PREEMPT_RT branch, 26-rt1 **

Synopsis: We gain a 13%+ IO improvement in the PREEMPT_RT kernel by
re-working some of the PI logic.

[
	pi-enhancements v2

	Changes since v1:

	*) Added proper reference counting to prevent tasks from
	   deleting while a node->update() is still in flight
	*) unified the RCU boost path
]


[
	fyi -> you can find this series at the following URLs in
	addition to this thread:

  		 http://git.kernel.org/?p=linux/kernel/git/ghaskins/linux-2.6-hacks.git;a=shortlog;h=pi-rework

  		 ftp://ftp.novell.com/dev/ghaskins/pi-rework-v2.tar.bz2

]

Hi All,

The following series applies to 26-rt1 as a request-for-comment on a 
new approach to priority-inheritance (PI), as well as some performance
enhancements to take advantage of those new approaches.  This yields at
least a 13-15% improvement for diskio on my 4-way x86_64 system.  An
8-way system saw as much as 700% improvement during early testing, but
I have not recently reconfirmed this number.

Motivation for series:

I have several ideas on things we can do to enhance and improve kernel
performance with respect to PREEMPT_RT

1) For instance, it would be nice to support priority queuing and
   (at least positional) inheritance in the wait-queue infrastructure.

2) Reducing overhead in the real-time locks (sleepable replacements for
   spinlock_t in PREEMPT_RT) to try to approach the minimal overhead
   if their non-rt equivalent.  We have determined via instrumentation
   that one area of major overhead is the pi-boost logic.

However, today the PI code is entwined in the rtmutex infrastructure,
yet we require more flexibility if we want to address (1) and (2)
above.  Therefore the first step is to separate the PI code away from
rtmutex into its own library (libpi). This is covered in patches 1-7.

(I realize patch #7 is a little hard to review since I removed and added
a lot of code that the unified diff is all mashing together...I will try
to find a way to make this more readable).

Patch 8 is the first real consumer of the libpi logic to try to enhance
performance.  It accomplishes this by deferring pi-boosting a lock
owner unless it is absolutely necessary.  Since instrumentation
shows that the majority of locks are acquired either via the fast-path,
or via the adaptive-spin path, we can eliminate most of the pi-overhead
with this technique.  This yields a measurable performance gain (at least
13% for workloads with heavy lock contention was observed in our lab).

We have not yet completed the work on the pi-waitqueues or any of the other
related pi enhancements.  Those will be coming in a follow-on announcement.

Feedback/comments welcome!

Regards,
-Greg


---

Gregory Haskins (8):
      rtmutex: pi-boost locks as late as possible
      rtmutex: convert rtmutexes to fully use the PI library
      rtmutex: use runtime init for rtmutexes
      RT: wrap the rt_rwlock "add reader" logic
      rtmutex: formally initialize the rt_mutex_waiters
      sched: rework task reference counting to work with the pi infrastructure
      sched: add the basic PI infrastructure to the task_struct
      add generalized priority-inheritance interface


 Documentation/libpi.txt   |   59 ++
 include/linux/pi.h        |  278 +++++++++++
 include/linux/rt_lock.h   |    2 
 include/linux/rtmutex.h   |   18 -
 include/linux/sched.h     |   57 +-
 include/linux/workqueue.h |    2 
 kernel/fork.c             |   35 +
 kernel/rcupreempt-boost.c |   25 -
 kernel/rtmutex-debug.c    |    4 
 kernel/rtmutex-tester.c   |    4 
 kernel/rtmutex.c          | 1091 ++++++++++++++++++---------------------------
 kernel/rtmutex_common.h   |   19 -
 kernel/rwlock_torture.c   |   32 -
 kernel/sched.c            |  209 ++++++---
 kernel/workqueue.c        |   39 +-
 lib/Makefile              |    3 
 lib/pi.c                  |  516 +++++++++++++++++++++
 17 files changed, 1543 insertions(+), 850 deletions(-)
 create mode 100644 Documentation/libpi.txt
 create mode 100644 include/linux/pi.h
 create mode 100644 lib/pi.c



