Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZKSOCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZKSOCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZKSOCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:02:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbZKSOCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:02:48 -0500
Message-ID: <4B055082.50401@redhat.com>
Date: Thu, 19 Nov 2009 09:04:50 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump	patching
 without stop_machine
References: <cover.1258580048.git.jbaron@redhat.com> <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com> <20091119002826.GB28962@Krystal>
In-Reply-To: <20091119002826.GB28962@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
>> Add text_poke_fixup() which takes a fixup address to where a processor
>> jumps if it hits the modifying address while code modifying.
>> text_poke_fixup() does following steps for this purpose.
>>
>>  1. Setup int3 handler for fixup.
>>  2. Put a breakpoint (int3) on the first byte of modifying region,
>>     and synchronize code on all CPUs.
>>  3. Modify other bytes of modifying region, and synchronize code on all CPUs.
>>  4. Modify the first byte of modifying region, and synchronize code
>>     on all CPUs.
>>  5. Clear int3 handler.
>>
> 
> Hi Masami,
> 
> I like the approach and the API is clean. I have intersped comments
> below.

Hi Mathieu,

Thank you for reviewing :-)

> Ingo: I raise a question about text_mutex vs on_each_cpu hangs I
> experienced recently in the message below. Might be worth having a look,
> I suspect this might have caused the hangs Paul McKenney had with his
> past TREE RCU callback migration. I think he did take a mutex in the cpu
> hotplug callbacks and might have used IPIs within that same lock.
> 
>> Thus, if some other processor execute modifying address when step2 to step4,
>> it will be jumped to fixup code.
>>
>> This still has many limitations for modifying multi-instructions at once.
>> However, it is enough for 'a 5 bytes nop replacing with a jump' patching,
>> because;
>>  - Replaced instruction is just one instruction, which is executed atomically.
>>  - Replacing instruction is a jump, so we can set fixup address where the jump
>>    goes to.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> ---
>>  arch/x86/include/asm/alternative.h |   12 ++++
>>  arch/x86/include/asm/kprobes.h     |    1 +
>>  arch/x86/kernel/alternative.c      |  120 ++++++++++++++++++++++++++++++++++++
>>  kernel/kprobes.c                   |    2 +-
>>  4 files changed, 134 insertions(+), 1 deletions(-)
>>
> 
> [snip snip]
> 
>> index de7353c..af47f12 100644
>> --- a/arch/x86/kernel/alternative.c
>> +++ b/arch/x86/kernel/alternative.c
>> @@ -4,6 +4,7 @@
>>  #include <linux/list.h>
>>  #include <linux/stringify.h>
>>  #include <linux/kprobes.h>
>> +#include <linux/kdebug.h>
>>  #include <linux/mm.h>
>>  #include <linux/vmalloc.h>
>>  #include <linux/memory.h>
>> @@ -552,3 +553,122 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>>  	local_irq_restore(flags);
>>  	return addr;
>>  }
>> +
>> +/*
>> + * On pentium series, Unsynchronized cross-modifying code
>> + * operations can cause unexpected instruction execution results.
>> + * So after code modified, we should synchronize it on each processor.
>> + */
>> +static void __kprobes __local_sync_core(void *info)
>> +{
>> +	sync_core();
>> +}
>> +
>> +void __kprobes sync_core_all(void)
>> +{
>> +	on_each_cpu(__local_sync_core, NULL, 1);
> 
> OK, so you rely on the fact that on_each_cpu has memory barriers and
> executes the remote "__local_sync_core" with the appropriate memory
> barriers underneath, am I correct ?

Right, at least I expected that.

>> +}
>> +
>> +/* Safely cross-code modifying with fixup address */
>> +static void *patch_fixup_from;
>> +static void *patch_fixup_addr;
>> +
>> +static int __kprobes patch_exceptions_notify(struct notifier_block *self,
>> +					      unsigned long val, void *data)
>> +{
>> +	struct die_args *args = data;
>> +	struct pt_regs *regs = args->regs;
>> +
>> +	if (likely(!patch_fixup_from))
>> +		return NOTIFY_DONE;
>> +
>> +	if (val != DIE_INT3 || !regs || user_mode_vm(regs) ||
>> +	    (unsigned long)patch_fixup_from != regs->ip)
>> +		return NOTIFY_DONE;
>> +
>> +	args->regs->ip = (unsigned long)patch_fixup_addr;
>> +	return NOTIFY_STOP;
>> +}
>> +
>> +/**
>> + * text_poke_fixup() -- cross-modifying kernel text with fixup address.
>> + * @addr:	Modifying address.
>> + * @opcode:	New instruction.
>> + * @len:	length of modifying bytes.
>> + * @fixup:	Fixup address.
>> + *
>> + * Note: You must backup replaced instructions before calling this,
>> + * if you need to recover it.
>> + * Note: Must be called under text_mutex.
>> + */
>> +void *__kprobes text_poke_fixup(void *addr, const void *opcode, size_t len,
>> +				void *fixup)
>> +{
>> +	static const unsigned char int3_insn = BREAKPOINT_INSTRUCTION;
>> +	static const int int3_size = sizeof(int3_insn);
>> +
>> +	/* Replacing 1 byte can be done atomically. */
> 
> I'm sure it can be done atomically, but can it be done safely though ?
> 
> (disclaimer: we're still waiting for the official answer on this
> statement): Assuming instruction trace cache effects of SMP cross-code
> modification, and that only int3 would be safe to patch, then even
> changing 1 single byte could only be done by going to an intermediate
> int3 and synchronizing all other cores.

Ah, I see. Certainly, that's possible (int3 might be a special token of
cache coherency). So even len==1, we might better use int3 capping.

