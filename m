Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYH0Gfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYH0Gfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbYH0GfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:35:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:21315 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbYH0GfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:35:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,276,1217833200"; 
   d="scan'208";a="432541200"
Date: Wed, 27 Aug 2008 14:33:00 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lockdep: fix invalid list_del_rcu in zap_class
Message-ID: <20080827063300.GA18265@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The problem is found during iwlagn driver testing on
v2.6.27-rc4-176-gb8e6c91 kernel, but it turns out to be a lockdep bug.
In our testing, we frequently load and unload the iwlagn driver
(>50 times). Then the MAX_STACK_TRACE_ENTRIES is reached (expected
behaviour?). The error message with the call trace is as below.

BUG: MAX_STACK_TRACE_ENTRIES too low!
turning off the locking correctness validator.
Pid: 4895, comm: iwlagn Not tainted 2.6.27-rc4 #13

Call Trace:
 [<ffffffff81014aa1>] save_stack_trace+0x22/0x3e
 [<ffffffff8105390a>] save_trace+0x8b/0x91
 [<ffffffff81054e60>] mark_lock+0x1b0/0x8fa
 [<ffffffff81056f71>] __lock_acquire+0x5b9/0x716
 [<ffffffffa00d818a>] ieee80211_sta_work+0x0/0x6ea [mac80211]
 [<ffffffff81057120>] lock_acquire+0x52/0x6b
 [<ffffffff81045f0e>] run_workqueue+0x97/0x1ed
 [<ffffffff81045f5e>] run_workqueue+0xe7/0x1ed
 [<ffffffff81045f0e>] run_workqueue+0x97/0x1ed
 [<ffffffff81046ae4>] worker_thread+0xd8/0xe3
 [<ffffffff81049503>] autoremove_wake_function+0x0/0x2e
 [<ffffffff81046a0c>] worker_thread+0x0/0xe3
 [<ffffffff810493ec>] kthread+0x47/0x73
 [<ffffffff8128e3ab>] trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100cea9>] child_rip+0xa/0x11
 [<ffffffff8100c4df>] restore_args+0x0/0x30
 [<ffffffff810316e1>] finish_task_switch+0x0/0xcc
 [<ffffffff810493a5>] kthread+0x0/0x73
 [<ffffffff8100ce9f>] child_rip+0x0/0x11


Although the above is harmless, when the ilwagn module is removed
later lockdep will trigger a kernel oops as below.


BUG: unable to handle kernel NULL pointer dereference at
0000000000000008
IP: [<ffffffff810531e1>] zap_class+0x24/0x82
PGD 73128067 PUD 7448c067 PMD 0
Oops: 0002 [1] SMP
CPU 0
Modules linked in: rfcomm l2cap bluetooth autofs4 sunrpc
nf_conntrack_ipv6 xt_state nf_conntrack xt_tcpudp ip6t_ipv6header
ip6t_REJECT ip6table_filter ip6_tables x_tables ipv6 cpufreq_ondemand
acpi_cpufreq dm_mirror dm_log dm_multipath dm_mod snd_hda_intel sr_mod
snd_seq_dummy snd_seq_oss snd_seq_midi_event battery snd_seq
snd_seq_device cdrom button snd_pcm_oss snd_mixer_oss snd_pcm
snd_timer snd_page_alloc e1000e snd_hwdep sg iTCO_wdt
iTCO_vendor_support ac pcspkr i2c_i801 i2c_core snd soundcore video
output ata_piix ata_generic libata sd_mod scsi_mod ext3 jbd mbcache
uhci_hcd ohci_hcd ehci_hcd [last unloaded: mac80211]
Pid: 4941, comm: modprobe Not tainted 2.6.27-rc4 #10
RIP: 0010:[<ffffffff810531e1>]  [<ffffffff810531e1>]
zap_class+0x24/0x82
RSP: 0000:ffff88007bcb3eb0  EFLAGS: 00010046
RAX: 0000000000068ee8 RBX: ffffffff8192a0a0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000001dfb RDI: ffffffff816e70b0
RBP: ffffffffa00cd000 R08: ffffffff816818f8 R09: ffff88007c923558
R10: ffffe20002ad2408 R11: ffffffff811028ec R12: ffffffff8192a0a0
R13: 000000000002bd90 R14: 0000000000000000 R15: 0000000000000296
FS:  00007f9d1cee56f0(0000) GS:ffffffff814a58c0(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 0000000073047000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 4941, threadinfo ffff88007bcb2000, task
ffff8800758d1fc0)
Stack:  ffffffff81057376 0000000000000000 ffffffffa00f7b00
0000000000000000
 0000000000000080 0000000000618278 00007fff24f16720 0000000000000000
 ffffffff8105d37a ffffffffa00f7b00 ffffffff8105d591 313132303863616d
Call Trace:
 [<ffffffff81057376>] ? lockdep_free_key_range+0x61/0xf5
 [<ffffffff8105d37a>] ? free_module+0xd4/0xe4
 [<ffffffff8105d591>] ? sys_delete_module+0x1de/0x1f9
 [<ffffffff8106dbfa>] ? audit_syscall_entry+0x12d/0x160
 [<ffffffff8100be2b>] ? system_call_fastpath+0x16/0x1b


Code: b2 00 01 00 00 00 c3 31 f6 49 c7 c0 10 8a 61 81 eb 32 49 39 38
75 26 48 98 48 6b c0 38 48 8b 90 08 8a 61 81 48 8b 88 00 8a 61 81 <48>
89 51 08 48 89 0a 48 c7 80 08 8a 61 81 00 02 20 00 48 ff c6
RIP  [<ffffffff810531e1>] zap_class+0x24/0x82
 RSP <ffff88007bcb3eb0>
CR2: 0000000000000008
---[ end trace a1297e0c4abb0f2e ]---


The root cause for this oops is in add_lock_to_list() when
save_trace() fails due to MAX_STACK_TRACE_ENTRIES is reached,
entry->class is assigned but entry is never added into any lock list.
This makes the list_del_rcu() in zap_class() oops later when the
module is unloaded. This patch fixes the problem by assigning
entry->class after save_trace() returns success.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3bfb187..5593c56 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -875,11 +875,11 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 	if (!entry)
 		return 0;
 
-	entry->class = this;
-	entry->distance = distance;
 	if (!save_trace(&entry->trace))
 		return 0;
 
+	entry->class = this;
+	entry->distance = distance;
 	/*
 	 * Since we never remove from the dependency list, the list can
 	 * be walked lockless by other CPUs, it's only allocation
