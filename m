Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbYCYMnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbYCYMnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 08:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYCYMmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 08:42:53 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:46972 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYCYMmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 08:42:52 -0400
Date: Tue, 25 Mar 2008 08:42:48 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] RWSEM: Rewrite rwsem.c and rwsem-spinlock.c more
 simply.
In-Reply-To: <20080325123633.GL2170@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803250834220.19530@localhost.localdomain>
References: <alpine.LFD.1.00.0803250659530.18358@localhost.localdomain> <87skyfgg4y.fsf@basil.nowhere.org> <alpine.LFD.1.00.0803250813190.19386@localhost.localdomain> <20080325123633.GL2170@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Andi Kleen wrote:

> > i'm not sure what this means -- which of the transformations in
> > that patch is considered unsafe?  here's a typical simplification:
>
> It is not unsafe, just generates slight worse code.
>
> current is inline assembler and the compiler doesn't know that it
> could cache it in a register because it is not marked pure for
> various reasons. That is why current is often cached explicitely in
> a local variable to tell the compiler that.

  ah, i think i see, thanks.  learn something every day.

> Before you run off and do that everywhere: it is also not a large
> win, just a small one unless current is used very often.

  there's actually not that many explicit calls to either
set_task_state or __set_task_state in the entire tree, and a lot of
those don't count as they really are setting the state for a different
task or for some other reason.  in fact, here's the entire list for
the whole tree:

$ grep -r set_task_state *
arch/powerpc/kernel/semaphore.c:	__set_task_state(tsk, TASK_UNINTERRUPTIBLE);
arch/powerpc/kernel/semaphore.c:		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
arch/powerpc/kernel/semaphore.c:	__set_task_state(tsk, TASK_RUNNING);
arch/powerpc/kernel/semaphore.c:	__set_task_state(tsk, TASK_INTERRUPTIBLE);
arch/powerpc/kernel/semaphore.c:		set_task_state(tsk, TASK_INTERRUPTIBLE);
arch/powerpc/kernel/semaphore.c:	__set_task_state(tsk, TASK_RUNNING);
arch/alpha/kernel/semaphore.c:		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
arch/alpha/kernel/semaphore.c:		set_task_state(tsk, TASK_INTERRUPTIBLE);
arch/parisc/kernel/semaphore.c:		set_task_state(current, TASK_UNINTERRUPTIBLE);
arch/parisc/kernel/semaphore.c:		set_task_state(current, TASK_INTERRUPTIBLE);
arch/mn10300/kernel/semaphore.c:	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
arch/mn10300/kernel/semaphore.c:		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
arch/mn10300/kernel/semaphore.c:	set_task_state(tsk, TASK_INTERRUPTIBLE);
arch/mn10300/kernel/semaphore.c:		set_task_state(tsk, TASK_INTERRUPTIBLE);
arch/s390/kernel/semaphore.c:	__set_task_state(tsk, TASK_UNINTERRUPTIBLE);
arch/s390/kernel/semaphore.c:		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
arch/s390/kernel/semaphore.c:	__set_task_state(tsk, TASK_RUNNING);
arch/s390/kernel/semaphore.c:	__set_task_state(tsk, TASK_INTERRUPTIBLE);
arch/s390/kernel/semaphore.c:		set_task_state(tsk, TASK_INTERRUPTIBLE);
arch/s390/kernel/semaphore.c:	__set_task_state(tsk, TASK_RUNNING);
arch/s390/mm/fault.c:		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
arch/s390/mm/fault.c:			set_task_state(tsk, TASK_RUNNING);
arch/frv/kernel/semaphore.c:	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
arch/frv/kernel/semaphore.c:		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
arch/frv/kernel/semaphore.c:	set_task_state(tsk, TASK_INTERRUPTIBLE);
arch/frv/kernel/semaphore.c:		set_task_state(tsk, TASK_INTERRUPTIBLE);
arch/mips/kernel/semaphore.c:	__set_task_state(tsk, TASK_UNINTERRUPTIBLE);
arch/mips/kernel/semaphore.c:		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
arch/mips/kernel/semaphore.c:	__set_task_state(tsk, TASK_RUNNING);
arch/mips/kernel/semaphore.c:	__set_task_state(tsk, TASK_INTERRUPTIBLE);
arch/mips/kernel/semaphore.c:		set_task_state(tsk, TASK_INTERRUPTIBLE);
arch/mips/kernel/semaphore.c:	__set_task_state(tsk, TASK_RUNNING);
Documentation/scheduler/sched-coding.txt:set_task_state(tsk, state_value)
drivers/mmc/core/sdio_irq.c:		set_task_state(current, TASK_INTERRUPTIBLE);
drivers/mmc/core/sdio_irq.c:		set_task_state(current, TASK_RUNNING);
drivers/mfd/ucb1x00-ts.c:			set_task_state(tsk, TASK_INTERRUPTIBLE);
drivers/mfd/ucb1x00-ts.c:			set_task_state(tsk, TASK_INTERRUPTIBLE);
fs/aio.c:	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
fs/aio.c:		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
fs/aio.c:	__set_task_state(tsk, TASK_RUNNING);
fs/aio.c:			set_task_state(tsk, TASK_INTERRUPTIBLE);
fs/aio.c:		set_task_state(tsk, TASK_RUNNING);
include/linux/sched.h:/* Convenience macros for the sake of set_task_state */
include/linux/sched.h:#define __set_task_state(tsk, state_value)		\
include/linux/sched.h:#define set_task_state(tsk, state_value)		\
kernel/ptrace.c:			__set_task_state(child, TASK_STOPPED);
kernel/fork.c:			__set_task_state(p, TASK_STOPPED);
kernel/mutex.c:		__set_task_state(task, state);
lib/rwsem-spinlock.c:	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
lib/rwsem-spinlock.c:		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
lib/rwsem-spinlock.c:	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
lib/rwsem-spinlock.c:		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
lib/rwsem.c:	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
lib/rwsem.c:		set_task_state(tsk, TASK_UNINTERRUPTIBLE);

  once you ignore the semaphore stuff (and a bit of the rest, like the
stuff in sched.h), there's not really that much left that could be
rewritten with set_current_state() anyway.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
