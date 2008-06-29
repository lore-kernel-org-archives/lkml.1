Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYF2MdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYF2MdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 08:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbYF2Mc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 08:32:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:23774 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbYF2Mcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 08:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Gwn6jRMgXOYzAwSXOHpVsF/Vuxxck3NlI1LFdqJUBgNvZLspe5AYgUVXTtLo1jtQcP
         Lnhvv9LVuaVARtOAuunE5zfJND/hwJtQAiA5bxO+40cOiy6WahRnFyFe7nk6NeNcv6bj
         47WaslkKVmDpZsqlIe4BsdoY4QT45lT+LOfeo=
Message-ID: <19f34abd0806290532k1b176d97k96f7c5bb2bb9e830@mail.gmail.com>
Date: Sun, 29 Jun 2008 14:32:54 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: -tip: WARNING: at kernel/lockdep.c:2738
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <srostedt@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just got this on the latest tip/master shortly after finishing initcalls:

------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2738 check_flags+0x142/0x160()
Pid: 5, comm: watchdog/0 Not tainted 2.6.26-rc8-tip-00206-g3248a70-dirty #49
 [<c0139684>] warn_on_slowpath+0x54/0x70
 [<c015be00>] ? trace_hardirqs_off_caller+0x40/0xe0
 [<c010a7c5>] ? native_sched_clock+0xb5/0x110
 [<c018076e>] ? ftrace_record_ip+0x12e/0x240
 [<c05ab8c8>] ? _spin_unlock_irqrestore+0x48/0x80
 [<c029ffd3>] ? debug_locks_off+0x3/0x50
 [<c018076e>] ? ftrace_record_ip+0x12e/0x240
 [<c0104f6b>] ? mcount_call+0x5/0xa
 [<c015b322>] check_flags+0x142/0x160
 [<c015f6e9>] lock_acquire+0x59/0xd0
 [<c01769f1>] ? watchdog+0xb1/0x1e0
 [<c05ab2fd>] _read_lock+0x3d/0x70
 [<c01769f1>] ? watchdog+0xb1/0x1e0
 [<c01769f1>] watchdog+0xb1/0x1e0
 [<c05ab8c8>] ? _spin_unlock_irqrestore+0x48/0x80
 [<c012bae9>] ? complete+0x49/0x60
 [<c0176940>] ? watchdog+0x0/0x1e0
 [<c014e637>] kthread+0x47/0x80
 [<c014e5f0>] ? kthread+0x0/0x80
 [<c0104f53>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 8e23f95b45fa05f7 ]---
possible reason: unannotated irqs-on.
irq event stamp: 18
hardirqs last  enabled at (17): [<c015e02b>] trace_hardirqs_on+0xb/0x10
hardirqs last disabled at (18): [<c015beab>] trace_hardirqs_off+0xb/0x10
softirqs last  enabled at (0): [<c0137cd8>] copy_process+0x268/0x10b0
softirqs last disabled at (0): [<00000000>] 0x0

I hope this wasn't caused by any of my patches :-S

$ addr2line -e vmlinux -i c01769f1
kernel/softlockup.c:232
kernel/softlockup.c:271

It seems that Andrew reported this too,
http://lkml.org/lkml/2008/6/9/41, but I already have the fix,

commit 040ec23d07f95285e9777a85cda29cb339a3065b
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jun 9 01:45:29 2008 -0700

    sched: sched_clock() lockdep fix

so it can't be the same one.

(It seems to be something ftrace-related, adding Steven to Cc.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
