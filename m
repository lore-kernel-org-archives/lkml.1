Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYJ0PEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYJ0PEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYJ0PEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:04:46 -0400
Received: from host0.dyn.jankratochvil.net ([89.250.240.59]:47565 "EHLO
	host0.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbYJ0PEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:04:45 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2008 11:04:44 EDT
Date: Mon, 27 Oct 2008 15:56:48 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: inconsistent behavior with ptrace(TRACEME) and fork/exec
Message-ID: <20081027145648.GA15791@host0.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, 19 Jul 2006 21:18:29 +0200, Mike Frysinger wrote:
> my understanding is that if a parent forks and the child does
> a ptrace(TRACEME) right before doing an exec(), the kernel should always
> halt it and wait indefinitely for the parent to start ptracing it.

Yes, just the parent must process the event (signal).  In your testcase the
parent finished before the signal could be delivered.  If the tracer exits the
tracee's tracing is finished and it continues freely.


> unfortunately, this behavior seems to be unreliable.

Fixed the races in your code and I do not see there any problem, do you?
The ptrace problems/testsuite is being maintained at:
  http://sourceware.org/systemtap/wiki/utrace/tests


Regards,
Jan

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ptrace-vfork-traceme.c"

#define _GNU_SOURCE
#include <errno.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ptrace.h>
#include <sys/wait.h>

#define fail(msg, args...) \
do { \
	fprintf(stderr, "FAIL:%i: " msg "\n", __LINE__, ## args); \
	exit(1); \
} while (0)

static void child_exit(int sig)
{
	int status;
#if 0 /* Correct behavior.  */
	printf("failure, child exited with %i: %s\n", sig, strsignal(sig));
#endif
	printf("wait() = %i\n", wait(&status));
	printf("status = 0x%x\n", status);
	printf("\tWIFEXITED = %i\n", WIFEXITED(status));
	printf("\tWEXITSTATUS = %i\n", WEXITSTATUS(status));
	printf("\tWIFSIGNALED = %i\n", WIFSIGNALED(status));
	printf("\tWTERMSIG = %i (%s)\n", WTERMSIG(status), strsignal(WTERMSIG(status)));
	/* WIFSTOPPED happens.  */
	printf("\tWIFSTOPPED = %i\n", WIFSTOPPED(status));
	/* SIGTRAP happens.  */
	printf("\tWSTOPSIG = %i (%s)\n", WSTOPSIG(status), strsignal(WSTOPSIG(status)));
#if 0 /* We can continue.  Just calling printf() from a signal handler is not
	 correct.  */
	exit(1);
#endif
}

int main(int argc, char *argv[])
{
	long pret;
	pid_t pid;

	/* child process ... shouldnt be executed, but just in case ... */
	if (argc > 1 && !strcmp(argv[1], "child"))
#if 0 /* Parent did not kill us, after its child_exit() messages we should get
         here.  */
		fail("kernel should have halted me...");
#else
		{ puts ("child exiting"); exit (0); }
#endif

	/* vfork() child must not call ptrace().  */
	pid = fork();
	if (pid == -1)
		fail("vfork() didnt work: %m");
	else if (!pid) {
		/* do the child stuff here */
		errno = 0;
		pret = ptrace(PTRACE_TRACEME, 0, NULL, NULL);
		if (pret && errno)
			fail("ptrace(PTRACE_TRACEME) = %li: %m", pret);

		int eret = execlp(argv[0], argv[0], "child", NULL);
		fail("execlp() = %i", eret);
	}

	/* do the parent stuff here */
	signal(SIGCHLD, child_exit);

	/* We cannot PTRACE_PEEKUSER here as the child still may not have
	   called PTRACE_TRACEME.  */
	pause ();

	errno = 0;
	pret = ptrace(PTRACE_PEEKUSER, pid, NULL, NULL);
	if (pret && errno)
		fail("ptrace(PTRACE_PEEKUSER, %i) = %li: %m", pid, pret);

	puts("SUCCESS! :D");

	return 0;
}

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ptrace-vfork-traceme.c.patch"

--- ptrace-vfork-traceme.c-orig	2008-10-27 15:41:51.000000000 +0100
+++ ptrace-vfork-traceme.c	2008-10-27 15:47:05.000000000 +0100
@@ -18,14 +18,23 @@ do { \
 static void child_exit(int sig)
 {
 	int status;
+#if 0 /* Correct behavior.  */
 	printf("failure, child exited with %i: %s\n", sig, strsignal(sig));
+#endif
 	printf("wait() = %i\n", wait(&status));
-	printf("status = %i\n", status);
+	printf("status = 0x%x\n", status);
 	printf("\tWIFEXITED = %i\n", WIFEXITED(status));
 	printf("\tWEXITSTATUS = %i\n", WEXITSTATUS(status));
 	printf("\tWIFSIGNALED = %i\n", WIFSIGNALED(status));
 	printf("\tWTERMSIG = %i (%s)\n", WTERMSIG(status), strsignal(WTERMSIG(status)));
+	/* WIFSTOPPED happens.  */
+	printf("\tWIFSTOPPED = %i\n", WIFSTOPPED(status));
+	/* SIGTRAP happens.  */
+	printf("\tWSTOPSIG = %i (%s)\n", WSTOPSIG(status), strsignal(WSTOPSIG(status)));
+#if 0 /* We can continue.  Just calling printf() from a signal handler is not
+	 correct.  */
 	exit(1);
+#endif
 }
 
 int main(int argc, char *argv[])
@@ -35,9 +44,15 @@ int main(int argc, char *argv[])
 
 	/* child process ... shouldnt be executed, but just in case ... */
 	if (argc > 1 && !strcmp(argv[1], "child"))
+#if 0 /* Parent did not kill us, after its child_exit() messages we should get
+         here.  */
 		fail("kernel should have halted me...");
+#else
+		{ puts ("child exiting"); exit (0); }
+#endif
 
-	pid = vfork();
+	/* vfork() child must not call ptrace().  */
+	pid = fork();
 	if (pid == -1)
 		fail("vfork() didnt work: %m");
 	else if (!pid) {
@@ -54,6 +69,10 @@ int main(int argc, char *argv[])
 	/* do the parent stuff here */
 	signal(SIGCHLD, child_exit);
 
+	/* We cannot PTRACE_PEEKUSER here as the child still may not have
+	   called PTRACE_TRACEME.  */
+	pause ();
+
 	errno = 0;
 	pret = ptrace(PTRACE_PEEKUSER, pid, NULL, NULL);
 	if (pret && errno)

--k+w/mQv8wyuph6w0--
