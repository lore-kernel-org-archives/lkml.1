Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbYKHO6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbYKHO6x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 09:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYKHO6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 09:58:44 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:10811 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYKHO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 09:58:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Tm56dQvhRgbQ2AyaYua9eb7LVO1CmZM7oASF7v6DdXw5vhgD2tXf/VC19T1yVW9xuT
         TWYruZunMgmPgYN1Ajt8tm0IJWT06iiUt+dgguVYV4oK5l1zPq+ULYKrNXA8lnCl91vA
         sPcBWAZuqOGBap0gmGgA7HTyrjMJ6vAYgpOEo=
Message-ID: <c62985530811080658q66a6d619l364a619cef5a9c96@mail.gmail.com>
Date: Sat, 8 Nov 2008 15:58:41 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC v2][PATCH 1/2] Add low level support for ftrace return tracing
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811071302030.3711@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49148114.9040203@gmail.com>
	 <alpine.DEB.1.10.0811071302030.3711@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/7 Steven Rostedt <rostedt@goodmis.org>:
> Shouldn't the CONFIG_FTRACE_RETURN be dependent on CONFIG_FUNCTION_TRACER
> that is the #endif above. This probably is not needed.



The return tracing is independent from the original function tracing.
And actually, when I talk about a plugin, it's a kind of mistake
because it doesn't really use the function tracer.

>> +CFLAGS_REMOVE_tsc.o = -pg
>> +CFLAGS_REMOVE_rtc.o = -pg
>> +CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
>> +CFLAGS_REMOVE_ftrace.o = -pg
>> +CFLAGS_REMOVE_early_printk.o = -pg
>> +endif
>> +
>> +
>> +
>>  #
>>  # vsyscalls (which work on the user stack) should have
>>  # no stack-protector checks:
>> @@ -67,6 +77,7 @@ obj-$(CONFIG_X86_LOCAL_APIC)        += apic.o nmi.o
>>  obj-$(CONFIG_X86_IO_APIC)    += io_apic.o
>>  obj-$(CONFIG_X86_REBOOTFIXUPS)       += reboot_fixups_32.o
>>  obj-$(CONFIG_DYNAMIC_FTRACE) += ftrace.o
>> +obj-$(CONFIG_FTRACE_RETURN)  += ftrace.o
>>  obj-$(CONFIG_KEXEC)          += machine_kexec_$(BITS).o
>>  obj-$(CONFIG_KEXEC)          += relocate_kernel_$(BITS).o crash.o
>>  obj-$(CONFIG_CRASH_DUMP)     += crash_dump_$(BITS).o
>> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
>> index 9134de8..c2eb2c5 100644
>> --- a/arch/x86/kernel/entry_32.S
>> +++ b/arch/x86/kernel/entry_32.S
>> @@ -1188,7 +1188,13 @@ ENTRY(mcount)
>>
>>       cmpl $ftrace_stub, ftrace_trace_function
>>       jnz trace
>> +#ifdef CONFIG_FTRACE_RETURN
>> +     cmpl $ftrace_return_stub, ftrace_function_return
>> +     jnz trace_return
>> +#endif
>>  .globl ftrace_stub
>> +.globl ftrace_return_stub
>> +ftrace_return_stub:
>
> Hmm, ftrace_stub will always be just a ret. Can't you just reuse
> ftrace_stub?
>


That's right. I created ftrace_return_stub because I needed a
ftrace_stub with the appropriate  type.
I wanted an ftrace_strub with the type void(*)(struct ftrace_retfunc
*). Would such a cast on ftrace_stub be admitted for the coding style?
In this case there is no problem to have only ftrace_stub.


