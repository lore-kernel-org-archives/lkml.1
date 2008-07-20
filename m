Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbYGTMUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbYGTMUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 08:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYGTMU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 08:20:27 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49430 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbYGTMU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 08:20:27 -0400
Date: Sun, 20 Jul 2008 16:23:54 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] coredump: exit_mm: clear ->mm first, then play with ->core_state
Message-ID: <20080720122354.GD143@tv-sign.ru>
References: <20080716135359.GA1219@tv-sign.ru> <20080720023258.26D2015421D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720023258.26D2015421D@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19, Roland McGrath wrote:
>
> > With the previous changes the sub-threads which participate in coredump do
> > not need to have the valid ->mm when the coredump is in progress, now we
> > can decouple exit_mm() from coredumping code.
>
> I'm all for separating the code more cleanly.  But I don't think it can
> work to change the order of the operations, i.e. it is not really true that
> core dumps don't need each thread's ->mm link to be valid.  Is there a
> benefit to unlinking the mm before waiting for the core dump to finish?

If select_bad_process() sees the PF_EXITING task with ->mm != NULL, it
returns ERR_PTR(-1). This means that any prcoess doing the mt coredump
blocks oom kill completely. It is not that oom_kill doesn't take this
process into account, oom_kill just can't work intil ->core_dump()
completes.

Yes, oom_kill.c in turn need fixes but still this is not nice, and I
personally hate this coredump code in the middle of exit_mm().

However,

> The issue is that the user_regset calls to get "thread state" might
> actually read some user memory.  Those calls use a task_struct pointer and
> you don't get to separately tell them the mm_struct describing the thread's
> address space.  For example, the sparc64 "general registers" note for core
> files includes the register window read from user memory.
>
> So, it's not OK to clear the ->mm before everything examining the thread's
> machine state is really done, i.e. core dump and anything else.

Oh, thanks Roland.

Andrew, please drop

	coredump-binfmt_elf_fdpic-dont-use-sub-threads-mm.patch
	coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch





btw, arch/sparc64/kernel/ptrace.c has a lot of

	if (target == current)
		copy_xxx_user();
	else
		access_process_vm();

perhaps it make sense to make a helper. Just curious (I don't know what
regset is), is it possible that ->get() is called when target->mm == NULL?

Oleg.		

