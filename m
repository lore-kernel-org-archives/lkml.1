Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYKHAE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYKHAE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 19:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYKHAEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 19:04:49 -0500
Received: from hq2.tensilica.com ([65.205.227.30]:27769 "EHLO
	maia.hq.tensilica.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751311AbYKHAEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 19:04:49 -0500
Message-ID: <4914D7A0.3070703@tensilica.com>
Date: Fri, 07 Nov 2008 16:04:48 -0800
From: Piet Delaney <piet.delaney@tensilica.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Piet Delaney <piet.delaney@tensilica.com>
Subject: [XTENSA] [KGDB] kgdbts: ERROR PUT: end of test buffer on 'bad_read_test'
 line 0 expected S0* got $T05thread:0000000000000001;#a7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting a problem with the kgdb Test Suite on the third test:

    kgdbts:RUN plant and detach test
    kgdbts:RUN sw breakpoint test
    kgdbts:RUN bad memory access test
    kgdbts: ERROR PUT: end of test buffer on 'bad_read_test' line 0 expected S0* got $T05thread:0000000000000001;#a7
    ------------[ cut here ]------------
    WARNING: at /export/src/xtensa-next/drivers/misc/kgdbts.c:723 run_simple_test+0x2a1/0x2cc()

I'm using an Illegal Instruction (ILL) instead of the normal BREAK instruction for now so I can use
the std JTAG based gdb to debug the stub. The test appears to be just expecting the '#a7' but the stub has
sent the Trap Information from gdb_serial_stub() up in frame #5:

    1217 static int gdb_serial_stub(struct kgdb_state *ks)
    1218 {
    1219         int error = 0;
    1220         int tmp;
    1221
    1222         /* Clear the out buffer. */
    1223         memset(remcom_out_buffer, 0, sizeof(remcom_out_buffer));
    1224
    1225         if (kgdb_connected) {
    1226                 unsigned char thref[8];
    1227                 char *ptr;
    1228
    1229                 /* Reply to host that an exception has occurred */
    1230                 ptr = remcom_out_buffer;
    1231                 *ptr++ = 'T';
    1232                 ptr = pack_hex_byte(ptr, ks->signo);
    1233                 ptr += strlen(strcpy(ptr, "thread:"));
    1234                 int_to_threadref(thref, shadow_pid(current->pid));
    1235                 ptr = pack_threadid(ptr, thref);
    1236                 *ptr++ = ';';

(gdb) bt
#0  dump_stack () at /export/src/xtensa-next/arch/xtensa/kernel/traps.c:507
#1  0xd0016a3d in warn_on_slowpath (file=0xd01b90e4 "/export/src/xten"..., line=0x2d3) at /export/src/xtensa-next/kernel/panic.c:316
#2  0xd012369d in run_simple_test (is_get_char=0x0, chr=0x37) at /export/src/xtensa-next/drivers/misc/kgdbts.c:721                                  [ERRORS on T05thread:0000000000000001']
#3  0xd0123e8e in kgdbts_put_char (chr=0x37) at /export/src/xtensa-next/drivers/misc/kgdbts.c:1056
#4  0xd0041a1c in put_packet (buffer=0xd0261100 "T05thread:000000"...) at /export/src/xtensa-next/kernel/kgdb.c:333
#5  0xd0042e32 in gdb_serial_stub (ks=0xd381fa94) at /export/src/xtensa-next/kernel/kgdb.c:1237                                                     [WRITES 'T05thread:0000000000000001']
#6  0xd0043392 in kgdb_handle_exception (evector=0x3f, signo=0x5, ecode=0x8, regs=0xd381fd40) at /export/src/xtensa-next/kernel/kgdb.c:1501
#7  0xd000705e in __kgdb_xtensa_notify (args=0xd381fc60, cmd=0x3) at /export/src/xtensa-next/arch/xtensa/kernel/kgdb.c:818
#8  0xd00070d8 in kgdb_xtensa_notify (self=0xd020e71c, cmd=0x3, args=0xd381fc60) at /export/src/xtensa-next/arch/xtensa/kernel/kgdb.c:837
#9  0xd0034712 in notifier_call_chain (nl=0xd0209b84, val=0x3, v=0xd381fc60, nr_to_call=0xffffffff, nr_calls=0x0) at /export/src/xtensa-next/kernel/notifier.c:85
#10 0xd00347e0 in __atomic_notifier_call_chain (nh=0xd0209b74, val=0x3, v=0xd381fc60, nr_to_call=0xffffffff, nr_calls=0x0) at /export/src/xtensa-next/kernel/notifier.c:174
#11 0xd0034805 in atomic_notifier_call_chain (nh=0xd0209b74, val=0x3, v=0xd381fc60) at /export/src/xtensa-next/kernel/notifier.c:183
#12 0xd0034bbc in notify_die (val=DIE_DEBUG, str=0xd01a5db4 "debug", regs=0xd381fd40, err=0x8, trap=0x3f, sig=0x5) at /export/src/xtensa-next/kernel/notifier.c:564
#13 0xd0005995 in do_debug (regs=0xd381fd40) at /export/src/xtensa-next/arch/xtensa/kernel/traps.c:302
#14 0xd0005898 in do_illegal_instruction (regs=0xd381fd40) at /export/src/xtensa-next/arch/xtensa/kernel/traps.c:234
#15 0xd0002448 in _kernel_exception () at /export/src/xtensa-next/arch/xtensa/kernel/entry.S:602
#16 0xd0007177 in arch_kgdb_breakpoint () at /export/src/xtensa-next/arch/xtensa/kernel/kgdb.c:919
#17 0xd0043774 in kgdb_breakpoint () at /export/src/xtensa-next/kernel/kgdb.c:1717
#18 0xd0123a00 in run_bad_read_test () at /export/src/xtensa-next/drivers/misc/kgdbts.c:849
#19 0xd0123b74 in kgdbts_run_tests () at /export/src/xtensa-next/drivers/misc/kgdbts.c:909
#20 0xd0123e12 in configure_kgdbts () at /export/src/xtensa-next/drivers/misc/kgdbts.c:1017
#21 0xd022e2c2 in init_kgdbts () at /export/src/xtensa-next/drivers/misc/kgdbts.c:1034
#22 0xd00013ee in do_one_initcall (fn=0xd022e2a8 <init_kgdbts>) at /export/src/xtensa-next/init/main.c:715
#23 0xd0226848 in do_initcalls () at /export/src/xtensa-next/init/main.c:755
#24 0xd022687e in do_basic_setup () at /export/src/xtensa-next/init/main.c:776
#25 0xd0226903 in kernel_init (unused=0x0) at /export/src/xtensa-next/init/main.c:865
#26 0xd0002bad in kernel_thread () at /export/src/xtensa-next/arch/xtensa/kernel/entry.S:1965
Backtrace stopped: previous frame inner to this frame (corrupt stack?)
(gdb)

I've tried a few changes in the trap handler but so far the problem persist.
The test suite suite seems like a nice idea. Did I miss an explanation somewhere
that goes into the details of the code that implements this? Chapter 5 of the Internals
doc just says to look at the code; which I've been doing.

I thought it might be worthwhile to get your thoughts now that I've been messing with it a while.

-piet

