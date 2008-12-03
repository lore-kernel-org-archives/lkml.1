Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbYLDAze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbYLDAze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758504AbYLDAxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:53:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757078AbYLDAxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:53:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: eranian@googlemail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org,
       eranian@gmail.com, sfr@canb.auug.org.au,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 20/24] perfmon: system calls interface
In-Reply-To: Ingo Molnar's message of  Wednesday, 26 November 2008 15:00:27 +0100 <20081126140027.GC6562@elte.hu>
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
	<20081126140027.GC6562@elte.hu>
X-Zippy-Says: ALFRED JARRY!  Say something about th' DEATH of DISCO!!
Message-Id: <20081204005203.6B80BFC3BF@magilla.sf.frob.com>
Date: Tue,  2 Dec 2008 18:02:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	/*
> > +	 * cannot attach to a kernel thread
> > +	 */
> > +	if (!task->mm) {

This should test (task->flags & PF_KTHREAD).  (But it's superfluous anyway.)

> > +	/*
> > +	 * cannot attach to a zombie task
> > +	 */
> > +	if (task->exit_state == EXIT_ZOMBIE || task->exit_state == EXIT_DEAD) {

The usual test to write here is just "if (task->exit_state)".
(But it's superfluous anyway.)

> Thirdly, the check for ->exit_state in pfm_task_incompatible() is not 
> needed: we've just passed ptrace_check_attach() so we know we just 
> transitioned the task to task->state == TASK_TRACED.

Correct.

> If you _ever_ see a task exit TASK_TRACED and go zombie or dead from 
> there without this code allowing it that means the whole state machine 
> with ptrace is borked up by perfmon. 

Is always possible for a TASK_TRACED task to suddenly die via SIGKILL, and
it's even possible it will be reaped (EXIT_DEAD) despite ptrace, in the
de_thread() (MT exec) case.  This race is tolerable for everything ptrace
does (it holds a task ref, and the arch code copes).  It must also be
tolerated by the perfmon code.

> For example i dont see where the perfmon-control task parents itself as
> the exclusive debugger (parent) of the debuggee-task.

ptrace_check_attach() ensures that this is so.  


Thanks,
Roland