>>  ftrace_stub:
>>       ret
>>
>> @@ -1206,7 +1212,23 @@ trace:
>>       popl %edx
>>       popl %ecx
>>       popl %eax
>> +     jmp ftrace_stub
>>
>> +#ifdef CONFIG_FTRACE_RETURN
>> +trace_return:
>> +     pushl %eax
>> +     pushl %ecx
>> +     pushl %edx
>> +     movl 0xc(%esp), %eax
>> +     pushl %eax
>> +     lea 0x4(%ebp), %eax
>> +     pushl %eax
>> +     call prepare_ftrace_return
>> +     addl $8, %esp
>> +     popl %edx
>> +     popl %ecx
>> +     popl %eax
>> +#endif
>>       jmp ftrace_stub
>
> This is a hanging "jmp ftrace_stub" when CNOFIG_FTRACE_RETURN is not set.


Oops, yes I will correct it.

>>  END(mcount)
>>  #endif /* CONFIG_DYNAMIC_FTRACE */
>> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
>> index 6914933..2bdd11d 100644
>> --- a/arch/x86/kernel/ftrace.c
>> +++ b/arch/x86/kernel/ftrace.c
>> @@ -18,29 +18,236 @@
>>  #include <linux/list.h>
>>
>>  #include <asm/ftrace.h>
>> +#include <linux/ftrace.h>
>>  #include <asm/nops.h>
>> +#include <asm/nmi.h>
>>
>>
>> -static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
>> +static int ftrace_calc_offset(long ip, long addr)
>> +{
>> +     return (int)(addr - ip);
>> +}
>>
>> -union ftrace_code_union {
>> -     char code[MCOUNT_INSN_SIZE];
>> +#ifdef CONFIG_FTRACE_RETURN
>> +#define FTRACE_TRAMPOLINE_SIZE 32
>> +
>> +struct ftrace_return_data {
>> +     /* Bitmap which defines free slots in func table */
>> +     unsigned long bitmap;
>> +     raw_spinlock_t bitmap_lock;
>> +     union ftrace_return_code_union *trampoline;
>> +     struct ftrace_retfunc *func_table;
>> +     unsigned long overrun;
>> +};
>> +
>> +static struct ftrace_return_data ftrace_return_state;
>> +
>> +/*
>> + * On each slot of this trampoline we have
>> + * push $index
>> + * call ftrace_return_to_handler
>> + * Index is the place in the func table where
>> + * are stored the information for the current
>> + * call frame.
>> + */
>> +union ftrace_return_code_union {
>> +     char code[MCOUNT_INSN_SIZE + 2];
>>       struct {
>> -             char e8;
>> +             char push; /* push imm8 */
>> +             char index; /* index on the trampoline/func table */
>> +             char e8; /* call to the return handler */
>>               int offset;
>>       } __attribute__((packed));
>>  };
>>
>>
>> -static int ftrace_calc_offset(long ip, long addr)
>> +void ftrace_call_replace(char index, unsigned long ip, unsigned long addr,
>> +                      union ftrace_return_code_union *calc)
>>  {
>> -     return (int)(addr - ip);
>> +     calc->push              = 0x6a;
>> +     calc->index             = index;
>> +     calc->e8                = 0xe8;
>> +     calc->offset    = ftrace_calc_offset(ip + 2 + MCOUNT_INSN_SIZE, addr);
>> +
>
> Heads up, some of this code will be modified in the future to handle
> trampolines used by modules. But you don't have to worry about that yet.
> ;-)


Ok :-)



