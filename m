Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbZFXPK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbZFXPK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZFXPKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:10:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41943 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbZFXPKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:10:22 -0400
Date: Wed, 24 Jun 2009 17:10:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vince@deater.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: performance counter 20% error finding retired instruction count
Message-ID: <20090624151010.GA12799@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vince@deater.net> wrote:

> Hello
>
> As an aside, is it time to set up a dedicated Performance Counters
> for Linux mailing list?   (Hereafter referred to as p10c7l to avoid
> confusion with the other implementations that have already taken
> all the good abbreviated forms of the concept).

('perfcounters' is the name of the subsystem/feature and it's 
unique.)

> [...]  If/when the infrastructure appears in a released kernel, 
> there's going to be a lot of chatter by people who use performance 
> counters and suddenly find they are stuck with a huge step 
> backwards in functionality.  And asking Fortran programmers to 
> provide kernel patches probably won't be a productive response.  
> But I digress.
>
> I was trying to get an exact retired instruction count from 
> p10c7l. I am using the test million.s, available here
>
>  ( http://www.csl.cornell.edu/~vince/projects/perf_counter/million.s )
>
> It should count exactly one million instructions.
>
> Tests with valgrind and qemu show that it does.
>
> Using perfmon2 on Pentium Pro, PII, PIII, P4, Athlon32, and Phenom
> all give the proper result:
>
> tobler:~% pfmon -e retired_instructions ./million
> 1000002 RETIRED_INSTRUCTIONS
>
>    ( it is 1,000,002 +/-2 because on most x86 architectures retired
>      instruction count includes any hardware interrupts that might
>      happen at the time.  It woud be a great feature if p10c7l
>      could add some way of gathering the per-process hardware
>      instruction count statistic to help quantify that).
>
> Yet with perf on the same Athlon32 machine (using
> kernel 2.6.30-03984-g45e3e19) gives:
>
> tobler:~%perf stat ./million
>
>  Performance counter stats for './million':
>
>        1.519366  task-clock-ticks     #       0.835 CPU utilization factor
>               3  context-switches     #       0.002 M/sec
>               0  CPU-migrations       #       0.000 M/sec
>              53  page-faults          #       0.035 M/sec
>         2483822  cycles               #    1634.775 M/sec
>         1240849  instructions         #     816.689 M/sec # 0.500 per cycle
>          612685  cache-references     #     403.250 M/sec
>            3564  cache-misses         #       2.346 M/sec
>
>  Wall-clock time elapsed:     1.819226 msecs
>
> Running multiple times gives:
>    1240849
>    1257312
>    1242313
>
> Which is a varying error of at least 20% which isn't even 
> consistent.  Is this because of sampling?  The documentation 
> doesn't really warn about this as far as I can tell.
>
> Thanks for any help resolving this problem

Thanks for the question! There's still gaps in the documentation so 
let me explain the basics here:

'perf stat' counts the true cost of executing the command in 
question, including the costs of:

   fork()ing the task
   exec()-ing it
   the ELF loader resolving dynamic symbols
   the app hitting various pagefaults that instantiate its pagetables

etc.

Those operations are pretty 'noisy' on a typical CPU, with lots of 
cache effects, so the noise you see is real.

You can eliminate much of the noise by only counting user-space 
instructions, as much of the command startup cost is in 
kernel-space.

Running your test-app that way can be done the following way:

 $ perf stat --repeat 10 -e 0:1:u ./million

 Performance counter stats for './million' (10 runs):

        1002106  instructions           ( +-   0.015% )

    0.000599029  seconds time elapsed.

( note the --repeat feature of perf stat - it does a loop of command 
  executions and observes the noise and displays it. )

Those ~2100 instructions are executed by your app: as the ELF 
dynamic loader starts up your test-app.

If you have some tool that reports less than that then that tool is 
not being truthful about the true overhead of your application.

Also note that applications that only execute 1 million instructions 
are very, very rare - a modern CPU can execute billions of 
instructions, per second, per core.

So i usually test a reference app that is more realistic, that 
executes 1 billion instructions:

 $ perf stat --repeat 10 -e 0:1:u ./loop_1b_instructions

 Performance counter stats for './loop_1b_instructions' (10 runs):

     1000079797  instructions           ( +-   0.000% )

    0.239947420  seconds time elapsed.

the noise there is very low. (despite 230 milliseconds still being a 
very short runtime)

Hope this helps - thanks,

	Ingo
