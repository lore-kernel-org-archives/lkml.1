Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZAESBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZAESBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZAESAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:00:43 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58829 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbZAESAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:00:41 -0500
Date: Mon, 5 Jan 2009 10:00:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090105180037.GH6959@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090102195326.GF6842@linux.vnet.ibm.com> <20090102231239.GA19778@alice> <20090103015748.GL6842@linux.vnet.ibm.com> <20090103094003.GA6149@alice> <20090104013254.GG6958@linux.vnet.ibm.com> <20090104145726.GA14895@alice> <20090104211349.GS6958@linux.vnet.ibm.com> <20090104233855.GA17021@alice> <20090105022827.GA8080@linux.vnet.ibm.com> <20090105121409.GA5783@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105121409.GA5783@alice>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 01:14:09PM +0100, Eric Sesterhenn wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Mon, Jan 05, 2009 at 12:38:55AM +0100, Eric Sesterhenn wrote:
> > > hi,
> > > 
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Sun, Jan 04, 2009 at 03:57:26PM +0100, Eric Sesterhenn wrote:
> > > > > 
> > > > > Just tell me what i need to do, I am not really familiar with ftrace.
> > > > > I am only able to test 2.6.28-04980-gb58602a, since current -git is not
> > > > > able to boot on this box :|
> > > > 
> > > > Very cool!
> > > > 
> > > > The idea is to have __call_rcu() in kernel/rcutree.c record the
> > > > address of the callback (argument "head") and the function (argument
> > > > "func").  In rcu_do_batch(), just before invoking list->func(list),
> > > > also record the address of the callback ("list") and the function
> > > > (again, "func").
> > > > 
> > > > The new ftrace package has some mechanisms for doing this, but there is
> > > > always the old-fashioned way of using printk(), for example in
> > > > rcu_do_batch():
> > > > 
> > > > 	prefetch(next);
> > > > 	if (rcu_dump_callbacks)
> > > > 		printk("rcu_head=%p, func=%p\n", list, func);
> > > > 	list->func(list);
> > > > 
> > > > Initialize rcu_dump_callbacks to zero, then use a small kernel module
> > > > (or some such) to set it to one just before running your test.
> > > 
> > > i did it via the ugly printk and captured it via netconsole
> > 
> > Good stuff!!!
> > 
> > > for the box with rcutree you can find the log here:
> > > http://www.cccmz.de/~snakebyte/200.log
> > > The interesting part seems start at 155.858923, thats when I load
> > > the rcutorture module
> > 
> > When I download this, I see an 82.100963 immediately followed by an
> > 167.894017, no 155.858923.  Do I have the right log?
> > 
> > > with http://www.cccmz.de/~snakebyte/200_1.log i had another try,
> > > actually saw a rcu_do_batch: rcu_head=d1907720, func=(null) in the traces,
> > > box went into unresponsive mode afterwards
> > 
> > Interesting.  The original function is 0xd1902ad0, passed to __call_rcu()
> > at 157.364214 -- would you be able to tell me what function that
> > corresponds to?  (Looks to me like a module, perhaps rcutorture?)
> 
> I did the log more than once, guess this was the time from the one
> i uploaded earlier with the same name
> 
> > Whatever function it is, the rcu_head definitely got corrupted some
> > time during the 8 milliseconds or so that the callback was waiting for
> > a grace period.  However, it did just fine being invoked several times
> > beforehand -- this is a very popular RCU callback function, it appears.
> >
> > My guess is that the ensuing CPU 0 stall messages are due to CPU 0
> > having a heart attack trying to execute at address 0.
> 
> Could the popular rcu function be registered by rcutorture, but when
> we remove the module the callback is no longer valid? I can compile
> a kernel just fine and with other stress tests i did not see any oops so
> far.

One approach would be to print out the address of rcutorture's RCU
callbacks at rcutorture module initialization time (in rcu_torture_init()
in kernel/rcutorture.c).  The two callbacks are rcu_torture_cb() and
rcu_bh_torture_wakeme_after_cb().  Unless you are specifying the 
"torture_type" parameter to rcutorture, only the first one should be in
use.

> > Are you swapping over NFS, or is the netpoll_send_udp() just garbage on
> > the stack?
> 
> Swap is locally on a disc, nfs is configured but not used for swap.

