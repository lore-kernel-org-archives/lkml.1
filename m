Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbYIXR3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbYIXR3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 13:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYIXR3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 13:29:11 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:53179 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbYIXR3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 13:29:11 -0400
Date: Wed, 24 Sep 2008 21:34:59 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Joe Korty <joe.korty@ccur.com>
Cc: Roland McGrath <roland@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG, TEST PATCH] stallout race between SIGCONT and SIGSTOP
Message-ID: <20080924173459.GA5426@tv-sign.ru>
References: <20080923155331.GA20380@tsunami.ccur.com> <20080923163530.GA656@tv-sign.ru> <20080924150541.GA119@tv-sign.ru> <20080924151933.GA17531@tsunami.ccur.com> <20080924155611.GA5334@tv-sign.ru> <20080924171143.GA18733@tsunami.ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924171143.GA18733@tsunami.ccur.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24, Joe Korty wrote:
>
> On Wed, Sep 24, 2008 at 11:56:11AM -0400, Oleg Nesterov wrote:
> > Confused. Do you agree the kernel is not buggy?
>
> I agree with you that what the kernel is doing now is correct.

Great. Thanks a lot for the report and discussion! And thanks
for your analysis (sent privately), the problem was completely
explained by you.

BTW, I forgot to show the test-case you sent me privately, perhaps
someone from CC might want to look... It really helped.

Oleg.

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/select.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#define NUMSTOPS 10

int child_stopped = 0;
int waiting = 1;

void handler(int signo, siginfo_t *info, void *context) 
{
	if (info && info->si_code == CLD_STOPPED) {
		printf("Child has been stopped\n");
		waiting = 0;
		child_stopped++;
	}
}


int main(void)
{
	pid_t pid;
	struct sigaction act;
	struct timeval tv;

	act.sa_sigaction = handler;
	act.sa_flags = SA_SIGINFO;
	sigemptyset(&act.sa_mask);
	sigaction(SIGCHLD,  &act, 0);     

	setbuf(stdout, NULL);
	printf("%d SIGSTOP/SIGCONT combinations to be sent.\n", NUMSTOPS);

	if ((pid = fork()) == 0) {
		/* child */
		while(1) {
			/* wait forever, or until we are 
			   interrupted by a signal */
			tv.tv_sec = 0;
			tv.tv_usec = 0;
			select(0, NULL, NULL, NULL, &tv);
		}
		return 0;
	} else {
		/* parent */
		int s; 		
		int i;

		usleep(12000);
		for (i = 0; i < NUMSTOPS; i++) {
			waiting = 1;

			printf("--> Sending SIGSTOP #%d\n", i);
			kill(pid, SIGSTOP);

			/*
			  Don't let the kernel optimize away queued
			  SIGSTOP/SIGCONT signals.
			*/
			while (waiting)
				usleep(12000);

			printf("--> Sending SIGCONT\n");
			kill(pid, SIGCONT);
			// usleep(12000);
		}

		/* POSIX specifies default action to be abnormal termination */
		usleep(12000);
		kill(pid, SIGKILL);
		waitpid(pid, &s, 0);
	}

	if (child_stopped == NUMSTOPS) {
		printf("Test PASSED\n");
		return 0;
	}

	printf("Test FAILED\n");
	return -1;
}

