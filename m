Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYGaOgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYGaOgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYGaOgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:36:23 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58300 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbYGaOgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:36:22 -0400
Date: Thu, 31 Jul 2008 09:36:02 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Roland McGrath <roland@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Bug in 2b2a1ff64afbadac842bbc58c5166962cf4f7664 ?
Message-ID: <20080731143602.GA28700@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ea5b3ea0dbdb8b9f9ef73e639517cf4805cf2e6f Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Thu, 31 Jul 2008 07:29:14 -0700
Subject: [PATCH 1/1] notify parent of death

Commit 2b2a1ff64afbadac842bbc58c5166962cf4f7664
("tracehook: death" by ROland McGrath on Jul 25) included a change
that apparently causes parents not to be notified of child death
in normal circumstances.  In particular the following testcase
fails without this patch.  (I'm sure this patch is wrong, but
hopefully it illustrates where a real problem might hide).

Before commit 2b2a1ff64afbadac842bbc58c5166962cf4f7664, calling
this program testwait.c and running
	# ./testwait /bin/sh
	  # exit
would succeed.  Ever since that commit, exiting the shell makes
it defunct.  With the following patch, it again appears to
properly exit, and my test machine seems to suffer no ill effects
from the patch - though I haven't run ltp since as I say I doubt
the patch is the right solution.

More likely the last line in tracehook_notify_death() isn't
quite right.

thanks,
-serge

 #include <stdio.h>
 #include <stdlib.h>
 #include <sched.h>
 #include <sys/syscall.h>
 #include <unistd.h>
 #include <signal.h>
 #include <string.h>
 #include <errno.h>
 #include <libgen.h>
 #include <fcntl.h>
 #include <sys/types.h>
 #include <sys/wait.h>

extern pid_t getpgid(pid_t pid);
extern pid_t getsid(pid_t pid);

static const char* procname;

int do_child(void *vargv)
{
        char **argv = (char **)vargv;
        execve(argv[0], argv, __environ);
        perror("execve");
        return 1;
}

int main(int argc, char *argv[])
{
        int c;
        int ret, use_clone = 0;
        int pid;
        int status;

        argv = &argv[optind];
        argc = argc - optind;

        int stacksize = 4*getpagesize();
        void *childstack, *stack = malloc(stacksize);

        if (!stack) {
                perror("malloc");
                return -1;
        }
        childstack = stack + stacksize;

        pid = clone(do_child, childstack, 0, (void *)argv);
        if (pid == -1) {
                perror("clone");
                return -1;
        }
        if ((ret = waitpid(pid, &status, __WALL)) < 0)
                printf("waitpid() returns %d, errno %d\n", ret, errno);

        exit(0);
}

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 kernel/exit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 6cdf607..847fa12 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -924,7 +924,7 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 		tsk->exit_signal = SIGCHLD;
 
 	signal = tracehook_notify_death(tsk, &cookie, group_dead);
-	if (signal > 0)
+	if (signal >= 0)
 		signal = do_notify_parent(tsk, signal);
 
 	tsk->exit_state = signal < 0 ? EXIT_DEAD : EXIT_ZOMBIE;
-- 
1.5.3.6

