Return-Path: <linux-kernel-owner+w=401wt.eu-S1761186AbXGKJLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186AbXGKJLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbXGKJK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:10:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:9932 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbXGKJK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:10:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZQS6GeYw2SP8lB4jFG6dUU12D0oocHTWtdHSCAeKuh7vMSrOvg7CroyGHobwaSmfjt7AFx05ESNxXOtwSnZhZH43KPy6jcO8mmXATomuQee/7ewv2kOxriw4SADgoTF56Krt1IJFXPGsuTy6OtuVgCG+Zc6DT/m1zfoAYBdaAkc=
Subject: Re: [PATCH] signals: real-time signals delivery order
From: Anton Salikhmetov <salikhmetov@gmail.com>
Reply-To: salikhmetov@gmail.com
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <loom.20070711T092936-151@post.gmane.org>
References: <1184116335.19893.12.camel@localhost>
	 <loom.20070711T092936-151@post.gmane.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Jul 2007 13:10:50 +0400
Message-Id: <1184145051.7491.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

В Срд, 11/07/2007 в 07:34 +0000, Matthieu CASTET пишет:
> Anton Salikhmetov <salikhmetov <at> gmail.com> writes:
> 
> > 
> > From: Anton Salikhmetov <salikhmetov <at> gmail.com>
> > 
> > According to the POSIX standard, multiple real-time signals
> > pending to a process should be delivered in a strict order.
> > Specifically, the lowest-numbered signal should be delivered
> > first and multiple occurrences of signals with the same number
> > should be delivered in FIFO order.
> > 
> > Current Linux kernel delivers the highest-numbered signals
> > pending to a process first, not the lowest-numbered ones. This
> > contradicts to the requirement explained above. The problem can
> > be demonstrated by the following test program:
> I believe you should check that you mask or signal in your signal handler.
> If you don't the high-prio handler will be prempted by low-prio, and they will
> be executed in the reverse order.
> 

Thanks, I have modified the test program blocking the signals for the
duration of the signal handler as follows:

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define SIG_RAND (SIGRTMIN + rand() % (SIGRTMAX - SIGRTMIN + 1))
#define NUMSIG 7

struct {
	int sig, num;
} seq[NUMSIG];

void sh(int sig, siginfo_t *info, void *unused)
{
	static int cnt;
	seq[cnt].num = info->si_value.sival_int;
	seq[cnt++].sig = sig;
}

int main(int argc, char *argv[])
{
	int i;
	pid_t p = getpid();
	struct sigaction sa;
	sigset_t ss, ssold;
	union sigval sv;

	sigemptyset(&ss);
	for (i = SIGRTMIN; i <= SIGRTMAX; i++) {
		sa.sa_sigaction = sh;
		sa.sa_flags = SA_SIGINFO;
		sigfillset(&sa.sa_mask);
		sigaction(i, &sa, NULL);
		sigaddset(&ss, i);
	}

	sigprocmask(SIG_BLOCK, &ss, &ssold);
	switch (fork()) {
		case -1:
			perror("fork()");
			return 1;
		case 0:
			srand(time(NULL));
			for (i = 0; i < NUMSIG; i++) {
				sv.sival_int = i;
				sigqueue(p, SIG_RAND, sv);
			}
			return 0;
		default:
			wait(NULL);
	}
	sigprocmask(SIG_SETMASK, &ssold, NULL);

	for (i = 0; i < NUMSIG; i++)
		printf("SIGRTMIN + %2d, sent with number %d\n",
			seq[i].sig - SIGRTMIN, seq[i].num);
	return 0;
}

This modified program works correctly with the original kernel:

SIGRTMIN +  2, sent with number 5
SIGRTMIN +  3, sent with number 2
SIGRTMIN + 10, sent with number 6
SIGRTMIN + 16, sent with number 3
SIGRTMIN + 17, sent with number 4
SIGRTMIN + 18, sent with number 0
SIGRTMIN + 29, sent with number 1

I would like to explain why I got an impression the next_signal()
funtion did not work correctly. When I ran the old test program using a
vendor-specific heavily patched kernel the signals order was as the
POSIX standard specified. Another kernel, which was closer to the
vanilla kernel, did not show the expected behavior. Instead, the signals
were handled in the reversed order.

Sorry for making noise in the mailing list.

Anton

> 
> Matthieu 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

