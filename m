Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbYGTLgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbYGTLgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 07:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYGTLg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 07:36:27 -0400
Received: from saeurebad.de ([85.214.36.134]:56757 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbYGTLg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 07:36:27 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: kill mm->core_done
References: <20080715140715.GA25824@tv-sign.ru> <87d4l9jvru.fsf@saeurebad.de>
	<20080720084758.GA143@tv-sign.ru>
Date: Sun, 20 Jul 2008 13:35:57 +0200
In-Reply-To: <20080720084758.GA143@tv-sign.ru> (Oleg Nesterov's message of
	"Sun, 20 Jul 2008 12:47:58 +0400")
Message-ID: <87tzekrdnm.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 07/20, Johannes Weiner wrote:
>> 
>> Oleg Nesterov <oleg@tv-sign.ru> writes:
>> 
>> > --- 26-rc2/kernel/exit.c~5_KILL_CORE_DONE	2008-07-13 19:58:19.000000000 +0400
>> > +++ 26-rc2/kernel/exit.c	2008-07-15 17:06:58.000000000 +0400
>> > @@ -680,7 +680,13 @@ static void exit_mm(struct task_struct *
>> >  		if (atomic_dec_and_test(&core_state->nr_threads))
>> >  			complete(&core_state->startup);
>> >  
>> > -		wait_for_completion(&mm->core_done);
>> > +		for (;;) {
>> > +			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>> > +			if (!self.task) /* see coredump_finish() */
>> 
>> kernel/exit.c: In function `exit_mm':
>> kernel/exit.c:686: error: `self' undeclared (first use in this function)
>> kernel/exit.c:686: error: (Each undeclared identifier is reported only once
>> kernel/exit.c:686: error: for each function it appears in.)
>> make[1]: *** [kernel/exit.o] Error 1
>
> This is on top of other patches in -mm tree,
>
>          coredump-zap_threads-comments-use-while_each_thread.patch
>          introduce-pf_kthread-flag.patch
>          kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
>          coredump-zap_threads-must-skip-kernel-threads.patch
>          coredump-elf_core_dump-skip-kernel-threads.patch
>          coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
>          coredump-move-mm-core_waiters-into-struct-core_state.patch
>          coredump-simplify-core_state-nr_threads-calculation.patch
>          coredump-turn-core_state-nr_threads-into-atomic_t.patch
>          coredump-make-mm-core_state-visible-to-core_dump.patch
>          coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch
>          coredump-elf_core_dump-use-core_state-dumper-list.patch
>          coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
>          coredump-kill-mm-core_done.patch

Sorry, I should have given more information.

I was building -mm directly with all these patches applied.  I did not
cherry-pick this exact patch into some other tree.

But I still can not find anything defining `self' in these patches:

$ grep self coredump-*.patch \
	introduce-pf_kthread-flag.patch \
	kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-kill-mm-core_done.patch:+                      if (!self.task) /* see coredump_finish() */

cscope finds some other definitions of self in the tree, but nothing
relevant.

	Hannes
