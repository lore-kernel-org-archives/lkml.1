Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbXLEQyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbXLEQyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbXLEQxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:53:48 -0500
Received: from styx.suse.cz ([82.119.242.94]:58107 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754212AbXLEQxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:53:46 -0500
Message-ID: <4756D87A.3060103@suse.cz>
Date: Wed, 05 Dec 2007 17:57:30 +0100
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE CR, s.r.o.
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] prevent sending wrong signals to a traced process whose
 tracer gets killed
References: <1196774846.19677.3.camel@elijah.suse.cz>
In-Reply-To: <1196774846.19677.3.camel@elijah.suse.cz>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------080702010208050103010601"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080702010208050103010601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Petr Tesarik wrote:
> Hi,
> 
> I experienced troubles when tracing a process with strace. Sometimes,
> when I killed the strace process (SIGKILL), the traced process was also
> killed. I found out that it was getting SIGTRAP and, indeed, when the
> traced process set up a signal handler for SIGTRAP, it no longer died.
> 
> I noticed that normally, when the traced process is continued (via
> PTRACE_CONT or similar), the signal to be sent to it is stored in
> current->exit_code, which is then examined by the arch-specific code and
> usually leads to something like:
> 
>                 send_sig(current->exit_code, current, 1);
> 
> The exit_code is set in ptrace_stop(), but the tracing process may go
> away while the traced process waits for it, and in that case exit_code
> is left as-is. I think we must set it to zero in ptrace_untrace().

My patch was very wrong, but at least I produced a test case. It fails
on all systems I could test. The only correct solution (TM) could be
achieved if we could tell the tracee in ptrace_stop() that the tracer
actually died and it should use nostop_code instead of exit_code.
Possibly a new flag?

Regards,
Petr Tesarik


--------------080702010208050103010601
Content-Type: text/x-csrc;
 name="tracerkill.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tracerkill.c"

/*
 * Author: Petr Tesarik <ptesarik@suse.cz>
 *
 * This program tests what happens when the tracer goes away while
 * the tracee is waiting for it.
 *
 * A successful run should produce output like this:
 *
 * Started child 4206
 * Attached process 4206
 * 
 * OK
 * Parent terminated with exit code 0
 *
 * A failed run looks like this:
 *
 * Started child 4318
 * Attached process 4318
 * Parent terminated with exit code 0
 * Child died unexpectedly
 *
 * The exit status is:
 *   0 (TEST_OK)	success
 *   1 (TEST_FAILED)	the test failed
 *   2 (TEST_ABORTED)	unexpected failure prevented the test
 *			to be performed
 */

#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <sys/time.h>
#include <time.h>
#include <signal.h>
#include <sys/ptrace.h>

#define TEST_OK      0
#define TEST_FAILED  1
#define TEST_ABORTED 2

int run_child()
{
	struct timeval tv;

	if (ptrace(PTRACE_TRACEME, 0, 0, 0)) {
		perror("PTRACE_TRACEME");
		return TEST_ABORTED;
	}
	raise(SIGSTOP);

	gettimeofday(&tv, NULL);

	puts("\nOK");
	return TEST_OK;
}

int ptrace_wait(pid_t pid, char *who)
{
	int status;

	if (waitpid(pid, &status, WUNTRACED) == -1) {
		perror("waitpid for ptrace");
		return TEST_ABORTED;
	}

	if (WIFEXITED(status)) {
		printf("%s terminated with code %d\n",
		       who, WEXITSTATUS(status));
		return WEXITSTATUS(status);
	} else if (WIFSIGNALED(status)) {
		printf("%s got signal %d\n", who, WTERMSIG(status));
		return TEST_ABORTED;
	} else if (!WIFSTOPPED(status)) {
		printf("%s died with status %d\n", who, status);
		return TEST_ABORTED;
	}

	return TEST_OK;
}

int run_parent()
{
	pid_t childpid;
	int ret;

	if (!(childpid = fork()))
		return run_child();

	printf("Started child %d\n", childpid);

	if ((ret = ptrace_wait(childpid, "Child")))
		return ret;

	printf("Attached process %d\n", childpid);

	if (ptrace(PTRACE_SYSCALL, childpid, 0, SIGCONT)) {
		perror("PTRACE_SYSCALL child");
		return TEST_ABORTED;
	}

	/* The rest of this function is artificial, but I
	 * could achieve similar effects by sending a SIGKILL
	 * to strace of a heavily multithreaded application.
	 */

	/* Give the child some time to get into TASK_TRACED */
	sleep(1);
	/* do not detach from child and exit */
	return TEST_OK;
}

#define BUFSIZE	512

int copy_stdout(int fd)
{
	FILE *f;
	static char line[BUFSIZE];
	int ret = TEST_FAILED;

	if (! (f = fdopen(fd, "r"))) {
		perror("fdopen");
		return TEST_ABORTED;
	}

	while (fgets(line, BUFSIZE, f)) {
		if (!strcmp(line, "OK\n"))
			ret = TEST_OK;
		fputs(line, stdout);
	}

	return ret;
}

int run_checker(pid_t pid, int fd)
{
	int status;
	int ret;

	ret = copy_stdout(fd);

	/* Wait for the parent process to terminate */
	if (waitpid(pid, &status, 0) == -1) {
		perror("waitpid parent");
		return TEST_ABORTED;
	}

	if (WIFEXITED(status)) {
		int exitcode = WEXITSTATUS(status);

		printf("Parent terminated with exit code %d\n", exitcode);
		if (exitcode == TEST_OK && ret == TEST_FAILED)
			printf("Child died unexpectedly\n");
		if (ret < exitcode)
			ret = exitcode;
	} else {
		if (WIFSIGNALED(status))
			printf("Parent got signal %d\n", WTERMSIG(status));
		else
			printf("Parent died with status %d\n", status);
		if (ret < TEST_ABORTED)
			ret = TEST_ABORTED;
	}

	return ret;
}

int main()
{
	pid_t pid;
	int fds[2];

	if (pipe(fds)) {
		perror("pipe");
		return TEST_ABORTED;
	}

	if ((pid = fork())) {
		/* If closing the write side of the pipe fails,
		 * copy_stdout() will never reach EOF, so this
		 * is fairly important.
		 */
		if (close(fds[1])) {
			perror("close");
			return TEST_ABORTED;
		}

		return run_checker(pid, fds[0]);
	} else {
		if (dup2(fds[1], 1) == -1) {
			perror("dup2");
			return TEST_ABORTED;
		}
		setlinebuf(stdout);

		/* I don't care if these closes fail... */
		close(fds[0]);
		close(fds[1]);

		return run_parent();
	}
}

--------------080702010208050103010601--
