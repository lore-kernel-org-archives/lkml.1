Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZLORnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZLORnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 12:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZLORnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 12:43:11 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:60973 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408AbZLORnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 12:43:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAAtYJ0uuWOw8/2dsb2JhbACBS9cdhCsE
Date: Tue, 15 Dec 2009 12:43:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and
	cleanup
Message-ID: <20091215174302.GA3928@Krystal>
References: <20091214220320.665065925@quilx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091214220320.665065925@quilx.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:25:49 up 13 days,  8:16,  4 users,  load average: 0.16, 0.24,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> Leftovers from the earlier patchset. Mostly applications of per cpu counters
> to core components.
> 
> After this patchset there will be only one user of local_t left: Mathieu's
> trace ringbuffer. Does it really need these ops?
> 

Besides my own ring buffer implementation in LTTng, at least Steven's
kernel/trace/ring_buffer.c (in mainline) use this too. We would need a
way to directly map to the same resulting behavior with per-cpu
variables.

In LTTng, I use local_cmpxchg, local_read, local_add and, in some
setups, local_add_return to manage the write counter and commit
counters. These per-cpu counters are kept in per-cpu buffer management
data allocated for each data collection "channel".

The current way I allocate this structure for all cpus is:

  chan->buf = alloc_percpu(struct ltt_chanbuf);

But note that each struct ltt_chanbuf contains a pointer to an array
containing each sub-buffer commit counters for the given buffer:

struct commit_counters {
        local_t cc;
        local_t cc_sb;                  /* Incremented _once_ at sb switch */
        local_t events;                 /* Event count */
};

struct ltt_chanbuf {
        struct ltt_chanbuf_alloc a;     /* Parent. First field. */
        /* First 32 bytes cache-hot cacheline */
        local_t offset;                 /* Current offset in the buffer */
        struct commit_counters *commit_count;
                                        /* Commit count per sub-buffer */
        atomic_long_t consumed;         /*
                                         * Current offset in the buffer
                                         * standard atomic access (shared)
                                         */
....

So I think accessing the "local_t offset" through percpu pointers should
be fine if I allocate struct ltt_chanbuf through the per cpu API.
However, I wonder how to deal with the commit_count counters, because
there is an indirection level.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
