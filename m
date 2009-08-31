Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbZHaF12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbZHaF12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 01:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZHaF12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 01:27:28 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:38876 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbZHaF11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 01:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jecenzo+OsVW4rRCAqK2MNsBIUdzg2/uarra+UHk/fn4sYtSLYKEGls8me2kBMddsS
         r79QBon5rpOP+MdyOoseSaXL/UEd2h4YRXwM5M8XGAaY49X7Y3G3oY4DN88jxHHtCIem
         JhjcsJ/Y3IJBZBnCG1+BW6tdRjh9XdKu8J2pY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0908251333410.6044@xanadu.home>
References: <6d53329e0908250342g2cfb73f6v90f73c283c0d391c@mail.gmail.com>
	 <alpine.LFD.2.00.0908251333410.6044@xanadu.home>
Date: Mon, 31 Aug 2009 10:57:28 +0530
Message-ID: <6d53329e0908302227l63420351m1005d0c76346e2ec@mail.gmail.com>
Subject: Re: ARM + jprobes/kretprobes SEGV/hangs/OOPS in 2.6.29 kernel
From: venki kaps <venkiece2005@gmail.com>
To: Nicolas Pitre <nico@cam.org>
Cc: "sagar.abhishek@gmail.com" <sagar.abhishek@gmail.com>,
       "jkenisto@us.ibm.com" <jkenisto@us.ibm.com>,
       "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
       "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
       "linux-arm@vger.kernel.org" <linux-arm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "prasanna@in.ibm.com" <prasanna@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have further investigated with respect to this issue and found the
problem with
'dump_stack()' which calls in my sample kprobe,kretprobe and jprobe
modules to get
the stack dump.

Here it is giving sample example module which covers all the probes.

Sample module test program:
---------------------------
#include <linux/module.h>
#include <linux/init.h>
#include <linux/kprobes.h>

static int k_count1 = 0;
static int k_count2 = 0;
static int k_count3 = 0;
static int k_count4 = 0;

/* Proxy routine having the same arguments as actual sys_open() routine */
long jsys_open(unsigned int fd, char __user * buf, size_t count)
{
        printk("%s %d, Proxy sys_open, arguments are %d, %d\n",
__FILE__, __LINE__, fd, count);
        printk("%s %d, Stack_dump :\n", __FILE__, __LINE__);
        dump_stack();
        /* Always end with a call to jprobe_return(). */
        k_count1++;
        jprobe_return();
        /* NOTREACHED */
        return 0;
}

static struct jprobe my_jprobe = {
        .entry = JPROBE_ENTRY(jsys_open)
};

static const char *probed_func = "sys_open";

/* Return-probe handler: Log the return value from the probed function. */
static int ret_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
{
        int retval = regs_return_value(regs);

        printk("%s %d, %s returns %d\n", __FILE__, __LINE__,
probed_func, retval);
        printk("%s %d, Stack_dump :\n", __FILE__, __LINE__);
        dump_stack();
        k_count2++;
        return 0;
}

static struct kretprobe my_kretprobe = {
        .handler = ret_handler,
        /* Probe up to 20 instances concurrently. */
        .maxactive = 20
};

static struct kprobe k_001_kpr;

