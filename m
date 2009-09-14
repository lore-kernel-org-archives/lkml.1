Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZINPUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZINPUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZINPUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:20:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386AbZINPUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:20:21 -0400
Subject: Re: Warning from ring buffer code (Was: Re: linux-next: tip tree
 build warning)
From: Steven Rostedt <srostedt@redhat.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
       Christopher Li <sparse@chrisli.org>,
       Josh Triplett <josh@freedesktop.org>
In-Reply-To: <1252753957.12217.10.camel@ht.satnam>
References: <20090804161640.70817ee6.sfr@canb.auug.org.au>
	 <1249403089.4634.139.camel@localhost.localdomain>
	 <20090912165300.9d257283.sfr@canb.auug.org.au>
	 <20090912073906.GA3972@elte.hu>  <1252753957.12217.10.camel@ht.satnam>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 14 Sep 2009 11:16:56 -0400
Message-Id: <1252941416.2964.143.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 16:42 +0530, Jaswinder Singh Rajput wrote:

> 
> Here are some more trace related warnings in current linus (as well as
> -tip) tree :
> 
>   CHECK   arch/x86/kernel/ptrace.c
> include/trace/events/syscalls.h:18:1: warning: symbol 'ftrace_raw_output_sys_enter' was not declared. Should it be static?
> include/trace/events/syscalls.h:42:1: warning: symbol 'ftrace_raw_output_sys_exit' was not declared. Should it be static?
> include/trace/events/syscalls.h:18:1: warning: symbol 'ftrace_define_fields_sys_enter' was not declared. Should it be static?
> include/trace/events/syscalls.h:42:1: warning: symbol 'ftrace_define_fields_sys_exit' was not declared. Should it be static?

I just wrote a patch to fix the above.

> include/trace/events/syscalls.h:18:1: error: bad constant expression
> include/trace/events/syscalls.h:42:1: error: bad constant expression

Not sure why sparse is failing on this. Looking at the sched.c code, I
ran "make kernel/sched.i" and then removed the CPP expressions and then
expanded the macros and here's where it is failing:

static void ftrace_profile_sched_kthread_stop(struct task_struct *t)
{
	struct ftrace_data_offsets_sched_kthread_stop __attribute__((unused)) __data_offsets;
	struct ftrace_event_call *event_call = &event_sched_kthread_stop;
	extern void perf_tpcounter_event(int, u64, u64, void *, int);
	struct ftrace_raw_sched_kthread_stop *entry;
	u64 __addr = 0, __count = 1;
	unsigned long irq_flags;
	
	int __entry_size;
	int __data_size;
	int pc;

	do { ({ unsigned long __dummy;
				typeof(irq_flags) __dummy2;
				(void)(&__dummy == &__dummy2);
				1;
			});
		do { (irq_flags) = __raw_local_save_flags();
		} while (0);
	} while (0);
	pc = (current_thread_info()->preempt_count);
	__data_size = ftrace_get_offsets_sched_kthread_stop(&__data_offsets, t);
	__entry_size = (((__data_size + sizeof(*entry) + sizeof(u32))+((typeof(__data_size + sizeof(*entry) + sizeof(u32)))(sizeof(u64))-1))&~((typeof(__data_size + sizeof(*entry) + sizeof(u32)))(sizeof(u64))-1));
	__entry_size -= sizeof(u32);
	do {
		char raw_data[__entry_size];   <<<<----------- FAILURE HERE
		struct trace_entry *ent;
		*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;
		entry = (struct ftrace_raw_sched_kthread_stop *)raw_data;
		ent = &entry->ent;
		tracing_generic_entry_update(ent, irq_flags, pc);
		ent->type = event_call->id;
		{ memcpy(entry->comm, t->comm, 16);
			entry->pid = t->pid;
			;
		} perf_tpcounter_event(event_call->id, __addr, __count, entry, __entry_size);
	} while (0);
};

Sure enough, sparse does not like the __entry_size. I replaced it with
"10" and sparse was happy with it. That is a perfectly legal entry, so
this looks more like a bug with sparse.

I just tested this too:

static void func(int size_me) {
	char array[size_me];

	memcpy(array, "hello", size);
};

and sparse failed on it as well. Note, you need to have something call
func, or sparse will ignore it.


-- Steve


