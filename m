Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbYIEPO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbYIEPO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 11:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYIEPOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 11:14:19 -0400
Received: from keg.few.vu.nl ([130.37.24.4]:53165 "EHLO keg.few.vu.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYIEPOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 11:14:18 -0400
X-Greylist: delayed 3187 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2008 11:14:18 EDT
Date: Fri, 5 Sep 2008 16:20:08 +0200 (CEST)
From: Erik Bosman <ejbosman@cs.vu.nl>
X-X-Sender: ebn310@keg.few.vu.nl
To: Subrata Modak <subrata@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       ltp-list <ltp-list@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [LTP] [TESTING] x86: implement prctl PR_GET_TSC and PR_SET_TSC
 in 2.6.26
In-Reply-To: <1220612977.4796.53.camel@subratamodak.linux.ibm.com>
Message-ID: <Pine.GSO.4.56.0809051517350.28418@keg.few.vu.nl>
References: <1219769280.5452.49.camel@subratamodak.linux.ibm.com> 
 <Pine.GSO.4.56.0809011925140.16379@keg.few.vu.nl> 
 <1220534054.12494.33.camel@subratamodak.linux.ibm.com>
 <1220612977.4796.53.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Sep 2008, Subrata Modak wrote:
>
> 2) Built fine on i686, but disable-tsc-on-off-stress-test failed:
>
> # uname -a
> Linux 2.6.26-autokern1 #1 SMP Fri Sep 5 09:49:37 UTC 2008 i686 GNU/Linux
>
> # ./disable-tsc-test
> rdtsc() == 4098191459558
> prctl(PR_GET_TSC, &tsc_val); tsc_val == PR_TSC_ENABLE
> rdtsc() == 4098192032718
> prctl(PR_SET_TSC, PR_TSC_ENABLE)
> rdtsc() == 4098192209502
> prctl(PR_SET_TSC, PR_TSC_SIGSEGV)
> rdtsc() == [ SIG_SEGV ]
> prctl(PR_GET_TSC, &tsc_val); tsc_val == PR_TSC_SIGSEGV
> prctl(PR_SET_TSC, PR_TSC_ENABLE)
> rdtsc() == 4098192880534
> # echo $?
> 0
>
> # ./disable-tsc-on-off-stress-test
> Floating point exception
> # echo $?
> 136

I'm a bit puzzled by this, since I don't use any floats
in my test (or even integer division.)

Another strange thing is that it is the parent process getting
the signal, while the parent doesn't do anything but forking
and waiting.

If the bug was in the kernel (for example sending a SIGFPE instead
of a SIGSEGV,) the signal would be expected to go to the child process
doing the actual testing (I know, bugs are bugs, but my patches were
not that invasive.)

Does it fail every time? Does it fail immediately? Can you use gdb
to locate where it happens?

I cannot reproduce this error using gcc 4.2.3.
Valgrind doesn't give me any errors except uninitialized (and in
this case unused) prctl arguments.
Could it be a optimization bug?

>
> # ./disable-tsc-ctxt-sw-stress-test
> [No further output means we're allright]
> # echo $?
> 0
>
>
> 3) Build failure on ppc64 with a POWER6 cpu:
>

The test uses the intel RDTSC instruction
and PR_SET_TSC/PR_GET_TSC is currently only
implemented on x86. So it is of little use to
try to compile this test on other platforms.

>
> Can you kindly help us fix the:
> 1) Floating point exception for disable-tsc-on-off-stress-test, running
> 2.6.26 on i686,
> 2) build failure issue(s) with ppc64.
>
> I also see the following issue(s) when i run it on i386 machine running
> kernel less than 2.6.26:
>

...

> $ ./disable-tsc-ctxt-sw-stress-test
> [No further output means we're allright]
> prctl: Invalid argument
> prctl: Invalid argument
> ..............
> ..............
> prctl: Invalid argument
> $ echo $?
> 0
>
> $ ./disable-tsc-ctxt-sw-stress-test
> [No further output means we're allright]
> prctl: Invalid argument
> prctl: Invalid argument
> ..............
> ..............
> prctl: Invalid argument
> $ echo $?
> 0
>
> Should it not fail on any kernel(s) below 2.6.26 ? It shows pass for all
> the tests. And also lots of lines like:
>
> prctl: Invalid argument
>
> is printed, which in ideal situation should not be printed at all. What
> do you think ?
>
> Regards--
> Subrata
>

The current test wasn't written to be integrated into an automated testing
framework and only uses stderr output for error reporting. To integrate
the test into a framework, just test whether all children terminate using
SIGALRM (which means success.)

Regards,
Erik Bosman
