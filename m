Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbYAKHWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbYAKHWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 02:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757612AbYAKHWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 02:22:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbYAKHWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 02:22:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [x86/mm] vsyscall_fn fault in early startup
X-Zippy-Says: I have the power to HALT PRODUCTION on all TEENAGE SEX COMEDIES!!
Message-Id: <20080111072143.D940526F9A9@magilla.localdomain>
Date: Thu, 10 Jan 2008 23:21:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I bisected my startup problem down to:

	197e4989b0404996dfe3ab091c1398e4c2813d44 is first bad commit
	commit 197e4989b0404996dfe3ab091c1398e4c2813d44
	Author: Ingo Molnar <mingo@elte.hu>
	Date:   Wed Jan 9 13:31:06 2008 +0100

	    x86: mark native_read_tsc() as __vsyscall_fn

	    Andi Kleen reported the following breakage: the 64-bit vdso faulted
	    because native_read_tsc() is not a vsyscall-fn. Mark it as such.

	    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Without that commit, it gets past early startup and boots fine,
but of course then init crashes in the vDSO just as Andi reported.

Apparently this one:

	commit 715cf488c640ef4bed6c971660251d8d6cba4fbb
	Author: Ingo Molnar <mingo@elte.hu>
	Date:   Wed Jan 9 13:31:06 2008 +0100

	    x86: map vsyscalls early enough

	    map vsyscalls early enough. This is important if a __vsyscall_fn
	    function is used by other kernel code too.

	    Signed-off-by: Ingo Molnar <mingo@elte.hu>

is not really doing its job.  It's not early enough for the use I'm hitting.

Thanks to qemu-gdbserver, I have this handy backtrace for the early startup
case even though it dies too hard to print one.  
0xffffffffff60010d is really &native_read_tsc+0 though gdb reports the name
of the preceding symbol (vread_tsc).

   #0  early_idt_handler ()
       at /home/roland/redhat/linux/2.6/arch/x86/kernel/head_64.S:289
   #1  0x0000000000000010 in ?? ()
   #2  0xffffffffff60010d in vread_tsc ()
       at /home/roland/redhat/linux/2.6/arch/x86/kernel/tsc_64.c:308
   #3  0xffffffff80258cec in __lock_acquire (lock=0xffffffff806f4bf8, 
       subclass=0, trylock=0, read=0, check=2, hardirqs_off=1, 
       ip=18446744071564512884)
       at /home/roland/redhat/linux/2.6/kernel/lockdep.c:2416
   #4  0xffffffff802598f2 in lock_acquire (lock=0xffffffff806ea460, subclass=1, 
       trylock=3340, read=131072, check=-1, ip=18446744071564405679)
       at /home/roland/redhat/linux/2.6/kernel/lockdep.c:2703
   #5  0xffffffff8054de4f in _spin_lock (lock=0xffffffff806f4be0)
       at /home/roland/redhat/linux/2.6/kernel/spinlock.c:180
   #6  0xffffffff80254e74 in clockevents_register_notifier (
       nb=0xffffffff806f4c80)
       at /home/roland/redhat/linux/2.6/kernel/time/clockevents.c:114
   #7  0xffffffff807dc1f4 in tick_init ()
       at /home/roland/redhat/linux/2.6/kernel/time/tick-common.c:390
   #8  0xffffffff807c9811 in start_kernel ()
       at /home/roland/redhat/linux/2.6/init/main.c:531
   #9  0xffffffff807c9110 in x86_64_start_kernel (
       real_mode_data=0x92dc0 <Address 0x92dc0 out of bounds>)
       at /home/roland/redhat/linux/2.6/arch/x86/kernel/head64.c:73

So with lockdep et al turned on, tick_init leads to native_read_tsc.
setup_arch is after tick_init, so not early enough.  

I don't know if map_vsyscall needs too much stuff to come much earlier than
it is.  

It might be best just to let native_read_tsc be inlined ;-)


Thanks,
Roland
