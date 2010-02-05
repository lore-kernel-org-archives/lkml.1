Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673Ab0BERlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:41:40 -0500
Received: from fe02x03-cgp.akado.ru ([77.232.31.165]:64585 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932165Ab0BERlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:41:39 -0500
X-Greylist: delayed 3609 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Feb 2010 12:41:38 EST
Date: Fri, 5 Feb 2010 19:33:59 +0300 (MSK)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Scheduler oddity
Message-ID: <alpine.LNX.2.00.1002051928230.4744@linmac>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following test exhibits somewhat odd behaviour on, at least, 2.6.32.3 
(ppc) and 2.6.29.1 (x86_64), perhaps someone could explain why.

#define _GNU_SOURCE
#include <sched.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, const char *argv[])
{
    int   pipe_fd[2];
    pid_t pid;

    if (argc == 2 && !strcmp(argv[1], "batch")) {
        int ret;
        struct sched_param p = {0};

        ret = sched_setscheduler(0, SCHED_BATCH, &p);
        if (ret) {
            perror("sched_setscheduler");
            return 1;
        }
        printf("using batch\n");
    }
    else {
        printf("using default\n");
    }

    /* create the pipe */
    if (pipe(pipe_fd) == -1) {
        perror("pipe");
        return 1;
    }

    /* fork a process that will run cat */
    pid = fork();

    if (pid == -1) {
        perror("fork");
        return 1;
    }

    if (pid == 0) {
        /* child */
        close(pipe_fd[1]); /* close the write end of the pipe */
        if (dup2(pipe_fd[0], STDIN_FILENO) == -1) {
            perror("dup2");
            return 1;
        }
        close(pipe_fd[0]);
        execl("/usr/bin/wc", "wc", "-c", NULL);
        perror("execl");
        return 1;
    } else {
        /* parent */
        int i;

        close(pipe_fd[0]); /* close the read end of the pipe */
        for (i = 0; i < 10000000; i++)
            write(pipe_fd[1], "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", 30);
        close(pipe_fd[1]);
        wait(NULL);
        return 0;
    }

    return 0;
}

~$ uname -a
Linux linmac 2.6.32.3 #4 Sun Jan 31 09:52:58 MSK 2010 ppc 7447A, altivec supported PowerMac10,2 GNU/Linux

$ gcc -o test-pipe test-pipe.c

$ \time -v ./test-pipe batch
using batch
300000000
        Command being timed: "./test-pipe batch"
        User time (seconds): 0.50
        System time (seconds): 7.47
        Percent of CPU this job got: 99%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 0:07.98
        Average shared text size (kbytes): 0
        Average unshared data size (kbytes): 0
        Average stack size (kbytes): 0
        Average total size (kbytes): 0
        Maximum resident set size (kbytes): 2496
        Average resident set size (kbytes): 0
        Major (requiring I/O) page faults: 0
        Minor (reclaiming a frame) page faults: 343
        Voluntary context switches: 9933
        Involuntary context switches: 1997
        Swaps: 0
        File system inputs: 0
        File system outputs: 0
        Socket messages sent: 0
        Socket messages received: 0
        Signals delivered: 0
        Page size (bytes): 4096
        Exit status: 0

$ \time -v ./test-pipe 
using default
300000000
        Command being timed: "./test-pipe"
        User time (seconds): 1.53
        System time (seconds): 34.74
        Percent of CPU this job got: 100%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 0:36.27
        Average shared text size (kbytes): 0
        Average unshared data size (kbytes): 0
        Average stack size (kbytes): 0
        Average total size (kbytes): 0
        Maximum resident set size (kbytes): 2496
        Average resident set size (kbytes): 0
        Major (requiring I/O) page faults: 0
        Minor (reclaiming a frame) page faults: 343
        Voluntary context switches: 9992328
        Involuntary context switches: 9994617
        Swaps: 0
        File system inputs: 0
        File system outputs: 0
        Socket messages sent: 0
        Socket messages received: 0
        Signals delivered: 0
        Page size (bytes): 4096
        Exit status: 0


P.S. The test wasn't written by me

-- 
mailto:av1474@comtv.ru
