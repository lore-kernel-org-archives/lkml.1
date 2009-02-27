Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbZB0Rwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbZB0Rwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 12:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZB0Rwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 12:52:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59279 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643AbZB0Rwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 12:52:38 -0500
Message-ID: <49A82851.5080707@redhat.com>
Date: Fri, 27 Feb 2009 12:52:17 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for conversions
References: <87y6vyuzsn.fsf@basil.nowhere.org> <alpine.DEB.2.00.0902221741040.18221@gandalf.stny.rr.com> <20090223023332.GA5430@Krystal> <alpine.DEB.2.00.0902222317510.18221@gandalf.stny.rr.com> <20090223045357.GA9158@Krystal> <alpine.DEB.2.00.0902230928000.18221@gandalf.stny.rr.com> <20090223154258.GB28727@Krystal> <alpine.DEB.2.00.0902231044050.18221@gandalf.stny.rr.com> <20090223161312.GA30279@Krystal> <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com> <20090223173108.GB1441@Krystal> <alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------030904070604050300020107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030904070604050300020107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Steven Rostedt wrote:
> On Mon, 23 Feb 2009, Mathieu Desnoyers wrote:
>>> Hmm, lets see. I simply set a bit in the PTE mappings. There's not many, 
>>> since a lot are 2M pages, for x86_64. Call stop_machine, and now I can 
>>> modify 1 or 20,000 locations. Set the PTE bit back. Note, the changing of 
>>> the bits are only done when CONFIG_DEBUG_RODATA is set.
>>>
>>> text_poke requires allocating a page. Map the page into memory. Set up a 
>>> break point.
>> text_poke does not _require_ a break point. text_poke can work with
>> stop_machine.
> 
> It can? Doesn't text_poke require allocating pages? The code called by 
> stop_machine is all atomic. vmap does not give an option to allocate with 
> GFP_ATOMIC.

Hi,

With my patch, text_poke() never allocate pages any more :)

BTW, IMHO, both of your methods are useful and have trade-off.

ftrace wants to change massive amount of code at once. If we do
that with text_poke(), we have to map/unmap pages each time and
it will take a long time -- might be longer than one stop_machine_run().

On the other hand, text_poke() user like as kprobes and tracepoints,
just want to change a few amount of code at once, and it will be
added/removed incrementally. If we do that with stop_machine_run(),
we'll be annoyed by frequent machine stops.(Moreover, kprobes uses
breakpoint, so it doesn't need stop_machine_run())


Thank you,

>> There are two different problems here :
> 
> I agree that they are two different problems. The reason I relate them is 
> because text_poke can not be called from a stop_machine call.
> 
>> - How you deal with concurrency
>>   - you use stop machine
>>   - I use breakpoints
>> - How you deal with RO page mappings
>>   - you change the kernel page flags
>>   - i use text_poke
>>
>> Please don't mix those separate concerns.
> 
> So you have two different concerns. One is that I use stop_machine, 
> instead of break points, the other is that I modify all kernel text to
> make the change.
> 
> Lets look at them separately.
> 
> The stop_machine vs. break points.
> 
> breakpoints is a cool trick, but is not implemented on all the archs that 
> dynamic ftrace is.
> 
> break points are performed on a running system. This may be lower in 
> latency tracing when the tracer is started, but can create a large number 
> of variables that can not all be understood.
> 
> stop_machine is quite simple. No need to take traps, no need to handle 
> what to do when another process runs the code being changed.
> 
> When making the hooks, stop_machine can add a bit of a interrupt latency. 
> But this is only when the hooks are added or removed. Why is this such a 
> big deal?  It is much easier to add the hooks with tracing disabled (via 
> a simple toggle bit). Then start and stop your tracing by using the toggle 
> bit. After you are all done, then remove the hooks. Or just keep them 
> on since they are low overhead anyway (only a few hooks right?)
> 
> 
> CONFIG_DEBUG_RODATA (only an x86 issue at the moment)
> 
> text_poke vs changing all pages:
> 
> You said this is a separate issue than stop_machine. But that is not the 
> case. text_poke can not be done in an atomic section. This removes it from 
> being used by stop_machine.
> 
> As you said, text_poke only handles the RO/RW issue, not the modifying of 
> code on the fly. Thus, keeping stop_machine around, we must also not use 
> text_poke.
> 
> I guess this takes the text_poke vs changing all pages out of the 
> question. While stop_machine is still being used, we can not use 
> text_poke (without rewriting it).
> 
> Also when we want to trace all functions, is it really necessary to vmap
> each one at a time? Andi suggested that we could optimise by mapping 
> larger pages, and finding the ones that share the page. This too would 
> require a rewrite of text_poke.
> 
> 
> 
>>>> If, in the end, your argument is "the function tracer works as-is now,
>>>> and I have no time to change it given it represents too much work" or "I
>>>> don't care about your use-cases", I'm OK with that. But please then don't
>>>> argue that it's because it's the best technical solution when it isn't.
>>> No, I have yet to hear a valuable argument against stop_machine. You are 
>>> pushing the burden of proof on me, when we have something that does work, 
>>> on several archs. You want me to redesign the system to be x86 only, and 
>>> then say, hey, my original code works better.
>>>
>> stop_machine involves high interrupt latency. This is the argument I've
>> been repeating for 1-2 emails already. And I have to disagree with you :
>> we can do this code generically given the right abstractions
>> (BREAKPOINT_INSN* macros I proposed earlier). Is having something that
>> "works" your only argument to stop improving it ?
> 
> The high interrupt latency only happens at the time we need to hook the 
> functions. This does not mean it is the time to start the tracing. That 
> can be done separately.
> 
> Your only concern is the stop_machine latency? Then you might as well also 
> prevent modules, since that uses stop machine too. Again, this happens 
> only when the tracer hooks are added or removed. This is done at a time 
> the sys-admin will activate it. It is not a random latency that is 
> occurred by some timer or other asynchronous event.
> 
>>> I do not see text_poke being theoretically better. The only reason you 
>>> given me to use it is because you dislike stop_machine.
>>>
>> There is absolutely no link between stop_machine and text_poke. I argue
>> against stop_machine saying that the breakpoint approach is less
>> intrusive because it does not involve disabling interrupts for so long,
>> and I argue against modifying the kernel page flags because that
>> modifies the access rights of the core kernel and modules to RO
>> mappings, which is IMO a side-effect that we should eliminate _if we
>> can_. Please keep those two concerns separate.
> 
> text_poke can not be executed from stop_machine. There's the link. The two 
> concerns are not separate.
> 
> Your concern with stop_machine is that it will cause an interrupt latency 
> when the sysadmin enables or disables the functions. There exists other 
> interrupt latencies that can be worst that are asynchronous. Run hackbench 
> with the irqs off tracer and see for yourself.
> 
> -- Steve
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


