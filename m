Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZD0CLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZD0CLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 22:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZD0CLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 22:11:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbZD0CLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 22:11:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org
Subject: Re: copy_process() && ti->flags (Was: PT_DTRACE && uml)
In-Reply-To: Oleg Nesterov's message of  Monday, 27 April 2009 01:18:20 +0200 <20090426231820.GB6580@redhat.com>
References: <20090416204004.GA28013@redhat.com>
	<20090416232430.4DAE4FC3C6@magilla.sf.frob.com>
	<20090420183718.GC32527@redhat.com>
	<20090421011354.4B19EFC3C7@magilla.sf.frob.com>
	<20090421214819.GA22845@redhat.com>
	<20090422032205.B8D39FC3C7@magilla.sf.frob.com>
	<20090422220400.GA22755@redhat.com>
	<20090422221726.GC22755@redhat.com>
	<20090423160229.GA9820@c2.user-mode-linux.org>
	<20090426220954.GA6580@redhat.com>
	<20090426231820.GB6580@redhat.com>
X-Zippy-Says: Look DEEP into the OPENINGS!!  Do you see any ELVES or EDSELS...
    or a HIGHBALL??...
Message-Id: <20090427021057.045DBFC3B6@magilla.sf.frob.com>
Date: Sun, 26 Apr 2009 19:10:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> dup_task_struct()->setup_thread_stack() copies parent's ti->flags.
> 
> Why? Which flags should be actually copied? I must have missed
> something, but whats wrong with the patch below?

I suspect it just evolved that way as the default case of how
copy_process() is written: copy whole structs, and then fix them up.

Almost all the details of struct thread_info are arch-specific, so
whether copy-and-fix or start-from-zero is better really has to be
decided by each arch maintainer.

Your next two questions are not about UML, but about arch/x86 code.
Those should be directed to the x86 maintainers, whom you did not CC.

> OK, it is wrong. On x86 we should at least copy TIF_IA32. But
> why should we copy, say, TIF_DEBUG?

TIF_DEBUG is set when task->thread.debugregN fields have interesting
values.  The semantics today are that those values are copied, so
copying TIF_DEBUG too makes the child's context switches do what they
should.

This illustrates the general point: since the overall policy defaults
to copying, then what actually keeps the code simpler overall is to
have the same default at each substructure (and so it is for
thread_struct and thread_info).  If some things should be cleared,
they are cleared explicitly.  Hence, to clear TIF_DEBUG one would have
to do it on purpose, and would be required to think about what
TIF_DEBUG means and that clearing thread->debugregN goes along with
it.  (And at this point, one would then realize that one can't do it
without changing the user-visible semantics.)

> Actually, I don't understand why don't we use TS_IA32 instead of
> TIF_IA32. Only current can change this flag, perhaps it makes sense
> to move it in thread_info->status.

However, it is tested by other threads asynchronously.  The stated use
of TS_* flags is things only tested by current or when current is
stopped (e.g. TS_COMPAT).  In other uses like TASK_SIZE_OF(),
get_gate_vma(), etc., that might not be so.  It might be so on x86
that there can never be any modification to ti->status that could
momentarily clear some bit, but that is not formally said to be
required.

> copy_process()->clear_tsk_thread_flag(TIF_SIGPENDING) looks unneeded
> in any case...

It goes along with init_sigpending().  But it's actually potentially
wrong in case of shared_pending signals.  Do recalc_sigpending_tsk()
if anything.  As I think you intend to point out, it is always pretty
harmless to leave TIF_SIGPENDING set.  (get_signal_to_deliver will
just figure it out.)  So I think that should just be removed,
independent of your other questions.


Thanks,
Roland