>>  }
>>
>> -unsigned char *ftrace_nop_replace(void)
>> +asmlinkage
>> +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>>  {
>> -     return ftrace_nop;
>> +     unsigned long flags;
>> +     int index;
>> +     unsigned long old, trampoline;
>> +     int faulted;
>> +
>> +     /* Nmi's are currently unsupported */
>> +     if (atomic_read(&nmi_active))
>
> Would "in_nmi()" be better?


I searched this function in the kernel and didn't find it. And so I
used nmi_active. But I would prefer a trick like in_nmi()
because I'm not tracing anything when the watchdog in active. The
better way should be to disable it only when we are in nmi context.
Perhaps I should implement in_nmi() and put it on nmi.h ?

>> +             return;
>> +
>> +     raw_local_irq_save(flags);
>> +     __raw_spin_lock(&ftrace_return_state.bitmap_lock);
>> +     if (!ftrace_return_state.bitmap) {
>> +             __raw_spin_unlock(&ftrace_return_state.bitmap_lock);
>> +             raw_local_irq_restore(flags);
>> +             return;
>> +     }
>> +     /* Find next free slot and reserve */
>> +     index = ffs(ftrace_return_state.bitmap) - 1;
>> +     clear_bit(index, &ftrace_return_state.bitmap);
>
> Have you thought about using the stack? Or just add something to the
> task struct, a list of return pointers. Or just add it to the thread info
> struct itself. Make it a depth of 30 or something, and if you hit the max
> depth, bail. (Note the thread info is on the task's stack)


You're right. The solution of trampolines is sufficient for my labtop
with two cores. If tracing is done on smp with much more cpu and a lot
of concurrent tasks, I fear there would be too much overruns and a lot
of missing traces.
Ok I will move this to thread_info. I will have to figure out first
which functions never return and/or so which never free the bitmap.
Because if I implement such a stack of pointers, I can't have such a
bug.
The first non-return function I know is cpu_idle(), I will have to
find the others.

BTW, I just wonder for something, is "current" available even on
interrupt context? If so that should be no problem. I can store the
return pointer of an interrupt on the thread_info of the interrupted
task.

>> +
>> +     __raw_spin_unlock(&ftrace_return_state.bitmap_lock);
>> +     raw_local_irq_restore(flags);
>> +     ftrace_return_state.func_table[index].func = self_addr;
>> +
>> +     trampoline = (unsigned long)&ftrace_return_state.trampoline[index];
>> +
>> +     /*
>> +      * Protect against fault, even if it shouldn't
>> +      * happen. This tool is too much intrusive to
>> +      * ignore such a protection.
>> +      */
>> +     asm volatile(
>> +             "1: movl (%3), %1\n"
>> +             "2: movl %4, (%0)\n"
>> +             "   movl $0, %2\n"
>> +
>> +             ".section .fixup, \"ax\"\n"
>> +             "3: movl $1, %2\n"
>> +             ".previous\n"
>> +
>> +             ".section __ex_table, \"a\"\n"
>> +             "   .long 1b, 3b\n"
>> +             "   .long 2b, 3b\n"
>> +             ".previous\n"
>> +
>> +             : "=rm" (parent), "=r" (old), "=r" (faulted)
>> +             : "0" (parent), "r" (trampoline)
>> +             : "memory"
>
> BTW, I suggest using names instead of the %#, see
> arch/sparc64/kernel/ftrace.c for details.


Right. Would be much more readable.

>> +     );
>> +
>> +     if (faulted) {
>> +             set_bit(index, &ftrace_return_state.bitmap);
>
> You said that this should never fault, correct. Lets be conservative and
> have a way to WARN_ON and shut everything down if you detect something
> that is not suppose to happen.


That's right.

>
>> +             return;
>> +     }
>> +
>> +     if (!__kernel_text_address(old)) {

> Again, this should WARN_ON and shut things down.


Ok.

>> +             set_bit(index, &ftrace_return_state.bitmap);
>> +             *parent = old;
>> +             return;
>> +     }
>> +
>> +
>> +     ftrace_return_state.func_table[index].ret = old;
>> +     ftrace_return_state.func_table[index].calltime =
>> +                             cpu_clock(raw_smp_processor_id());
>
> We might be able to save the call time in the tracer when it happens.
> This way we do not need to save it here.


But I have to capture the time on two points: call and return. I only
submit the trace on return. So I can only
use the ring- buffer timestamp.
No?
But I can store it in the thread info.

>> +}
>> +
>> +/*
>> + * No caller of this function is really aware it is calling it since
>> + * it is a hooker called through a trampoline which passes the offset
>> + * of the function in the func table through the stack. So we have to
>> + * clean the stack ourself. Hence the stdcall.
>> + * We want to be sure our offset pushed on the stack will not be assumed
>> + * to be transmitted through a register => asmlinkage.
>> + */
>
> Hmm, I'm surprised you did not have the return to asm, and have asm
> call this function do the clean up, and then the asm can simply jump back.
>
> e.g.
>
>        return_to_handler:
>                push $0
>                push %eax
>                push %ecx
>                push %edx
>                call ftrace_return_to_handler
>                /* ftrace_return_to_hander returns the original ret addr */
>                mov  %eax, 12(%esp)
>                pop  %edx
>                pop  %ecx
>                pop  %eax
>                /* the original ret addr is next on the stack */
>                ret
>
> Of course you still need a way to add the index needed, but then if you
> did my way of adding the return values to the thread info then you don't
> need that. All you need is to add say 20 or 30 return addresses and time
> stamps.
>
> 30 entries will add 360 bytes to the stack. If you only do 20 (which
> would probably be better) then that would add 240 bytes. That is to store
> a 4 byte return address (on 32 bit archs) and a 8 byte timestamp.


Right, I will test with 20 entries and store the overrun on the global
struct. If someone with hundreds of cpu misses
a lot of traces, I hope there will be a report :-)
I first wanted to avoid the call and return from asm to have the most
part in C. I wanted it readable. But actually this hack with
asmlinkage, and those tricks in asm inline make the things far less
from being readable. I will do as you said.

