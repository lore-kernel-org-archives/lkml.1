Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYAWOtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYAWOtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYAWOtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:49:06 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:17666 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYAWOtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:49:04 -0500
Date: Wed, 23 Jan 2008 17:48:38 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: roland@redhat.com
Cc: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Bunch of utrace crashes
Message-ID: <20080123144837.GB6044@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Roland.

utrace patch against 2.6.24-rc8 kernel reasonably quickly oopses in the
following way:

BUG: unable to handle kernel paging request at virtual address f54ffa34
printing eip: c10492cc *pdpt = 0000000000003001 *pde = 0000000001747067 *pte = 00000000354ff000 
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in: af_packet nf_conntrack_netbios_ns nf_conntrack_ipv4 xt_state nf_conntrack ipt_REJECT iptable_filter ip_tables xt_tcpudp ip6t_REJECT ip6table_filter ip6_tables x_tables cpufreq_ondemand loop sr_mod k8temp cdrom hwmon
Pid: 23705, comm: expl_ptratt Not tainted (2.6.24-rc8-utrace #4)
EIP: 0060:[<c10492cc>] EFLAGS: 00210282 CPU: 0
EIP is at get_utrace_lock_attached+0x3c/0xb0
EAX: f5ea5590 EBX: f6836c88 ECX: f5ea5590 EDX: 00000002
ESI: f54ff590 EDI: f54ff590 EBP: f5e41830 ESP: f73cde10
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process expl_ptratt (pid: 23705, ti=f73cd000 task=f5ea5590 task.ti=f73cd000)
Stack: 00000002 00000001 c1049290 f6836c88 f5e41830 f54ff590 f5ea5fc0 c104a41b 
       f6836c88 f5ea5590 f5ea5fc0 f5ea5fc0 c104d7c2 00000002 00000001 c104d762 
       00000000 00000000 f6836ca0 f60ace58 00000009 f5ea5590 f73cdf10 c102107a 
Call Trace:
 [<c1049290>] get_utrace_lock_attached+0x0/0xb0
 [<c104a41b>] utrace_detach+0x1b/0xc0
 [<c104d7c2>] ptrace_exit+0xb2/0x1b0
 [<c104d762>] ptrace_exit+0x52/0x1b0
 [<c102107a>] do_exit+0x8a/0x760
 [<c1208100>] _spin_unlock_irq+0x20/0x30
 [<c1021776>] do_group_exit+0x26/0x70
 [<c1028c80>] get_signal_to_deliver+0x1f0/0x3e0
 [<c1001ff3>] do_notify_resume+0x93/0x760
 [<c1208100>] _spin_unlock_irq+0x20/0x30
 [<c101a10c>] finish_task_switch+0x5c/0xc0
 [<c101a0b0>] finish_task_switch+0x0/0xc0
 [<c1205a19>] schedule+0x1f9/0x680
 [<c1208102>] _spin_unlock_irq+0x22/0x30
 [<c104df36>] sys_ptrace+0x676/0x750
 [<c1002c24>] work_notifysig+0x13/0x1b
 [<c118b1d8>] __kfree_skb+0x8/0x80
 =======================
Code: b8 00 6d 2c c1 31 d2 89 5c 24 0c 89 7c 24 14 c7 44 24 08 90 92 04 c1 c7 44 24 04 01 00 00 00 c7 04 24 02 00 00 00 e8 14 51 ff ff <8b> 9e a4 04 00 00 85 db 74 51 83 be 88 00 00 00 20 74 48 8d 7b 
EIP: [<c10492cc>] get_utrace_lock_attached+0x3c/0xb0 SS:ESP 0068:f73cde10

What happens is dangling tsk passed into get_utrace_lock_attached() --
"8b 9e a4 04 00 00" is "mov 0x4a4(%esi),%ebx" which corresponds to
->utrace offset inside task_struct here. Sorry, haven't looked further.


Another bug which I _think_, can be triggered is "BUG_ON(tsk->utrace == utrace);"
in check_dead_utrace -- it can happen if utrace_clear_tsk() skipped
clearing ->utrace pointer in otherwise normal detaching sequence. This
can happen, due to utrace->u.live.signal being valid pointer at that time.
Now this can happen when execution of resumed task starts:

	do_notify_resume
	get_signal_to_deliver
	tracehook_get_signal
	utrace_get_signal
	[utrace pointer found, utrace->lock taken]
	utrace_quiescent
	[signal is valid here, put onto live struct utrace without
	 locking]

So, ->utrace clearance skipped
	wake_quiescent
	check_dead_utrace
	BUG_ON(tsk->utrace == utrace);

I can't reproduce this on -rc8 at will, but I don't see anything that
prevents above race as well. Probably window for #1 far wider :-(

