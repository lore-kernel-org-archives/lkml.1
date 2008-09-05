Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYIELJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYIELJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 07:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYIELJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 07:09:43 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57093 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYIELJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 07:09:42 -0400
Subject: Re: [LTP] [TESTING] x86: implement prctl PR_GET_TSC and PR_SET_TSC
	in	2.6.26
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Erik Bosman <ejbosman@cs.vu.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: ltp-list <ltp-list@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
In-Reply-To: <1220534054.12494.33.camel@subratamodak.linux.ibm.com>
References: <1219769280.5452.49.camel@subratamodak.linux.ibm.com>
	 <Pine.GSO.4.56.0809011925140.16379@keg.few.vu.nl>
	 <1220534054.12494.33.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Fri, 05 Sep 2008 16:39:37 +0530
Message-Id: <1220612977.4796.53.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Erik,

On Thu, 2008-09-04 at 18:44 +0530, Subrata Modak wrote:
> Hi Erik,
> 
> On Mon, 2008-09-01 at 19:36 +0200, Erik Bosman wrote:
> > Hi Subrata,
> > 
> > Sorry for my late reaction. I'm busy working on my Master thesis right
> > now.

I would disturb you for a brief period once again.

> > 
> > On Tue, 26 Aug 2008, Subrata Modak wrote:
> > 
> > > Hi Erik,
> > >
> > > Would you kindly let us know how you tested prctl PR_GET_TSC and
> > > PR_SET_TSC, which is added in 2.6.26. Did you write/develop an automated
> > > test case(s) of your own. Let us know if you would like the same to
> > > share with LTP under GPLv2.
> > >
> > 
> > One of my patches added three tests to the Documentation/prctl, so you can
> > find them there from 2.6.26 on. They are not automated but it is not hard
> > to change that. I would recommend using disable-tsc-on-off-stress-test.c.
> 
> Thank you very much. I would look into them surely, and see how i can
> integrate them inside LTP.

I have run those tests on i686, x86_64 & ppc64 running 2.6.26 kernel.
And here are my observations:

1) Built and ran perfectly on X86_64:

# uname -a
Linux 2.6.26-autokern1 #1 SMP PREEMPT Fri Sep 5 09:40:31 UTC 2008 x86_64
GNU/Linux

# ./disable-tsc-test               
rdtsc() == 9766811077875
prctl(PR_GET_TSC, &tsc_val); tsc_val == PR_TSC_ENABLE
rdtsc() == 9766811184102
prctl(PR_SET_TSC, PR_TSC_ENABLE)
rdtsc() == 9766811200743
prctl(PR_SET_TSC, PR_TSC_SIGSEGV)
rdtsc() == [ SIG_SEGV ]
prctl(PR_GET_TSC, &tsc_val); tsc_val == PR_TSC_SIGSEGV
prctl(PR_SET_TSC, PR_TSC_ENABLE)
rdtsc() == 9766811246535
# echo $?
0

# ./disable-tsc-on-off-stress-test 
[No further output means we're allright]
# echo $?
0

# ./disable-tsc-ctxt-sw-stress-test 
[No further output means we're allright]
# echo $?
0



2) Built fine on i686, but disable-tsc-on-off-stress-test failed:

# uname -a
Linux 2.6.26-autokern1 #1 SMP Fri Sep 5 09:49:37 UTC 2008 i686 GNU/Linux

# ./disable-tsc-test 
rdtsc() == 4098191459558
prctl(PR_GET_TSC, &tsc_val); tsc_val == PR_TSC_ENABLE
rdtsc() == 4098192032718
prctl(PR_SET_TSC, PR_TSC_ENABLE)
rdtsc() == 4098192209502
prctl(PR_SET_TSC, PR_TSC_SIGSEGV)
rdtsc() == [ SIG_SEGV ]
prctl(PR_GET_TSC, &tsc_val); tsc_val == PR_TSC_SIGSEGV
prctl(PR_SET_TSC, PR_TSC_ENABLE)
rdtsc() == 4098192880534
# echo $?
0

# ./disable-tsc-on-off-stress-test 
Floating point exception
# echo $?
136

# ./disable-tsc-ctxt-sw-stress-test 
[No further output means we're allright]
# echo $?
0


3) Build failure on ppc64 with a POWER6 cpu:

# uname -a
Linux 2.6.26-autokern1 #1 SMP Fri Sep 5 05:41:12 EDT 2008 ppc64 ppc64
ppc64 GNU/Linux

# make
cc     disable-tsc-ctxt-sw-stress-test.c   -o
disable-tsc-ctxt-sw-stress-test
disable-tsc-ctxt-sw-stress-test.c: In function ‘rdtsc’:
disable-tsc-ctxt-sw-stress-test.c:33: error: impossible constraint in
‘asm’
make: *** [disable-tsc-ctxt-sw-stress-test] Error 1

# gcc --version
gcc (GCC) 4.1.2 20071124 (Red Hat 4.1.2-42)
Copyright (C) 2006 Free Software Foundation, Inc.



Can you kindly help us fix the:
1) Floating point exception for disable-tsc-on-off-stress-test, running
2.6.26 on i686,
2) build failure issue(s) with ppc64.

I also see the following issue(s) when i run it on i386 machine running
kernel less than 2.6.26:

$ uname -a
Linux 2.6.18-92.el5 #1 SMP Tue Apr 29 13:16:12 EDT 2008 i686 i686 i386
GNU/Linux

$ ./disable-tsc-test 
rdtsc() == 34367216958620
prctl(PR_GET_TSC, &tsc_val); prctl: Invalid argument
tsc_val == [not set]
rdtsc() == 34367217591252
prctl(PR_SET_TSC, PR_TSC_ENABLE)
prctl: Invalid argument
rdtsc() == 34367217645449
prctl(PR_SET_TSC, PR_TSC_SIGSEGV)
prctl: Invalid argument
rdtsc() == 34367217698450
$ echo $?
0

$ ./disable-tsc-ctxt-sw-stress-test 
[No further output means we're allright]
prctl: Invalid argument
prctl: Invalid argument
..............
..............
prctl: Invalid argument
$ echo $?
0

$ ./disable-tsc-ctxt-sw-stress-test 
[No further output means we're allright]
prctl: Invalid argument
prctl: Invalid argument
..............
..............
prctl: Invalid argument
$ echo $?
0

Should it not fail on any kernel(s) below 2.6.26 ? It shows pass for all
the tests. And also lots of lines like:

prctl: Invalid argument

is printed, which in ideal situation should not be printed at all. What
do you think ?

Regards--
Subrata

> 
> > 
> > Is it a problem if the test causes a very high load?
> 
> No, there is no such problem. But we will run it separately rather than
> with default run. Normally, we run the stress tests separately from the
> normal functional tests.
> 
> Regards--
> Subrata
> 
> > 
> > > We already have the prctl() test cases in LTP and probably with this
> > > addition, we need to add some more tests to the existing scenario. Would
> > > you review the existing ones too:
> > >
> > > http://ltp.cvs.sourceforge.net/ltp/ltp/testcases/kernel/syscalls/prctl/,
> > 
> > Prctl is by definition a very diverse syscall, I am not an expert on
> > all prctl calls. I don't think I can help you with many of them (as I
> > don't have the hardware, ) and as I said, I'm rather busy finishing my
> > master thesis.
> > 
> > Regards,
> > Erik
> 
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Ltp-list mailing list
> Ltp-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ltp-list