OK, just garbage on the stack, then.

> > > And just in case it helps somehow: http://www.cccmz.de/~snakebyte/200_3.log
> > 
> > Hmmm...  The main recent change to kernel/rcutorture.c is the addition
> > of a reboot notifier, so that rcutorture can shut itself down gracefully
> > should the system go down while rcutorture is still running.  This panic
> > occurs in rcu_torture_stutter(), which is shown below:
> > 
> > 	static int
> > 	rcu_torture_stutter(void *arg)
> > 	{
> > 		VERBOSE_PRINTK_STRING("rcu_torture_stutter task started");
> > 		do {
> > 			schedule_timeout_interruptible(stutter * HZ);
> > 			stutter_pause_test = 1;
> > 			if (!kthread_should_stop() && !fullstop)
> > 				schedule_timeout_interruptible(stutter * HZ);
> > 			stutter_pause_test = 0;
> > 		} while (!kthread_should_stop() && !fullstop);
> > 		VERBOSE_PRINTK_STRING("rcu_torture_stutter task stopping");
> > 		return 0;
> > 	}
> > 
> > I don't see any reason why this function would transfer control to
> > location 0x60, though I do see a bug in the new shutdown code.  I
> > don't expect this to make any difference, but a patch is included
> > nevertheless.
> 
> Sadly it doesnt.

:-/

> > > for the one with rcupreemt you can find the log here:
> > > http://www.cccmz.de/~snakebyte/201.log
> > > rcutorture is loaded at 87.312399
> > 
> > Hmmm...  Offset 0x60 seems to be a common thread.  This lets
> > rcu_torture_ops off the hook, since it isn't that large.
> > 
> > Anyway, could you give the attached patch a go, even though I cannot see
> > how it would help?  ;-)
> 
> This is with the patch on the preemt rcu box (the 201.logs)

Looking these over, I would be surprised if this is a problem in the RCU
infrastructure itself, given that it shows up with all three versions,
but it could easily be a problem in rcutorture.  I should be able to get
some tests running locally later today.

							Thanx, Paul

