Return-Path: <linux-kernel-owner+w=401wt.eu-S1030470AbXC2RAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030470AbXC2RAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030459AbXC2RAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:00:15 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:21669 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030472AbXC2RAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:00:12 -0400
Date: Thu, 29 Mar 2007 21:07:31 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: roland@redhat.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: utrace, RCU and ia64
Message-ID: <20070329170731.GA6808@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Roland, Andrew.

Something really sick is going on with combination of utrace, RCU and ia64.

Below are quickly reproducable oops happenning on 8-way SMP,
my lame-o attempts to decode it, and test program itself.

I checked 2.6.21-rc5 which was OK,
2.6.21-rc5 + linux-2.6.21-current-utrace.patch which was bad, and
2.6.21-rc5-mm1 which was also bad.

------------------------------------------------------------
Unable to handle kernel paging request at virtual address 6b6b6b6b6b6b6b6b
expl_ptratt[4391]: Oops 11012296146944 [1]
Modules linked in: autofs4 hidp rfcomm l2cap bluetooth sunrpc 8021q bridge ipv6 xt_length ipt_ttl xt_tcpmss iptable_mangle iptable_filter xt_multiport xt_limit ipt_tos ipt_REJECT ip_tables x_tables vfat fat button parport_pc lp parport sg e100 e1000 mii shpchp ide_cd cdrom dm_snapshot dm_zero dm_mirror dm_mod mptsas mptscsih mptbase scsi_transport_sas sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
Pid: 4391, CPU 4, comm:          expl_ptratt
psr : 0000121008026018 ifs : 8000000000000389 ip  : [<a000000100094881>]    Not tainted
ip is at __rcu_process_callbacks+0x3e1/0x660
unat: 0000000000000000 pfs : 0000000000000389 rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 0000000000555965
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001000948a0 b6  : a0000001000d9ee0 b7  : a000000100010080
f6  : 1003e6b6b6b6b6b6b6b6b f7  : 1003e0000000003333334
f8  : 1003e0000000000001680 f9  : 1003e0000000000001680
f10 : 1003e0000000000000048 f11 : 1003e0000000000000050
r1  : a000000100d130a0 r2  : 0000000000000003 r3  : 0000000000000001
r8  : e000000468054028 r9  : e000000468054000 r10 : 0000000000000004
r11 : a00000010095a880 r12 : e000000467bcfc30 r13 : e000000467bc8000
r14 : e0000004681452e8 r15 : e000000107f77940 r16 : e000000107f77978
r17 : 0000000000000002 r18 : 000000000000000a r19 : e000000467bc8c34
r20 : 0000000000000020 r21 : e000000108bb2cac r22 : e000000108a8cdc8
r23 : 0000000000000002 r24 : e0000001000065d8 r25 : 6b6b6b6b6b6b6b6b
r26 : e000000108bb2cc0 r27 : 0000000000000002 r28 : 0000000000000002
r29 : 0000000000004000 r30 : 0000000000004000 r31 : 0000000000000011
Call Trace:
 [<a000000100012380>] show_stack+0x40/0xa0
                                sp=e000000467bcf7c0 bsp=e000000467bc9040
 [<a000000100012c80>] show_regs+0x840/0x880
                                sp=e000000467bcf990 bsp=e000000467bc8fe0
 [<a000000100034d80>] die+0x1c0/0x2a0
                                sp=e000000467bcf990 bsp=e000000467bc8f98
 [<a0000001005db5b0>] ia64_do_page_fault+0x8d0/0xa00
                                sp=e000000467bcf9b0 bsp=e000000467bc8f48
 [<a00000010000b300>] ia64_leave_kernel+0x0/0x280
                                sp=e000000467bcfa60 bsp=e000000467bc8f48
 [<a000000100094880>] __rcu_process_callbacks+0x3e0/0x660
                                sp=e000000467bcfc30 bsp=e000000467bc8f00
 [<a000000100094b40>] rcu_process_callbacks+0x40/0xa0
                                sp=e000000467bcfc30 bsp=e000000467bc8ee0
 [<a000000100078fd0>] tasklet_action+0x1d0/0x340
                                sp=e000000467bcfc30 bsp=e000000467bc8eb8
 [<a0000001000785b0>] __do_softirq+0xf0/0x240
                                sp=e000000467bcfc30 bsp=e000000467bc8e40
 [<a000000100078770>] do_softirq+0x70/0xc0
                                sp=e000000467bcfc30 bsp=e000000467bc8dd8
 [<a0000001000789c0>] irq_exit+0x80/0xa0
                                sp=e000000467bcfc30 bsp=e000000467bc8dc0
 [<a000000100010030>] ia64_handle_irq+0x250/0x280
                                sp=e000000467bcfc30 bsp=e000000467bc8d90
 [<a00000010000b300>] ia64_leave_kernel+0x0/0x280
                                sp=e000000467bcfc30 bsp=e000000467bc8d90
 [<a0000001005d6940>] _spin_unlock_irqrestore+0x40/0x80
                                sp=e000000467bcfe00 bsp=e000000467bc8d60
 [<a000000100064cf0>] wait_task_inactive+0x90/0x120
                                sp=e000000467bcfe00 bsp=e000000467bc8d38
 [<a0000001000e1a70>] sys_ptrace+0x890/0x1180
                                sp=e000000467bcfe10 bsp=e000000467bc8cb0
 [<a00000010000b0b0>] ia64_trace_syscall+0xd0/0x110
                                sp=e000000467bcfe30 bsp=e000000467bc8cb0
 [<a000000000010620>] __start_ivt_text+0xffffffff00010620/0x400
                                sp=e000000467bd0000 bsp=e000000467bc8cb0
