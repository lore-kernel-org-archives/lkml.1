Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbXEJQeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbXEJQeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbXEJQd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:33:59 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50260 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbXEJQd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:33:59 -0400
Date: Thu, 10 May 2007 22:11:58 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Con Kolivas" <kernel@kolivas.org>,
       "Mike Galbraith" <efault@gmx.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Definition of fairness (was Re: [patch] CFS scheduler, -v11)
Message-ID: <20070510164158.GB9173@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070508150431.GA26977@elte.hu> <20070509180205.GA27462@in.ibm.com> <b647ffbd0705091224m75bf8caawa0019ecfe8bf82e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <b647ffbd0705091224m75bf8caawa0019ecfe8bf82e7@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 09, 2007 at 09:24:17PM +0200, Dmitry Adamushko wrote:
> One quick observation.
> 
> Isn't it important for both processes to have the same "loops_per_ms" value?

Good catch.

I have modified the testcase based on this observation (using
setitimer).

-- 
Regards,
vatsa

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cpuhog.c"

#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <sys/resource.h>

volatile int time_elapsed;
int run_length  = 52; 	// in milliseconds
int sleep_length = 24;	// in milliseconds
int epoch_time = 5;	// in seconds

void alrm_handler(int signo)
{
	time_elapsed = 1;
}

main(int argc, char *argv[])
{
	double prevusage = 0;
	struct itimerval timer;
	time_t prevtime;

	if (argc > 1) {
		run_length = atoi(argv[1]);
		if (argc > 2)
			sleep_length = atoi(argv[2]);
		if (argc > 3)
			epoch_time = atoi(argv[3]);
	}

	signal(SIGVTALRM, alrm_handler);
	memset(&timer, 0, sizeof(timer));

	timer.it_value.tv_sec = run_length / 1000;
	timer.it_value.tv_usec = (run_length % 1000) * 1000;

	printf ("run time = %d ms (%d sec + %d usec), sleep time = %d ms,"
		" epoch time = %d s\n", run_length, timer.it_value.tv_sec,
		timer.it_value.tv_usec, sleep_length, epoch_time);

	prevtime = time(NULL);
	while (1) {
		time_t curtime, deltatime;
		struct rusage stats;
		int rc;

		rc = setitimer(ITIMER_VIRTUAL, &timer, NULL);
		if (rc < 0) {
			perror("setitimer");
			exit(1);
		}

		time_elapsed = 0;
		while (!time_elapsed)
		;

		usleep(sleep_length * 1000);

		curtime = time(NULL);
		deltatime = curtime - prevtime;
		if (deltatime >=  epoch_time) {
			double curusage, deltausage;

			getrusage(0, &stats);
			curusage = stats.ru_utime.tv_sec +
				   stats.ru_utime.tv_usec * 1e-6 +
				   stats.ru_stime.tv_sec + 
				   stats.ru_stime.tv_usec * 1e-6;

			deltausage = curusage - prevusage;
			printf ("Obtained %3.2f seconds of execution time in"
		       	      " %d elapsed seconds \n", deltausage, deltatime);
			prevtime = curtime;
			prevusage = curusage;
		}
	}
}

--6TrnltStXW4iwmi0--
