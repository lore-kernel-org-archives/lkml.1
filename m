Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbYHAVXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbYHAVXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762326AbYHAVQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:16:50 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:46083 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760296AbYHAVQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:16:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH RT RFC 0/7] Priority Inheritance enhancements
To: mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       tglx@linutronix.de, rosted@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com
Date: Fri, 01 Aug 2008 15:16:47 -0600
Message-ID: <20080801210945.3469.1183.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

** RFC for PREEMPT_RT branch, 26-rt1 **

Hi All,

The following series applies to 26-rt1 as a request-for-comment on a 
new approach to priority-inheritance (PI), as well as some performance
enhancements to take advantage of those new approaches.  This yields at
least a 10-15% improvement for diskio on my 4-way x86_64 system.  An
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
rtmutex into its own library (libpi). This is covered in patches 1-6.

(I realize patch #6 is a little hard to review since I removed and added
a lot of code that the unified diff is all mashing together...I will try
to find a way to make this more readable).

Patch 7 is the first real consumer of the libpi logic to try to enhance
performance.  It accomplishes this by deferring pi-boosting a lock
owner unless it is absolutely necessary.  Since instrumentation
shows that the majority of locks are acquired either via the fast-path,
or via the adaptive-spin path, we can eliminate most of the pi-overhead
with this technique.  This yields a measurable performance gain (at least
10% for workloads with heavy lock contention was observed in our lab).

For your convenience, you can also find these patches in a git tree here:

git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.git pi-rework

We have not yet completed the work on the pi-waitqueues or any of the other
related pi enhancements.  Those will be coming in a follow-on announcement.

Feedback/comments welcome!

Regards,
-Greg