Kernel panic - not syncing: Aiee, killing interrupt handler!
-------------------------------------------------------------
a0000001000944a0 <__rcu_process_callbacks>:
		...
a000000100094830:	nop.m 0x0
a000000100094836:	cmp.eq p8,p9=0,r39;;		# while (list)
a00000010009483c:	nop.i 0x0

a000000100094840: (p09) mov r35=1
a000000100094846:	nop.m 0x0
a00000010009484c: (p09) br.cond.dptk.few a0000001000948e0 <__rcu_process_callbacks+0x440>

a000000100094850:	nop.m 0x0
a000000100094856:	nop.i 0x0
a00000010009485c:	br.few a000000100094ae0 <__rcu_process_callbacks+0x640>

a000000100094860:	nop.m 0x0
a000000100094866:	ld8 r34=[r14],8		# r34 = next = list->next
						# r14 = &list->func
a00000010009486c:	nop.i 0x0;;

a000000100094870:	lfetch [r34]		# prefetch(next)
a000000100094876:	nop.m 0x0
a00000010009487c:	nop.i 0x0;;

a000000100094880:	ld8 r25=[r14];;		# r25 = list->func
a000000100094886: ===>	ld8 r26=[r25],8		# something with something called .opd (?)
						# I couldn't understand
a00000010009488c:	nop.i 0x0;;

a000000100094890:	ld8 r1=[r25]
a000000100094896:	mov b6=r26
a00000010009489c:	br.call.sptk.many b0=b6;;	# list->func()



Looks like place corresponds to function call in rcu_do_batch()

	list = rdp->donelist;
	while (list) {
		next = list->next;
		prefetch(next);
		list->func(list);
		list = next;
			...

-------------------------------------------------------------
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/ptrace.h>
#include <signal.h>

static void *thread_func(void *arg)
{
	execl("/proc/self/exe", NULL);
	return NULL;
}

int main(int argc, const char *argv[])
{
	pthread_t thread;
	int pid, n;

	if (argv[0] && (pid = fork()))
		for (n = 1;; ++n) {
			ptrace(PTRACE_ATTACH, pid, NULL, 0);
			ptrace(PTRACE_DETACH, pid, NULL, 0);
			if (!(n % 100000))
				printf("passed: %d\n", n);
		}

	if (pthread_create(&thread, NULL, thread_func, NULL))
		perror("pthread_create");

	while (1)
		pause();
	return 1;
}

