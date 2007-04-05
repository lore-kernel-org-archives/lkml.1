Return-Path: <linux-kernel-owner+w=401wt.eu-S1767181AbXDESUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767181AbXDESUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767189AbXDESUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:20:37 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:59211 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767181AbXDESUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:20:36 -0400
Subject: 2.6.21-rc5-mm4: ia64:  scheduling while atomic - utrace?
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: roland@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 05 Apr 2007 14:20:29 -0400
Message-Id: <1175797229.5335.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Running a 'usex -e' load [http://people.redhat.com/~anderson/usex/] on
2.6.21-rc5-mm4 on ia64, I see the following:

BUG: scheduling while atomic: strace/0x40000001/20162

Call Trace:
 [<a000000100014ec0>] show_stack+0x80/0xa0
                                sp=e000076042dc7610 bsp=e000076042dc1260
 [<a000000100014f10>] dump_stack+0x30/0x60
                                sp=e000076042dc77e0 bsp=e000076042dc1248
 [<a0000001006f76e0>] schedule+0x1d00/0x22a0
                                sp=e000076042dc77e0 bsp=e000076042dc1108
 [<a000000100099750>] __cond_resched+0x50/0xa0
                                sp=e000076042dc7800 bsp=e000076042dc10e8
 [<a0000001006f8e30>] cond_resched+0xb0/0xe0
                                sp=e000076042dc7800 bsp=e000076042dc10d0
 [<a0000001001561d0>] get_user_pages+0x1b0/0x7c0
                                sp=e000076042dc7800 bsp=e000076042dc1028
 [<a0000001001568a0>] access_process_vm+0xc0/0x440
                                sp=e000076042dc7820 bsp=e000076042dc0f78
 [<a00000010002fcc0>] ia64_sync_user_rbs+0x80/0x100
                                sp=e000076042dc7830 bsp=e000076042dc0f38
 [<a00000010002fdf0>] do_gpregs_writeback+0xb0/0xe0
                                sp=e000076042dc7840 bsp=e000076042dc0f10
 [<a00000010000cad0>] unw_init_running+0x70/0xa0
                                sp=e000076042dc7850 bsp=e000076042dc0ee8
 [<a00000010002ed70>] do_regset_call+0x110/0x140
                                sp=e000076042dc7c30 bsp=e000076042dc0e88
 [<a00000010002eea0>] gpregs_writeback+0x40/0x60
                                sp=e000076042dc7e30 bsp=e000076042dc0e60
 [<a000000100123900>] ptrace_report+0xe0/0x1e0
                                sp=e000076042dc7e30 bsp=e000076042dc0e28
 [<a000000100123aa0>] ptrace_report_syscall+0xa0/0xe0
                                sp=e000076042dc7e30 bsp=e000076042dc0e00
 [<a000000100123b10>] ptrace_report_syscall_exit+0x30/0x60
                                sp=e000076042dc7e30 bsp=e000076042dc0dc8
 [<a000000100122cb0>] utrace_report_syscall+0xf0/0x540
                                sp=e000076042dc7e30 bsp=e000076042dc0d48
 [<a000000100031800>] syscall_trace_leave+0x60/0xc0
                                sp=e000076042dc7e30 bsp=e000076042dc0cf0
 [<a00000010000c1c0>] ia64_trace_syscall+0x100/0x110
                                sp=e000076042dc7e30 bsp=e000076042dc0cf0

Looks like get_ptrace_state(), called from ptrace_report_syscall calls
rcu_read_lock() which disables preemption.  Corresponding
rcu_read_unlock() will be from put_ptrace_state() from ptrace_report()
at end of report.  However, ia64 needs to sync register backing store,
and this requires access to process vm.  get_user_pages' use of
cond_sched() is tripping the "scheduling while atomic" bug.

May be related to:

	http://marc.info/?a=102883379600003&r=1&w=4


Lee

