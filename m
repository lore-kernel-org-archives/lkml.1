Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbYGaAkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbYGaAkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYGaAjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:39:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54660 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbYGaAju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:39:50 -0400
Date: Wed, 30 Jul 2008 20:39:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: dump out ftrace buffers to console on panic
In-Reply-To: <20080730143028.a8e94161.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0807302020590.19138@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0807301700080.16138@gandalf.stny.rr.com> <20080730143028.a8e94161.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 30 Jul 2008, Andrew Morton wrote:

> On Wed, 30 Jul 2008 17:13:24 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
>>
>> At OLS I had a lot of interest to be able to have the ftrace buffers
>> dumped on panic.  Usually one would expect to uses kexec and examine
>> the buffers after a new kernel is loaded. But sometimes the resources
>> do not permit kdump and kexec, so having an option to still see the
>> sequence of events up to the crash is very advantageous.
>>
>> This patch adds the option to have the ftrace buffers dumped to the
>> console in the latency_trace format on a panic. When the option is set,
>> the default entries per CPU buffer are lowered to 16384, since the writing
>> to the serial (if that is the console) may take an aweful long time
>> otherwise.
>
> The modern spelling is "awful" ;)

I need to get spell check working with alpine :-/

>
>> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>> ---
>>   include/linux/ftrace.h |    6 +
>>   kernel/trace/Kconfig   |   10 ++
>>   kernel/trace/trace.c   |  179 ++++++++++++++++++++++++++++++++++++++++++++++++-
>>   3 files changed, 194 insertions(+), 1 deletion(-)
>>
>> Index: linux-tip.git/kernel/trace/trace.c
>> ===================================================================
>> --- linux-tip.git.orig/kernel/trace/trace.c	2008-07-29 10:47:53.000000000 -0400
>> +++ linux-tip.git/kernel/trace/trace.c	2008-07-30 16:46:15.000000000 -0400
>> @@ -14,6 +14,7 @@
>>   #include <linux/utsrelease.h>
>>   #include <linux/kallsyms.h>
>>   #include <linux/seq_file.h>
>> +#include <linux/notifier.h>
>
> Your email client space-stuffed the patch.

