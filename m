Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZFEPvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZFEPvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZFEPu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:50:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:49115 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZFEPu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:50:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iQvyjaGsFJOd1srVzbeoEFIiBvesgpVki/cFoCU4qmqdKZEzq1BmLKduxmCXmI1tE+
         XmLzO3kKwVLXwZmzCSeRCic/bgt7RH93G4WVRK9n6dHLA0uUARrHDlhiC+PknfbmCoM7
         dG+ZssqsMZpxJ3NN9Kp3AChV+Z8lQIoOZxcrM=
MIME-Version: 1.0
In-Reply-To: <20090602045418.GB8219@us.ibm.com>
References: <20090525185502.GA20781@redhat.com>
	 <20090526210514.C1C91FC2BD@magilla.sf.frob.com>
	 <20090526213346.GA7073@redhat.com>
	 <20090527005527.B50B7FC36B@magilla.sf.frob.com>
	 <20090602045418.GB8219@us.ibm.com>
Date: Fri, 5 Jun 2009 21:13:13 +0530
Message-ID: <f5a7b3810906050843g6cbf5067o5ba1b9e07e5e2f5b@mail.gmail.com>
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong 
	->nsproxy usage
From: naresh kamboju <naresh.kernel@gmail.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       naresh.kernel@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to inform 2.6.29 signal issues,
As per my understanding I have noticed that if there is a delay
(sleep/nanosleep/usleep) in the child process. Child could not
reporting exit status to parent at this situation parent is waiting
for ever by combinations of SIGSTOP and SIGCONT. So test cases are
reporting as HUNG.

Here I have attached open posix test cases which are reported as HUNG
with 2.6.29 kernels.
1.ltp/testcases/open_posix_testsuite/conformance/interfaces/clock_nanosleep/1-5.c
2.ltp/testcases/open_posix_testsuite/conformance/interfaces/nanosleep/3-2.c


ARCH: ARM
KERNEL: 2.6.29.1
Glibc: 2.9
Gcc: 4.3.3

/*****************************************************************/
 open_posix_testsuite/conformance/interfaces/clock_nanosleep/1-5.c

/*****************************************************************/
/*
 * Copyright (c) 2002-3, Intel Corporation. All rights reserved.
 * Created by:  julie.n.fleischer REMOVE-THIS AT intel DOT com
 * This file is licensed under the GPL license.  For the full content
 * of this license, see the COPYING file at the top level of this
 * source tree.

 * Test that clock_nanosleep() does not stop if a signal is received
 * that has no signal handler.  clock_nanosleep() should still respond
 * to the signal, but should resume after a SIGCONT signal is received.
 *
 * SIGSTOP will be used to stop the sleep.
 */
#include <stdio.h>
#include <time.h>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

#define PTS_PASS        0
#define PTS_FAIL        1
#define PTS_UNRESOLVED  2
#define PTS_UNSUPPORTED 4
#define PTS_UNTESTED    5


#define SLEEPSEC 5

#define CHILDPASS 1
#define CHILDFAIL 0

int main(int argc, char *argv[])
{
	int pid, slepts;
	struct timespec tsbefore, tsafter;

	if (clock_gettime(CLOCK_REALTIME, &tsbefore) != 0) {
		perror("clock_gettime() did not return success\n");
		return PTS_UNRESOLVED;
	}


	if ((pid = fork()) == 0) {
		/* child here */
		struct timespec tssleep;

		tssleep.tv_sec=SLEEPSEC;
		tssleep.tv_nsec=0;
		if (clock_nanosleep(CLOCK_REALTIME, 0, &tssleep, NULL) == 0) {
			printf("clock_nanosleep() returned success\n");
			return CHILDPASS;
		} else {
			printf("clock_nanosleep() did not return success\n");
			return CHILDFAIL;
		}
		return CHILDFAIL;
	} else {
		/* parent here */
		int i;

		sleep(1);

		if (kill(pid, SIGSTOP) != 0) {
			printf("Could not raise SIGSTOP\n");
			return PTS_UNRESOLVED;
		}

		if (kill(pid, SIGCONT) != 0) {
			printf("Could not raise SIGCONT\n");
			return PTS_UNRESOLVED;
		}

		if (wait(&i) == -1) {
			perror("Error waiting for child to exit\n");
			return PTS_UNRESOLVED;
		}

		if (!WIFEXITED(i) || !WEXITSTATUS(i)) {
			printf("Test FAILED\n");
			return PTS_FAIL;
		}

		if (clock_gettime(CLOCK_REALTIME, &tsafter) == -1) {
			perror("Error in clock_gettime()\n");
			return PTS_UNRESOLVED;
		}

		slepts=tsafter.tv_sec-tsbefore.tv_sec;

#ifdef DEBUG
		printf("Start %d sec; End %d sec\n", (int) tsbefore.tv_sec,
				(int) tsafter.tv_sec);
#endif
		if (slepts >= SLEEPSEC) {
			printf("Test PASSED\n");
			return PTS_PASS;
		} else {
			printf("clock_nanosleep() did not sleep long enough\n");
			return PTS_FAIL;
		}

	} //end fork

	return PTS_UNRESOLVED;
}



