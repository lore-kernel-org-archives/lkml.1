Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYK0Omn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYK0Omn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYK0Ome
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:42:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40819 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbYK0Omd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:42:33 -0500
Date: Thu, 27 Nov 2008 15:42:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       andi@firstfloor.org, sfr@canb.auug.org.au,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 20/24] perfmon: system calls interface
Message-ID: <20081127144210.GA4672@elte.hu>
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com> <20081126140027.GC6562@elte.hu> <7c86c4470811270622s540a17d8r73462dfa93d1bc6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811270622s540a17d8r73462dfa93d1bc6d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* stephane eranian <eranian@googlemail.com> wrote:

> Ingo,
> 
> On Wed, Nov 26, 2008 at 3:00 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Thirdly, the check for ->exit_state in pfm_task_incompatible() is 
> > not needed: we've just passed ptrace_check_attach() so we know we 
> > just transitioned the task to task->state == TASK_TRACED.
> >
> > If you _ever_ see a task exit TASK_TRACED and go zombie or dead 
> > from there without this code allowing it that means the whole 
> > state machine with ptrace is borked up by perfmon. For example i 
> > dont see where the perfmon-control task parents itself as the 
> > exclusive debugger (parent) of the debuggee-task.
> >
> 
> Perfmon requires ptrace ONLY to stop the thread you want to operate 
> on. For instance, to read the counters in a thread via pfm_read(), 
> you need to have that thread stopped, so perfmon can extract the 
> machine state safely. But when the monitored thread runs, it does 
> not have to remain under the control of ptrace. All that is needed 
> is that the thread is stopped while we are in the perfmon syscall. I 
> think ptrace allows this today. We will be able to drop ptrace() 
> once we switch to utrace in which case, the kernel will be able to 
> easily stop the thread when entering the perfmon syscalls. I guess I 
> don't quite understand the meaning of your last sentence.

The meaning of my last sentence is the jist of my argument: you cannot 
do it like this! You are using a bit of the ptrace infrastructure but 
unsafely, as pointed out here.

and the thing is, i fail to understand the whole justification of the 
new sys_pfm_attach()/PFM_NO_TARGET system calls.

Firstly, there's a taste issue: why didnt you add sys_pfm_detach 
instead of adding a butt-ugly PFM_NO_TARGET special case into 
sys_pfm_attach() that maps to pfm_detach??

But more importantly, and very fundamentally: why did you implement it 
as a special system call? Why didnt you extend ptrace to read/write 
the PMU context? It is _trivial_ and needs no new syscalls at all: 
just a new ptrace parameter to arch_ptrace(). And ptrace will drive 
the TASK_TRACED state machine safely - it already stops/starts tasks 
to read/write hardware context safely.

And as a bonus, if this is implemented via a ptrace extension it will 
be trivial to add support for these new context types to all sorts of 
user-space debuggers as well. With new syscalls it will take ages for 
this to trickle through to all parties involved.

	Ingo
