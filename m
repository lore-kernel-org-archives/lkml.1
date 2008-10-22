Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYJVKDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYJVKDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYJVKDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:03:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:34028 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753547AbYJVKDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:03:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/FcnsF9crF0rgy0DTLowNJXn5Hkil+GmdaZjYib7
	wA+8a2JQ4Ej6Ke
Subject: Re: [PATCH 0/4] pending scheduler updates
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081022094019.GG12453@elte.hu>
References: <20081017172701.047939625@chello.nl>
	 <20081020120538.GD10594@elte.hu>
	 <20081021173529.GG11679@linux.vnet.ibm.com>
	 <20081022094019.GG12453@elte.hu>
Content-Type: multipart/mixed; boundary="=-ROcPLKR3FvRa4oX2UFvR"
Date: Wed, 22 Oct 2008 12:03:41 +0200
Message-Id: <1224669821.6871.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ROcPLKR3FvRa4oX2UFvR
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2008-10-22 at 11:40 +0200, Ingo Molnar wrote:
> * Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> 
> > On Mon, Oct 20, 2008 at 02:05:38PM +0200, Ingo Molnar wrote:
> > > 
> > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > > Please apply
> > > 
> > > applied these to tip/sched/urgent:
> > > 
> > >  f9c0b09: sched: revert back to per-rq vruntime
> > >  a4c2f00: sched: fair scheduler should not resched rt tasks
> > >  ffda12a: sched: optimize group load balancer
> > > 
> > > (will wait with 4/4 until you and Mike come to a verdict.)
> > 
> > Is there any conclusion on Patch 4/4? It looks sane to me!
> 
> Mike?

Your call of course, but I don't think it's a good trade.  In testing,
it does serious injury to mysql+oltp peak throughput, and slows down
things which need frequent preemption in order to compete effectively
against hogs.  (includes desktop, though that's not heavily tested)

The attached starvation testcase, distilled from real app and posted to
lkml a few years ago, it totally kills.  It's a worst case scenario to
be sure, but that worst case is pretty dramatic.  I guesstimated it
would take ~12 hours for it to do 10M signals with wakeup preemption so
restricted, vs 43 seconds with preemption as is.  To me, that suggests
that anything ultra fast/light will pay through the nose.

It has positive effects too, but IMHO, the bad outweigh the good.

	-Mike

--=-ROcPLKR3FvRa4oX2UFvR
Content-Disposition: attachment; filename=starve.c
Content-Type: text/x-csrc; name=starve.c; charset=utf-8
Content-Transfer-Encoding: 7bit

#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/wait.h>

volatile unsigned long loop = 10000000;

void
handler (int n)
{
  if (loop > 0)
    --loop;
}

static int
child (void)
{
  pid_t ppid = getppid ();

  sleep (1);
  while (1)
    kill (ppid, SIGUSR1);
  return 0;
}

int
main (int argc, char **argv)
{
  pid_t child_pid;
  int r;

  loop = argc > 1 ? strtoul (argv[1], NULL, 10) : 10000000;
  printf ("expecting to receive %lu signals\n", loop);

  if ((child_pid = fork ()) == 0)
    exit (child ());

  signal (SIGUSR1, handler);
  while (loop)
    sleep (1);
  r = kill (child_pid, SIGTERM);
  waitpid (child_pid, NULL, 0);
  return 0;
}

--=-ROcPLKR3FvRa4oX2UFvR--

