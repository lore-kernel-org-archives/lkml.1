Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbZK1HbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbZK1HbD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 02:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZK1HbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 02:31:03 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:56309 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbZK1HbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 02:31:01 -0500
Date: Sat, 28 Nov 2009 13:00:50 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: powerpc: fork && stepping (Was: [RFC,PATCH 0/14] utrace/ptrace)
Message-ID: <20091128073049.GD23108@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20091125080342.GD2660@in.ibm.com> <20091125154052.GA6734@redhat.com> <20091126075335.GA18508@in.ibm.com> <20091126145051.GB4382@redhat.com> <20091126172524.GA14768@redhat.com> <20091126182226.GF12355@darkmag.usersys.redhat.com> <20091126202312.GA21945@redhat.com> <19214.63688.860929.962005@cargo.ozlabs.ibm.com> <20091126223703.GA28556@redhat.com> <20091127174627.GB26193@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127174627.GB26193@darkmag.usersys.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 06:46:27PM +0100, Veaceslav Falico wrote:
> On Thu, Nov 26, 2009 at 11:37:03PM +0100, Oleg Nesterov wrote:
> >
> > Could you look at this
> >
> >   ptrace-copy_process-should-disable-stepping.patch
> >   http://marc.info/?l=linux-mm-commits&m=125789789322573
> >
> > patch? It is not clear to me how we can modify the test-case to
> > verify it fixes the original problem for powerpc.
> 
> I modified the test-case, it confirms that
> ptrace-copy_process-should-disable-stepping.patch fixes the
> problem with TIF_SINGLESTEP copied by fork() on powerpc.
> 
> Probably we need a similar fix for step-fork.c in ptrace-tests.
> 
> Modified the original testcase to call fork via syscall(__NR_fork),
> to avoid the looping inside libc's fork() on powerpc.
> The parent singlesteps until he sees that the child has forked, after
> that the parent PTRACE_CONTs until the child exits.

Thanks Veaceslav. This works:

Index: ptrace-tests/tests/step-fork.c
===================================================================
--- ptrace-tests.orig/tests/step-fork.c
+++ ptrace-tests/tests/step-fork.c
@@ -29,6 +29,7 @@
 #include <unistd.h>
 #include <sys/wait.h>
 #include <string.h>
+#include <sys/syscall.h>
 #include <signal.h>

 #ifndef PTRACE_SINGLESTEP
@@ -78,7 +79,7 @@ main (int argc, char **argv)
        sigprocmask (SIG_BLOCK, &mask, NULL);
        ptrace (PTRACE_TRACEME);
        raise (SIGUSR1);
-       if (fork () == 0)
+       if (syscall(__NR_fork) == 0)
          {
            read (-1, NULL, 0);
            _exit (22);

Oleg,
With the above patch applied, syscall-reset is the only failure I see on
powerpc:

errno 14 (Bad address)
syscall-reset: syscall-reset.c:95: main: Assertion `(*__errno_location
()) == 38' failed.
unexpected child status 67f
FAIL: syscall-reset
...
========================================
1 of 40 tests failed
(11 tests were not run)
Please report to utrace-devel@redhat.com
========================================

Ananth
