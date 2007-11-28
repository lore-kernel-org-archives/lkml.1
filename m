Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbXK1CIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbXK1CIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 21:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbXK1CI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 21:08:26 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46926 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759558AbXK1CIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 21:08:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrea Arcangeli <andrea@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jack@suse.cz, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: /proc dcache deadlock in do_exit
References: <20071127132022.GW6840@v2.random>
	<20071127143852.601509ac.akpm@linux-foundation.org>
	<20071128012129.GD6840@v2.random> <20071128014509.GE6840@v2.random>
Date: Tue, 27 Nov 2007 19:07:04 -0700
In-Reply-To: <20071128014509.GE6840@v2.random> (Andrea Arcangeli's message of
	"Wed, 28 Nov 2007 02:45:09 +0100")
Message-ID: <m1ir3ngm2f.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli <andrea@suse.de> writes:

>> 
>> So you may need to apply this one too (this one is needed to fix the
>> second bug, my previous patch is needed after applying this one):
>
> thinking what happened once already, I think this would be more
> debuggable but maybe not... dunno.

Please god no.   The inability to schedule is a bug that apparently
was fixed after sles9 forked off.

In mainline it is safe to sleep until the very end of do_exit and
your suggest patch breaks that.

None of your patches are necessary for mainline.



I believe the commit below is the one that really fixed this issue,
although it may have been something earlier.  But it may have been
earlier, and there have been some significant clean ups since then.

> commit 00732b345b940de766fefaf1297ce26a67bdcea9
> Author: mingo <mingo>
> Date:   Tue Oct 19 06:12:06 2004 +0000
> 
>     [PATCH] fix & clean up zombie/dead task handling & preemption
>     
>     This patch fixes all the preempt-after-task->state-is-TASK_DEAD problems we
>     had.  Right now, the moment procfs does a down() that sleeps in
>     proc_pid_flush() [it could] our TASK_DEAD state is zapped and we might be
>     back to TASK_RUNNING to and we trigger this assert:
>     
>             schedule();
>             BUG();
>             /* Avoid "noreturn function does return".  */
>             for (;;) ;
>     
>     I have split out TASK_ZOMBIE and TASK_DEAD into a separate p->exit_state
>     field, to allow the detaching of exit-signal/parent/wait-handling from
>     descheduling a dead task.  Dead-task freeing is done via PF_DEAD.
>     
>     Tested the patch on x86 SMP and UP, but all architectures should work
>     fine.
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Andrew Morton <akpm@osdl.org>
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
>     
>     BKrev: 4174b036IkpU2-XeLFkjqH681u4Pyg
> 

Eric
