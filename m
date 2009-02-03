Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZBCWqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZBCWqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZBCWqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:46:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:2117 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZBCWqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:46:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VYk7OXPOPJB/5/Nnxjhi8teDtokzc/9Sn739vqvRSr+9mHloDhVHUfcMsaI/TkkqeF
         +7LltgBKrZ9w9z9JHGBm00LHigR31xv32ydkflXkkOZ5T4g5JMv8EM2hFvDTGkOwRDP4
         XBoNjqVFoH3XkhFjOTAPW9cA0/p6Sf1XhoVyA=
MIME-Version: 1.0
Date: Tue, 3 Feb 2009 23:46:40 +0100
Message-ID: <19f34abd0902031446r617fd29cmf60e9409564fa58b@mail.gmail.com>
Subject: FASYNC + dup + close gives the wrong fd in SIGIO
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-man@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There seems to be a small deficiency in the O_ASYNC/FASYNC
implementation. When the flag is set for a file descriptor, it does
not "follow" the fd across dup()+close(), so the SIGIO handler will
get the ->si_fd for the fd at the time when O_ASYNC was set. For
example:

pipe([3, 4])                            = 0
getpid()                                = 23982
fcntl(3, F_SETOWN, 23982)               = 0
fcntl(3, F_SETSIG, 0x1d)                = 0
fcntl(3, F_SETFL, O_RDONLY|O_ASYNC)     = 0
dup(3)                                  = 5
close(3)                                = 0
write(4, "\0"..., 1)                    = 1
--- SIGIO (I/O possible) @ 0 (0) ---
[...]
SIGIO for fd 3

It seems a bit obscure, I agree, but I thought I'd mention it. Maybe
the fcntl() man page could carry this extra information?

Here's my test case:

#define _GNU_SOURCE

#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static int done = 0;

static void handle_sigio(int signo, siginfo_t *info, void *unused)
{
        printf("SIGIO for fd %d\n", info->si_fd);
        done = 1;
}

int main(void)
{
        struct sigaction act;
        int pipe_fd[2];

        memset(&act, 0, sizeof(act));
        act.sa_sigaction = &handle_sigio;
        act.sa_flags = SA_SIGINFO;
        sigaction(SIGIO, &act, NULL);

        pipe(pipe_fd);
        fcntl(pipe_fd[0], F_SETOWN, getpid());
        fcntl(pipe_fd[0], F_SETSIG, SIGIO);
        fcntl(pipe_fd[0], F_SETFL, O_ASYNC);
        dup(pipe_fd[0]);
        close(pipe_fd[0]);

        write(pipe_fd[1], "", 1);

        while (!done)
                sleep(1);

        return 0;
}



Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
