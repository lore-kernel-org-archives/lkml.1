Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbXGKBMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbXGKBMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 21:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758842AbXGKBMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 21:12:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:31849 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758840AbXGKBMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 21:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QosA+fzjP8H1/8XFCIuSFuALjnexJ1cXAkFRcbFhogn/jLr9YMSI7P388Gunxjk3+q9uit4tDL+CwPCUjjuF6Hx1fPVN4LCcEWLdtPf8xliXGSiSLliUmn4hMdZR6SVF3qJCoQGTgOxC+N3nHYwj/jpYpaJpQPFdcYN6JFw+cL0=
Subject: [PATCH] signals: real-time signals delivery order
From: Anton Salikhmetov <salikhmetov@gmail.com>
Reply-To: salikhmetov@gmail.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 11 Jul 2007 05:12:15 +0400
Message-Id: <1184116335.19893.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Salikhmetov <salikhmetov@gmail.com>

According to the POSIX standard, multiple real-time signals
pending to a process should be delivered in a strict order.
Specifically, the lowest-numbered signal should be delivered
first and multiple occurrences of signals with the same number
should be delivered in FIFO order.

Current Linux kernel delivers the highest-numbered signals
pending to a process first, not the lowest-numbered ones. This
contradicts to the requirement explained above. The problem can
be demonstrated by the following test program:

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
		sigemptyset(&sa.sa_mask);
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

Example of the program output for the original kernel:

SIGRTMIN + 23, sent with number 0
SIGRTMIN + 21, sent with number 1
SIGRTMIN + 21, sent with number 6
SIGRTMIN + 16, sent with number 2
SIGRTMIN + 15, sent with number 3
SIGRTMIN + 14, sent with number 4
SIGRTMIN +  5, sent with number 5

Example of the program output for the patched kernel:

SIGRTMIN + 2, sent with number 1
SIGRTMIN + 3, sent with number 0
SIGRTMIN + 17, sent with number 3
SIGRTMIN + 23, sent with number 5
SIGRTMIN + 25, sent with number 2
SIGRTMIN + 29, sent with number 6
SIGRTMIN + 30, sent with number 4

Patch for the Linux 2.6.22.1 kernel:

Signed-off-by: Anton Salikhmetov <salikhmetov@gmail.com>
---
--- linux-2.6.22.1.orig/kernel/signal.c	2007-07-10 22:56:30.000000000
+0400
+++ linux-2.6.22.1/kernel/signal.c	2007-07-11 04:42:17.000000000 +0400
@@ -134,34 +134,11 @@
 
 int next_signal(struct sigpending *pending, sigset_t *mask)
 {
-	unsigned long i, *s, *m, x;
-	int sig = 0;
-	
-	s = pending->signal.sig;
-	m = mask->sig;
-	switch (_NSIG_WORDS) {
-	default:
-		for (i = 0; i < _NSIG_WORDS; ++i, ++s, ++m)
-			if ((x = *s &~ *m) != 0) {
-				sig = ffz(~x) + i*_NSIG_BPW + 1;
-				break;
-			}
-		break;
-
-	case 2: if ((x = s[0] &~ m[0]) != 0)
-			sig = 1;
-		else if ((x = s[1] &~ m[1]) != 0)
-			sig = _NSIG_BPW + 1;
-		else
-			break;
-		sig += ffz(~x);
-		break;
-
-	case 1: if ((x = *s &~ *m) != 0)
-			sig = ffz(~x) + 1;
-		break;
-	}
-	
+	unsigned long *s = pending->signal.sig, *m = mask->sig, x;
+	int sig = 0, i;
+	for (i = 0; i < _NSIG_WORDS; i++, s++, m++)
+		if ((x = (*s & ~*m)))
+			sig = fls(x) + i * _NSIG_BPW;
 	return sig;
 }

