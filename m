Return-Path: <linux-kernel-owner+w=401wt.eu-S1761020AbXIXWYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020AbXIXWYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbXIXWYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:24:12 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:47471 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbXIXWYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:24:11 -0400
Message-ID: <46F83900.6060209@tiscali.nl>
Date: Tue, 25 Sep 2007 00:24:00 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, hch@infradead.org,
       mathieu.desnoyers@polymtl.ca, akpm <akpm@linux-foundation.org>,
       sam@ravnborg.org, davem@davemloft.net
Subject: Re: [PATCH/RFC] samples/: move kprobes sources to samples
References: <20070924145828.d279abac.randy.dunlap@oracle.com>
In-Reply-To: <20070924145828.d279abac.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I could only point to three nitpicks 

Randy Dunlap wrote:
> This is RFC patch 2/2.
> Patch 1/2 introduces the samples/ infrastructure:
>   http://lkml.org/lkml/2007/9/24/397
> 
> 
> ---
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Move kprobes source files from Documentation/kprobes.txt to
> samples/kprobes/ and add them to the build system.
> 
> Fix sparse warnings in all 3 kprobes samples source files.
> 
> Although kprobe-example.c is x86-specific, make it build on any
> platform by surrounding some code in ifdef/endif blocks.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/kprobes.txt           |  214 ------------------------------------
>  samples/Kconfig                     |    5 
>  samples/Makefile                    |    3 
>  samples/kprobes/Makefile            |    5 
>  samples/kprobes/jprobe_example.c    |   65 ++++++++++
>  samples/kprobes/kprobe_example.c    |   79 +++++++++++++
>  samples/kprobes/kretprobe-example.c |   60 ++++++++++
>  7 files changed, 222 insertions(+), 209 deletions(-)
> 
> --- /dev/null
> +++ linux-2.6.23-rc7/samples/kprobes/Makefile
> @@ -0,0 +1,5 @@
> +# builds the kprobes example kernel modules;
> +# then to use one (as root):  insmod <module_name.ko>
> +
> +obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o \
> +		kretprobe-example.o
> --- linux-2.6.23-rc7.orig/samples/Kconfig
> +++ linux-2.6.23-rc7/samples/Kconfig
> @@ -7,5 +7,10 @@ menuconfig SAMPLES
>  
>  if SAMPLES
>  
> +config SAMPLE_KPROBES
> +	tristate "Build kprobes examples -- loadable modules only"
> +	depends on KPROBES && m
> +	help
> +	  This builds several kprobes example modules.
>  
>  endif # SAMPLES
> --- /dev/null
> +++ linux-2.6.23-rc7/samples/kprobes/jprobe_example.c
> @@ -0,0 +1,65 @@
> +/*jprobe-example.c */
> +/*
> + * Here's a sample kernel module showing the use of jprobes to dump
> + * the arguments of do_fork().
> + *
> + * Build and insert the kernel module as done in the kprobe example.
> + * You will see the trace data in /var/log/messages and on the
> + * console whenever do_fork() is invoked to create a new process.
> + * (Some messages may be suppressed if syslogd is configured to
> + * eliminate duplicate messages.)
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/uio.h>
> +#include <linux/kprobes.h>
> +#include <linux/ptrace.h>
> +
> +/*
> + * Jumper probe for do_fork.
> + * Mirror principle enables access to arguments of the probed routine
> + * from the probe handler.
> + */
> +
> +/* Proxy routine having the same arguments as actual do_fork() routine */
> +static long jdo_fork(unsigned long clone_flags, unsigned long stack_start,
> +	      struct pt_regs *regs, unsigned long stack_size,
> +	      int __user * parent_tidptr, int __user * child_tidptr)
> +{
> +	printk("jprobe: clone_flags=0x%lx, stack_size=0x%lx, regs=0x%p\n",
> +	       clone_flags, stack_size, regs);
> +	/* Always end with a call to jprobe_return(). */
> +	jprobe_return();
> +	/*NOTREACHED*/
> +	return 0;
> +}
> +
> +static struct jprobe my_jprobe = {
> +	.entry = jdo_fork
> +};
> +
> +static int __init jprobe_init(void)
> +{
> +	int ret;
> +	my_jprobe.kp.symbol_name = "do_fork";
> +
> +	if ((ret = register_jprobe(&my_jprobe)) <0) {

or do:
	ret = register_jprobe(&my_jprobe);
	if (ret < 0) {

> +		printk("register_jprobe failed, returned %d\n", ret);
> +		return -1;
> +	}
> +	printk("Planted jprobe at %p, handler addr %p\n",
> +	       my_jprobe.kp.addr, my_jprobe.entry);
> +	return 0;
> +}
> +
> +static void __exit jprobe_exit(void)
> +{
> +	unregister_jprobe(&my_jprobe);
> +	printk("jprobe unregistered\n");
> +}
> +
> +module_init(jprobe_init)
> +module_exit(jprobe_exit)
> +MODULE_LICENSE("GPL");
> --- /dev/null
> +++ linux-2.6.23-rc7/samples/kprobes/kprobe_example.c
> @@ -0,0 +1,79 @@
> +/*kprobe_example.c*/
> +/*
> + * NOTE: This example is x86-specific.
> + * Here's a sample kernel module showing the use of kprobes to dump a
> + * stack trace and selected i386 registers when do_fork() is called.
> + *
> + * You will see the trace data in /var/log/messages and on the console
> + * whenever do_fork() is invoked to create a new process.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/kprobes.h>
> +#include <linux/sched.h>
> +#include <linux/ptrace.h>
> +
> +/*For each probe you need to allocate a kprobe structure*/
> +static struct kprobe kp;
> +
> +/*kprobe pre_handler: called just before the probed instruction is executed*/
> +static int handler_pre(struct kprobe *p, struct pt_regs *regs)
> +{
> +#ifdef CONFIG_X86_32
> +	printk("pre_handler: p->addr=0x%p, eip=%lx, eflags=0x%lx\n",
> +		p->addr, regs->eip, regs->eflags);
> +#endif
> +#ifdef CONFIG_X86_64
> +	printk("pre_handler: p->addr=0x%p, rip=%lx, eflags=0x%lx\n",
> +		p->addr, regs->rip, regs->eflags);
> +#endif
> +	dump_stack();
> +	return 0;
> +}
> +
> +/*kprobe post_handler: called after the probed instruction is executed*/
> +static void handler_post(struct kprobe *p, struct pt_regs *regs, unsigned long flags)
> +{
> +	printk("post_handler: p->addr=0x%p, eflags=0x%lx\n",
> +		p->addr, regs->eflags);
> +}
> +
> +/* fault_handler: this is called if an exception is generated for any
> + * instruction within the pre- or post-handler, or when Kprobes
> + * single-steps the probed instruction.
> + */
> +static int handler_fault(struct kprobe *p, struct pt_regs *regs, int trapnr)
> +{
> +	printk("fault_handler: p->addr=0x%p, trap #%dn",
> +		p->addr, trapnr);
> +	/* Return 0 because we don't handle the fault. */
> +	return 0;
> +}
> +
> +static int __init kprobe_init(void)
> +{
> +	int ret;
> +	kp.pre_handler = handler_pre;
> +	kp.post_handler = handler_post;
> +	kp.fault_handler = handler_fault;
> +	kp.symbol_name = "do_fork";
> +
> +	ret = register_kprobe(&kp);
> +	if (ret < 0) {
> +		printk("register_kprobe failed, returned %d\n", ret);
> +		return ret;
> +	}
> +	printk("kprobe registered\n");
> +	return 0;
> +}
> +
> +static void __exit kprobe_exit(void)
> +{
> +	unregister_kprobe(&kp);
> +	printk("kprobe unregistered\n");
> +}
> +
> +module_init(kprobe_init)
> +module_exit(kprobe_exit)
> +MODULE_LICENSE("GPL");
> --- /dev/null
> +++ linux-2.6.23-rc7/samples/kprobes/kretprobe-example.c
> @@ -0,0 +1,60 @@
> +/*kretprobe-example.c*/
> +/*
> + * Here's a sample kernel module showing the use of return probes to
> + * report failed calls to sys_open().
> + *
> + * Build and insert the kernel module as done in the kprobe example.
> + * You will see the trace data in /var/log/messages and on the console
> + * whenever sys_open() returns a negative value.  (Some messages
> + * may be suppressed if syslogd is configured to eliminate duplicate
> + * messages.)
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/kprobes.h>
> +#include <linux/ptrace.h>
> +
> +static const char *probed_func = "sys_open";
> +
> +/* Return-probe handler: If the probed function fails, log the return value. */
> +static int ret_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
> +{
> +	int retval = regs_return_value(regs);
> +	if (retval < 0) {
> +		printk("%s returns %d\n", probed_func, retval);
> +	}

or without brackets

> +	return 0;
> +}
> +
> +static struct kretprobe my_kretprobe = {
> +	.handler = ret_handler,
> +	/* Probe up to 20 instances concurrently. */
> +	.maxactive = 20
> +};
> +
> +static int __init kretprobe_init(void)
> +{
> +	int ret;
> +	my_kretprobe.kp.symbol_name = (char *)probed_func;
> +
> +	if ((ret = register_kretprobe(&my_kretprobe)) < 0) {

or:
	ret = register_kretprobe(&my_kretprobe);
	if ( ret < 0 ) {

> +		printk("register_kretprobe failed, returned %d\n", ret);
> +		return -1;
> +	}
> +	printk("Planted return probe at %p\n", my_kretprobe.kp.addr);
> +	return 0;
> +}
> +
> +static void __exit kretprobe_exit(void)
> +{
> +	unregister_kretprobe(&my_kretprobe);
> +	printk("kretprobe unregistered\n");
> +	/* nmissed > 0 suggests that maxactive was set too low. */
> +	printk("Missed probing %d instances of %s\n",
> +		my_kretprobe.nmissed, probed_func);
> +}
> +
> +module_init(kretprobe_init)
> +module_exit(kretprobe_exit)
> +MODULE_LICENSE("GPL");
> --- linux-2.6.23-rc7.orig/Documentation/kprobes.txt
> +++ linux-2.6.23-rc7/Documentation/kprobes.txt
> @@ -166,7 +166,8 @@ code mapping.
>  The Kprobes API includes a "register" function and an "unregister"
>  function for each type of probe.  Here are terse, mini-man-page
>  specifications for these functions and the associated probe handlers
> -that you'll write.  See the latter half of this document for examples.
> +that you'll write.  See the files in the samples/kprobes/ sub-directory
> +for examples.
>  
>  4.1 register_kprobe
>  
> @@ -392,220 +393,15 @@ e. Watchpoint probes (which fire on data
>  
>  8. Kprobes Example
>  
> -Here's a sample kernel module showing the use of kprobes to dump a
> -stack trace and selected i386 registers when do_fork() is called.
> ------ cut here -----
> -/*kprobe_example.c*/
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/kprobes.h>
> -#include <linux/sched.h>
> -
> -/*For each probe you need to allocate a kprobe structure*/
> -static struct kprobe kp;
> -
> -/*kprobe pre_handler: called just before the probed instruction is executed*/
> -int handler_pre(struct kprobe *p, struct pt_regs *regs)
> -{
> -	printk("pre_handler: p->addr=0x%p, eip=%lx, eflags=0x%lx\n",
> -		p->addr, regs->eip, regs->eflags);
> -	dump_stack();
> -	return 0;
> -}
> -
> -/*kprobe post_handler: called after the probed instruction is executed*/
> -void handler_post(struct kprobe *p, struct pt_regs *regs, unsigned long flags)
> -{
> -	printk("post_handler: p->addr=0x%p, eflags=0x%lx\n",
> -		p->addr, regs->eflags);
> -}
> -
> -/* fault_handler: this is called if an exception is generated for any
> - * instruction within the pre- or post-handler, or when Kprobes
> - * single-steps the probed instruction.
> - */
> -int handler_fault(struct kprobe *p, struct pt_regs *regs, int trapnr)
> -{
> -	printk("fault_handler: p->addr=0x%p, trap #%dn",
> -		p->addr, trapnr);
> -	/* Return 0 because we don't handle the fault. */
> -	return 0;
> -}
> -
> -static int __init kprobe_init(void)
> -{
> -	int ret;
> -	kp.pre_handler = handler_pre;
> -	kp.post_handler = handler_post;
> -	kp.fault_handler = handler_fault;
> -	kp.symbol_name = "do_fork";
> -
> -	ret = register_kprobe(&kp);
> -	if (ret < 0) {
> -		printk("register_kprobe failed, returned %d\n", ret);
> -		return ret;
> -	}
> -	printk("kprobe registered\n");
> -	return 0;
> -}
> -
> -static void __exit kprobe_exit(void)
> -{
> -	unregister_kprobe(&kp);
> -	printk("kprobe unregistered\n");
> -}
> -
> -module_init(kprobe_init)
> -module_exit(kprobe_exit)
> -MODULE_LICENSE("GPL");
> ------ cut here -----
> -
> -You can build the kernel module, kprobe-example.ko, using the following
> -Makefile:
> ------ cut here -----
> -obj-m := kprobe-example.o
> -KDIR := /lib/modules/$(shell uname -r)/build
> -PWD := $(shell pwd)
> -default:
> -	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
> -clean:
> -	rm -f *.mod.c *.ko *.o
> ------ cut here -----
> -
> -$ make
> -$ su -
> -...
> -# insmod kprobe-example.ko
> -
> -You will see the trace data in /var/log/messages and on the console
> -whenever do_fork() is invoked to create a new process.
> +See samples/kprobes/kprobe_example.c.
>  
>  9. Jprobes Example
>  
> -Here's a sample kernel module showing the use of jprobes to dump
> -the arguments of do_fork().
> ------ cut here -----
> -/*jprobe-example.c */
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/fs.h>
> -#include <linux/uio.h>
> -#include <linux/kprobes.h>
> -
> -/*
> - * Jumper probe for do_fork.
> - * Mirror principle enables access to arguments of the probed routine
> - * from the probe handler.
> - */
> -
> -/* Proxy routine having the same arguments as actual do_fork() routine */
> -long jdo_fork(unsigned long clone_flags, unsigned long stack_start,
> -	      struct pt_regs *regs, unsigned long stack_size,
> -	      int __user * parent_tidptr, int __user * child_tidptr)
> -{
> -	printk("jprobe: clone_flags=0x%lx, stack_size=0x%lx, regs=0x%p\n",
> -	       clone_flags, stack_size, regs);
> -	/* Always end with a call to jprobe_return(). */
> -	jprobe_return();
> -	/*NOTREACHED*/
> -	return 0;
> -}
> -
> -static struct jprobe my_jprobe = {
> -	.entry = jdo_fork
> -};
> -
> -static int __init jprobe_init(void)
> -{
> -	int ret;
> -	my_jprobe.kp.symbol_name = "do_fork";
> -
> -	if ((ret = register_jprobe(&my_jprobe)) <0) {
> -		printk("register_jprobe failed, returned %d\n", ret);
> -		return -1;
> -	}
> -	printk("Planted jprobe at %p, handler addr %p\n",
> -	       my_jprobe.kp.addr, my_jprobe.entry);
> -	return 0;
> -}
> -
> -static void __exit jprobe_exit(void)
> -{
> -	unregister_jprobe(&my_jprobe);
> -	printk("jprobe unregistered\n");
> -}
> -
> -module_init(jprobe_init)
> -module_exit(jprobe_exit)
> -MODULE_LICENSE("GPL");
> ------ cut here -----
> -
> -Build and insert the kernel module as shown in the above kprobe
> -example.  You will see the trace data in /var/log/messages and on
> -the console whenever do_fork() is invoked to create a new process.
> -(Some messages may be suppressed if syslogd is configured to
> -eliminate duplicate messages.)
> +See samples/kprobes/jprobe_example.c.
>  
>  10. Kretprobes Example
>  
> -Here's a sample kernel module showing the use of return probes to
> -report failed calls to sys_open().
> ------ cut here -----
> -/*kretprobe-example.c*/
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/kprobes.h>
> -
> -static const char *probed_func = "sys_open";
> -
> -/* Return-probe handler: If the probed function fails, log the return value. */
> -static int ret_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
> -{
> -	int retval = regs_return_value(regs);
> -	if (retval < 0) {
> -		printk("%s returns %d\n", probed_func, retval);
> -	}
> -	return 0;
> -}
> -
> -static struct kretprobe my_kretprobe = {
> -	.handler = ret_handler,
> -	/* Probe up to 20 instances concurrently. */
> -	.maxactive = 20
> -};
> -
> -static int __init kretprobe_init(void)
> -{
> -	int ret;
> -	my_kretprobe.kp.symbol_name = (char *)probed_func;
> -
> -	if ((ret = register_kretprobe(&my_kretprobe)) < 0) {
> -		printk("register_kretprobe failed, returned %d\n", ret);
> -		return -1;
> -	}
> -	printk("Planted return probe at %p\n", my_kretprobe.kp.addr);
> -	return 0;
> -}
> -
> -static void __exit kretprobe_exit(void)
> -{
> -	unregister_kretprobe(&my_kretprobe);
> -	printk("kretprobe unregistered\n");
> -	/* nmissed > 0 suggests that maxactive was set too low. */
> -	printk("Missed probing %d instances of %s\n",
> -		my_kretprobe.nmissed, probed_func);
> -}
> -
> -module_init(kretprobe_init)
> -module_exit(kretprobe_exit)
> -MODULE_LICENSE("GPL");
> ------ cut here -----
> -
> -Build and insert the kernel module as shown in the above kprobe
> -example.  You will see the trace data in /var/log/messages and on the
> -console whenever sys_open() returns a negative value.  (Some messages
> -may be suppressed if syslogd is configured to eliminate duplicate
> -messages.)
> +See samples/kprobes/kretprobe-example.c.
>  
>  For additional information on Kprobes, refer to the following URLs:
>  http://www-106.ibm.com/developerworks/library/l-kprobes.html?ca=dgr-lnxw42Kprobe
> --- /dev/null
> +++ linux-2.6.23-rc7/samples/Makefile
> @@ -0,0 +1,3 @@
> +# Makefile for Linux samples code
> +
> +obj-$(CONFIG_SAMPLES) += kprobes/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