>
>> +__attribute__((stdcall)) asmlinkage static
>> +unsigned long ftrace_return_to_handler(int index)
>> +{
>> +     struct ftrace_retfunc *table;
>> +     unsigned long ret;
>> +     unsigned long eax, edx;
>> +
>> +     /*
>> +      * The function we are hooking on return could have
>> +      * a return value. Just keep the value of eax and return
>> +      * it in the end. We keep edx too for 64 bits return
>> +      * values.
>> +      */
>
> The above asm version would handle the return value too.
>
>> +
>> +     asm volatile(
>> +             "movl %%eax, %0\n"
>> +             "movl %%edx, %1\n"
>> +             : "=r" (eax), "=r" (edx)
>> +             : : "memory"
>> +     );
>> +
>> +     table = &ftrace_return_state.func_table[index];
>> +     ret = table->ret;
>> +     table->rettime = cpu_clock(raw_smp_processor_id());
>> +     ftrace_function_return(table);
>> +
>> +     set_bit(index, &ftrace_return_state.bitmap);
>> +
>> +     /* Put the original return address of the hooked function as our
>> +      * return address and restore the return values.
>> +      */
>> +     asm volatile (
>> +             "movl %0, 4(%%ebp)\n"
>> +             "movl %1, %%edx\n"
>> +             : : "r" (ret), "r" (edx)
>> +             : "memory"
>> +     );
>> +
>> +     return eax;
>> +}
>> +
>> +/*
>> + * Set the trampoline.
>> + * See union ftrace_return_code_union.
>> + */
>> +static void __init fill_trampoline(void)
>> +{
>> +     union ftrace_return_code_union tramp_code;
>> +     int i;
>> +     unsigned long ip;
>> +
>> +     for (i = 0; i < FTRACE_TRAMPOLINE_SIZE; i++) {
>> +             ip = (unsigned long)&ftrace_return_state.trampoline[i];
>> +             ftrace_call_replace((char)i, ip,
>> +                                 (unsigned long)&ftrace_return_to_handler,
>> +                                 &tramp_code);
>> +             memcpy(&ftrace_return_state.trampoline[i],
>> +                    &tramp_code, sizeof(union ftrace_return_code_union));
>> +     }
>> +}
>> +
>> +static int __init init_ftrace_function_return(void)
>> +{
>> +     ftrace_return_state.bitmap_lock =
>> +                             (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
>> +     ftrace_return_state.trampoline = kmalloc(
>> +                              sizeof(union ftrace_return_code_union) *
>> +                              FTRACE_TRAMPOLINE_SIZE,
>> +                              GFP_KERNEL);
>> +     if (!ftrace_return_state.trampoline)
>> +             return -ENOMEM;
>> +
>> +     fill_trampoline();
>> +     /* Allocate 32 slots */
>> +     ftrace_return_state.bitmap = ~0;
>> +     ftrace_return_state.func_table = kmalloc(FTRACE_TRAMPOLINE_SIZE *
>> +                                      sizeof(struct ftrace_retfunc),
>> +                                      GFP_KERNEL);
>> +     if (!ftrace_return_state.func_table) {
>> +             kfree(ftrace_return_state.trampoline);
>> +             return -ENOMEM;
>> +     }
>> +     ftrace_return_state.overrun = 0;
>> +     return 0;
>>  }
>> +device_initcall(init_ftrace_function_return);
>> +
>> +
>> +#endif
>> +
>> +#ifdef CONFIG_DYNAMIC_FTRACE
>> +
>> +union ftrace_code_union {
>> +     char code[MCOUNT_INSN_SIZE];
>> +     struct {
>> +             char e8;
>> +             int offset;
>> +     } __attribute__((packed));
>> +};
>>
>>  unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
>>  {
>> @@ -183,6 +390,15 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
>>  }
>>
>>
>> +
>> +
>> +static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
>> +
>> +unsigned char *ftrace_nop_replace(void)
>> +{
>> +     return ftrace_nop;
>> +}
>> +
>>  int
>>  ftrace_modify_code(unsigned long ip, unsigned char *old_code,
>>                  unsigned char *new_code)
>> @@ -292,3 +508,4 @@ int __init ftrace_dyn_arch_init(void *data)
>>
>>       return 0;
>>  }
>> +#endif
>> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
>> index 1f5608c..41760d9 100644
>> --- a/include/linux/ftrace.h
>> +++ b/include/linux/ftrace.h
>> @@ -267,6 +267,22 @@ ftrace_init_module(unsigned long *start, unsigned long *end) { }
>>  #endif
>>
>>
>> +#ifdef CONFIG_FTRACE_RETURN
>> +struct ftrace_retfunc {
>> +     unsigned long ret;
>> +     unsigned long func;
>> +     unsigned long long calltime;
>> +     unsigned long long rettime;
>> +};
>> +
>> +extern atomic_t disable_return;
>> +
>> +extern void ftrace_return_stub(struct ftrace_retfunc *);
>> +extern void register_ftrace_return(void (*func)(struct ftrace_retfunc *));
>> +extern void (*ftrace_function_return)(struct ftrace_retfunc *);
>> +extern void unregister_ftrace_return(void);
>> +#endif
>> +
>>  /*
>>   * Structure which defines the trace of an initcall.
>>   * You don't have to fill the func field since it is
>> diff --git a/kernel/extable.c b/kernel/extable.c
>> index adf0cc9..5caa856 100644
>> --- a/kernel/extable.c
>> +++ b/kernel/extable.c
>
> I'd still like to trace these functions.  Instead of adding the notrace
> here, Use the CFLAGS_REMOVE_extable.o = -pg  in the Makefile when your
> CONFIG_FTRACE_RETURN is set.
>
>
>> @@ -40,7 +40,7 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
>>       return e;
>>  }
>>
>> -int core_kernel_text(unsigned long addr)
>> +notrace int core_kernel_text(unsigned long addr)
>>  {
>>       if (addr >= (unsigned long)_stext &&
>>           addr <= (unsigned long)_etext)
>> @@ -53,7 +53,7 @@ int core_kernel_text(unsigned long addr)
>>       return 0;
>>  }
>>
>> -int __kernel_text_address(unsigned long addr)
>> +notrace int __kernel_text_address(unsigned long addr)
>>  {
>>       if (core_kernel_text(addr))
>>               return 1;
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 48c323c..23bedc5 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -2714,7 +2714,7 @@ int is_module_address(unsigned long addr)
>>
>>
>>  /* Is this a valid kernel address? */
>> -struct module *__module_text_address(unsigned long addr)
>> +notrace struct module *__module_text_address(unsigned long addr)
>>  {
>>       struct module *mod

> Other than what I've said above, this looks promising


Thanks a lot Steven! I will apply those changes on the V3.
