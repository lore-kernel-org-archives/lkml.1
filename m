Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbYFVU6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbYFVU6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYFVU6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:58:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:28392 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbYFVU6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:58:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BM+zz/MknCx6e0gN1LrKTAv5QLNQu70MGARssOP2MKjCUVAzL22d5XHovP9muJnNWj
         c6GCnX0dcYVqBEs5F3fQvR+JXhtnLKFzatohXgADZ7+uQcMVeaTKpFD9puTxZ11W8qow
         O2IpiqA75hOhFMliOFzmkkAiHWeN/ofQGMGLk=
Message-ID: <19f34abd0806221358k35d18279g4365b4aee32da194@mail.gmail.com>
Date: Sun, 22 Jun 2008 22:58:05 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH -tip-rcu] Make rcutorture more vicious: make quiescent rcutorture less power-hungry
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, josh@freedesktop.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, dino@in.ibm.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
In-Reply-To: <20080622200638.GA25328@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080618122144.GA27143@linux.vnet.ibm.com>
	 <20080618162649.GA18326@linux.vnet.ibm.com>
	 <20080622200638.GA25328@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 10:06 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> This patch makes the non-module rcutorture a bit more friendly to
> the power-conservation code.  This is a rather simple-minded approach.
> More sophisticated approaches would get rid of the rcutorture tasks
> while rcutorture execution was suppressed, but attempts thus far to
> do this have not gone well -- calling rcu_torture_init() from a /proc
> callout results in oopses.

Hi Paul,

I applied your three patches

[PATCH] Make rcutorture more vicious: add stutter feature
[PATCH] Make rcutorture more vicious: reinstate boot-time testing
[PATCH -tip-rcu] Make rcutorture more vicious: make quiescent
rcutorture less power-hungry

to v2.6.26-rc7 and gave it a quick testing in qemu. But it seems to
hang during gdb self-tests at boot:

rcu-torture:--- Start of test: nreaders=6 nfakewriters=4
stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3
stutter=5
Clocksource tsc unstable (delta = 617797275 ns)
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.29 [Flags: R/O].
msgmni has been set to 228
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:01.0: Activating ISA DMA hang workarounds
pci 0000:00:02.0: Boot video device
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
FDC 0 is a S82078B
brd: module loaded
loop: module loaded
kgdb: Registered I/O driver kgdbts.
kgdbts:RUN plant and detach test

<--- full stop


gdb shows this:

kgdb_handle_exception (evector=0, signo=<value optimized out>,
    ecode=<value optimized out>, regs=0xc0769eec)
    at include/asm/processor.h:688
688             asm volatile("rep; nop" ::: "memory");
(gdb) bt
#0  kgdb_handle_exception (evector=0, signo=<value optimized out>,
    ecode=<value optimized out>, regs=0xc0769eec)
    at include/asm/processor.h:688
#1  0xc011ffa1 in kgdb_notify (self=<value optimized out>, cmd=9,
    ptr=0xc0769e30) at arch/x86/kernel/kgdb.c:478
#2  0xc014f527 in notifier_call_chain (nl=<value optimized out>, val=9,
    v=0xc0769e30, nr_to_call=-1, nr_calls=0x0) at kernel/notifier.c:85
#3  0xc014f925 in __atomic_notifier_call_chain (nh=<value optimized out>,
    val=9, v=0xc0769e30, nr_to_call=-1, nr_calls=0x0) at kernel/notifier.c:174
#4  0xc014f95a in atomic_notifier_call_chain (nh=0x2, val=0, v=0xffffffff)
    at kernel/notifier.c:183
#5  0xc014f98d in notify_die (val=0, str=<value optimized out>,
    regs=<value optimized out>, err=0, trap=0, sig=8) at kernel/notifier.c:564
#6  0xc010a8e8 in do_divide_error (regs=0xc0769eec, error_code=0)
    at arch/x86/kernel/traps_32.c:594
#7  0xc058cdba in page_fault ()
#8  0xc080f780 in per_cpu__init_tss ()
#9  0xc013c255 in do_softirq () at kernel/softirq.c:271
#10 0xc013c255 in do_softirq () at kernel/softirq.c:271
#11 0xc013c3f5 in irq_exit () at kernel/softirq.c:310
#12 0xc011db28 in smp_apic_timer_interrupt (regs=<value optimized out>)
    at arch/x86/kernel/apic_32.c:619
#13 0xc0108ed3 in apic_timer_interrupt () at include/asm/desc.h:309
#14 0xc0106ce0 in ?? () at arch/x86/kernel/process_32.c:466
#15 0xc0768000 in ?? ()
#16 0x00000000 in ?? ()

Without your patches, the kernel gets through here just fine.

These are my RCU-related options:

$ grep RCU .config
# CONFIG_CLASSIC_RCU is not set
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_TRACE=y
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y

As a convenience feature, it would be nice to have a boot option
controlling the run-at-boot as well, simply because it saves a
recompile for me :-) Actually, for some reason, the test still starts
at boot even when CONFIG_RCU_TORTURE_TEST_RUNNABLE=n. Is a hunk
missing from patch #2?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
