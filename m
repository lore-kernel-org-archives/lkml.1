Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbXJLOIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbXJLOIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 10:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXJLOI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 10:08:26 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:40681 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbXJLOIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:08:24 -0400
Subject: Re: [PATCH 0/7] RT: (RFC) RT-Overload/Sched enhancements
From: Gregory Haskins <ghaskins@novell.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1192184985.27435.17.camel@twins>
References: <20071011213916.27097.42597.stgit@novell1.haskins.net>
	 <1192184985.27435.17.camel@twins>
Content-Type: text/plain
Date: Fri, 12 Oct 2007 10:05:56 -0400
Message-Id: <1192197956.4067.33.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-12 at 12:29 +0200, Peter Zijlstra wrote:

> I'm wondering why we need the cpu prio management stuff.

I know we covered most of this on IRC, but let me recap so everyone can
follow the thread:

1) The cpupri alg is just one search alg vs the other.  I think we are
all in agreement that it is not clear if one has an advantage over the
other without some empirical data.  So that aspect still remains to be
investigated.  For now, either can be interchanged as the main
functionality is what uses the search, not the search alg itself.

2) The patch series makes some innovations above the current state of
the push-rt patch, which I will try to summarize here for consideration:

	A) CPU Priority should be updated due to PI changes as well as
ctx-switch

	B) The search algorithm in the cpupri alg employs a priority amongst
eligible CPUs: last-run (for cache-affinity), this_cpu (for
lower-overhead preemption), and finally any other cpu in the
cpus_allowed.  It would be ideal to see the other alg provide similar
priority.

	C) The search and pusher functions are separated.  Search is useful in
circumstances outside the push_rt_task functions (see (D))

	D) The primary patch addresses one case where we need to redistribute
(high-pri preemption).  There are 3 in total.  The series adds support
for a second case (low-pri RT wakeup).

	E) We push until equilibrium instead of just a single task.

3) Having a distinct cpu-priority layer (regardless of search-arg) will
have (IMO) interesting potential going forward.  For instance, we could
have an optional notifier that gets kicked whenever we change
priority-class.  This would allow for some interesting RT related
enhancements by allowing system-level components to register for
priority changes.  For example: APIC TPR, or KVM hypercalls (for RT
guests, on an RT host).  This is more theoretical and half-baked at this
point, but it was something I have been kicking around.


That's all I can think of for now.

Regards,
-Greg

