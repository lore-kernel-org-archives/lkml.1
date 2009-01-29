Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbZA2Vf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbZA2Vf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZA2VfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:35:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60379 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbZA2VfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:35:10 -0500
Message-ID: <49822105.1030106@redhat.com>
Date: Thu, 29 Jan 2009 15:35:01 -0600
From: David Smith <dsmith@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Roland McGrath <roland@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [2.6.29-rc2 regression] CRED changes causing setuid failures
Content-Type: multipart/mixed;
 boundary="------------090400040303010501080102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090400040303010501080102
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I'm seeing setuid problems with 2.6.29-rc2.  I've narrowed the problem
down to the 2 attached test files.  test1, a setuid root program drops
root euid (by calling setresuid()), then execs test2 (a non-setuid
program).  Test2 then execs test1, but test1's euid isn't set back to 0
as it should be.

After doing a git bisect, here's the change that causes the problem:

commit d84f4f992cbd76e8f39c488cf0c5d123843923b1
Author: David Howells <dhowells@redhat.com>
Date:   Fri Nov 14 10:39:23 2008 +1100

    CRED: Inaugurate COW credentials

I believe this regression is tied to the fact that test2 creates a 2nd
thread (that does nothing).  Without the 2nd thread, the test runs
correctly.

-- 
David Smith
dsmith@redhat.com
Red Hat
http://www.redhat.com
256.217.0141 (direct)
256.837.0057 (fax)

--------------090400040303010501080102
Content-Type: text/x-csrc;
 name="test1.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test1.c"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <string.h>
#include <stdint.h>
#include <signal.h>
#include <errno.h>
#include <sys/wait.h>

int delete_mod = 0;

static int run_as(uid_t uid, gid_t gid, const char *path, char *const argv[])
{
    int i = 0;
    fprintf(stderr, "execing: ");
    while (argv[i]) {
	fprintf(stderr, "%s ", argv[i]);
	i++;
    }
    fprintf(stderr, "\n");

    /* Make sure we run as the full user.  If we're
     * switching to a non-root user, this won't allow
     * that process to switch back to root (since the
     * original process is setuid). */
    if (setresgid (gid, gid, gid) < 0) {
	perror("setresgid");
	exit(1);
    }
    if (setresuid (uid, uid, uid) < 0) {
	perror("setresuid");
	exit(1);
    }

    /* Actually run the command. */
    if (execv(path, argv) < 0)
	perror(path);
    _exit(1);
    return -1;
}


int main(int argc, char **argv)
{
    char *prog = argv[0];
    char *newargv[2];

    if (argc > 1)
	delete_mod = 1;

    fprintf(stderr, "%s: uid = %d, euid = %d\n", prog, (int)getuid(),
	    (int)geteuid());
    if (geteuid() != 0) {
	fprintf(stderr, "%s: ERROR - The effective user ID isn't root!\n",
		prog);
	exit(1);
    }

    if (delete_mod)
	exit(0);

    newargv[0] = "./test2";
    newargv[1] = NULL;
    if (run_as (getuid(), getgid(), newargv[0], newargv) < 0) {
	perror(argv[0]);
	return 1;
    }
    return 0;
}

--------------090400040303010501080102
Content-Type: text/x-csrc;
 name="test2.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test2.c"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <string.h>
#include <stdint.h>
#include <signal.h>
#include <errno.h>
#include <pthread.h>
#include <sys/wait.h>

static void *thread_func(void *arg __attribute__ ((unused)))
{
    while (1) {
	/* do nothing */
    }
    return NULL;
}

static void setup_main_signals(void)
{
    pthread_t tid;
    struct sigaction sa;
    sigset_t *s = malloc(sizeof(*s));
    if (!s) {
	perror("malloc");
	exit(1);
    }
    sigfillset(s);
    pthread_sigmask(SIG_SETMASK, s, NULL);

    memset(&sa, 0, sizeof(sa));
    sigfillset(&sa.sa_mask);
    sa.sa_handler = SIG_IGN;
    sigaction(SIGINT, &sa, NULL);
    sigaction(SIGTERM, &sa, NULL);
    sigaction(SIGHUP, &sa, NULL);
    sigaction(SIGQUIT, &sa, NULL);

    sigemptyset(s);
    sigaddset(s, SIGINT);
    sigaddset(s, SIGTERM);
    sigaddset(s, SIGHUP);
    sigaddset(s, SIGQUIT);
    pthread_sigmask(SIG_SETMASK, s, NULL);
    if (pthread_create(&tid, NULL, thread_func, s) < 0) {
	perror("pthread_create");
	exit(1);
    }
}

void cleanup_and_exit(void)
{
    const char *test1 = "./test1";
    fprintf(stderr, "cleanup and exit\n");
    if (execlp(test1, basename (test1), "-d", NULL) < 0) {
	perror(test1);
	_exit(1);
    }
    _exit(0);
}

int main(int argc __attribute__ ((unused)), char **argv)
{
    char *prog = argv[0];

    fprintf(stderr, "%s: uid = %d, euid = %d\n", prog, (int)getuid(),
	    (int)geteuid());

    setup_main_signals();

    cleanup_and_exit();
    return 0;
}

--------------090400040303010501080102
Content-Type: text/plain;
 name="Makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Makefile"

CFLAGS = -D_GNU_SOURCE -Wall -Werror -Wunused
all: test1 test2

test1: test1.c
	gcc $(CFLAGS) -o test1 test1.c
	sudo chown root.root test1
	sudo chmod +s test1

test2: test2.c
	gcc $(CFLAGS) -o test2 test2.c -lpthread

clean:
	rm -f *.o test1 test2

--------------090400040303010501080102--