--------------030904070604050300020107
Content-Type: text/plain;
 name="text_poke-use-own-vmap-area.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="text_poke-use-own-vmap-area.patch"

Use map_vm_area() instead of vmap() in text_poke() for avoiding page allocation
and delayed unmapping.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/x86/include/asm/alternative.h |    1 +
 arch/x86/kernel/alternative.c      |   25 ++++++++++++++++++++-----
 init/main.c                        |    3 +++
 3 files changed, 24 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/include/asm/alternative.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/alternative.h
+++ linux-2.6/arch/x86/include/asm/alternative.h
@@ -177,6 +177,7 @@ extern void add_nops(void *insns, unsign
  * The _early version expects the memory to already be RW.
  */
 
+extern void text_poke_init(void);
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_early(void *addr, const void *opcode, size_t len);
 
Index: linux-2.6/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/alternative.c
+++ linux-2.6/arch/x86/kernel/alternative.c
@@ -485,6 +485,16 @@ void *text_poke_early(void *addr, const 
 	return addr;
 }
 
+static struct vm_struct *text_poke_area[2];
+static DEFINE_SPINLOCK(text_poke_lock);
+
+void __init text_poke_init(void)
+{
+	text_poke_area[0] = get_vm_area(PAGE_SIZE, VM_ALLOC);
+	text_poke_area[1] = get_vm_area(2 * PAGE_SIZE, VM_ALLOC);
+	BUG_ON(!text_poke_area[0] || !text_poke_area[1]);
+}
+
 /**
  * text_poke - Update instructions on a live kernel
  * @addr: address to modify
@@ -501,8 +511,9 @@ void *__kprobes text_poke(void *addr, co
 	unsigned long flags;
 	char *vaddr;
 	int nr_pages = 2;
-	struct page *pages[2];
-	int i;
+	struct page *pages[2], **pgp = pages;
+	int i, ret;
+	struct vm_struct *vma;
 
 	if (!core_kernel_text((unsigned long)addr)) {
 		pages[0] = vmalloc_to_page(addr);
@@ -515,12 +526,16 @@ void *__kprobes text_poke(void *addr, co
 	BUG_ON(!pages[0]);
 	if (!pages[1])
 		nr_pages = 1;
-	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
-	BUG_ON(!vaddr);
+	spin_lock(&text_poke_lock);
+	vma = text_poke_area[nr_pages-1];
+	ret = map_vm_area(vma, PAGE_KERNEL, &pgp);
+	BUG_ON(ret);
+	vaddr = vma->addr;
 	local_irq_save(flags);
 	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
 	local_irq_restore(flags);
-	vunmap(vaddr);
+	unmap_kernel_range((unsigned long)vma->addr, (unsigned long)vma->size);
+	spin_unlock(&text_poke_lock);
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
@@ -528,3 +543,4 @@ void *__kprobes text_poke(void *addr, co
 		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
 	return addr;
 }
+EXPORT_SYMBOL_GPL(text_poke);
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -676,6 +676,9 @@ asmlinkage void __init start_kernel(void
 	taskstats_init_early();
 	delayacct_init();
 
+#ifdef CONFIG_X86
+	text_poke_init();
+#endif
 	check_bugs();
 
 	acpi_early_init(); /* before LAPIC and SMP init */

--------------030904070604050300020107--
