Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbZK0Rqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbZK0Rqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 12:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZK0Rqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 12:46:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbZK0Rqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 12:46:45 -0500
Date: Fri, 27 Nov 2009 18:46:27 +0100
From: Veaceslav Falico <vfalico@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: powerpc: fork && stepping (Was: [RFC,PATCH 0/14] utrace/ptrace)
Message-ID: <20091127174627.GB26193@darkmag.usersys.redhat.com>
References: <20091124200127.GA5751@redhat.com> <20091125080342.GD2660@in.ibm.com> <20091125154052.GA6734@redhat.com> <20091126075335.GA18508@in.ibm.com> <20091126145051.GB4382@redhat.com> <20091126172524.GA14768@redhat.com> <20091126182226.GF12355@darkmag.usersys.redhat.com> <20091126202312.GA21945@redhat.com> <19214.63688.860929.962005@cargo.ozlabs.ibm.com> <20091126223703.GA28556@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126223703.GA28556@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 11:37:03PM +0100, Oleg Nesterov wrote:
>
> Could you look at this
>
>   ptrace-copy_process-should-disable-stepping.patch
>   http://marc.info/?l=linux-mm-commits&m=125789789322573
>
> patch? It is not clear to me how we can modify the test-case to
> verify it fixes the original problem for powerpc.

I modified the test-case, it confirms that
ptrace-copy_process-should-disable-stepping.patch fixes the
problem with TIF_SINGLESTEP copied by fork() on powerpc.

Probably we need a similar fix for step-fork.c in ptrace-tests.

Modified the original testcase to call fork via syscall(__NR_fork),
to avoid the looping inside libc's fork() on powerpc.
The parent singlesteps until he sees that the child has forked, after
that the parent PTRACE_CONTs until the child exits.

#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <assert.h>
#include <sys/syscall.h>

int main(void)
{
	void *addr_after_fork = &&after_fork;
	int pid, status;

	if (!(pid = fork())) {
		assert(ptrace(PTRACE_TRACEME) == 0);
		kill(getpid(), SIGSTOP);

		if (!syscall(__NR_fork)) {
			/* kernel bug: this child will be killed by SIGTRAP */
			printf("Hello world\n");
			return 43;
		}

after_fork:	wait(&status);
		return WEXITSTATUS(status);
	}

	for (;;) {
		siginfo_t info;

		assert(pid == wait(&status));
		assert(ptrace(PTRACE_GETSIGINFO, pid, 0,&info) == 0);
		if (info.si_addr == addr_after_fork)
			break;
		assert(ptrace(PTRACE_SINGLESTEP, pid, 0,0) == 0);
	}

	for (;;) {
		if (WIFEXITED(status))
			break;
		assert(ptrace(PTRACE_CONT, pid, 0,0) == 0);
		assert(pid == wait(&status));
	}

	assert(WEXITSTATUS(status) == 43);
	return 0;
}

--
Veaceslav
