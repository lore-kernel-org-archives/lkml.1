Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbZKZO4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbZKZO4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 09:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760286AbZKZO4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 09:56:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbZKZO4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 09:56:20 -0500
Date: Thu, 26 Nov 2009 15:50:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: powerpc: fork && stepping (Was: [RFC,PATCH 0/14] utrace/ptrace)
Message-ID: <20091126145051.GB4382@redhat.com>
References: <20091124200127.GA5751@redhat.com> <20091125080342.GD2660@in.ibm.com> <20091125154052.GA6734@redhat.com> <20091126075335.GA18508@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126075335.GA18508@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I changed the subject. This bug has nothing to do with utrace,
the kernel fails with or without these changes.

On 11/26, Ananth N Mavinakayanahalli wrote:
>
> On Wed, Nov 25, 2009 at 04:40:52PM +0100, Oleg Nesterov wrote:
> > On 11/25, Ananth N Mavinakayanahalli wrote:
> > >
> > > step-fork: step-fork.c:56: handler_fail: Assertion `0' failed.
> > > /bin/sh: line 5: 24803 Aborted                 ${dir}$tst
> > > FAIL: step-fork
> >
> > This is expected. Should be fixed by
> >
> > 	ptrace-copy_process-should-disable-stepping.patch
> >
> > in -mm tree. (I am attaching this patch below just in case)
> > I din't mention this patch in this series because this bug
> > is "ortogonal" to utrace/ptrace.
>
> The patch doesn't seem to fix the issue on powerpc:
>
> step-fork: step-fork.c:56: handler_fail: Assertion `0' failed.
> /bin/sh: line 5: 17325 Aborted                 ${dir}$tst
> FAIL: step-fork

Good to know, thanks again Ananth.

I'll take a look. Since I know nothing about powerpc, I can't
promise the quick fix ;)

The bug was found by code inspection, but the fix is not trivial
because it depends on arch/, and it turns out the arch-independent
fix in

	ptrace-copy_process-should-disable-stepping.patch
	http://marc.info/?l=linux-mm-commits&m=125789789322573

doesn't work.

Ananth, could you please run the test-case from the changelog
below ? I do not really expect this can help, but just in case.

Oleg.

#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <assert.h>

int main(void)
{
	int pid, status;

	if (!(pid = fork())) {
		assert(ptrace(PTRACE_TRACEME) == 0);
		kill(getpid(), SIGSTOP);

		if (!fork()) {
			/* kernel bug: this child will be killed by SIGTRAP */
			printf("Hello world\n");
			return 43;
		}

		wait(&status);
		return WEXITSTATUS(status);
	}

	for (;;) {
		assert(pid == wait(&status));
		if (WIFEXITED(status))
			break;
		assert(ptrace(PTRACE_SINGLESTEP, pid, 0,0) == 0);
	}

	assert(WEXITSTATUS(status) == 43);
	return 0;
}

