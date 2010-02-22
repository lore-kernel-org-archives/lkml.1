Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0BVOkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:40:31 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50054 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab0BVOka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:40:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=UZXZwELBGVcEnsEUzD3tJzuoVmPRkJl3XlfPfiYZOWovGunljRoXFLLi+Eqpv/+ok4
         CbK4jaCbaCBXSH+mDrs50gNbZKb3ZjCQu+lq57+1JSGgbSMIrbi1r8lfXH85wTI2s8C4
         rrolcR287l31l+W06tOBrrQkDuHM96cs+hp8E=
Message-ID: <4B829750.90107@gmail.com>
Date: Mon, 22 Feb 2010 22:40:16 +0800
From: Hui Zhu <teawater@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       gdb-patches ml <gdb-patches@sourceware.org>,
       Michal Marek <mmarek@suse.cz>
Subject: [PATCH 0/2] markup_oops.pl and GDB: Let GDB can handle kernel oops
 stack message
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I make a patch in http://lkml.org/lkml/2010/1/3/28 to let kernel show
special stack message and convert it to core file when kernel die.
But it need change too much part and other thing make a lot of people
didn't like it.

So I make a patch for markup_oops.pl to make it can convert the oops
message to GDB command.
And make a patch for GDB to add a new target empty which level is same
with corelow target. It can save the memory and reg operation command's
value and send it to GDB as the inferior's value. Then GDB can parse the
oops message directly.

The oops didn't show all the stack message, because it just show
"kstack_depth_to_print" values. To show all the stack value, you need
add kernel commandline "kstack=4096". Because this part have check:
if (kstack_end(stack))
break;
So set kstack_depth_to_print to big number will not affect anything.

For example:
Add "kstack=4096" to kernel commandline. Get the oops message and save
it to a file.

cat ~/tmp/amd64 | perl ./scripts/markup_oops.pl -g -c x86_64- -m
~/tmp/e.ko ~/tmp/vmlinux > ./gc
This line parse the oops message from ~/tmp/amd64 to file ./gc.

gdb -x ./gc
add symbol table from file
"../common_pc_64.glibc_std.standard/export/dist/e.ko" at
.text_addr = 0xffffffffa001b000
#0 init_module () at /home/teawater/study/kernel/stack2core/example/e.c:10
10 buf[0] = 3;
(gdb) bt
#0 init_module () at /home/teawater/study/kernel/stack2core/example/e.c:10
#1 0xffffffff8020903b in do_one_initcall (fn=0xffffffffa001b000
<init_module>)
at
/home/teawater/kernel/common_pc_64.glibc_std.standard/build/linux/init/main.c:737
#2 0xffffffff80261e55 in sys_init_module (umod=0x6905b0, len=50382,
uargs=<value optimized out>)
at
/home/teawater/kernel/common_pc_64.glibc_std.standard/build/linux/kernel/module.c:2385
#3 0xffffffff8020bb0b in ?? ()
at
/home/teawater/kernel/common_pc_64.glibc_std.standard/build/linux/arch/x86/kernel/entry_64.S:359
(gdb) frame 3
#3 0xffffffff8020bb0b in ?? ()
at
/home/teawater/kernel/common_pc_64.glibc_std.standard/build/linux/arch/x86/kernel/entry_64.S:359
359 call *sys_call_table(,%rax,8) # XXX: rip relative
(gdb) frame 2
#2 0xffffffff80261e55 in sys_init_module (umod=0x6905b0, len=50382,
uargs=<value optimized out>)
at
/home/teawater/kernel/common_pc_64.glibc_std.standard/build/linux/kernel/module.c:2385
2385 ret = do_one_initcall(mod->init);
(gdb) list
2380 blocking_notifier_call_chain(&module_notify_list,
2381 MODULE_STATE_COMING, mod);
2382
2383 /* Start the module */
2384 if (mod->init != NULL)
2385 ret = do_one_initcall(mod->init);
2386 if (ret < 0) {
2387 /* Init routine failed: abort. Try to protect us from
2388 buggy refcounters. */
2389 mod->state = MODULE_STATE_GOING;
(gdb) p mod
$1 = (struct module *) 0xffffffffa001b340

Thanks,
Hui