Again, I just switched from pine to alpine, and ^R is not pulling in 
patches correctly. I thought I fixed it, but I guess I did not :-(

>
>>   #include <linux/debugfs.h>
>>   #include <linux/pagemap.h>
>>   #include <linux/hardirq.h>
>> @@ -22,6 +23,7 @@
>>   #include <linux/ftrace.h>
>>   #include <linux/module.h>
>>   #include <linux/percpu.h>
>> +#include <linux/kdebug.h>
>>   #include <linux/ctype.h>
>>   #include <linux/init.h>
>>   #include <linux/poll.h>
>> @@ -104,7 +106,16 @@ int				ftrace_function_enabled;
>>    * for a buffer. Note, the number of entries is always rounded
>>    * to ENTRIES_PER_PAGE.
>>    */
>> -static unsigned long		trace_nr_entries = 65536UL;
>> +#ifdef CONFIG_FTRACE_DUMP_ON_OOPS
>> +/*
>> + * If dump on oops is defined, lower the number of entries.
>> + * Usually this goes over the serial, and is used for debugging.
>
> I suspect that (netconsole > serial) nowadays.

Hmm, I find that serial is more reliable for me. Also it is what I usually 
have when I debug a machine remotely.

>
>> + */
>> +# define TRACE_ENTRIES_DEFAULT	16384UL
>> +#else
>> +# define TRACE_ENTRIES_DEFAULT	65536UL
>> +#endif
>> +static unsigned long		trace_nr_entries = TRACE_ENTRIES_DEFAULT;
>>
>>   /* trace_types holds a link list of available tracers. */
>>   static struct tracer		*trace_types __read_mostly;
>> @@ -2930,6 +2941,166 @@ static __init void tracer_init_debugfs(v
>>   #endif
>>   }
>>
>> +#ifdef CONFIG_FTRACE_DUMP_ON_OOPS
>> +static int trace_panic_handler(struct notifier_block *this,
>> +			       unsigned long event, void *unused)
>> +{
>> +	ftrace_dump();
>> +	return NOTIFY_OK;
>> +}
>> +
>> +static struct notifier_block trace_panic_notifier = {
>> +	.notifier_call  = trace_panic_handler,
>> +	.next           = NULL,
>> +	.priority       = 150   /* priority: INT_MAX >= x >= 0 */
>> +};
>> +
>> +static int trace_die_handler(struct notifier_block *self,
>> +			     unsigned long val,
>> +			     void *data)
>> +{
>> +	switch (val) {
>> +	case DIE_OOPS:
>> +		ftrace_dump();
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +	return NOTIFY_OK;
>> +}
>> +
>> +static struct notifier_block trace_die_notifier = {
>> +	.notifier_call = trace_die_handler,
>> +	.priority = 200
>> +};
>> +
>> +static void
>> +trace_printk_seq(struct trace_seq *s)
>> +{
>> +	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
>
> That's an open-coded min().
>
> Beware that some architectures' PAGE_SIZE has unsigned long type and
> others have a different type (unsigned?) so a min() on PAGE_SIZE will
> warn on some architectures and not on others.  min_t will fix that.

Thanks. This is cut and paste from another part of the code. I'll fix that 
too.

>
>> +	s->buffer[len] = 0;
>>
>> +	printk("%s", s->buffer);
>
> If the null-termination of ->buffer[] was actually needed then we have
> a big problem here.

hehe, yeah, my first run filled up the page before printing, and I saw the 
result of that.  I changed the code later to print at each iteration, 
which is much less than a page size. It should pretty much fit on a line.
Since the dump is the only user, I could just print the buffer without the 
checks. I can put a warn on if the len is greater than some max, and 
return.

>
> I'd suggest a conversion to vsnprintf().

??

>
>> +	trace_seq_reset(s);
>> +}
>> +
>> +
>> +static struct trace_iterator dump_iter;
>> +static raw_spinlock_t ftrace_dump_lock =
>> +	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
>
> argh.  Please never do an uncommented raw_spinlock_t.  It's just
> impossible for your readers to work out ytf it was chosen.

OK. I'll add the comment. The reason for doing this is because it is a 
special case in oops and not for normal use. If an oops happened in the
lockdep code, I don't want it to recursive fault here.

>
>> +static int dump_running;
>> +
>> +void ftrace_dump(void)
>> +{
>> +	struct trace_iterator *iter = &dump_iter;
>> +	struct trace_array_cpu *data;
>> +	static cpumask_t mask;
>> +	unsigned long flags;
>> +	int cpu, ret;
>> +	int cnt = 0;
>> +
>> +	local_irq_save(flags);
>> +
>> +	/* only one dump at a time */
>> +	__raw_spin_lock(&ftrace_dump_lock);
>
> Should we have a __raw_spinlock_irqsave()?

I'd like one but one doesn't exist. Actually, it is good we don't have one 
because __raw_spin_lock should rarely be used.

Hmm, I think I should just change the whole thing back to normal 
spin_locks and just hope that lockdep never oops ;-)


>
>> +	if (dump_running)
>> +		ret = 1;
>> +	else {
>> +		dump_running = 1;
>> +		ret = 0;
>> +	}
>> +	__raw_spin_unlock(&ftrace_dump_lock);
>> +
>> +	if (ret)
>> +		goto out;
>> +
>> +	/* No turning back! */
>> +	ftrace_kill_atomic();
>> +
>> +	printk("Dumping ftrace buffer:\n");
>
> didst thou run checkpatch?

Damn, I thought I did, but obviously I didn't!

>
>> +	memset(iter, 0, sizeof(*iter));
>
> This is zeroing out dump_iter, which is already zeroed.  Is it needed?

Good point. No it isn't needed. I'll replace that with a comment.

>
>> +	iter->tr = &global_trace;
>> +	iter->trace = current_trace;
>
> The use of local variable `iter' instead of simply using direct access
> to dump_iter declarifies things.  Perhaps it generates significantly
> better code?  If not, I'd suggest doing it the simple way.
>
> dump_iter could be made local to this function.

I can make it local to this function. The reason for using iter, is that I 
cut and pasted other code and modified it from there.

>
>> +	/*
>> +	 * We need to stop all tracing on all CPUS to read the
>> +	 * the next buffer. This is a bit expensive, but is
>> +	 * not done often. We fill all what we can read,
>> +	 * and then release the locks again.
>> +	 */
>> +
>> +	cpus_clear(mask);
>> +
>> +	for_each_tracing_cpu(cpu) {
>> +		data = iter->tr->data[cpu];
>> +
>> +		if (!head_page(data) || !data->trace_idx)
>> +			continue;
>> +
>> +		atomic_inc(&data->disabled);
>> +		cpu_set(cpu, mask);
>> +	}
>> +
>> +	for_each_cpu_mask(cpu, mask) {
>> +		data = iter->tr->data[cpu];
>> +		__raw_spin_lock(&data->lock);
>> +
>> +		if (data->overrun > iter->last_overrun[cpu])
>> +			iter->overrun[cpu] +=
>> +				data->overrun - iter->last_overrun[cpu];
>> +		iter->last_overrun[cpu] = data->overrun;
>> +	}
>> +
>> +	while (!trace_empty(iter)) {
>> +
>> +		if (!cnt)
>> +			printk("---------------------------------\n");
>> +
>> +		cnt++;
>> +
>> +		/* reset all but tr, trace, and overruns */
>> +		memset(&iter->seq, 0,
>> +		       sizeof(struct trace_iterator) -
>> +		       offsetof(struct trace_iterator, seq));
>> +		iter->iter_flags |= TRACE_FILE_LAT_FMT;
>> +		iter->pos = -1;
>> +
>> +		if (find_next_entry_inc(iter) != NULL) {
>> +			print_trace_line(iter);
>> +			trace_consume(iter);
>> +		}
>> +
>> +		trace_printk_seq(&iter->seq);
>> +	}
>> +
>> +	if (!cnt)
>> +		printk("   (ftrace buffer empty)\n");
>> +	else
>> +		printk("---------------------------------\n");
>> +
>> +	for_each_cpu_mask(cpu, mask) {
>> +		data = iter->tr->data[cpu];
>> +		__raw_spin_unlock(&data->lock);
>> +	}
>> +
>> +	for_each_cpu_mask(cpu, mask) {
>> +		data = iter->tr->data[cpu];
>> +		atomic_dec(&data->disabled);
>> +	}
>
> Can we combine those two loops into one?

Yes but I kept it this way to match the semantics of the taking and 
incrementing of the disabled atomic variable.  The disabling is done first 
but with a check to see if the buffers even exist, and we update mask to 
match.  Then we run the loop on the match and take the locks.

I feel safer on keeping the grabing of spinlocks and disabling the 
buffers separate, as well as releasing them.

>
>> +	__raw_spin_lock(&ftrace_dump_lock);
>> +	dump_running = 0;
>> +	__raw_spin_unlock(&ftrace_dump_lock);
>> +
>> + out:
>> +	local_irq_restore(flags);
>> +}
>> +#endif /* CONFIG_FTRACE_DUMP_ON_OOPS */
>
> Do we really need a new config option for this?  Would it hurt too much
> to make it unconditionally available?

I don't mind making it unconditionally available. I only added the config 
option because I thought people would like to turn it off.

I'll resubmit with the above concerns fixed and without the config option.

Thanks Andrew, as always, you give constructive feedback.

-- Steve

