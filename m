Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbXCEGy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbXCEGy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 01:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXCEGy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 01:54:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:29522 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbXCEGyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 01:54:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lCkh0nU+xZyFqgR3ol8OI1PUDRZwZbgRTUIBFVW3upMZOZxJAfQ8N3e1yBOgaBPrdo6EXWc56vjNbxyGvD+OAcQSSxNpe/qf6QnXffQ0e2/LGFNl7l9g0CsJfAZQj8qdGUslx9aTydIiCl3Zl21NCXHiWA/Vvy0EE9PvICjDdWc=
Message-ID: <6d6a94c50703042254r6b0a328cu614f8c26ad0b9656@mail.gmail.com>
Date: Mon, 5 Mar 2007 14:54:21 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Cc: bryan.wu@analog.com, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703032330.50116.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1172722480.5264.75.camel@roc-desktop>
	 <200703032330.50116.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/07, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 01 March 2007 05:14:40 Wu, Bryan wrote:
> > Here is the update version of blackfin-arch.patch in -mm tree.
> > simply add support to utrace and it was tested on blackfin STAMP board
> > as well as other following patches.
>
> Wow, this has come a long way since I looked at the patches last
> year, good work!
>
> I've gone through the complete patch again now, and these are the
> issues I've found in it. None of these are show-stoppers and I'd
> like to see it all go in during the next merge window. There should
> be enough time until then to address these points:
>
> > +EXPORT_SYMBOL(__ioremap);
> > +EXPORT_SYMBOL(strcmp);
> > +EXPORT_SYMBOL(strncmp);
> > +EXPORT_SYMBOL(dump_thread);
> > +
> > +EXPORT_SYMBOL(ip_fast_csum);
> > +
> > +EXPORT_SYMBOL(kernel_thread);
> > +
> > +EXPORT_SYMBOL(__up);
> > +EXPORT_SYMBOL(__down);
> > +EXPORT_SYMBOL(__down_trylock);
> > +EXPORT_SYMBOL(__down_interruptible);
> > +
> > +EXPORT_SYMBOL(is_in_rom);
>
> In general, please put EXPORT_SYMBOL lines below the definition
> of the symbol itself. This list of exports should only be used
> for symbols that come from assembly files.

What is the right way to export symbol coming from c files?


>
> You should probably also think about whether some of them are
> better done as EXPORT_SYMBOL_GPL.

It is probably not. We need code using those symbols, no matter it's
non-GPLd or GPLd.


>
> > +     pending = bfin_read_IPEND() & ~0x8000;
> > +     other_ints = pending & (pending - 1);
> > +     if (other_ints == 0)
> > +             lower_to_irq14();
> > +     irq_exit();
> > +
>
> The last line here has trailing whitespace. While this gets automatically
> removed by akpm's scripts, you're normally better off not adding it
> in the first place, because it may cause your follow-on patches not
> to apply, aside from being wrong to start with.
>
> > +void machine_halt(void)
> > +{
> > +     for (;;)
> > +             /* nothing */ ;
> > +}
> > +
> > +void machine_power_off(void)
> > +{
> > +     for (;;)
> > +             /* nothing */ ;
> > +}
>
> It might be nicer to make this
>
>         for (;;)
>                 asm volatile ("idle");
>
> Otherwise you end up burning CPU cycles after a halt without
> any particular need.

Good suggestion, thanks.


