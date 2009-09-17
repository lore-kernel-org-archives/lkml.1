Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbZIQIpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbZIQIpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbZIQIpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:45:33 -0400
Received: from mail-pz0-f190.google.com ([209.85.222.190]:40430 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbZIQIpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:45:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=fatQ2hQqdPCIgpD9hHD3duNfYFVjsI5s3pzf8fLyskKx7+53wk/uo0xNHORs4lCmyv
         zH1+KP1fwOjg3jxPz8n9aZNWe2UJ04KZbxqy6Z8F9SDP204k+3+uhbl/WxnzgzUu1ndh
         zoC1fEaoX5EWYCzFZeffYX/9+yibAOZWCRMtc=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Thu, 17 Sep 2009 16:37:59 +0800
Message-ID: <daef60380909170137k4e62c069p5a5a0f51c3e9026e@mail.gmail.com>
Subject: [PATCH] Fix the regs->sp value error when got a traps in x86_32 
	kernel mode
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/x86/kernel/entry_32.S, it said the after get a trap, the stack will be:
 *	30(%esp) - %eip
 *	34(%esp) - %cs
 *	38(%esp) - %eflags
 *	3C(%esp) - %oldesp
 *	40(%esp) - %oldss
And it handle the trap and put it to pt_regs as this format.

But actually, if the trap is happen in cpl 0, cpu will not save the sp
and ss, the stack will be:
 *	30(%esp) - %eip
 *	34(%esp) - %cs
 *	38(%esp) - %eflags
And it set to pt_regs.  Then some the regs->sp and regs->ss is wrong.

It will not affect the trap return, because "irq_return" handle it right.

But the function that use regs->sp and reg->ss will be affect, for
example: kprobe.  I make a example to reproduce this issue.

Patch the following patch to the kernel:
---
 kernel/fork.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1335,7 +1335,14 @@ long do_fork(unsigned long clone_flags,
 	struct task_struct *p;
 	int trace = 0;
 	long nr;
-
+{
+	uint32_t	sp;
+	asm volatile("movl %%esp, %0":"=m" (sp));
+	printk("do_fork1 sp = 0x%08lx\n", sp);
+	asm volatile("nop");
+	asm volatile("movl %%esp, %0":"=m" (sp));
+	printk("do_fork2 sp = 0x%08lx\n", sp);
+}
 	/*
 	 * Do some preliminary argument and permissions checking before we
 	 * actually start allocating stuff


Make a new module that use kprobe:
cat Makefile
obj-m := showsp.o

KERNELDIR := /home/teawater/kernel/bcommonpc
PWD  := $(shell pwd)

default:
	$(MAKE) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KERNELDIR) M=$(PWD) modules

clean:
	$(MAKE) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KERNELDIR) M=$(PWD) clean

cat showsp.c
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/kprobes.h>

#ifndef CONFIG_KPROBES
#error "Linux Kernel doesn't support KPROBES.  Please open it in
'General setup->Kprobes'."
#endif

#define KNAME_NOT_SET		"NOT SET"
static char			*kname = KNAME_NOT_SET;
static unsigned int		koffset = 0;
static unsigned int		kaddr = 0;

static int
handler_pre(struct kprobe *p, struct pt_regs *regs)
{
	printk("sp = 0x%08lx\n", regs->sp);

	return 0;
}

static void
handler_post(struct kprobe *p, struct pt_regs *regs,
				unsigned long flags)
{
}

static int
handler_fault(struct kprobe *p, struct pt_regs *regs, int trapnr)
{
	printk(KERN_ERR "kcoredump: get fault addr = 0x%p, trap #%dn\n",
		p->addr, trapnr);
	return 0;
}

static struct kprobe kp = {
	.pre_handler	= handler_pre,
	.post_handler	= handler_post,
	.fault_handler	= handler_fault,
};

int init_module(void)
{
	/* Check argument.  */
	if (strcmp (kname, KNAME_NOT_SET)) {
		kp.symbol_name = kname;
		kp.offset = koffset;
	}
	else {
		if (kaddr) {
			kp.addr = (kprobe_opcode_t *)kaddr;
		}
		else {
			printk (KERN_ERR "kcoredump: must set the name or addr.\n");
			return -EINVAL;
		}
	}

	return register_kprobe(&kp);
}

void cleanup_module(void)
{
	unregister_kprobe(&kp);
}

module_param_named(name, kname, charp, 0644);
module_param_named(offset, koffset, uint, 0644);
module_param_named(addr, kaddr, uint, 0644);

MODULE_LICENSE("GPL");

make

gdb ./vmline
(gdb) disassemble /m do_fork
Dump of assembler code for function do_fork:
1334	{
0xc011eec0 <do_fork+0>:	push   %ebp
0xc011eec1 <do_fork+1>:	mov    %edx,%ebp
0xc011eec3 <do_fork+3>:	push   %edi
0xc011eec4 <do_fork+4>:	mov    %eax,%edi
0xc011eec6 <do_fork+6>:	push   %esi
0xc011eec7 <do_fork+7>:	mov    %ecx,%esi
0xc011eec9 <do_fork+9>:	push   %ebx
0xc011eeca <do_fork+10>:	sub    $0x2c,%esp

1335		struct task_struct *p;
1336		int trace = 0;
1337		long nr;
1338	{
1339		uint32_t	sp;
1340		asm volatile("movl %%esp, %0":"=m" (sp));
0xc011eecd <do_fork+13>:	mov    %esp,0x28(%esp)

1341		printk("do_fork1 sp = 0x%08lx\n", sp);
0xc011eed1 <do_fork+17>:	mov    0x28(%esp),%eax
0xc011eed5 <do_fork+21>:	movl   $0xc0533427,(%esp)
0xc011eedc <do_fork+28>:	mov    %eax,0x4(%esp)
0xc011eee0 <do_fork+32>:	call   0xc0120b60 <printk>

1342		asm volatile("nop");
0xc011eee5 <do_fork+37>:	nop

1343		asm volatile("movl %%esp, %0":"=m" (sp));
---Type <return> to continue, or q <return> to quit---
0xc011eee6 <do_fork+38>:	mov    %esp,0x28(%esp)

1344		printk("do_fork2 sp = 0x%08lx\n", sp);
0xc011eeea <do_fork+42>:	mov    0x28(%esp),%eax
0xc011eeee <do_fork+46>:	movl   $0xc053343e,(%esp)
0xc011eef5 <do_fork+53>:	mov    %eax,0x4(%esp)
0xc011eef9 <do_fork+57>:	call   0xc0120b60 <printk>

1345	}

insmod showsp.ko name=do_fork offset=37

root@localhost:/> ls
do_fork1 sp = 0xcfb8bf5c
sp = 0xc0533427
do_fork2 sp = 0xcfb8bf5c

The sp is not right.

This patch just fix the regs->sp in do_int3, it can fix the kprobe and
some other part.  And I didn't fix the ss.
If you think we need fix them in SAVE_ALL or we need fix the ss.  I
will post a new patch for it.

Signed-off-by: Hui Zhu <teawater@gmail.com>
---
 arch/x86/kernel/traps.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -463,6 +463,16 @@ void restart_nmi(void)
 /* May run on IST stack. */
 dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
+#ifdef CONFIG_X86_32
+	unsigned long orig_sp = 0;
+
+	/* Get right sp to right value if CPL is 0.  */
+	if ((regs->cs & 0x3) == 0) {
+		orig_sp = regs->sp;
+		regs->sp = (unsigned long)&regs->sp;
+	}
+#endif
+
 #ifdef CONFIG_KPROBES
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
@@ -476,6 +486,13 @@ dotraplinkage void __kprobes do_int3(str
 	preempt_conditional_sti(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
+
+#ifdef CONFIG_X86_32
+	/* Get right sp to right value if CPL is 0.  */
+	if ((regs->cs & 0x3) == 0) {
+		regs->sp = orig_sp;
+	}
+#endif
 }

 #ifdef CONFIG_X86_64
