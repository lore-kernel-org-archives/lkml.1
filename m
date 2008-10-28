Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYJ1O65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYJ1O65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYJ1O6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:58:49 -0400
Received: from host0.dyn.jankratochvil.net ([89.250.240.59]:35990 "EHLO
	host0.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbYJ1O6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:58:48 -0400
Date: Tue, 28 Oct 2008 15:58:32 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: inconsistent behavior with ptrace(TRACEME) and fork/exec
Message-ID: <20081028145832.GA9211@host0.dyn.jankratochvil.net>
References: <20081027145648.GA15791@host0.dyn.jankratochvil.net> <8bd0f97a0810271038g4f0b7326r68c7e88841d0e6f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <8bd0f97a0810271038g4f0b7326r68c7e88841d0e6f9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

sorry I had a race with signal()/pause() in my last post, fixed here.


On Mon, 27 Oct 2008 18:38:16 +0100, Mike Frysinger wrote:
> On Mon, Oct 27, 2008 at 10:56, Jan Kratochvil wrote:
> > On Wed, 19 Jul 2006 21:18:29 +0200, Mike Frysinger wrote:
> >> my understanding is that if a parent forks and the child does
> >> a ptrace(TRACEME) right before doing an exec(), the kernel should always
> >> halt it and wait indefinitely for the parent to start ptracing it.
> >
> > Yes, just the parent must process the event (signal).  In your testcase the
> > parent finished before the signal could be delivered.  If the tracer exits the
> > tracee's tracing is finished and it continues freely.
> 
> no signal should have been generated.  the child should have gone
> straight to the exec and waited for the parent to process it.

Every ptrace event generates SIGCHLD.  vfork() frees the parent at the moment
the child calls exec() or _exit().  Here the child calls exec() which both
frees the parent to continue the execution AND delivers SIGCHLD with the
status WIFSTOPPED WSTOPSIG(SIGTRAP) to it.  I do not see a problem here.


> >> unfortunately, this behavior seems to be unreliable.
> >
> > Fixed the races in your code and I do not see there any problem, do you?
> > The ptrace problems/testsuite is being maintained at:
> >  http://sourceware.org/systemtap/wiki/utrace/tests
> 
> there is no race condition ... it's using vfork here remember ?

Yes but you said that you see the same problem even with fork():

On Wed, 19 Jul 2006 21:18:29 +0200, Mike Frysinger wrote:
# also, while the attached test uses vfork(), same behavior can be observed
# with fork().  


> it is impossible for the parent to have executed anything after the vfork()
> before the child made it into the exec() and gone to sleep

You must not rely on the vfork() specifics as vfork() can be just fork():
http://www.opengroup.org/onlinepubs/009695399/functions/vfork.html
APPLICATION USAGE


I hope there is no problem with the kernel at this moment, the attached
testcase works even with vfork() reliably.



Regards,
Jan

--0F1p//8PRICkK4MW
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
#include <assert.h>

#define fail(msg, args...) \
do { \
	fprintf(stderr, "FAIL:%i: " msg "\n", __LINE__, ## args); \
	exit(1); \
} while (0)

static volatile int caught = 0;

static void child_exit(int sig)
{
	int status;
#if 0 /* Correct behavior.  */
	printf("failure, child exited with %i: %s\n", sig, strsignal(sig));
#else
	assert(sig == SIGCHLD);
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
#else
	caught = 1;
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

	/* Setup the handler already here as after vfork() there would be
	   a race setting it up before we get signalled.  */
	signal(SIGCHLD, child_exit);

	/* vfork() child must not call ptrace().  */
	pid = vfork();
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

	/* We cannot pause() here as the signal already could occur, we would
	   have to SIG_BLOCK SIGCHLD and sigsuspend() here.  */
	while (!caught);

	errno = 0;
	pret = ptrace(PTRACE_PEEKUSER, pid, NULL, NULL);
	if (pret && errno)
		fail("ptrace(PTRACE_PEEKUSER, %i) = %li: %m", pid, pret);

	puts("SUCCESS! :D");

	return 0;
}

--0F1p//8PRICkK4MW--