>
> > +#if defined(CONFIG_MTD_UCLINUX)
> > +     /* generic memory mapped MTD driver */
> > +     memory_mtd_end = memory_end;
> > +
> > +     mtd_phys = _ramstart;
> > +     mtd_size = PAGE_ALIGN(*((unsigned long *)(mtd_phys + 8)));
> > +
> > +# if defined(CONFIG_EXT2_FS) || defined(CONFIG_EXT3_FS)
> > +     if (*((unsigned short *)(mtd_phys + 0x438)) == EXT2_SUPER_MAGIC)
> > +             mtd_size =
> > +                 PAGE_ALIGN(*((unsigned long *)(mtd_phys + 0x404)) << 10);
> > +# endif
> > +
> > +# if defined(CONFIG_CRAMFS)
> > +     if (*((unsigned long *)(mtd_phys)) == CRAMFS_MAGIC)
> > +             mtd_size = PAGE_ALIGN(*((unsigned long *)(mtd_phys + 0x4)));
> > +# endif
> > +
> > +# if defined(CONFIG_ROMFS_FS)
> > +     if (((unsigned long *)mtd_phys)[0] == ROMSB_WORD0
> > +         && ((unsigned long *)mtd_phys)[1] == ROMSB_WORD1)
> > +             mtd_size =
> > +                 PAGE_ALIGN(be32_to_cpu(((unsigned long *)mtd_phys)[2]));
>
> This detection seems to me like a strange thing to do in setup_arch().
> It should be possible to do this much later, at a point where the system
> is much less fragile and e.g. printk works. It could even be moved into
> some place in the mtd code itself, since other architectures might want
> to do the same thing.

After download the rootfs image from host to the target ram, we need
to move the image to the right place, so we need to know the size of
the image at this time.

