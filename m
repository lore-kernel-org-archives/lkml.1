Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbXHQU4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbXHQU4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbXHQU4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:56:32 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2309 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbXHQU4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:56:30 -0400
Date: Fri, 17 Aug 2007 16:55:55 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: John Blackwood <john.blackwood@ccur.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Tom Horsley <tom.horsley@ccur.com>
Subject: Re: [PATCH] select: fix sys_select to not leak ERESTARTNOHAND to userspace
Message-ID: <20070817205555.GA15379@hmsreliant.think-freely.org>
References: <46C5C1A0.7060708@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C5C1A0.7060708@ccur.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 11:41:20AM -0400, John Blackwood wrote:
> Hi Neil,
> 
> We've been having problems with this select patch change.
> 
> Specifically -- previously, when a ptrace attach was done to a task
> blocked in a select() call and that task had a timeout value,
> the task would restart the select() call with an updated timeout value.
> 
> With this patch in place, the task now instead returns EINTR.
> 
> A test that shows this issue is provided below.
> 
> We also confirmed that attaching to a program sitting
> in select() with gdb makes the select get an EINTR, so this
> behavior also shows up in gdb.
> 
> Thank you for your considerations in this matter.
> 
I'm on vacation at the moment, but will look at this more closely when I get
back on tuesday
Regards
Neil

> ------------------- -------------------
> #include <stdio.h>
> #include <sys/time.h>
> #include <sys/types.h>
> #include <unistd.h>
> #include <errno.h>
> #include <stdlib.h>
> #include <string.h>
> #include <ctype.h>
> #include <time.h>
> #include <signal.h>
> #include <sys/wait.h>
> #include <sys/ptrace.h>
> 
> int
> main(int argc, char ** argv) {
>    pid_t kid;
>    if ((kid = fork()) == 0) {
>       int ms_wait = 2000;
>       int rval;
>       struct timeval timeout;
> 
>       timeout.tv_sec = ms_wait / 1000;
>       timeout.tv_usec = (ms_wait % 1000) * 1000;
>       rval = select(0, NULL, NULL, NULL, &timeout);
>       if (rval == -1) {
>          int errcode = errno;
>          printf("Hey! Why did my select error off with errno %d (%s)?\n",
>                 errcode, strerror(errcode));
>          fflush(stdout);
>       } else {
>          printf("select call completed, return value: %d\n", rval);
>       }
>       exit(0);
>    } else if (kid == (pid_t)-1) {
>       perror("fork");
>    } else {
>       int ms_wait = 500;
>       int rval;
>       struct timeval timeout;
> 
>       /* Wait a bit to make sure kid has a chance to get into its
>        * select call
>        */
>       timeout.tv_sec = ms_wait / 1000;
>       timeout.tv_usec = (ms_wait % 1000) * 1000;
>       rval = select(0, NULL, NULL, NULL, &timeout);
> 
>       /* Now attach to the kid, then continue him.
>        */
>       if (ptrace(PTRACE_ATTACH, kid, (void *)0, (void *)0) != 0) {
>          perror("ptrace");
>       }
>       if (waitpid(kid, &rval, 0) != kid) {
>          perror("waitpid");
>       }
>       if (ptrace(PTRACE_CONT, kid, (void *)0, (void *)0) != 0) {
>          perror("ptrace");
>       }
>       if (waitpid(kid, &rval, 0) != kid) {
>          perror("waitpid");
>       }
>    }
>    return 0;
> }

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
