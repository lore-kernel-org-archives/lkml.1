Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYHSWKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYHSWKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYHSWKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:10:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:46290 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYHSWKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:10:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=PIVyvcd7Wo3y0nlbU9o1plRpbPNuQQU4bvRqdL0WtSqY5zHg7wO/aYhWsyJdjy755P
         QcMU31hsS3TFTVN2Mz3Rj7+Leu1qTmZMTiCHhytdJ08C5UbLJd78SmfYzpTV/dseqatH
         wZSyECwHPegtl3TnrrQRcaMyYtFZk2vURRDG8=
Subject: [0/2 -tip] microcode: bug-fix + updates
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Oruba <peter.oruba@amd.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 00:10:14 +0200
Message-Id: <1219183814.10426.28.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Peter Z., you may jump immediately to [*] :-) ]


[1/2] [-tip, BUG-fix] microcode: fix unbalanced use of get_cpu()

check a boot-up CPU (#0) in microcode_{intel,amd}_module_init().


[2/2] [-tip] microcode: refactoring

This is the 1st patch is series. Here the aim was to avoid any significant changes,
logically-wise.

So it's mainly about generic interface refactoring: e.g. make microcode_{intel,amd}.c
more about arch-specific details and less about policies like make-sure-we-run-on-a-target-cpu
(no more set_cpus_allowed_ptr() here) and generic synchronization (no more microcode_mutex here).

All in all, more line have been deleted than added.

4 files changed, 145 insertions(+), 198 deletions(-)


Note, I've only done some basic testing. Someone with ucode firmware files is very welcome to give this code a try.



[*] btw., with DEBUG being enabled, pr_debug() generates [1] when 
debug_smp_processor_id() is used (CONFIG_DEBUG_PREEMPT).

the problem seems to be caused by the following commit:
commit b845b517b5e3706a3729f6ea83b88ab85f0725b0
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Aug 8 21:47:09 2008 +0200

    printk: robustify printk


wake_up_klogd() -> __get_cpu_var() -> smp_processor_id()

and that's being called from release_console_sem() which is, in turn, said to be "may be called from any context" [2]

and in this case, it seems to be called from some non-preemptible context (although, it can't be printk()...
although, I haven't looked carefully yet).

Provided [2], __get_cpu_var() is perhaps not the right solution there.


[1]

[ 7697.942005] BUG: using smp_processor_id() in preemptible [00000000] code: syslogd/3542
[ 7697.942005] caller is wake_up_klogd+0x1b/0x50
[ 7697.942005] Pid: 3542, comm: syslogd Not tainted 2.6.27-rc3-tip-git #2
[ 7697.942005] Call Trace:
[ 7697.942005]  [<ffffffff8036b398>] debug_smp_processor_id+0xe8/0xf0
[ 7697.942005]  [<ffffffff80239d3b>] wake_up_klogd+0x1b/0x50
[ 7697.942005]  [<ffffffff8023a047>] release_console_sem+0x1e7/0x200
[ 7697.942005]  [<ffffffff803c0f17>] do_con_write+0xb7/0x1f30
[ 7697.942005]  [<ffffffff8020d920>] ? show_trace+0x10/0x20
[ 7697.942005]  [<ffffffff8020dc42>] ? dump_stack+0x72/0x80
[ 7697.942005]  [<ffffffff8036392d>] ? __ratelimit+0xbd/0xe0
[ 7697.942005]  [<ffffffff8036b398>] ? debug_smp_processor_id+0xe8/0xf0
[ 7697.942005]  [<ffffffff80239d3b>] ? wake_up_klogd+0x1b/0x50
[ 7697.942005]  [<ffffffff8023a047>] ? release_console_sem+0x1e7/0x200
[ 7697.942005]  [<ffffffff803c2de9>] con_write+0x19/0x30
[ 7697.942005]  [<ffffffff803b37b6>] write_chan+0x276/0x3c0
[ 7697.942005]  [<ffffffff80232b20>] ? default_wake_function+0x0/0x10
[ 7697.942005]  [<ffffffff804cb872>] ? _spin_lock_irqsave+0x22/0x50
[ 7697.942005]  [<ffffffff803b1334>] tty_write+0x194/0x260
[ 7697.942005]  [<ffffffff803b3540>] ? write_chan+0x0/0x3c0
[ 7697.942005]  [<ffffffff803b14a4>] redirected_tty_write+0xa4/0xb0
[ 7697.942005]  [<ffffffff803b1400>] ? redirected_tty_write+0x0/0xb0
[ 7697.942005]  [<ffffffff802a88c2>] do_loop_readv_writev+0x52/0x80
[ 7697.942005]  [<ffffffff802a939d>] do_readv_writev+0x1bd/0x1d0
[ 7697.942005]  [<ffffffff802a93e9>] vfs_writev+0x39/0x60
[ 7697.942005]  [<ffffffff802a9870>] sys_writev+0x50/0x90
[ 7697.942005]  [<ffffffff8020bb3b>] system_call_fastpath+0x16/0x1b


--Dmitry