static int k_001_before_hook(struct kprobe *k_001_kpr, struct pt_regs *p)
{
        printk("%s %d\nStack dump for the kprobe pre handler for
instruction at %p\n", __FILE__, __LINE__, k_001_kpr->addr);
        dump_stack();
        k_count3++;
        return 0;
}

void k_001_after_hook(struct kprobe *k_001_kpr, struct pt_regs *p,
unsigned long flags)
{
        printk("%s %d\nStack dump for the kprobe post handler at
%p\n", __FILE__, __LINE__, k_001_kpr->addr);
        dump_stack();
        printk("%s %d, The Registers are:\n", __FILE__, __LINE__);
        k_count4++;
}


static int __init k_001_init_probe(void)
{
        int ret;
        int retj;
        printk("%s %d\nInserting the kprobe for sys_open\n", __FILE__,
__LINE__);

        /* Registering a kprobe */
        k_001_kpr.pre_handler = (kprobe_pre_handler_t) k_001_before_hook;
        k_001_kpr.post_handler = (kprobe_post_handler_t) k_001_after_hook;
        k_001_kpr.symbol_name = "sys_open", __FILE__, __LINE__;
        if (register_kprobe(&k_001_kpr) < 0) {
                printk("%s %dk-001.c:register_kprobe is failed\n",
__FILE__, __LINE__);
                return -1;
        }
        printk("%s %d, register_kprobe is successful\n", __FILE__, __LINE__);

        printk("%s %d, Inserting the kretprobe for sys_open\n",
__FILE__, __LINE__);
        my_kretprobe.kp.symbol_name = (char *)probed_func;

        if ((ret = register_kretprobe(&my_kretprobe)) < 0) {
                printk("%s %d, register_kretprobe failed, returned
%d\n", __FILE__, __LINE__, ret);
                return -1;
        }
        printk("%s %d, Planted return probe for sys_open at %p\n",
__FILE__, __LINE__, my_kretprobe.kp.addr);

        my_jprobe.kp.symbol_name = "sys_open";

        if ((retj = register_jprobe(&my_jprobe)) < 0) {
                printk("%s %d,register_jprobe failed, returned %d\n",
__FILE__, __LINE__, ret);
                return -1;
        }
        printk("%s %d,Planted jprobe at %p, handler addr %p\n",
__FILE__, __LINE__, my_jprobe.kp.addr, my_jprobe.entry);

        return 0;
}

static void __exit k_001_exit_probe(void)
{
        unregister_kprobe(&k_001_kpr);
        printk("%s %d\nkprobe unregistered from sys_open \n",
__FILE__, __LINE__);

        unregister_kretprobe(&my_kretprobe);
        printk("%s %dkretprobe unregistered\n", __FILE__, __LINE__);
        /* nmissed > 0 suggests that maxactive was set too low. */
        printk("%s %dMissed probing %d instances of %s\n", __FILE__,
__LINE__, my_kretprobe.nmissed, probed_func);

        unregister_jprobe(&my_jprobe);
        printk("%s %d,jprobe unregistered\n", __FILE__, __LINE__);

        if (k_count1 > 0 && k_count2 > 0 && k_count3 > 0 && k_count4 > 0)
                printk("TEST PASS");
        else
                printk("TEST FAIL");
}

module_init(k_001_init_probe);
module_exit(k_001_exit_probe);

MODULE_DESCRIPTION("Kprobes test module");
MODULE_LICENSE("GPL");

I have tested the above program and got result as system hang.

Disable dump_stack:
------------------------------
I have disabled dump_stack(ARM specific) in the above program
and did not notice any problem.

After disabling the dump_stack(), all the probes are working
fine for 'do_fork,sys_open and sys_close system calls.

ARM dump_stack implementation has been changed in 2.6.29 kernel:
----------------------------------------------------------------------------------------------------
I have found in 2.6.29 kernel the current ARM dump_stack implementation
has been changed.Due to that change the kprobes,jprobes and kretprobes
are failing for 'do_fork,sys_open and sys_close' system calls.

Current dump_stack implementation:

Location: arch/arm/kernel/traps.c

void dump_stack(void)
{
        dump_backtrace(NULL, NULL);
}


I have just reverted back the above source to old kernel implementation.

Index: b/arch/arm/kernel/traps.c
===================================================================
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -202,7 +202,11 @@ static void dump_backtrace(struct pt_reg

 void dump_stack(void)
 {
+#if 0
        dump_backtrace(NULL, NULL);
+#else
+       __backtrace();
+#endif
 }

 EXPORT_SYMBOL(dump_stack);


After the above change,All probes are working fine with
enabling of dump_stack() in my sample modules.

I have some queries with repect to the above changes.

Queries:
========
1) Revert back the old kernel implementation might not be a good solution.
	I anticipate it needs to be fixed in 2.6.29 kernel implementations.
	Am i right/wrong.
	
2) Shall i avoid by calling dump_stack() in my sample test modules?

3) Only do_fork, sys_open and sys_close system calls are working fine with
	dump_stack() but still 'SEGV,sysetm hangs' for do_execve,do_gettimeofday,
	sys_gettimeofday,sys_read,sys_write, etc system calls.

I have been further investigating with respect to the above issues
Meanwhile could you please provide the inputs with respect to the above queries?

Thanks in advance.

Best regards,
Venkappa


On Tue, Aug 25, 2009 at 11:07 PM, Nicolas Pitre<nico@cam.org> wrote:
> On Tue, 25 Aug 2009, venki kaps wrote:
>
>> Hi,
>>
>> I have been tracing kernel system call information using
>> the Kprobes/jprobes/kretprobes implementation in the 2.6.29 kernel on
>> ARM architecture.
>> Although the mainline kprobe/jprobe/kretprobe examples are working
>> fine (do_fork),
>> I have been facing some issues while running my own jprobe/kretprobe tests.
>>
> [...]
>>
>> Query:
>> =====
>>       - Are there any limitations for jptobes/kretporbes in mainline kernel for ARM?
>
> No limitation in particular that I know of.
>
>>       - Why it works for only do_fork and why not for others
>> (do_execve/sys_open/sys_close/sys_read/sys_write)?
>
> I don't know.  Will try to have a look.
>
>>       - Is it required any additional setup to achieve this?
>
> Not supposed to need anything special.
>
>
> Nicolas
>