> 
>> +	if (unlikely(len <= 1))
>> +		return text_poke(addr, opcode, len);
>> +
>> +	/* Preparing */
>> +	patch_fixup_addr = fixup;
>> +	wmb();
> 
> hrm, missing comment ?

Ah, it's a barrier between patch_fixup_addr and patch_fixup_from.
int3 trap handler checks patch_fixup_from first and refers patch_fixup_addr.

> 
>> +	patch_fixup_from = (u8 *)addr + int3_size; /* IP address after int3 */
>> +
>> +	/* Cap by an int3 */
>> +	text_poke(addr, &int3_insn, int3_size);
>> +	sync_core_all();
>> +
>> +	/* Replace tail bytes */
>> +	text_poke((char *)addr + int3_size, (const char *)opcode + int3_size,
>> +		  len - int3_size);
>> +	sync_core_all();
>> +
>> +	/* Replace int3 with head byte */
>> +	text_poke(addr, opcode, int3_size);
>> +	sync_core_all();
>> +
>> +	/* Cleanup */
>> +	patch_fixup_from = NULL;
>> +	wmb();
> 
> missing comment here too.
> 
>> +	return addr;
> 
> Little quiz question:
> 
> When patch_fixup_from is set to NULL, what ensures that the int3
> handlers have completed their execution ?
> 
> I think it's probably OK, because the int3 is an interrupt gate, which
> therefore disables interrupts as soon as it runs, and executes the
> notifier while irqs are off. When we run sync_core_all() after replacing
> the int3 by the new 1st byte, we only return when all other cores have
> executed an interrupt, which implies that all int3 handlers previously
> running should have ended. Is it right ? It looks to me as if this 3rd
> sync_core_all() is only needed because of that. Probably that adding a
> comment would be good.

Thanks, it's a good point and that's more what I've thought.
As you said, it is probably safe. Even if it's not safe,
we can add some int3 fixup handler (with lowest priority)
which set regs->ip-1 if there is no int3 anymore, for safety.

> Another thing: I've recently noticed that the following locking seems to
> hang the system with doing stress-testing concurrently with cpu
> hotplug/hotunplug:
> 
> mutex_lock(&text_mutex);
>   on_each_cpu(something, NULL, 1);
> 
> The hang seems to be caused by the fact that alternative.c has:
> 
> within cpu hotplug (cpu hotplug lock held)
>   mutex_lock(&text_mutex);
> 
> It might also be caused by the interaction with the stop_machine()
> performed within the cpu hotplug lock. I did not find the root cause of
> the problem, but this probably calls for lockdep improvements.

Hmm, would you mean it will happen even if we use stop_machine()
under text_mutex locking?
It seems that bigger problem of cpu-hotplug and on_each_cpu() etc.

> In any case, given you are dealing with the exact same locking scenario
> here, I would recomment the following stress-test:
> 
> in a loop, use text_poke_jump()
> in a loop, hotunplug all cpus, then hotplug all cpus
> 
> I had to fix this temporarily by taking get/put_online_cpus() about the
> text_mutex.
> 
> [snip snip]
> 
>> +static struct notifier_block patch_exceptions_nb = {
>> +	.notifier_call = patch_exceptions_notify,
>> +	.priority = 0x7fffffff /* we need to be notified first */
>> +};
>> +
>> +static int __init patch_init(void)
>> +{
>> +	return register_die_notifier(&patch_exceptions_nb);
>> +}
>> +
>> +arch_initcall(patch_init);
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index e5342a3..43a30d8 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -898,7 +898,7 @@ EXPORT_SYMBOL_GPL(unregister_kprobes);
>>  
>>  static struct notifier_block kprobe_exceptions_nb = {
>>  	.notifier_call = kprobe_exceptions_notify,
>> -	.priority = 0x7fffffff /* we need to be notified first */
>> +	.priority = 0x7ffffff0 /* High priority, but not first.  */
> 
> It would be good to keep all these priorities in a centralized header.

Sure, I'll put it in kprobes.h.

Thank you!
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