/*****************************************************************/
 open_posix_testsuite/conformance/interfaces/nanosleep/3-2.c

/*****************************************************************/
/*
 * Copyright (c) 2002, Intel Corporation. All rights reserved.
 * Created by:  julie.n.fleischer REMOVE-THIS AT intel DOT com
 * This file is licensed under the GPL license.  For the full content
 * of this license, see the COPYING file at the top level of this
 * source tree.
 *
 * Regression test motivated by an LKML discussion.  Test that nanosleep()
 * can be interrupted and then continue.
 */
#include <stdio.h>
#include <time.h>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

#define PTS_PASS        0
#define PTS_FAIL        1
#define PTS_UNRESOLVED  2
#define PTS_UNSUPPORTED 4
#define PTS_UNTESTED    5

#define SLEEPSEC 5

#define CHILDPASS 0 //if interrupted, child will return 0
#define CHILDFAIL 1

int main(int argc, char *argv[])
{
	int pid, slepts;
	struct timespec tsbefore, tsafter;

	if (clock_gettime(CLOCK_REALTIME, &tsbefore) != 0) {
		perror("clock_gettime() did not return success\n");
		return PTS_UNRESOLVED;
	}


	if ((pid = fork()) == 0) {
		/* child here */
		struct timespec tssleep;

		tssleep.tv_sec=SLEEPSEC;
		tssleep.tv_nsec=0;
		if (nanosleep(&tssleep, NULL) == 0) {
			printf("nanosleep() returned success\n");
			return CHILDPASS;
		} else {
			printf("nanosleep() did not return success\n");
			return CHILDFAIL;
		}
		return CHILDFAIL;
	} else {
		/* parent here */
		int i;

		sleep(1);

		if (kill(pid, SIGSTOP) != 0) {
			printf("Could not raise SIGSTOP\n");
			return PTS_UNRESOLVED;
		}

		if (kill(pid, SIGCONT) != 0) {
			printf("Could not raise SIGCONT\n");
			return PTS_UNRESOLVED;
		}

		if (wait(&i) == -1) {
			perror("Error waiting for child to exit\n");
			return PTS_UNRESOLVED;
		}

		if (!WIFEXITED(i)) {
			printf("nanosleep() did not return 0\n");
			return PTS_FAIL;
		}

		if (clock_gettime(CLOCK_REALTIME, &tsafter) == -1) {
			perror("Error in clock_gettime()\n");
			return PTS_UNRESOLVED;
		}

		slepts=tsafter.tv_sec-tsbefore.tv_sec;

		printf("Start %d sec; End %d sec\n", (int) tsbefore.tv_sec,
				(int) tsafter.tv_sec);
		if (slepts >= SLEEPSEC) {
			printf("Test PASSED\n");
			return PTS_PASS;
		} else {
			printf("nanosleep() did not sleep long enough\n");
			return PTS_FAIL;
		}

	} //end fork

	return PTS_UNRESOLVED;
}


/*****************************************************************/

thanks for your time.

Best regards,
Naresh Kamboju

On Tue, Jun 2, 2009 at 10:24 AM, Sukadev
Bhattiprolu<sukadev@linux.vnet.ibm.com> wrote:
> Roland McGrath [roland@redhat.com] wrote:
> | > Yes. Perhaps it would be nice to add a helper,
> |
> | I agree.
> |
> | > > sys_kill, do_tkill all look wrong to me.
> | >
> | > They should be fine, note the
> | >
> | >     if (from_ancestor_ns)
> | >             q->info.si_pid = 0;
> | >
> | > in __send_signal(). If we send the signal "down" to the sub-namespace,
> | > si_pid == 0 is correct. And, unlike do_notify_parent/ptrace_notify/etc
> | > kill/tkill can't send the signal "up".
> |
> | Ah, right.  I knew there was something around this I was forgetting.
>
> Setting si_pid to task_tgid_vnr(current); in places like do_tkill() is
> slightly misleading bc, it can get modified later in send_signal().  We
> can't set si_pid correctly in do_tkill() since we must first establish
> pid-namespace relationship and that can mess up control flow.
>
> Maybe a comment will help.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
