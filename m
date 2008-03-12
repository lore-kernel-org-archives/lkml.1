Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYCLWRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYCLWRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYCLWRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:17:07 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:62240 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137AbYCLWRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:17:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhcFAP/y10dMQWoK/2dsb2JhbACBWaY1
Date: Wed, 12 Mar 2008 18:17:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Implement slub fastpath with sequence number
Message-ID: <20080312221703.GA25625@Krystal>
References: <20080311093144.GB30220@Krystal> <1205246043.8514.188.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1205246043.8514.188.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:46:28 up 12 days, 17:57,  8 users,  load average: 0.72, 0.70,
	0.62
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2008-03-11 at 05:31 -0400, Mathieu Desnoyers wrote:
> > Here is a new version that works. tested on x86. tweaked the bitmasks
> > into unions to remove operations from the critical path, but I tried to
> > keep that clean. It applies on vm.git HEAD.
> > 
> > It allows the cmpxchg_local to detect object re-use by keeping a counter in the
> > freeoffset MSBs.
> > 
> > Whenever an object is freed in the cpu slab cache, the counter is incremented.
> > Whenever the alloc/free slow paths are modifying the offset or freebase, the
> > sequence counter is also incremented. It is used to make sure we know if
> > freebase has been modified in an interrupt nested over the fast path.
> 
> Is it (remotely) possible that the version will wrap giving the false
> impression that nothing has changed and thus falsely proceed with a
> wrong object?
> 

If we have exactly, on a 32 bits arch, 65536 memory alloc or free in the
slab we are dealing with done in interrupt and softirqs nested over the
cmpxchg_local loop, without ever giving the control back to check the
value, and that after we get the control back the offset within the slab
is exactly the same, then, yes, it's possible. In that case, we would
think it's ok to proceed with the object and we would have memory
corruption (object used twice or free object list corruption).

Given that the alloc fast path takes about 115 cycles on a 3GHz Pentium
4 for an alloc/free pair (65536 * 38.33ns = 2.5ms total), having this
scenario would mean that every other interrupt would not have been
serviced for 2.5ms. In that case, we would probably have other problems
to deal with. On 64 bits architectures, with 2^32 bits, we would have to
wait for about 160 seconds (approx.).

This is why I added a check to verify if the sequence number delta is
bigger than half of the number of bits we have to count it :

+#ifdef CONFIG_DEBUG_VM
+       /*
+        * Just to be paranoid : warn if we detect that enough free or
+        * slow paths nested on top of us to get the counter to go
+        * half-way to overflow. That would be insane to do that much
+        * allocations/free in interrupt handers, but check it anyway.
+        */
+       WARN_ON(result - old > -1UL >> 1);
+#endif

If we ever have a kernel which starts to behave weirdly and *could* be
unlucky and get nearer to overflow, this check would likely detect it.
Worse case I have seen so far on my stressed machine was a delta of 3.

> I would really prefer if we defer all this fast path fiddling until we
> have the cpu_ops in place, this all just makes the code utterly
> unreadable.
> 
> 

Even with cpu_ops in place, I think it would be safer to still disable
preemption in the fastpath. It would make sure a thread is not stopped
in the middle of the cmpxchg loop, a lot of activity happens, and later
on the thread is woken up. In this scenario, the 16 bits might not be
enough to keep track of allocations/frees in the slab.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
