Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYJCQjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYJCQjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYJCQje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:39:34 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:46431 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752807AbYJCQje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:39:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAGzh5UhMQWq+/2dsb2JhbACBcbpGgWg
Date: Fri, 3 Oct 2008 12:39:31 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [ltt-dev] LTTng 0.27, vmap-less buffering and splice()
Message-ID: <20081003163931.GA5564@Krystal>
References: <20081002060626.GD7676@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081002060626.GD7676@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:32:06 up 120 days, 21:12,  5 users,  load average: 0.66, 0.57,
	0.62
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did some performance testing between LTTng 0.26 (uses vmap buffers)
and LTTng 0.31 (vmap-less buffers). I think performance got degraded in
the process. Those tests only write trace data in circular buffers
("overwrite mode").

No tracing, kernel 2.6.27-rc8 :
tbench : 1862.24

LTTng 0.26, kernel 2.6.27-rc7, flight recorder, default size buffers :
tbench : 1156.37 MB/s

LTTng 0.31, kernel 2.6.27-rc8, flight recorder, default size buffers :
tbench : 942.72 MB/s

For those of the LTT community interested in LTTng performance, I think
it's worth having a look at the ltt-relay-alloc.patch implementation to
see if there is any obvious performance degradation source. I'll play a
bit with the implementation to see where it comes from.

Mathieu

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Hi,
> 
> I have reworked the underlying buffering mechanism LTTng uses in the
> past week. I took "relay", changed its vmap() buffers for my own linked
> list of buffers (not vmaped), made read/write wrappers which support
> writing data larger than a page size and writing across page boundaries,
> and finally managed to create a splice_read file operation which
> supports that. I finally changed lttd to make it use splice() instead of
> a mmap() and... it worked! :-) (after a bit a debugging, clearly)
> 
> This is all in LTTng 0.27 and ltt-control 0.53 (for the lttd part).
> As this is an important change, testing is very welcome. If you are
> interested in looking in the inner details of the buffering mechanism I
> just did, you might also want to enable the "check for random buffer
> access" option in the menuconfig. It will generate warnings when offset
> accesses more than a page away from the previous done is requested by
> the client. Cases such as large data write and reentrancy over the
> tracer code will generate a few "cache misses", but it's supposed to be
> rare, and therefore not a performance concern. This self-checking
> feature has proven to be very useful in the early development stages,
> and I think it's also useful if any other tracer client want to use it :
> it helps finding lack of reference locality a tracer client might have.
> 
> I am also very interested in getting numbers comparing the performance
> of the new buffering infrastructure with the previous one. Having much
> less TLB impact should improve performance.
> 
> It's all available in the git tree :
> http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=summary
> 
> And the userspace packages available at http://ltt.polymtl.ca (see the
> "QUICKSTART")
> 
> Cheers,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
