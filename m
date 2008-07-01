Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbYGAMq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbYGAMq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYGAMqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:46:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:34959 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbYGAMqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:46:18 -0400
Subject: Delayed interrupt work, thread pools
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: ksummit-2008-discuss@lists.linux-foundation.org
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 22:45:35 +1000
Message-Id: <1214916335.20711.141.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's something that's been running in the back of my mind for some
time that could be a good topic of discussion at KS.

In various areas (I'll come up with some examples later), kernel code
such as drivers want to defer some processing to "task level", for
various reasons such as locking (taking mutexes), memory allocation,
interrupt latency, or simply doing things that may take more time than
is reasonable to do at interrupt time or do things that may block.

Currently, the main mechanism we provide to do that is workqueues. They
somewhat solve the problem, but at the same time, somewhat can make it
worse.

The problem is that delaying a potentially long/sleeping task to a work
queue will have the effect of delaying everything else waiting on that
work queue.

The ability to have per-cpu work queues helps in areas where the problem
scope is mostly per-cpu, but doesn't necessarily cover the case where
the problem scope depends on the driver's activity, not necessarily tied
to one CPU.

Let's take some examples: The main one (which triggers my email) is
spufs, ie, the management of the SPU "co-processors" on the cell
processor, though the same thing mostly applies to any similar
co-processor architecture that would require the need to service page
faults to access user memory.

In this case, various contexts running on the device may want to service
long operations (ie. handle_mm_fault in this case), but using the main
work queue or even a dedicated per-cpu one will cause a context to
potentially hog other contexts or other drivers trying to do the same
while the first one is blocked in the page fault code waiting for IOs...

The basic interface that such drivers want it still about the same as
workqueues tho: "call that function at task level as soon as possible".

Thus the idea of turning workqueues into some kind of pool of threads. 

At a given point in time, if none are available (idle) and work stacks
up, the kernel can allocate a new bunch and dispatch more work. Of
course, we would have to find tune what the actual algorithm is to
decide whether to allocate new threads or just wait / throttle for
current delayed work to complete. But I believe the basic premise still
stand.

So what about we allocate a "pool" of task structs, initially blocked,
ready to service jobs dispatched from interrupt time, with some
mechanism, possibly based on the existing base work queue, that can
allocate more if too much work stacks up or (via some scheduler
feedback) too many of the current ones are blocked (ie. waiting for IOs
for example).

For the specific SPU management issue we've been thinking about, we
could just implement an ad-hoc mechanism locally, but it occurs to me
that maybe this is a more generic problem and thus some kind of
extension to workqueues would be a good idea here.

Any comments ?

Cheers,
Ben.
 

