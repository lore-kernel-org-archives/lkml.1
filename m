Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYIXPAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYIXPAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 11:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYIXO76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:59:58 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49069 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbYIXO75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:59:57 -0400
Date: Wed, 24 Sep 2008 19:05:41 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Joe Korty <joe.korty@ccur.com>
Cc: Roland McGrath <roland@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG, TEST PATCH] stallout race between SIGCONT and SIGSTOP
Message-ID: <20080924150541.GA119@tv-sign.ru>
References: <20080923155331.GA20380@tsunami.ccur.com> <20080923163530.GA656@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923163530.GA656@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23, Oleg Nesterov wrote:
>
> I will be completely offline tomorrow.

Cancelled...

> Better yet, to avoid a possible confusion, could you please send me
> the (modified) source code to re-produce the stall ?

Thanks Joe for the test-case and for your comments.

Joe says:
>
> So it looks like the test is in error, not the kernel.

and I am happy to agree.

I think sigaction/10-1.c should be fixed, please see the patch below.

In essence the code does:

	for (1 .. 10) {
		kill(pid, SIGSTOP);
		wait_until_we_receive_CLD_STOPPED(); // <---- HANGS
		kill(pid, SIGCONT);
	}

We can look at the code from the different angle, this loop does

		kill(pid, SIGCONT);
		kill(pid, SIGSTOP);
		wait_until_we_receive_CLD_STOPPED(); // <---- HANGS

and it hangs because CLD_CONTINUED (which is ignored by the SIGCHLD
handler) masks CLD_STOPPED.

And yes, the mentioned patch makes the difference. To clarify, it
does not defer the "result" of SIGCONT, it only defers the sending
of SIGCHLD with .si_code == CLD_CONTINUED.

So, what happens is:

	kill(SIGCONT) does its job, CLD_CONTINUED will be sent a
	bit later.

	kill(SIGSTOP) starts another group-stop.

	the child sends CLD_CONTINUED, and before the parent deques
	the signal, it stops and sends CLD_STOPPED.

Now, since SIGCHLD is a non-rt signal, the second SIGCHLD is lost,
and wait_until_we_receive_CLD_STOPPED() hangs.

I did the test patch to be sure:

	--- 26-rc2/kernel/signal.c~	2008-09-20 20:37:52.000000000 +0400
	+++ 26-rc2/kernel/signal.c	2008-09-24 18:43:34.000000000 +0400
	@@ -808,7 +808,7 @@ static int send_signal(int sig, struct s
		 * exactly one non-rt signal, so that we can get more
		 * detailed information about the cause of the signal.
		 */
	-	if (legacy_queue(pending, sig))
	+	if (sig != SIGCHLD && legacy_queue(pending, sig))
			return 0;
		/*
		 * fast-pathed signals for kernel-internal things like SIGSTOP

and now your test-case doesn't hang.

Oleg.

--- tmp/posixtestsuite/conformance/interfaces/sigaction/10-1.c~	2003-04-15 01:18:58.000000000 +0400
+++ tmp/posixtestsuite/conformance/interfaces/sigaction/10-1.c	2008-09-24 18:01:23.000000000 +0400
@@ -19,19 +19,41 @@
 #define NUMSTOPS 10
 
 int child_stopped = 0;
-int waiting = 1;
+int child_continued = 0;
+int notification;
 
-void handler(int signo, siginfo_t *info, void *context) 
+void handler(int signo, siginfo_t *info, void *context)
 {
-	if (info && info->si_code == CLD_STOPPED) {
+	if (!info)
+		return;
+
+	notification = info->si_code;
+
+	switch (notification) {
+	case CLD_STOPPED:
 		printf("Child has been stopped\n");
-		waiting = 0;
 		child_stopped++;
+		break;
+	case CLD_CONTINUED:
+		printf("Child has been continued\n");
+		child_continued++;
+		break;
 	}
 }
 
+void wait_for_notification(int val)
+{
+	struct timeval tv;
+
+	while (notification != val) {
+		tv.tv_sec = 1;
+		tv.tv_usec = 0;
+		if (!select(0, NULL, NULL, NULL, &tv))
+			break;
+	}
+}
 
-int main()
+int main(void)
 {
 	pid_t pid;
 	struct sigaction act;
@@ -40,7 +62,7 @@ int main()
 	act.sa_sigaction = handler;
 	act.sa_flags = SA_SIGINFO;
 	sigemptyset(&act.sa_mask);
-	sigaction(SIGCHLD,  &act, 0);     
+	sigaction(SIGCHLD,  &act, 0);
 
 	if ((pid = fork()) == 0) {
 		/* child */
@@ -54,37 +76,36 @@ int main()
 		return 0;
 	} else {
 		/* parent */
-		int s; 		
+		int s;
 		int i;
 
 		for (i = 0; i < NUMSTOPS; i++) {
-			waiting = 1;
-
 			printf("--> Sending SIGSTOP\n");
+			notification = 0;
 			kill(pid, SIGSTOP);
 
 			/*
 			  Don't let the kernel optimize away queued
 			  SIGSTOP/SIGCONT signals.
 			*/
-			while (waiting) {
-				tv.tv_sec = 1;
-				tv.tv_usec = 0;
-				if (!select(0, NULL, NULL, NULL, &tv))
-				  break;
-			}
-
+			wait_for_notification(CLD_STOPPED);
 
 			printf("--> Sending SIGCONT\n");
+			notification = 0;
 			kill(pid, SIGCONT);
+			/*
+			  SIGCHLD doesn't queue, make sure CLD_CONTINUED
+			  doesn't mask the next CLD_STOPPED
+			*/
+			wait_for_notification(CLD_CONTINUED);
 		}
-		
+
 		/* POSIX specifies default action to be abnormal termination */
 		kill(pid, SIGHUP);
 		waitpid(pid, &s, 0);
 	}
 
-	if (child_stopped == NUMSTOPS) {
+	if (child_stopped == NUMSTOPS && child_continued == NUMSTOPS) {
 		printf("Test PASSED\n");
 		return 0;
 	}
@@ -92,4 +113,3 @@ int main()
 	printf("Test FAILED\n");
 	return -1;
 }
-