>
> > +#if defined(CONFIG_BF561)
> > +static struct cpu cpu[2];
> > +#else
> > +static struct cpu cpu[1];
> > +#endif
> > +static int __init topology_init(void)
> > +{
> > +#if defined (CONFIG_BF561)
> > +     register_cpu(&cpu[0], 0);
> > +     register_cpu(&cpu[1], 1);
> > +     return 0;
> > +#else
> > +     return register_cpu(cpu, 0);
> > +#endif
> > +}
>
> I think you should try to avoid the special-case stuff here. You can
> have CONFIG_NR_CPUS in Kconfig set dependent on CONFIG_BF561 and change
> the code here (and similarly in other places) to
>
> static struct cpu cpu[NR_CPUS];
> static int __init topology_init(void)
> {
>         int i;
>         for (i=0; i< NR_CPUS; i++) {
>                 register_cpu(&cpu[i], i);
>         return 0;
> }
>
Good suggestions, thanks.

> > +     for (i = ZERO_P; i <= L2_MEM; i++) {
> > +
> > +             if (cplb_data[i].valid) {
> > +
> > +                     as_1m = cplb_data[i].start % SIZE_1M;
> > +
> > +                     /* We need to make sure all sections are properly 1M aligned
> > +                      * However between Kernel Memory and the Kernel mtd section, depending
> on the
> > +                      * rootfs size, there can be overlapping memory areas.
> > +                      */
> > +
> > +                     if (as_1m) {
> > +#ifdef CONFIG_MTD_UCLINUX
> > +                             if (i == SDRAM_RAM_MTD) {
> > +                                     if ((cplb_data[SDRAM_KERN].end + 1) > cplb_data[SDRAM_RAM_MTD].start)
> > +                                             cplb_data[SDRAM_RAM_MTD].start = (cplb_data[i].start & (-2*SIZE_1M))
> + SIZE_1M;
>
> I count 6 levels of indentation, which severely limits readability,
> especially when you have terms this complex in the last level.
> Please try to split up functions like this into smaller units.
>
> > +/*
> > + * ++roman (07/09/96): implemented signal stacks (specially for tosemu on
> > + * Atari :-) Current limitation: Only one sigstack can be active at one
> time.
> > + * If a second signal with SA_ONSTACK set arrives while working on a
> sigstack,
> > + * SA_ONSTACK is ignored. This behaviour avoids lots of trouble with nested
> > + * signal handlers!
> > + */
>
> This comment is probably outdated.
>
> > +extern int setup_irq(unsigned int irq, struct irqaction *handler);
>
> this extern should be in a header.
>
> > +asmlinkage void trap_c(struct pt_regs *fp)
> > +{
> > +     int j, sig = 0;
> > +     siginfo_t info;
> > +     unsigned long trapnr = fp->seqstat & SEQSTAT_EXCAUSE;
> > +
> > +#ifdef CONFIG_KGDB
> > +# define CHK_DEBUGGER_TRAP() do { CHK_DEBUGGER(trapnr, sig, info.si_code,
> fp,); } while (0)
> > +# define CHK_DEBUGGER_TRAP_MAYBE() do { if (kgdb_connected)
> CHK_DEBUGGER_TRAP(); } while (0)
> > +#else
> > +# define CHK_DEBUGGER_TRAP() do { } while (0)
> > +# define CHK_DEBUGGER_TRAP_MAYBE() do { } while (0)
> > +#endif
> > +
> > +     trace_buffer_save(j);
> > +
> > +     /* trap_c() will be called for exceptions. During exceptions
> > +      * processing, the pc value should be set with retx value.
> > +      * With this change we can cleanup some code in signal.c- TODO
> > +      */
> > +     fp->orig_pc = fp->retx;
> > +     /* printk("exception: 0x%x, ipend=%x, reti=%x, retx=%x\n",
> > +             trapnr, fp->ipend, fp->pc, fp->retx); */
> > +
> > +     /* send the appropriate signal to the user program */
> > +     switch (trapnr) {
> > +
> > +     /* This table works in conjuction with the one in ./mach-common/entry.S
> > +      * Some exceptions are handled there (in assembly, in exception space)
> > +      * Some are handled here, (in C, in interrupt space)
> > +      * Some, like CPLB, are handled in both, where the normal path is
> > +      * handled in assembly/exception space, and the error path is handled
> > +      * here
> > +      */
> > +
> > +     /* 0x00 - Linux Syscall, getting here is an error */
> > +     /* 0x01 - userspace gdb breakpoint, handled here */
> > +     case VEC_EXCPT01:
> > +             info.si_code = TRAP_ILLTRAP;
> > +             sig = SIGTRAP;
> > +             CHK_DEBUGGER_TRAP_MAYBE();
> > +             /* Check if this is a breakpoint in kernel space */
> > +             if (fp->ipend & 0xffc0)
> > +                     return;
> > +             else
> > +                     break;
> > +#ifdef CONFIG_KGDB
> > +     case VEC_EXCPT02 :               /* gdb connection */
> > +             info.si_code = TRAP_ILLTRAP;
> > +             sig = SIGTRAP;
> > +             CHK_DEBUGGER_TRAP();
> > +             return;
> > +#else
> > +     /* 0x02 - User Defined, Caught by default */
> > +#endif
> > +     /* 0x03  - Atomic test and set */
> > +     case VEC_EXCPT03:
>
>
> The table here probably gets converted by gcc into a lookup table, but
> I think it would be clearer to make that explicit and force the table
> here with something like:
>
> static void trap_breakpoint(struct pt_regs *fp, siginfo_t *info,
>                                  unsigned int trapnr)
> {
>         info->si_code = TRAP_ILLTRAP;
>         CHK_DEBUGGER_TRAP_MAYBE();
>         if (fp->ipend & 0xffc0)
>                 return 0;
>         return SIGTRAP;
> }
>
> #ifdef CONFIG_KGDB
> static void trap_kgdb(struct pt_regs *fp, siginfo_t *info,
>                                  unsigned int trapnr)
> {
>         info->si_code = TRAP_ILLTRAP;
>         CHK_DEBUGGER_TRAP();
>         return SIGTRAP;
> }
> #endif
>
> static void (traps[])(struct pt_regs *fp, siginfo_t *info,
>                                  unsigned int trapnr) = {
>         [VEC_EXCPT01] &trap_breakpoint, /* 0x01 - userspace gdb breakpoint */
> #ifdef CONFIG_KGDB
>         [VEC_EXCPT02] &trap_kgdb,  /* gdb connection */
> #endif
>         ...
> };
>
> asmlinkage void trap_c(struct pt_regs *fp)
> {
>         ...
>         if (trapnr > 0x3f)
>                 goto error;
>         if (!traps[trapnr])
>                 goto out;
>         ret = traps[trapno](fp, &info, trapnr);
>         if (!ret)
>                 goto out;
>         ...
>
> That should make sure you get the efficient trap handling almost and might
> even
> save some code space (you'd have to try that).
>
> > +asmlinkage int sys_bfin_spinlock(int *spinlock)
> > +{
> > +     int ret = 0;
> > +     int tmp = 0;
> > +
> > +     local_irq_disable();
> > +     ret = get_user(tmp, spinlock);
> > +     if (ret == 0) {
> > +             if (tmp)
> > +                     ret = 1;
> > +             tmp = 1;
> > +             put_user(tmp, spinlock);
> > +     }
> > +     local_irq_enable();
> > +     return ret;
> > +}
>
> I'm curious: In your dual-core bf561, don't you actually need to implement
> something that maintains atomicity across cores rather than just across
> processes?

Yes, bf561 is a dual-core processor, but we are using only one core of
bf561 now.
IMHO, BF561 architecture was not designed for SMP or NUMA.

>
> > +#include <net/checksum.h>
> > +#include <asm/checksum.h>
> > +
> > +#ifdef CONFIG_IP_CHECKSUM_L1
> > +static unsigned short do_csum(const unsigned char *buff, int
> len)__attribute__((l1_text));
> > +#endif
> > +
> > +static unsigned short do_csum(const unsigned char *buff, int len)
> > +{
> > +     register unsigned long sum = 0;
> > +     int swappem = 0;
> > +
> > +     if (1 & (unsigned long)buff) {
> > +             sum = *buff << 8;
> > +             buff++;
> > +             len--;
> > +             ++swappem;
> > +     }
>
> For the non-L1 case, is there actually anything specific to blackfin in
> this code? I wonder if we should instead have a totally generic version
> of that in lib/csum.c for those architectures that don't want their
> own optimizations for this.
>
> > +static struct platform_device *stamp_devices[] __initdata = {
> > +#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
> > +     &rtc_device,
> > +#endif
> > +
> > +#if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
> > +     &bfin_pcmcia_cf_device,
> > +#endif
> > +
> > +#if defined(CONFIG_USB_SL811_HCD) || defined(CONFIG_USB_SL811_HCD_MODULE)
> > +     &sl811_hcd_device,
> > +#endif
>
> This array reminds me of the bad old days when all initialization functions
> had to be called from a common function. Normally I don't like to recommend
> using section magic for anything, but in this case I guess you'd be
> better off if you just do your own thing here, like:
>
> #define BFIN_PLATFORM_DEVICE(name) struct platform_device name \
>                 __attribute((section("initdata.platformdev")))
>
> then declare your platform devices in the respective driver, like
>
> static BFIN_PLATFORM_DEVICE(rtc_device) = {
>         ...
> };
>
> and loop through the new section like you do for the initcalls.
>
> > +void get_bf537_ether_addr(char *addr)
> > +{
> > +     /* currently the mac addr is saved in flash */
> > +     int flash_mac = 0x203f0000;
> > +     *(u32 *)(&(addr[0])) = *(int *)flash_mac;
> > +     flash_mac += 4;
> > +     *(u16 *)(&(addr[4])) = (u16)*(int *)flash_mac;
> > +}
> > +
> > +EXPORT_SYMBOL(get_bf537_ether_addr);
>
> This looks wrong in a number of aspects. Are there other things
> stored in the flash so you can make this a more general flash
> abstraction? Is there more than one driver using this at all?
> If not, it should probably be part of the driver, with the
> exact address being a compile-time constant for that driver.
>
> It should probably also use bfin_readXX instead direct dereferences.

Good suggestions, thanks.

>
> > +/* The number of spurious interrupts */
> > +volatile unsigned int num_spurious;
>
> Why volatile? It probably does not what you intended, maybe it should
> be atomic_t instead.
>
> > +/* BASE LEVEL interrupt handler routines */
> > +asmlinkage void evt_emulation(void);
> > +asmlinkage void evt_exception(void);
> > +asmlinkage void trap(void);
> > +asmlinkage void evt_ivhw(void);
> > +asmlinkage void evt_timer(void);
> > +asmlinkage void evt_evt2(void);
> > +asmlinkage void evt_evt7(void);
> > +asmlinkage void evt_evt8(void);
> > +asmlinkage void evt_evt9(void);
> > +asmlinkage void evt_evt10(void);
> > +asmlinkage void evt_evt11(void);
> > +asmlinkage void evt_evt12(void);
> > +asmlinkage void evt_evt13(void);
> > +asmlinkage void evt_soft_int1(void);
> > +asmlinkage void evt_system_call(void);
> > +asmlinkage void init_exception_buff(void);
>
> move the extern definitions to a header file please
>
> > +/* BASE LEVEL interrupt handler routines */
> > +asmlinkage void evt_emulation(void);
> > +asmlinkage void evt_exception(void);
> > +asmlinkage void trap(void);
> > +asmlinkage void evt_ivhw(void);
> > +asmlinkage void evt_timer(void);
> > +asmlinkage void evt_evt2(void);
> > +asmlinkage void evt_evt7(void);
> > +asmlinkage void evt_evt8(void);
> > +asmlinkage void evt_evt9(void);
> > +asmlinkage void evt_evt10(void);
> > +asmlinkage void evt_evt11(void);
> > +asmlinkage void evt_evt12(void);
> > +asmlinkage void evt_evt13(void);
> > +asmlinkage void evt_soft_int1(void);
> > +asmlinkage void evt_system_call(void);
>
> Then you don't have to write them twice ;-)
>
> > +static __inline__ void atomic_add(int i, atomic_t * v)
> > +{
> > +     long flags;
> > +
> > +     local_irq_save(flags);
> > +     v->counter += i;
> > +     local_irq_restore(flags);
> > +}
> > +
> > +static __inline__ void atomic_sub(int i, atomic_t * v)
> > +{
> > +     long flags;
> > +
> > +     local_irq_save(flags);
> > +     v->counter -= i;
> > +     local_irq_restore(flags);
> > +
> > +}
>
> The implementation of the atomic_t type looks very generic. Maybe it could
> be moved to asm-generic/atomic-irqdisable.h or similar to be shared by
> all architectures without atomic operations.
>
> > +struct spi_device_t {
> > +     char *dev_name;
> > +
> > +     unsigned short flag;
> > +     unsigned short bdrate;
> > +
> > +     unsigned short enable;
> > +     unsigned short master;
> > +     unsigned short out_opendrain;
> > +     unsigned short polar;
> > +     unsigned short phase;
> > +     unsigned short byteorder;       /* 0: MSB first; 1: LSB first; */
> > +     unsigned short size;    /* 0: 8 bits; 1: 16 bits */
> > +     unsigned short emiso;
> > +     unsigned short send_zero;
> > +     unsigned short more_data;
> > +     unsigned short slave_sel;
> > +     unsigned short ti_mod;
> > +
> > +     unsigned short dma;     /* use dma mode or not */
> > +     unsigned short dma_config;      /* only valid if dma enabled */
> > +
> > +      irqreturn_t(*irq_handler) (int irq, void *dev_id,
> > +                                 struct pt_regs *regs);
> > +     void *priv_data;
> > +};
>
> How does this fit in with the generic SPI code? Does it duplicate stuff
> from there, or do you use it?

We use our own. We have dma which can be used for SPI operations.

>
> > +static __inline__ void set_bit(int nr, volatile unsigned long *addr)
> > +{
> > +     int *a = (int *)addr;
> > +     int mask;
> > +     unsigned long flags;
> > +
> > +     a += nr >> 5;
> > +     mask = 1 << (nr & 0x1f);
> > +     local_irq_save(flags);
> > +     *a |= mask;
> > +     local_irq_restore(flags);
> > +}
> > +
> > +static __inline__ void __set_bit(int nr, volatile unsigned long *addr)
> > +{
> > +     int *a = (int *)addr;
> > +     int mask;
> > +
> > +     a += nr >> 5;
> > +     mask = 1 << (nr & 0x1f);
> > +     *a |= mask;
> > +}
>
> same as for the atomic header, this could become generic.
>
> > +#if defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
> > +#define SSYNC() do {         int _tmp; \
> > +                       __asm__ __volatile__ ("cli %0;\n\t"\
> > +                                         "nop;nop;\n\t"\
> > +                                            "ssync;\n\t"\
> > +                                            "sti %0;\n\t" \
> > +                                             :"=d"(_tmp):);\
> > + } while (0)
> > +#elif defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
> > +#define SSYNC() do {         int _tmp; \
> > +                       __asm__ __volatile__ ("cli %0;\n\t"\
> > +                                            "ssync;\n\t"\
> > +                                            "sti %0;\n\t" \
> > +                                             :"=d"(_tmp):);\
> > + } while (0)
> > +#elif !defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
> > +#define SSYNC() do {__builtin_bfin_ssync();} while (0)
> > +#elif !defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
> > +#define SSYNC() do {__asm__ __volatile__ ("ssync;\n\t") } while (0)
> > +#endif
> > +
> > +
> > +#if defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
> > +#define CSYNC() do {         int _tmp; \
> > +                       __asm__ __volatile__ ("cli %0;\n\t"\
> > +                                         "nop;nop;\n\t"\
> > +                                            "csync;\n\t"\
> > +                                            "sti %0;\n\t" \
> > +                                             :"=d"(_tmp):);\
> > + } while (0)
> > +#elif defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
> > +#define CSYNC() do {         int _tmp; \
> > +                       __asm__ __volatile__ ("cli %0;\n\t"\
> > +                                            "csync;\n\t"\
> > +                                            "sti %0;\n\t" \
> > +                                             :"=d"(_tmp):);\
> > + } while (0)
> > +#elif !defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
> > +#define CSYNC() do {__builtin_bfin_csync();} while (0)
> > +#elif !defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
> > +#define CSYNC() do {__asm__ __volatile__ ("csync;\n\t") } while (0)
> > +#endif
>
> it would be nice if you could convert these to inline functions
> instead of macros.
>
> > +static inline struct task_struct *get_current(void) __attribute__
> ((__const__));
> > +static inline struct task_struct *get_current(void)
> > +{
> > +     return (current_thread_info()->task);
> > +}
> > +
> > +#define      current (get_current())
>
> You might want to maintain the current variable in the L1 memory, but
> probably that difference it not measurable.
>
> > +#ifdef BFIN_DMA_NDEBUG
> > +#define assert(expr) do {} while(0)
> > +#else
> > +#define assert(expr)                                                 \
> > +     if (!(expr)) {                                          \
> > +     printk(KERN_INFO "Assertion failed! %s, %s, %s, line=%d \n",    \
> > +     #expr, __FILE__,__FUNCTION__,__LINE__);                 \
> > +     }
> > +#endif
>
> Please don't define your own assert() functions, in the kernel we have
> BUG_ON and WARN_ON for this.
>
> > +#ifndef _BLACKFIN_DPMC_H_
> > +#define _BLACKFIN_DPMC_H_
> > +
> > +#define SLEEP_MODE           1
> > +#define DEEP_SLEEP_MODE              2
> > +#define ACTIVE_PLL_DISABLED  3
> > +#define FULLON_MODE          4
> > +#define ACTIVE_PLL_ENABLED   5
> > +#define HIBERNATE_MODE               6
> > +
> > +#define IOCTL_FULL_ON_MODE   _IO('s', 0xA0)
> > +#define IOCTL_ACTIVE_MODE    _IO('s', 0xA1)
> > +#define IOCTL_SLEEP_MODE     _IO('s', 0xA2)
> > +#define IOCTL_DEEP_SLEEP_MODE        _IO('s', 0xA3)
> > +#define IOCTL_HIBERNATE_MODE _IO('s', 0xA4)
> > +#define IOCTL_CHANGE_FREQUENCY       _IOW('s', 0xA5, unsigned long)
> > +#define IOCTL_CHANGE_VOLTAGE _IOW('s', 0xA6, unsigned long)
> > +#define IOCTL_SET_CCLK               _IOW('s', 0xA7, unsigned long)
> > +#define IOCTL_SET_SCLK               _IOW('s', 0xA8, unsigned long)
> > +#define IOCTL_GET_PLLSTATUS  _IOW('s', 0xA9, unsigned long)
> > +#define IOCTL_GET_CORECLOCK  _IOW('s', 0xAA, unsigned long)
> > +#define IOCTL_GET_SYSTEMCLOCK        _IOW('s', 0xAB, unsigned long)
> > +#define IOCTL_GET_VCO                _IOW('s', 0xAC, unsigned long)
> > +#define IOCTL_DISABLE_WDOG_TIMER _IO('s', 0xAD)
> > +#define IOCTL_UNMASK_WDOG_WAKEUP_EVENT _IO('s',0xAE)
> > +#define IOCTL_PROGRAM_WDOG_TIMER _IOW('s',0xAF,unsigned long)
> > +#define IOCTL_CLEAR_WDOG_WAKEUP_EVENT _IO('s',0xB0)
> > +#define IOCTL_SLEEP_DEEPER_MODE _IO('s',0xB1)
> > +
> > +#define DPMC_MINOR           254
> > +
> > +#define ON   0
> > +#define OFF  1
> > +
> > +unsigned long calc_volt(void);
> > +int calc_vlev(int vlt);
> > +unsigned long change_voltage(unsigned long volt);
> > +int calc_msel(int vco_hz);
> > +unsigned long change_frequency(unsigned long vco_mhz);
> > +int set_pll_div(unsigned short sel, unsigned char flag);
>
> In general, you should be careful not to mix in-kernel declarations with
> user-visible parts. In this case, the ioctl definitions need to be exported
> via 'make headers_install', while the function declarations clearly are
> not useful for user space and should therefore be inside of
> '#ifdef __KERNEL__'. You should then list this file as 'unifdef-y' in the
> Kbuild file.
>
> > +
> > +#ifdef __KERNEL__
> > +#define SET_PERSONALITY(ex, ibcs2)
> set_personality((ibcs2)?PER_SVR4:PER_LINUX)
> > +#endif
>
> This looks bogus, I don't think you implement personalities.
>
> > +#define readb(addr) ({ unsigned __v; \
> > +                    int _tmp; \
> > +                    __asm__ __volatile__ ("cli %1;\n\t"\
> > +                                      "NOP;NOP;SSYNC;\n\t"\
> > +                                          "%0 = b [%2] (z);\n\t"\
> > +                                          "sti %1;\n\t" \
> > +  : "=d"(__v), "=d"(_tmp): "a"(addr)); (unsigned char)__v; })
> > +
> > +#define readw(addr) ({ unsigned __v; \
> > +                                        int _tmp; \
> > +                       __asm__ __volatile__ ("cli %1;\n\t"\
> > +                                                                      "NOP;NOP;SSYNC;\n\t"\
> > +                                                                      "%0 = w [%2] (z);\n\t"\
> > +                                             "sti %1;\n\t" \
> > +  : "=d"(__v), "=d"(_tmp): "a"(addr)); (unsigned short)__v; })
>
> They should probably be inline functions.
>
> > +#define TCGETS               0x5401
> > +#define TCSETS               0x5402
> > +#define TCSETSW              0x5403
> > +#define TCSETSF              0x5404
> > +#define TCGETA               0x5405
> > +#define TCSETA               0x5406
> > +#define TCSETAW              0x5407
> > +#define TCSETAF              0x5408
> > +#define TCSBRK               0x5409
> > +#define TCXONC               0x540A
> > +#define TCFLSH               0x540B
> > +#define TIOCEXCL     0x540C
> > +#define TIOCNXCL     0x540D
> > +#define TIOCSCTTY    0x540E
> > +#define TIOCGPGRP    0x540F
> > +#define TIOCSPGRP    0x5410
> > +#define TIOCOUTQ     0x5411
> > +#define TIOCSTI              0x5412
> > +#define TIOCGWINSZ   0x5413
> > +#define TIOCSWINSZ   0x5414
> > +#define TIOCMGET     0x5415
> > +#define TIOCMBIS     0x5416
> > +#define TIOCMBIC     0x5417
> > +#define TIOCMSET     0x5418
> > +#define TIOCGSOFTCAR 0x5419
> > +#define TIOCSSOFTCAR 0x541A
> > +#define FIONREAD     0x541B
> > +#define TIOCINQ              FIONREAD
> > +#define TIOCLINUX    0x541C
> > +#define TIOCCONS     0x541D
> > +#define TIOCGSERIAL  0x541E
> > +#define TIOCSSERIAL  0x541F
> > +#define TIOCPKT              0x5420
> > +#define FIONBIO              0x5421
> > +#define TIOCNOTTY    0x5422
> > +#define TIOCSETD     0x5423
> > +#define TIOCGETD     0x5424
> > +#define TCSBRKP              0x5425  /* Needed for POSIX tcsendbreak() */
> > +#define TIOCTTYGSTRUCT       0x5426  /* For debugging only */
> > +#define TIOCSBRK     0x5427  /* BSD compatibility */
> > +#define TIOCCBRK     0x5428  /* BSD compatibility */
> > +#define TIOCGSID     0x5429  /* Return the session ID of FD */
> > +#define TIOCGPTN     _IOR('T',0x30, unsigned int)    /* Get Pty Number (of pty-mux
> device) */
> > +#define TIOCSPTLCK   _IOW('T',0x31, int)     /* Lock/unlock Pty */
>
> These look like another good candidate for an asm-generic version.
>
> > +
> > +extern void sys_free_irq(unsigned int irq, void *dev_id);
>
> This functions should probably be renamed. Anything that starts with
> 'sys_' is normally a system call.
>
>  +
> > +/* Clock and System Control (0xFFC0 0400-0xFFC0 07FF) */
> > +#define bfin_read_PLL_CTL()                  bfin_read16(PLL_CTL)
> > +#define bfin_write_PLL_CTL(val)              bfin_write16(PLL_CTL,val)
> > +#define bfin_read_PLL_STAT()                 bfin_read16(PLL_STAT)
> > +#define bfin_write_PLL_STAT(val)             bfin_write16(PLL_STAT,val)
> > +#define bfin_read_PLL_LOCKCNT()              bfin_read16(PLL_LOCKCNT)
> > +#define bfin_write_PLL_LOCKCNT(val)          bfin_write16(PLL_LOCKCNT,val)
> > +#define bfin_read_CHIPID()                   bfin_read32(CHIPID)
> > +#define bfin_read_SWRST()                    bfin_read16(SWRST)
> > +#define bfin_write_SWRST(val)                bfin_write16(SWRST,val)
>
> I remember that we have discussed these macro abstractions before, but don't
> recall the result of the discussion. You have around 5000 such macros,
> and I still think it's not a helpful abstraction. It is much more common
> for device drivers to just use the read/write accessors directly. IIRC
> the objections that were raised (and my replies to them) were roughly:
>
> > the driver writer doesn't want to know the size of the variable, and
> > if it changes, they need to change every instance in the code, not
> > just the macro.
>
> A driver writer should better know the type of variable he is changing,
> e.g. because of the type he passes in and out. Also, hardware registers
> don't suddenly change in size.
>
> > These macros allow us to work around hardware bugs when accessing the
> > registers by simply redefining the accessor to do something more
> > complex.
>
> If there is a bug in the hardware, the workaround belongs into the
> driver. You can then still define a special inline function to
> access that particular register.

-Aubrey
