Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbYK0PQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbYK0PQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYK0PQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:16:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:59176 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYK0PQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:16:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=bpA4hzffiUkz9ua4flVCt6vamMDvgOF8L3H2vvDgMf1MjZ1SyrSA+m9a7hoDcnLZe5
         InDaLsyI80tAoqN8D14vB9L3iYPMOB/DxpPbkCMIqj+ebkXENuJK/Ew7f0d1ii8jutqo
         Vf5t+gP+fbMBvHRt9y0pyVXqiPlV3ffcb6IAg=
Message-ID: <7c86c4470811270716o55f3b076rc8607c7640c2ef14@mail.gmail.com>
Date: Thu, 27 Nov 2008 16:16:01 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 20/24] perfmon: system calls interface
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       andi@firstfloor.org, sfr@canb.auug.org.au,
       "Roland McGrath" <roland@redhat.com>, "Oleg Nesterov" <oleg@redhat.com>
In-Reply-To: <20081127144210.GA4672@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
	 <20081126140027.GC6562@elte.hu>
	 <7c86c4470811270622s540a17d8r73462dfa93d1bc6d@mail.gmail.com>
	 <20081127144210.GA4672@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

On Thu, Nov 27, 2008 at 3:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * stephane eranian <eranian@googlemail.com> wrote:
>
>> Ingo,
>>
>> On Wed, Nov 26, 2008 at 3:00 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > Thirdly, the check for ->exit_state in pfm_task_incompatible() is
>> > not needed: we've just passed ptrace_check_attach() so we know we
>> > just transitioned the task to task->state == TASK_TRACED.
>> >
>> > If you _ever_ see a task exit TASK_TRACED and go zombie or dead
>> > from there without this code allowing it that means the whole
>> > state machine with ptrace is borked up by perfmon. For example i
>> > dont see where the perfmon-control task parents itself as the
>> > exclusive debugger (parent) of the debuggee-task.
>> >
>>
>> Perfmon requires ptrace ONLY to stop the thread you want to operate
>> on. For instance, to read the counters in a thread via pfm_read(),
>> you need to have that thread stopped, so perfmon can extract the
>> machine state safely. But when the monitored thread runs, it does
>> not have to remain under the control of ptrace. All that is needed
>> is that the thread is stopped while we are in the perfmon syscall. I
>> think ptrace allows this today. We will be able to drop ptrace()
>> once we switch to utrace in which case, the kernel will be able to
>> easily stop the thread when entering the perfmon syscalls. I guess I
>> don't quite understand the meaning of your last sentence.
>
> The meaning of my last sentence is the jist of my argument: you cannot
> do it like this! You are using a bit of the ptrace infrastructure but
> unsafely, as pointed out here.
>
Perfmon requires the application to use ptrace. The function you looked
at is just there to verify that the application actually did attach before
making a perfmon syscall. If it was not for the stop/resume feature, I would
not require using ptrace. That's why I like the utrace functionality.

Ptracing and performance monitoring are two different things. One
is for debugging the other is for performance analysis. The requirements
are different. There are all sorts of nasty side effects of ptrace which are
pointless with performance monitoring, e.g., signal redirections.



> and the thing is, i fail to understand the whole justification of the
> new sys_pfm_attach()/PFM_NO_TARGET system calls.
>
> Firstly, there's a taste issue: why didnt you add sys_pfm_detach
> instead of adding a butt-ugly PFM_NO_TARGET special case into
> sys_pfm_attach() that maps to pfm_detach??
>
To tell you the truth, I had it exactly like that initially. Some
people suggested
I could combine attach and detach and thereby reduce the number of syscalls.
If you have no issue with adding dedicated syscalls for attach and detach, then
I can add this back.

> But more importantly, and very fundamentally: why did you implement it
> as a special system call? Why didnt you extend ptrace to read/write
> the PMU context? It is _trivial_ and needs no new syscalls at all:
> just a new ptrace parameter to arch_ptrace(). And ptrace will drive
> the TASK_TRACED state machine safely - it already stops/starts tasks
> to read/write hardware context safely.
>

I have not looked at those ptrace extensions. But one thing to keep in mind
is that perfmon can operate at the per-thread level but ALSO at the per-cpu
level (system-wide). I want to the use the same syscall sequence in either case.
You can attach to a thread for a per-thread context or a CPU for a system-wide
context. In system-wide mode, the target designate the CPU, in per-thread the
tid.
