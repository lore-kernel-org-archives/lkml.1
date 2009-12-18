Return-Path: <linux-kernel-owner+w=401wt.eu-S932316AbZLRR6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbZLRR6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZLRR6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:58:52 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:45460 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbZLRR6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:58:51 -0500
Date: Fri, 18 Dec 2009 23:28:42 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by
	08d68323d1f0c34452e614263b212ca556dae47f
Message-ID: <20091218175842.GA10666@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20091218005650.GA20667@redhat.com> <20091218030601.GB16470@nowhere> <20091218172747.GA10924@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218172747.GA10924@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 06:27:47PM +0100, Oleg Nesterov wrote:
> On 12/18, Frederic Weisbecker wrote:
> >
> > On Fri, Dec 18, 2009 at 01:56:50AM +0100, Oleg Nesterov wrote:
> > > Hi.

<snipped>

> > Single stepping works well for me, after a quick check on
> > gdb. How did you trigger the bug?
> 
> Please find the trivial test-case below. It hangs, because
> PTRACE_SINGLESTEP doesn't trigger the trap.
> 

aah...my other mail just criss-crossed yours.

I quickly ran on the said x86 box, loaded with -tip (commit
7818b3d0fc68f5c2a85fed86d9fa37131c5a3068) and it runs fine.

[root@llm05 prasadkr]# cat oleg.c
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <assert.h>

int main(void)
{
        int pid, status, i;

        pid = fork();
        if (!pid)
                for (;;);

        sleep(1);
        assert(ptrace(PTRACE_ATTACH, pid, 0,0) == 0);

        assert(pid == wait(&status));
        assert(WIFSTOPPED(status));

        for (i = 0; i < 10; ++i) {
                assert(ptrace(PTRACE_SINGLESTEP, pid, 0,0) == 0);

                printf("wait %d ...\n", i);
                assert(pid == wait(&status));

                assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGTRAP);
       	}

        kill(pid, SIGKILL);
        return 0;
}

[root@llm05 prasadkr]# gcc -o oleg oleg.c -g -Wall
[root@llm05 prasadkr]# ./oleg
wait 0 ...
wait 1 ...
wait 2 ...
wait 3 ...
wait 4 ...
wait 5 ...
wait 6 ...
wait 7 ...
wait 8 ...
wait 9 ...
[root@llm05 prasadkr]# 

Am I missing something here?

Thanks,
K.Prasad

