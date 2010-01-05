Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186Ab0AEJuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab0AEJuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 04:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486Ab0AEJug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 04:50:36 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:39857 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab0AEJuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 04:50:35 -0500
Date: Tue, 5 Jan 2010 10:50:30 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, caiqian@redhat.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Kratochvil <jkratoch@redhat.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: s390 && user_enable_single_step() (Was: odd utrace testing
 results on s390x)
Message-ID: <20100105105030.66bb8a0a@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100104211147.4CC94D532@magilla.sf.frob.com>
References: <1503844142.2061111261478093776.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<1257887498.2061171261478252049.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<20100104155225.GA16650@redhat.com>
	<20100104171626.22ea2d9c@mschwide.boeblingen.de.ibm.com>
	<20100104181412.GA21146@redhat.com>
	<20100104211147.4CC94D532@magilla.sf.frob.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Jan 2010 13:11:47 -0800 (PST)
Roland McGrath <roland@redhat.com> wrote:

> > This probably means that copy_process()->user_disable_single_step()
> > is not enough to clear the "this task wants single-stepping" copied
> > from parent.
> 
> I would suspect s390's TIF_SINGLE_STEP flag here.  That flag means "a
> single-step trap occurred".  This is what causes do_single_step to be
> called before returning to user mode, rather than the machine trap doing it
> directly as is done in the other arch implementations.

Just my thinking as well.

> If I'm right, then "this task wants single-stepping" is not the problem,
> and that really is fully cleared.  In fact, looking at s390's copy_thread
> (arch/s390/kernel/process.c) it clears out all the state that is actually
> touched by user_enable_single_step and user_disable_single_step.  So for
> s390 the new fork.c call is actually superfluous AFAICT.

        /* Don't copy debug registers */
        memset(&p->thread.per_info, 0, sizeof(p->thread.per_info));

Yep, the call from fork.c is indeed superfluous.

> The problem is that the copied parent state includes the "this task has a
> pending single-step to report" flag.  IMHO it clearly makes sense for
> s390's copy_thread to clear this flag in a new task, which it does not do now.
> 
> An alternative to that would be just to make its user_disable_single_step
> clear the flag.  That could in theory also have an effect on e.g. the
> (authentic) pending step report of a tracee that was stopped with
> TIF_SINGLE_STEP set when its tracer detached.  This might be considered a
> good thing, but since every other arch posts the SIGTRAP immediately they
> all have the equivalent issue and s390 doesn't need to be any "better" than
> they are before we have a generic resolution to the whole subject of
> tracer-induced signals (which we won't get into now).  I'm not even sure
> from my insufficient reading of the s390 assembly code whether this path is
> even possible, i.e. do_signal called before do_single_step.

do_signal is called before do_single_step. The order of checks of the
TIF_ bits is 1) machine checks, 2) need resched, 3) signal pending, 4)
notify resume, 5) restarting system call, 6) single step.
But why is that important ? If the TIF_SINGLE_STEP bit is set the order
of do_signal vs. do_single_step does not seem to be important to me.
There will be a SIGTRAP if TIF_SINGLE_STEP is set, no ?

But I agree, it is probably better to make all arches look the same in
regard to that pending step report. 

> Martin, I suggest having copy_thread clear TIF_SINGLE_STEP.
> That bit is always task-private state that should not be copied.

Then let us do this.
 
> Btw, given the complexity of FixPerRegisters (and its new additional cost
> on task==current), you might want to make user_*_single_step bail out if
> per_info.single_step is already set/clear on entry.

The LCTLG of multiple control registers is rather expensive. Does it
happen often that user_*_single_step is called without need? For gdb is
doesn't matter, the cost to switch between tracer and tracee is already
large, the cycles added to FixPerRegisters won't matter much. For
utrace things might be different.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

