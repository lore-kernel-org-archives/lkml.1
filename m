Return-Path: <linux-kernel-owner+w=401wt.eu-S1761907AbXLNQnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907AbXLNQnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbXLNQnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:43:39 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:57007 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbXLNQnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:43:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FANxBYkdMROHU/2dsb2JhbACBWqhc
Date: Fri, 14 Dec 2007 11:43:35 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Next patches for the 2.6.25 queue
Message-ID: <20071214164334.GA5253@Krystal>
References: <20071213144642.GA7800@Krystal> <20071213154908.GH10069@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071213154908.GH10069@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:40:40 up 40 days, 20:46,  7 users,  load average: 0.17, 0.46,
	0.65
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@kernel.org) wrote:
> On Thu, Dec 13, 2007 at 09:46:42AM -0500, Mathieu Desnoyers wrote:
> > Hi Andrew,
> > 
> > I would like to post my next patches in a way that would make it as
> > easy for you and the community to review them. Currently, the patches
> > that have really settled down are :
> > 
> > * For 2.6.25
> >...
> > - Immediate Values
> >   - Redux version, asked by Rusty
> >...
> 
> I might have missed it:
> 
> Are there any real numbers (opposed to estimates and microbenchmarks) 
> available how much performance we actually gain in which situations?
> 
> It might be some workload with markers using Immediate Values or 
> something like that, but it should be something where the kernel
> runs measurably faster with Immediate Values than without.
> 
> Currently I'm somewhere between "your Immediate Values are just an 
> academic code obfuscation without any gain in practice" and "janitors 
> should convert all drivers to use Immediate Values", and I'd like to 
> form an opinion based on in which situations the kernel runs faster by 
> how many percent.
> 
> That's also based on observation like e.g. that __read_mostly should 
> improve the performance, but I've already seen situations in the kernel 
> where it forced gcc to emit code that was obviously both bigger and 
> slower than without the __read_mostly [1], and that's part of why I'm 
> sceptical of all optimizations below the C level unless proven 
> otherwise.
> 

Hi Adrian,

Yes, I had numbers that were presented in the patch headers, but I
re-ran some tests to have a clearer picture. Actually, what makes this
difficult to benchmark is the measurement error caused by the system's
"background noise" (interrupts, softirqs, kernel threads...). Note that
we are measuring cache effects and, therefore, any program which does
the same operation many times in a loop will benefit from space and time
locality and won't trigger many cache misses after the first loop.

So, here is what I have done to get a significant difference between the
with and without immediate values :

I ran, in userspace, a program that does random memory access
(3 times, in a 10MB array) between each getppid() syscall, everything
wrapped in a loop, repeated 1000 times (enough so the results are
reproduceable between runs). Tests were done on a 3GHz Pentium 4 with
2GB of ram with Linux 2.6.24-rc5.

I instrumented getppid() with 40 markers, so the impact of memory reads
won't be burried in the "background noise". Since each markers is using
a 24 bytes structure (8 bytes aligned), and are next to each other in
memory, we will cause (depending on the alignment of structures in the
cache lines) :

L1 cache lines : 64 bytes
L2 cache lines : 128 bytes

8-9 memory reads (L2 cache misses)
15-16 L2 accesses (L1 cache misses)

for each getppid() syscall.

The result is as expected :

Number of cycles for getppid

* Without memory pressure : 1470 cycles
* With memory pressure (std. dev. calculated on 3 groups of 1000 loops on
                        compiled out case : 416.54 cycles)
  * 40 markers without immediate values : 14938 cycles
  * 40 markers with immediate values :    12795 cycles
  * Markers compiled out :                12427 cycles

for a 14% speedup reached by using immediate values of data reads.
There seems to be no significant difference between compiling out the
markers and using immediate values to disable them.

Note that since the markers are located in the same cache lines, those
40 markers are the equivalent to have about 8 markers _not_ on the same
cache lines (in real life, that's very likely to be the case).

So, the conditions to have a speedup here :

- A significant amount of cache lines must be saved.
- They must be read from memory often.

So, we will likely see a real-life impact in situations such as :
instrumenting spinlocks; whenever they would be taken/released many
times in a system call made by an application doing random memory access
(a hash-based search engine would be a good example, a database would
also be a suitable workload), we should be able to measure the impact.
However, this is hard to reproduce/measure, so this is why I created a
synthetic workload simulating this behavior.

So I would really suggest using the immediate values for applications
such as :
- code markup (the markers)
- dynamically enable what would have otherwise been selected in
  menuconfig (such as profiling, scheduler/timer statistics for
  powertop...)

where the goal is to have _zero_ measurable impact on performance on any
workload.

Mathieu

> > Thanks,
> > 
> > Mathieu
> 
> cu
> Adrian
> 
> [1] Figuring out what might have happened is left as an exercise to the 
>     reader.  :-)
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
