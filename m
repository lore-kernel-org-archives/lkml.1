Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZFFGwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZFFGwt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 02:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZFFGwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 02:52:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45705 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbZFFGwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:52:36 -0400
Date: Sat, 6 Jun 2009 08:47:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: naresh kamboju <naresh.kernel@gmail.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: open_posix_testsuite: STOP + CONT + wait hang?
Message-ID: <20090606064749.GA13508@redhat.com>
References: <20090525185502.GA20781@redhat.com> <20090526210514.C1C91FC2BD@magilla.sf.frob.com> <20090526213346.GA7073@redhat.com> <20090527005527.B50B7FC36B@magilla.sf.frob.com> <20090602045418.GB8219@us.ibm.com> <f5a7b3810906050843g6cbf5067o5ba1b9e07e5e2f5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5a7b3810906050843g6cbf5067o5ba1b9e07e5e2f5b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(change the subject)

On 06/05, naresh kamboju wrote:
>
> I want to inform 2.6.29 signal issues,
> As per my understanding I have noticed that if there is a delay
> (sleep/nanosleep/usleep) in the child process. Child could not
> reporting exit status to parent at this situation parent is waiting
> for ever by combinations of SIGSTOP and SIGCONT. So test cases are
> reporting as HUNG.

Thanks for report, but please provide more info.

> ARCH: ARM

is it ARM specific? I can't reproduce the problem on x86.

> KERNEL: 2.6.29.1

did you try other kernel versions?

> #define SLEEPSEC 5
...
> 	if ((pid = fork()) == 0) {
> 		/* child here */
> 		struct timespec tssleep;
>
> 		tssleep.tv_sec=SLEEPSEC;
> 		tssleep.tv_nsec=0;
> 		if (clock_nanosleep(CLOCK_REALTIME, 0, &tssleep, NULL) == 0) {
> 			printf("clock_nanosleep() returned success\n");
> 			return CHILDPASS;
> 		} else {
> 			printf("clock_nanosleep() did not return success\n");
> 			return CHILDFAIL;
> 		}
> 		return CHILDFAIL;
> 	} else {
> 		/* parent here */
> 		int i;
>
> 		sleep(1);
>
> 		if (kill(pid, SIGSTOP) != 0) {
> 			printf("Could not raise SIGSTOP\n");
> 			return PTS_UNRESOLVED;
> 		}
>
> 		if (kill(pid, SIGCONT) != 0) {
> 			printf("Could not raise SIGCONT\n");
> 			return PTS_UNRESOLVED;
> 		}
>
> 		if (wait(&i) == -1) {

And I guess it hangs here, right?

The child should sleep SLEEPSEC seconds then exit, so the whole
test-case should take SLEEPSEC seconds too.


Do you mean it really hangs and never completes?

Can you confirm it hangs in wait() ?

Does the child print "returned success" ?

If you can reproduce the problem, please send the content of
/proc/CHILD_PID/status and /proc/PARENT_PID/status.

Oleg.

