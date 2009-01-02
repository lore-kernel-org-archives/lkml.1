Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbZABLSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbZABLSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 06:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757049AbZABLSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 06:18:25 -0500
Received: from mail.gmx.net ([213.165.64.20]:35984 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756885AbZABLSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 06:18:24 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1+dMpB3C42dnrIBcsPdEFPRGNgP516SPfGJpbIQ8b
	doSyJer5s2PNDA
Date: Fri, 2 Jan 2009 12:18:19 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: josh@freedesktop.org, dipankar@in.ibm.com
Subject: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090102111819.GC6088@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 12:14:54 up  1:26,  6 users,  load average: 0.09, 0.29, 0.29
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

modprobing rcutorture and removing it again gives me the following oops:

[  122.873859] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
[  162.987060] BUG: unable to handle kernel NULL pointer dereference at 00000000
[  162.987194] IP: [<00000000>] 0x0
[  162.987268] *pde = 00000000 
[  162.987339] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  162.987499] last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/resource
[  162.987534] Modules linked in: [last unloaded: rcutorture]
[  162.987667] 
[  162.987699] Pid: 5091, comm: udevd Tainted: G        W  (2.6.28-04980-gb58602a-dirty #154) System Name
[  162.987732] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[  162.987761] EIP is at 0x0
[  162.987849] EAX: d0afcbf0 EBX: 00000000 ECX: c0160f5a EDX: 00000006
[  162.987880] ESI: d0afcbf0 EDI: 0000001c EBP: c0b01fe0 ESP: c0b01fd4
[  162.987910]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  162.987941] Process udevd (pid: 5091, ti=c0b01000 task=c8cc4100 task.ti=c8d20000)
[  162.988027] Stack:
[  162.988027]  c0160f61 00000200 00000001 c0b01ff8 c012a723 0000000a c8d20e4c 00000046
[  162.988027]  c012a6b4 c8d20e5c c01042ce
[  162.988027] Call Trace:
[  162.988027]  [<c0160f61>] ? rcu_process_callbacks+0x65/0x79
[  162.988027]  [<c012a723>] ? __do_softirq+0x6f/0xf6
[  162.988027]  [<c012a6b4>] ? __do_softirq+0x0/0xf6
[  162.988027]  <IRQ> <0> [<c012a631>] ? irq_exit+0x40/0x7c
[  162.988027]  [<c0110b91>] ? smp_apic_timer_interrupt+0x68/0x73
[  162.988027]  [<c0103521>] ? apic_timer_interrupt+0x2d/0x34
[  162.988027]  [<c017af71>] ? unmap_vmas+0x308/0x47f
[  162.988027]  [<c017afa2>] ? unmap_vmas+0x339/0x47f
[  162.988027]  [<c0143db5>] ? trace_hardirqs_on_caller+0x17/0x15a
[  162.988027]  [<c017e326>] ? exit_mmap+0x83/0x104
[  162.988027]  [<c01244b8>] ? mmput+0x39/0x89
[  162.988027]  [<c01278de>] ? exit_mm+0xc3/0xcb
[  162.988027]  [<c0128b99>] ? do_exit+0x199/0x6d5
[  162.988027]  [<c04e56b0>] ? trace_hardirqs_on_thunk+0xc/0x10
[  162.988027]  [<c0129137>] ? do_group_exit+0x62/0x88
[  162.988027]  [<c0129171>] ? sys_exit_group+0x14/0x16
[  162.988027]  [<c0102ea1>] ? sysenter_do_call+0x12/0x31
[  162.988027] Code:  Bad EIP value.
[  162.988027] EIP: [<00000000>] 0x0 SS:ESP 0068:c0b01fd4
[  162.990524] ---[ end trace 4eaa2a86a8e2da22 ]---
[  162.990555] Kernel panic - not syncing: Fatal exception in interrupt


Kernel is current -git with a unrelated
networking patch (http://marc.info/?l=linux-netdev&m=123088641023335&w=2)

root@whiterabbit:/usr/src/linux# grep RCU .config
# CONFIG_CLASSIC_RCU is not set
# CONFIG_TREE_RCU is not set
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_TRACE=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_PREEMPT_RCU_TRACE=y
CONFIG_RCU_TORTURE_TEST=m

Greetings, Eric
