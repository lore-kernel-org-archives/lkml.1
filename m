Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYBEIPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYBEIPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 03:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYBEIPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 03:15:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbYBEIPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 03:15:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: make traps on 'iret' be debuggable in user
	space
In-Reply-To: Ingo Molnar's message of  Tuesday, 5 February 2008 09:01:49 +0100 <20080205080149.GA16929@elte.hu>
References: <20080205075137.617012701A8@magilla.localdomain>
	<20080205080149.GA16929@elte.hu>
Emacs: a compelling argument for pencil and paper.
Message-Id: <20080205081506.655CB2701A8@magilla.localdomain>
Date: Tue,  5 Feb 2008 00:15:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> thanks, applied. I suppose you have a testcase for this that we could try?

This should exit 0 and show "wait status 0xb7f", and does on i386.
On 2.6.24 it exits 1 and shows "wait status 0xb".

Note, on the current tree before [PATCH] x86_64: fix iret exception recovery
that I also posted today, this will instead produce pathological weirdness
probably with a quick crash or silent reboot, from running with the wrong GS.

Thanks,
Roland

---
#define _GNU_SOURCE
#include <assert.h>
#include <errno.h>
#include <unistd.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/wait.h>
#include <stddef.h>
#include <sys/ptrace.h>
#include <asm/ptrace.h>
#include <asm/user.h>

static pid_t child;

static void
cleanup (void)
{
  if (child != 0)
    kill (child, SIGKILL);
}

static void
handler_fail (int signo)
{
  cleanup ();

  signal (SIGABRT, SIG_DFL);
  abort ();
}

int main (void)
{
  long l;
  int status, i;
  pid_t pid;
  long cs;

  setbuf (stdout, NULL);
  atexit (cleanup);
  signal (SIGABRT, handler_fail);
  signal (SIGINT, handler_fail);
  signal (SIGALRM, handler_fail);
  alarm (10);

  signal (SIGUSR1, SIG_IGN);
  signal (SIGUSR2, SIG_IGN);

  child = fork ();
  switch (child)
    {
    case -1:
      assert_perror (errno);
      assert (0);
    case 0:
      l = ptrace (PTRACE_TRACEME, 0, NULL, NULL);
      assert (l == 0);
      i = raise (SIGUSR1);
      assert (i == 0);
      assert (0);
    default:
      break;
    }

  pid = waitpid (child, &status, 0);
  assert (pid == child);
  assert (WIFSTOPPED (status));
  assert (WSTOPSIG (status) == SIGUSR1);

  cs = 0xFFFF;

  l = ptrace (PTRACE_POKEUSER, child,
	      (void *) offsetof (struct user_regs_struct, cs), (void *) cs);
  assert (l == 0);

  l = ptrace (PTRACE_CONT, child, NULL, NULL);
  assert (l == 0);

  pid = waitpid (child, &status, 0);
  assert (pid == child);

  printf ("wait status %#x\n", status);

  return WIFSTOPPED (status) ? 0 : 1;
}
