Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbXFMP5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbXFMP5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 11:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbXFMP52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 11:57:28 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:35479 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754887AbXFMP51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 11:57:27 -0400
Date: Wed, 13 Jun 2007 11:57:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@stusta.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/9] Conditional Calls - Architecture Independent Code
Message-ID: <20070613155724.GA8703@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.070136408@polymtl.ca> <20070604190102.GY5500@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070604190102.GY5500@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:46:49 up 16 days, 25 min,  6 users,  load average: 2.13, 1.25, 0.84
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

* Adrian Bunk (bunk@stusta.de) wrote:

> I have two questions for getting the bigger picture:
>
> 1. How much code will be changed?
> Looking at the F00F bug fixup example, it seems we'll have to make
> several functions in every single driver conditional in the kernel for
> getting the best performance.
> How many functions to you plan to make conditional this way?
>

I just changed the infrastructure to match Andi's advice : the
cond_calls are now "fancy" variables : they refer to a static variable
address, and every update (which must be done through the cond call API)
changes every load immediate referring to this variable. Therefore, they
can be simply embedded in a if(cond_call(var)) statement, so there is no
big code change to do.


> 2. What is the real-life performance improvement?
> That micro benchmarks comparing cache hits with cache misses give great 
> looking numbers is obvious.
> But what will be the performance improvement in real workloads after the
> functions you plan to make conditional according to question 1 have been 
> made conditional?
> 

Hrm, I am trying to get interesting numbers out of lmbench: I just ran a
test on a kernel sprinkled with about 50 markers at important sites
(LTTng markers: system call entry/exit, traps, interrupt handlers, ...).
The markers are compiled-in, but in "disabled state". Since the markers
re-use the cond_call infrastructure, each marker has its own cond_call.

I ran the test in two situations on my Pentium 4 box:

1 - Cond call optimizations are disabled. This is the equivalent of
using a global variable (in the kernel data) as a condition for the
branching.

2 - Cond call optimizations are enabled. It uses the load immediate
(which is now loading an integer on x86 instead of a char, to make sure
there is no pipeline stall due to false register dependency).

The results are that we really cannot tell that one is faster/slower
than the other; the standard deviation is much higher than the
difference between the two situations.

Note that lmbench is a workload that will not trigger much L1 cache
stress, since it repeats the same tests many times. Do you have any
suggestion of a test that would be more representative of a real
diversified (in term of in-kernel locality of reference) workload ?

Thanks,

Mathieu


> TIA
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
