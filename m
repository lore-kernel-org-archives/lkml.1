Return-Path: <linux-kernel-owner+w=401wt.eu-S1030649AbXBZUKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030649AbXBZUKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030648AbXBZUKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:10:54 -0500
Received: from smtp-out.google.com ([216.239.45.13]:5707 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030649AbXBZUKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:10:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:
	subject:content-type:content-transfer-encoding;
	b=CTl6eO0q3AxE2Os1MLjj/98TexpzI9ehMMv3sKkYi1uPoMW7nY5nKvyNNJ54R6pGb
	gbpoTjXzym77XRa6abKSw==
Message-ID: <45E33EBD.6020603@google.com>
Date: Mon, 26 Feb 2007 12:10:37 -0800
From: Mathieu Desnoyers <compudj@google.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: "Martin J. Bligh" <mbligh@google.com>, linux-kernel@vger.kernel.org
Subject: Thread flags modified without set_thread_flag() (non atomically)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looking into the thread flags, I found out that some architecture 
specific kernel functions (in 2.6.20) sets the thread flags with non 
atomic operation.

A good way to list the most trivial : grep -r TIF_ * | grep =

Some examples follows. If, for instance, 
x86_64/kernel/process.c:flush_thread is called from an exec system call, 
it will do the following :

x86_64/kernel/process.c:                t->flags ^= (_TIF_ABI_PENDING | 
_TIF_IA32);
x86_64/kernel/process.c:        t->flags &= ~_TIF_DEBUG;

void flush_thread(void)
{
        struct task_struct *tsk = current;
        struct thread_info *t = current_thread_info();

        if (t->flags & _TIF_ABI_PENDING) {
                t->flags ^= (_TIF_ABI_PENDING | _TIF_IA32);
                if (t->flags & _TIF_IA32)
                        current_thread_info()->status |= TS_COMPAT;
        }
        t->flags &= ~_TIF_DEBUG;
....

As long as the flags are only updated by the thread itself at this 
moment, it seems safe, but if other updates coming from other threads 
are expected, wouldn't it result in a bad behavior ?

i.e if resched_task ia being called by another CPU at the same time for 
this specific thread would set the TIF_NEED_RESCHED flag, but it could 
be overwritten by the non-atomic modification in flush_thread.

And about this specific flush_thread, I am puzzled about the t->flags ^= 
(_TIF_ABI_PENDING | _TIF_IA32); line. The XOR will clearly flip the 
_TIF_ABI_PENDING bit to 0, and very likely set _TIF_IA32 to the opposite 
of its current value. Why does this change need to be written atomically 
(can other threads play with these flags ?) ?

Mathieu


Other examples :

sparc64/kernel/ptrace.c:                if 
((task_thread_info(child)->flags & _TIF_32BIT) != 0) {
sparc64/kernel/process.c:               t->flags ^= (_TIF_ABI_PENDING | 
_TIF_32BIT);
sparc64/kernel/process.c:                       t->flags &= ~_TIF_PERFCTR;

sparc/kernel/process.c:         current_thread_info()->flags &= 
~_TIF_USEDFPU;
sparc/kernel/process.c:         current_thread_info()->flags &= 
~_TIF_USEDFPU;
sparc/kernel/process.c:         current_thread_info()->flags &= 
~_TIF_USEDFPU;
sparc/kernel/process.c:                 current_thread_info()->flags &= 
~(_TIF_USEDFPU);
sparc/kernel/traps.c:   current_thread_info()->flags |= _TIF_USEDFPU;
sparc/kernel/traps.c:   task_thread_info(fpt)->flags &= ~_TIF_USEDFPU;

powerpc/kernel/process.c:               t->flags ^= (_TIF_ABI_PENDING | 
_TIF_32BIT);

ia64/kernel/mca.c:      ti->flags = _TIF_MCA_INIT;

avr32/kernel/ptrace.c:          ti->flags |= _TIF_BREAKPOINT;
avr32/kernel/ptrace.c:                  ti->flags |= TIF_SINGLE_STEP;


