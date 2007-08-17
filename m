Return-Path: <linux-kernel-owner+w=401wt.eu-S1763162AbXHQPld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763162AbXHQPld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbXHQPlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:41:25 -0400
Received: from mail.ccur.com ([66.10.65.12]:46178 "EHLO mail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756176AbXHQPlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:41:24 -0400
Message-ID: <46C5C1A0.7060708@ccur.com>
Date: Fri, 17 Aug 2007 11:41:20 -0400
From: John Blackwood <john.blackwood@ccur.com>
Reply-To: john.blackwood@ccur.com
Organization: Concurrent Computer Corporation
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Tom Horsley <tom.horsley@ccur.com>
Subject: Re: [PATCH] select: fix sys_select to not leak ERESTARTNOHAND to
 userspace
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Aug 2007 15:41:20.0402 (UTC) FILETIME=[0ED06720:01C7E0E5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

We've been having problems with this select patch change.

Specifically -- previously, when a ptrace attach was done to a task
blocked in a select() call and that task had a timeout value,
the task would restart the select() call with an updated timeout value.

With this patch in place, the task now instead returns EINTR.

A test that shows this issue is provided below.

We also confirmed that attaching to a program sitting
in select() with gdb makes the select get an EINTR, so this
behavior also shows up in gdb.

Thank you for your considerations in this matter.

------------------- -------------------
#include <stdio.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <signal.h>
#include <sys/wait.h>
#include <sys/ptrace.h>

int
main(int argc, char ** argv) {
    pid_t kid;
    if ((kid = fork()) == 0) {
       int ms_wait = 2000;
       int rval;
       struct timeval timeout;

       timeout.tv_sec = ms_wait / 1000;
       timeout.tv_usec = (ms_wait % 1000) * 1000;
       rval = select(0, NULL, NULL, NULL, &timeout);
       if (rval == -1) {
          int errcode = errno;
          printf("Hey! Why did my select error off with errno %d (%s)?\n",
                 errcode, strerror(errcode));
          fflush(stdout);
       } else {
          printf("select call completed, return value: %d\n", rval);
       }
       exit(0);
    } else if (kid == (pid_t)-1) {
       perror("fork");
    } else {
       int ms_wait = 500;
       int rval;
       struct timeval timeout;

       /* Wait a bit to make sure kid has a chance to get into its
        * select call
        */
       timeout.tv_sec = ms_wait / 1000;
       timeout.tv_usec = (ms_wait % 1000) * 1000;
       rval = select(0, NULL, NULL, NULL, &timeout);

       /* Now attach to the kid, then continue him.
        */
       if (ptrace(PTRACE_ATTACH, kid, (void *)0, (void *)0) != 0) {
          perror("ptrace");
       }
       if (waitpid(kid, &rval, 0) != kid) {
          perror("waitpid");
       }
       if (ptrace(PTRACE_CONT, kid, (void *)0, (void *)0) != 0) {
          perror("ptrace");
       }
       if (waitpid(kid, &rval, 0) != kid) {
          perror("waitpid");
       }
    }
    return 0;
}
