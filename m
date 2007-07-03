Return-Path: <linux-kernel-owner+w=401wt.eu-S1757008AbXGCTDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbXGCTDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbXGCTCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:02:55 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:58681 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757272AbXGCTCy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:02:54 -0400
Date: Tue, 3 Jul 2007 14:57:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070703185748.GA4047@Krystal>
References: <20070703164046.645090494@polymtl.ca> <20070703164516.377240547@polymtl.ca> <20070703181151.GB5800@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070703181151.GB5800@martell.zuzino.mipt.ru>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:27:22 up 2 days, 13:10,  3 users,  load average: 0.91, 0.45, 0.35
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexey Dobriyan (adobriyan@gmail.com) wrote:
> On Tue, Jul 03, 2007 at 12:40:56PM -0400, Mathieu Desnoyers wrote:
> > Use immediate values with lower d-cache hit in optimized version as a
> > condition for scheduler profiling call.
> 
> How much difference in performance do you see?
> 

Hi Alexey,

Please have a look at Documentation/immediate.txt for that information.
Also note that the main advantage of the load immediate is to free a
cache line. Therefore, I guess the best way to quantify the improvement
it brings at one single site is not in terms of cycles, but in terms of
number of cache lines used by the scheduler code. Since memory bandwidth
seems to be an increasing bottleneck (CPU frequency increases faster
than the available memory bandwidth), it makes sense to free as much
cache lines as we can.

Measuring the overall impact on the system of this single modification
results in the difference brought by one site within the standard
deviation of the normal samples. It will become significant when the
number of immediate values used instead of global variables at hot
kernel paths (need to ponder with the frequency at which the data is
accessed) will start to be significant compared to the L1 data cache
size. We could characterize this in memory to L1 cache transfers per
seconds.

On 3GHz P4:

memory read: ~48 cycles

So we can definitely say that 48*HZ (approximation of the frequency at
which the scheduler is called) won't make much difference, but as it
grows, it will.

On a 1000HZ system, it results in:

48000 cycles/second, or 16µs/second, or 0.000016% speedup.

However, if we place this in code called much more often, such as
do_page_fault, we get, with an hypotetical scenario of approximation
of 100000 page faults per second:

4800000 cycles/s, 1.6ms/second or 0.0016% speedup.

So as the number of immediate values used increase, the overall memory
bandwidth required by the kernel will go down.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