> [  593.404728] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4
> stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5
> irqreader=1
> [  601.000124] BUG: unable to handle kernel paging request at d0af8a2d
> [  601.000431] IP: [<d0af8a2d>] 0xd0af8a2d
> [  601.000696] *pde = 0fbb4067 *pte = 00000000 
> [  601.000946] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> [  601.001027] last sysfs file: /sys/block/ram9/range
> [  601.001027] Modules linked in: [last unloaded: rcutorture]
> [  601.001027] 
> [  601.001027] Pid: 5021, comm: rcu_torture_fak Tainted: G        W
> (2.6.28-05692-g7d3b56b-dirty #169) System Name
> [  601.001027] EIP: 0060:[<d0af8a2d>] EFLAGS: 00010246 CPU: 0
> [  601.001027] EIP is at 0xd0af8a2d
> [  601.001027] EAX: 00000000 EBX: c98acfc4 ECX: c04f2c53 EDX: c98acf74
> [  601.001027] ESI: d0af8c0a EDI: 00000000 EBP: c98acfbc ESP: c98acfbc
> [  601.001027]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [  601.001027] Process rcu_torture_fak (pid: 5021, ti=c98ac000
> task=cbb64100 task.ti=c98ac000)
> [  601.001027] Stack:
> [  601.001027]  c98acfd0 d0af8c89 74816929 000024a7 00000000 c98acfe0
> c0136bcc c0136b8e
> [  601.001027]  00000000 00000000 c0103643 c9897ea4 00000000 00000000
> 00000000 00001301
> [  601.001027]  00008169
> [  601.001027] Call Trace:
> [  601.001027]  [<c0136bcc>] ? kthread+0x3e/0x66
> [  601.001027]  [<c0136b8e>] ? kthread+0x0/0x66
> [  601.001027]  [<c0103643>] ? kernel_thread_helper+0x7/0x10
> [  601.001027] Code:  Bad EIP value.
> [  601.001027] EIP: [<d0af8a2d>] 0xd0af8a2d SS:ESP 0068:c98acfbc
> [  601.001027] ---[ end trace 4eaa2a86a8e2da22 ]---
> [  601.006764] BUG: unable to handle kernel paging request at d0af8a2d
> [  601.007023] IP: [<d0af8a2d>] 0xd0af8a2d
> [  601.007265] *pde = 0fbb4067 *pte = 00000000 
> [  601.007511] Oops: 0000 [#2] PREEMPT DEBUG_PAGEALLOC
> [  601.007716] last sysfs file: /sys/block/ram9/range
> [  601.007716] Modules linked in: [last unloaded: rcutorture]
> [  601.007716] 
> [  601.007716] Pid: 5020, comm: rcu_torture_fak Tainted: G      D W
> (2.6.28-05692-g7d3b56b-dirty #169) System Name
> [  601.007716] EIP: 0060:[<d0af8a2d>] EFLAGS: 00010296 CPU: 0
> [  601.007716] EIP is at 0xd0af8a2d
> [  601.007716] EAX: 00000000 EBX: c98adfc4 ECX: c04f2c53 EDX: c98adf74
> [  601.007716] ESI: d0af8c0a EDI: 00000000 EBP: c98adfbc ESP: c98adfbc
> [  601.007716]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [  601.007716] Process rcu_torture_fak (pid: 5020, ti=c98ad000
> task=cbb62700 task.ti=c98ad000)
> [  601.007716] Stack:
> [  601.007716]  c98adfd0 d0af8c89 e5bc239c 000024ab 00000000 c98adfe0
> c0136bcc c0136b8e
> [  601.007716]  00000000 00000000 c0103643 c9897ea4 00000000 00000000
> 00000000 00000201
> [  601.007716]  00000674
> [  601.007716] Call Trace:
> [  601.007716]  [<c0136bcc>] ? kthread+0x3e/0x66
> [  601.007716]  [<c0136b8e>] ? kthread+0x0/0x66
> [  601.007716]  [<c0103643>] ? kernel_thread_helper+0x7/0x10
> [  601.007716] Code:  Bad EIP value.
> [  601.007716] EIP: [<d0af8a2d>] 0xd0af8a2d SS:ESP 0068:c98adfbc
> [  601.007716] ---[ end trace 4eaa2a86a8e2da22 ]---
> [  601.013281] BUG: unable to handle kernel paging request at d0af8a2d
> [  601.013542] IP: [<d0af8a2d>] 0xd0af8a2d
> [  601.013785] *pde = 0fbb4067 *pte = 00000000 
> [  601.014032] Oops: 0000 [#3] PREEMPT DEBUG_PAGEALLOC
> [  601.014239] last sysfs file: /sys/block/ram9/range
> [  601.014239] Modules linked in: [last unloaded: rcutorture]
> [  601.014239] 
> [  601.014239] Pid: 5019, comm: rcu_torture_fak Tainted: G      D W
> (2.6.28-05692-g7d3b56b-dirty #169) System Name
> [  601.014239] EIP: 0060:[<d0af8a2d>] EFLAGS: 00010286 CPU: 0
> [  601.014239] EIP is at 0xd0af8a2d
> [  601.014239] EAX: 00000000 EBX: c98b2fc4 ECX: c04f2c53 EDX: c98b2f74
> [  601.014239] ESI: d0af8c0a EDI: 00000000 EBP: c98b2fbc ESP: c98b2fbc
> [  601.014239]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [  601.014239] Process rcu_torture_fak (pid: 5019, ti=c98b2000
> task=c9804e00 task.ti=c98b2000)
> [  601.014239] Stack:
> [  601.014239]  c98b2fd0 d0af8c89 61a1df8f 000024a5 00000000 c98b2fe0
> c0136bcc c0136b8e
> [  601.014239]  00000000 00000000 c0103643 c9897ea4 00000000 00000000
> 00000000 000007bf
> [  601.014239]  00000012
> [  601.014239] Call Trace:
> [  601.014239]  [<c0136bcc>] ? kthread+0x3e/0x66
> [  601.014239]  [<c0136b8e>] ? kthread+0x0/0x66
> [  601.014239]  [<c0103643>] ? kernel_thread_helper+0x7/0x10
> [  601.014239] Code:  Bad EIP value.
> [  601.014239] EIP: [<d0af8a2d>] 0xd0af8a2d SS:ESP 0068:c98b2fbc
> [  601.014239] ---[ end trace 4eaa2a86a8e2da22 ]---
> 
> then i added the rcutree patch (Fix rcutree grace-period-latency bug on
> small systems) and got
> 
> [   65.968568] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4
> stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5
> irqreader=1
> [   68.872082] BUG: unable to handle kernel NULL pointer dereference at
> (null)
> [   68.872455] IP: [<(null)>] (null)
> [   68.872653] *pde = 00000000 
> [   68.872849] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> [   68.873027] last sysfs file: /sys/block/ram9/range
> [   68.873027] Modules linked in: [last unloaded: rcutorture]
> [   68.873027] 
> [   68.873027] Pid: 5023, comm: bash Tainted: G        W
> (2.6.28-05692-g7d3b56b-dirty #169) System Name
> [   68.873027] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
> [   68.873027] EIP is at 0x0
> [   68.873027] EAX: d0afd0b8 EBX: 00000000 ECX: c01612a6 EDX: 00000006
> [   68.873027] ESI: d0afd0b8 EDI: 0000001c EBP: c0b03fe0 ESP: c0b03fd4
> [   68.873027]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [   68.873027] Process bash (pid: 5023, ti=c0b03000 task=c98d1a00
> task.ti=ce824000)
> [   68.873027] Stack:
> [   68.873027]  c01612ad 00000200 00000001 c0b03ff8 c012aa97 0000000a
> ce824e98 00000046
> [   68.873027]  c012aa28 ce824ea8 c01042c2
> [   68.873027] Call Trace:
> [   68.873027]  [<c01612ad>] ? rcu_process_callbacks+0x65/0x79
> [   68.873027]  [<c012aa97>] ? __do_softirq+0x6f/0xf6
> [   68.873027]  [<c012aa28>] ? __do_softirq+0x0/0xf6
> [   68.873027]  <IRQ> <0> [<c012a9a5>] ? irq_exit+0x40/0x7c
> [   68.873027]  [<c0110ce1>] ? smp_apic_timer_interrupt+0x68/0x73
> [   68.873027]  [<c0103521>] ? apic_timer_interrupt+0x2d/0x34
> [   68.873027]  [<c07a024c>] ? _spin_lock+0x56/0x5d
> [   68.873027]  [<c07a0000>] ? _write_unlock_bh+0x28/0x37
> [   68.873027]  [<c017ad50>] ? do_wp_page+0x38b/0x453
> [   68.873027]  [<c017be9e>] ? handle_mm_fault+0x4e8/0x54d
> [   68.873027]  [<c0139da3>] ? down_read_trylock+0x3d/0x47
> [   68.873027]  [<c07a25d3>] ? do_page_fault+0x2dc/0x601
> [   68.873027]  [<c07a22f7>] ? do_page_fault+0x0/0x601
> [   68.873027]  [<c07a0bd7>] ? error_code+0x6f/0x74
> [   68.873027] Code:  Bad EIP value.
> [   68.873027] EIP: [<00000000>] 0x0 SS:ESP 0068:c0b03fd4
> [   68.880266] ---[ end trace 4eaa2a86a8e2da22 ]---
> [   68.880394] Kernel panic - not syncing: Fatal exception in interrupt
> 
> 
> Tried again without the rcutree patch and got this one,
> guess its just a timing thing wheter the NULL pointer deref or the other
> appears
> 
> [   99.643517] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4
> stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5
> irqreader=1
> [  104.149086] BUG: unable to handle kernel NULL pointer dereference at
> (null)
> [  104.149418] IP: [<(null)>] (null)
> [  104.149615] *pde = 00000000 
> [  104.149813] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> [  104.150029] last sysfs file: /sys/block/ram9/range
> [  104.150029] Modules linked in: [last unloaded: rcutorture]
> [  104.150029] 
> [  104.150029] Pid: 5030, comm: udevd Tainted: G        W
> (2.6.28-05692-g7d3b56b-dirty #169) System Name
> [  104.150029] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
> [  104.150029] EIP is at 0x0
> [  104.150029] EAX: d0afcc38 EBX: 00000000 ECX: c01612a6 EDX: 00000006
> [  104.150029] ESI: d0afcc38 EDI: 0000001c EBP: c0b03fe0 ESP: c0b03fd4
> [  104.150029]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [  104.150029] Process udevd (pid: 5030, ti=c0b03000 task=c98cb400
> task.ti=c98b1000)
> [  104.150029] Stack:
> [  104.150029]  c01612ad 00000200 00000001 c0b03ff8 c012aa97 0000000a
> c98b1e40 00000046
> [  104.150029]  c012aa28 c98b1e50 c01042c2
> [  104.150029] Call Trace:
> [  104.150029]  [<c01612ad>] ? rcu_process_callbacks+0x65/0x79
> [  104.150029]  [<c012aa97>] ? __do_softirq+0x6f/0xf6
> [  104.150029]  [<c012aa28>] ? __do_softirq+0x0/0xf6
> [  104.150029]  <IRQ> <0> [<c012a9a5>] ? irq_exit+0x40/0x7c
> [  104.150029]  [<c0110ce1>] ? smp_apic_timer_interrupt+0x68/0x73
> [  104.150029]  [<c0103521>] ? apic_timer_interrupt+0x2d/0x34
> [  104.150029]  [<c016e63f>] ? find_lock_page+0x5f/0x63
> [  104.150029]  [<c0170122>] ? filemap_fault+0x9f/0x391
> [  104.150029]  [<c017a6e8>] ? __do_fault+0x40/0x31d
> [  104.150029]  [<c017bc30>] ? handle_mm_fault+0x27a/0x54d
> [  104.150029]  [<c0139da3>] ? down_read_trylock+0x3d/0x47
> [  104.150029]  [<c07a25d3>] ? do_page_fault+0x2dc/0x601
> [  104.150029]  [<c07a22f7>] ? do_page_fault+0x0/0x601
> [  104.150029]  [<c07a0bd7>] ? error_code+0x6f/0x74
> [  104.150029] Code:  Bad EIP value.
> [  104.150029] EIP: [<00000000>] 0x0 SS:ESP 0068:c0b03fd4
> [  104.157313] ---[ end trace 4eaa2a86a8e2da22 ]---
> [  104.157441] Kernel panic - not syncing: Fatal exception in interrupt
> 
> I enabled classic rcu and pulled current -git (without both patches) and got these:
> 
> [   67.424425] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4
> stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5
> irqreader=1
> [   70.205083] BUG: unable to handle kernel NULL pointer dereference at
> (null)
> [   70.205416] IP: [<(null)>] (null)
> [   70.205605] *pde = 00000000 
> [   70.205798] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> [   70.206026] last sysfs file: /sys/block/ram9/range
> [   70.206026] Modules linked in: [last unloaded: rcutorture]
> [   70.206026] 
> [   70.206026] Pid: 1726, comm: udevd Tainted: G        W
> (2.6.28-05716-gfe0bdec #170) System Name
> [   70.206026] EIP: 0060:[<00000000>] EFLAGS: 00010202 CPU: 0
> [   70.206026] EIP is at 0x0
> [   70.206026] EAX: d0afc018 EBX: c10697c0 ECX: c0161905 EDX: d0afc018
> [   70.206026] ESI: 00000000 EDI: 00000001 EBP: c0b0bfd8 ESP: c0b0bfc4
> [   70.206026]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [   70.206026] Process udevd (pid: 1726, ti=c0b0b000 task=cee10000
> task.ti=ce80b000)
> [   70.206026] Stack:
> [   70.206026]  c016197c 00000202 00000200 00000001 0000001c c0b0bfe0
> c0161a00 c0b0bff8
> [   70.206026]  c012acca 0000000a ce80bec4 00000046 c012ac5b ce80bed4
> c01042c2
> [   70.206026] Call Trace:
> [   70.206026]  [<c016197c>] ? __rcu_process_callbacks+0x141/0x1ae
> [   70.206026]  [<c0161a00>] ? rcu_process_callbacks+0x17/0x28
> [   70.206026]  [<c012acca>] ? __do_softirq+0x6f/0x100
> [   70.206026]  [<c012ac5b>] ? __do_softirq+0x0/0x100
> [   70.206026]  <IRQ> <0> [<c012abdd>] ? irq_exit+0x40/0x77
> [   70.206026]  [<c0110ce9>] ? smp_apic_timer_interrupt+0x68/0x73
> [   70.206026]  [<c0103521>] ? apic_timer_interrupt+0x2d/0x34
> [   70.206026]  [<c014007b>] ? tick_do_periodic_broadcast+0xf/0x3a
> [   70.206026]  [<c018f325>] ? kmem_cache_free+0xbd/0xc5
> [   70.206026]  [<c019a45d>] ? putname+0x28/0x33
> [   70.206026]  [<c019a45d>] ? putname+0x28/0x33
> [   70.206026]  [<c019b7a0>] ? do_rmdir+0xba/0xc3
> [   70.206026]  [<c04e8b50>] ? trace_hardirqs_on_thunk+0xc/0x10
> [   70.206026]  [<c0102ecf>] ? sysenter_exit+0xf/0x16
> [   70.206026]  [<c01448f1>] ? trace_hardirqs_on_caller+0x17/0x15a
> [   70.206026]  [<c019b7f2>] ? sys_rmdir+0x15/0x17
> [   70.206026]  [<c0102ea1>] ? sysenter_do_call+0x12/0x31
> [   70.206026] Code:  Bad EIP value.
> [   70.206026] EIP: [<00000000>] 0x0 SS:ESP 0068:c0b0bfc4
> [   70.213814] ---[ end trace 4eaa2a86a8e2da22 ]---
> [   70.213934] Kernel panic - not syncing: Fatal exception in interrupt
> 
> 
> 
> 
> On the other box with tree rcu and the rcutorture patch (200.logs):
> 
> 
> [  168.408126] BUG: unable to handle kernel NULL pointer dereference at
> 00000029
> [  168.408433] IP: [<d1902ebf>] 0xd1902ebf
> [  168.408614] *pde = 00000000 
> [  168.408778] Oops: 0000 [#1] DEBUG_PAGEALLOC
> [  168.408978] last sysfs file: /sys/block/sda/size
> [  168.409164] Modules linked in: nfsd exportfs nfs lockd nfs_acl
> auth_rpcgss sunrpc ipv6 fuse unix [last unloaded: rcutorture]
> [  168.410099] 
> [  168.410197] Pid: 4154, comm: rcu_torture_rea Not tainted (2.6.28 #83) 
> [  168.410332] EIP: 0060:[<d1902ebf>] EFLAGS: 00010202 CPU: 0
> [  168.410516] EIP is at 0xd1902ebf
> [  168.410628] EAX: 00000001 EBX: 00000001 ECX: 00000000 EDX: 00000000
> [  168.410760] ESI: 00000000 EDI: 00000000 EBP: c7d52fd0 ESP: c7d52f84
> [  168.410992]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [  168.411120] Process rcu_torture_rea (pid: 4154, ti=c7d52000
> task=c7b73710 task.ti=c7d52000)
> [  168.411302] Stack:
> [  168.411398]  00000002 00000000 c0936a24 c7b48f8c 00000001 d1903040
> 00000000 c0936000
> [  168.411981]  d1902ff7 5f756372 74726f74 5f657275 00616572 0000103a
> 2e11c1af 00000dd1
> [  168.412021]  00000000 d1902e50 00000000 c7d52fe0 c013d81a c013d7e0
> 00000000 00000000
> [  168.412021] Call Trace:
> [  168.412021]  [<c013d81a>] ? kthread+0x3a/0x70
> [  168.412021]  [<c013d7e0>] ? kthread+0x0/0x70
> [  168.412021]  [<c0103cf3>] ? kernel_thread_helper+0x7/0x14
> [  168.412021] Code: 28 85 f6 74 1c 8d 45 bc c7 45 c8 40 30 90 d1 c7 45
> cc 00 00 00 00 e8 91 03 83 ee 90 a1 00 5e 90 d1 8b 1d a4 59 90 d1 85 db
> 74 12 <8b> 48 28 85 c9 74 0b 8b 55 bc 85 d2 0f 84 19 01 00 00 8d b4 26 
> [  168.412021] EIP: [<d1902ebf>] 0xd1902ebf SS:ESP 0068:c7d52f84
> [  168.418864] ---[ end trace 4bbd74c2c853213b ]---
> [  168.429775] __call_rcu: rcu_head=c3f47f24, func=c01b5a70
> [  168.429958] __call_rcu: rcu_head=c7bbecac, func=c0143580
> [  168.430129] __call_rcu: rcu_head=c7dbeea0, func=c01a6ae0
> [  168.431826] __call_rcu: rcu_head=c7de9328, func=c01a6ae0
> [  168.432089] rcu_do_batch: rcu_head=c3f47f24, func=c01b5a70
> [  168.432869] __call_rcu: rcu_head=c994fe18, func=c01b9c20
> [  168.436064] rcu_do_batch: rcu_head=c7bbecac, func=c0143580
> [  168.436226] rcu_do_batch: rcu_head=c7dbeea0, func=c01a6ae0
> [  168.444046] rcu_do_batch: rcu_head=c7de9328, func=c01a6ae0
> [  168.444193] rcu_do_batch: rcu_head=c994fe18, func=c01b9c20
> [  168.445866] BUG: unable to handle kernel NULL pointer dereference at
> 00000029
> [  168.446126] IP: [<d1902ebf>] 0xd1902ebf
> [  168.446315] *pde = 00000000 
> [  168.446488] Oops: 0000 [#2] DEBUG_PAGEALLOC
> [  168.446692] last sysfs file: /sys/block/sda/size
> [  168.446883] Modules linked in: nfsd exportfs nfs lockd nfs_acl
> auth_rpcgss sunrpc ipv6 fuse unix [last unloaded: rcutorture]
> [  168.447818] 
> [  168.447916] Pid: 4153, comm: rcu_torture_rea Tainted: G      D
> (2.6.28 #83) 
> [  168.448022] EIP: 0060:[<d1902ebf>] EFLAGS: 00010202 CPU: 0
> [  168.448022] EIP is at 0xd1902ebf
> [  168.448022] EAX: 00000001 EBX: 00000001 ECX: 00000000 EDX: 00000000
> [  168.448022] ESI: 00000000 EDI: 00000000 EBP: c7b48fd0 ESP: c7b48f84
> [  168.448022]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [  168.448022] Process rcu_torture_rea (pid: 4153, ti=c7b48000
> task=c7b5c710 task.ti=c7b48000)
> [  168.448022] Stack:
> [  168.448022]  00000002 00000000 c7d52f8c c7de5f74 00000001 d1903040
> 00000000 c0936000
> [  168.448022]  d1902ff7 5f756372 74726f74 5f657275 00616572 00001039
> b87c4524 00000ca3
> [  168.448022]  00000000 d1902e50 00000000 c7b48fe0 c013d81a c013d7e0
> 00000000 00000000
> [  168.448022] Call Trace:
> [  168.448022]  [<c013d81a>] ? kthread+0x3a/0x70
> [  168.448022]  [<c013d7e0>] ? kthread+0x0/0x70
> [  168.448022]  [<c0103cf3>] ? kernel_thread_helper+0x7/0x14
> [  168.448022] Code: 28 85 f6 74 1c 8d 45 bc c7 45 c8 40 30 90 d1 c7 45
> cc 00 00 00 00 e8 91 03 83 ee 90 a1 00 5e 90 d1 8b 1d a4 5[  168.457352]
> BUG: unable to handle kernel NULL pointer dereference at 0000001d
> [  168.457603] IP: [<d1903163>] 0xd1903163
> [  168.457776] *pde = 00000000 
> [  168.457942] Oops: 0000 [#3] DEBUG_PAGEALLOC
> [  168.458141] last sysfs file: /sys/block/sda/size
> [  168.458323] Modules linked in: nfsd exportfs nfs lockd nfs_acl
> auth_rpcgss sunrpc ipv6 fuse unix [last unloaded: rcutorture]
> [  168.459254] 
> [  168.459350] Pid: 4151, comm: rcu_torture_fak Tainted: G      D
> (2.6.28 #83) 
> [  168.459523] EIP: 0060:[<d1903163>] EFLAGS: 00010287 CPU: 0
> [  168.459706] EIP is at 0xd1903163
> [  168.459818] EAX: 00000001 EBX: c7dcafc0 ECX: 35502ab8 EDX: 00000021
> [  168.459949] ESI: cccccccd EDI: 00000000 EBP: c7dcafd0 ESP: c7dcafb8
> [  168.460080]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [  168.460262] Process rcu_torture_fak (pid: 4151, ti=c7dca000
> task=c7dcb710 task.ti=c7dca000)
> [  168.460442] Stack:
> [  168.460485]  c7dbadd8 00000000 01f30e05 00002699 00000000 d19030f0
> c7dcafe0 c013d81a
> [  168.460485]  c013d7e0 00000000 00000000 c0103cf3 c7ca9e70 00000000
> 00000000 00000000
> [  168.460485]  20df0493 0a860000
> [  168.460485] Call Trace:
> [  168.460485]  [<c013d81a>] ? kthread+0x3a/0x70
> [  168.460485]  [<c013d7e0>] ? kthread+0x0/0x70
> [  168.460485]  [<c0103cf3>] ? kernel_thread_helper+0x7/0x14
> [  168.460485] Code: c1 f7 e6 c1 ea 03 8d 14 92 01 d2 29 d1 8d 41 01 e8
> 23 83 ca ee 89 d8 e8 1c f7 ff ff 25 ff 03 00 00 e8 f2 c7 99 ee a1 00 5e
> 90 d1 <ff> 50 1c e8 75 fc ff ff e8 d0 a4 83 ee 85 c0 8d b6 00 00 00 00 
> [  168.460485] EIP: [<d1903163>] 0xd1903163 SS:ESP 0068:c7dcafb8
> [  168.467531] ---[ end trace 4bbd74c2c853213b ]---
> [  168.476855] BUG: unable to handle kernel NULL pointer dereference at
> 00000004
> [  168.477134] IP: [<d1903233>] 0xd1903233
> [  168.477322] *pde = 00000000 
> [  168.477485] Oops: 0002 [#4] DEBUG_PAGEALLOC
> [  168.477680] last sysfs file: /sys/block/sda/size
> [  168.477857] Modules linked in: nfsd exportfs nfs lockd nfs_acl
> auth_rpcgss sunrpc ipv6 fuse unix [last unloaded: rcutorture]
> [  168.478774] 
> [  168.478871] Pid: 4147, comm: rcu_torture_wri Tainted: G      D
> (2.6.28 #83) 
> [  168.479045] EIP: 0060:[<d1903233>] EFLAGS: 00010202 CPU: 0
> [  168.479228] EIP is at 0xd1903233
> [  168.479340] EAX: 00000000 EBX: d19073fc ECX: 00000001 EDX: 00000000
> [  168.479472] ESI: 0000000a EDI: 00000000 EBP: c7e05fd0 ESP: c7e05fc0
> [  168.479604]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [  168.479787] Process rcu_torture_wri (pid: 4147, ti=c7e05000
> task=c994e710 task.ti=c7e05000)
> [  168.479968] Stack:
> [  168.480015]  00000000 00000000 00000000 d19031f0 c7e05fe0 c013d81a
> c013d7e0 00000000
> [  168.480015]  00000000 c0103cf3 c7ca9e70 00000000 00000000 00000000
> 7574726f 725f6572
> [  168.480015] Call Trace:
> [  168.480015]  [<c013d81a>] ? kthread+0x3a/0x70
> [  168.480015]  [<c013d7e0>] ? kthread+0x0/0x70
> [  168.480015]  [<c0103cf3>] ? kernel_thread_helper+0x7/0x14
> [  168.480015] Code: 01 00 00 ba 13 00 00 00 be 0a 00 00 00 a1 00 20 83
> c0 e8 a1 21 82 ee e9 a0 00 00 00 8d 74 26 00 ff 05 6c 78 90 d1 8b 43 04
> 8b 13 <89> 42 04 89 10 b8 cc 59 90 d1 89 1b 89 5b 04 e8 19 a3 ca ee 83 
> [  168.480015] EIP: [<d1903233>] 0xd1903233 SS:ESP 0068:c7e05fc0
> [  168.486680] ---[ end trace 4bbd74c2c853213b ]---
> [  168.486798] Kernel panic - not syncing: Fatal exception in interrupt
> 9 90 d1 85 db
> 74 12 <8b> 48 28 85 c9 74 0b 8b 55 bc 85 d2 0f 84 19 01 00 00 8d b4 26 
> [  168.448022] EIP: [<d1902ebf>] 0xd1902ebf SS:ESP 0068:c7b48f84
> [  168.456684] ---[ end trace 4bbd74c2c853213b ]---
> 
> 
> Greetings, Eric
