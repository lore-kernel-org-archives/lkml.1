Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYFBXrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYFBXrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYFBXrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:47:33 -0400
Received: from hs-out-0708.google.com ([64.233.178.244]:4230 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbYFBXrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=asX9Pmw9jIex7IHJyJ+oEPgm+K0BsomtxJDL+ZjkBnfX8EqPoWfBWwnvETZiJlICMsn1R8diL4LfXPDSuSDxEt2RTrdoO8oEJsG4XANG+sSwZqY91Ul/ZaPKNxzRx7yAqKhSqiIXDH2yCEK7eF1mpFJW2CMyPEpp9sm5IIzXlCc=
Message-ID: <4844868F.20104@gmail.com>
Date: Mon, 02 Jun 2008 20:47:27 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: WARNING: at kernel/lockdep.c:2680 check_flags+0x98/0x151()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In next-20080530 and next-20080602 (and possibly earlier - I can't 
remember the linux-next tree before that I tried) I get the following:

[   12.885153] ------------[ cut here ]------------
[   12.885203] WARNING: at kernel/lockdep.c:2680 check_flags+0x98/0x151()
[   12.885248] Pid: 4, comm: watchdog/0 Not tainted 
2.6.26-rc4-next-20080602 #13
[   12.885292]
[   12.885293] Call Trace:
[   12.885364]  [<ffffffff8022bbd5>] warn_on_slowpath+0x58/0x8a
[   12.885410]  [<ffffffff804c9cfe>] ? _spin_unlock_irqrestore+0x51/0x6d
[   12.885455]  [<ffffffff8032ff41>] ? debug_locks_off+0x9/0x3c
[   12.885498]  [<ffffffff802582dd>] ? ftrace_record_ip+0x1fa/0x272
[   12.885542]  [<ffffffff8025278a>] ? watchdog+0xc5/0x1ff
[   12.885584]  [<ffffffff8020b2c0>] ? mcount_call+0x5/0x35
[   12.885627]  [<ffffffff8025278a>] ? watchdog+0xc5/0x1ff
[   12.885668]  [<ffffffff80247c80>] check_flags+0x98/0x151
[   12.885710]  [<ffffffff8024ae72>] lock_acquire+0x4a/0xa9
[   12.885753]  [<ffffffff8025278a>] ? watchdog+0xc5/0x1ff
[   12.885795]  [<ffffffff802526c5>] ? watchdog+0x0/0x1ff
[   12.885837]  [<ffffffff804c98da>] _read_lock+0x37/0x43
[   12.885879]  [<ffffffff8025278a>] watchdog+0xc5/0x1ff
[   12.885921]  [<ffffffff802526c5>] ? watchdog+0x0/0x1ff
[   12.885963]  [<ffffffff8023e48b>] kthread+0x4e/0x7b
[   12.886005]  [<ffffffff8020bf18>] child_rip+0xa/0x12
[   12.886046]  [<ffffffff80227d8f>] ? finish_task_switch+0x57/0x92
[   12.886090]  [<ffffffff804c9d55>] ? _spin_unlock_irq+0x3b/0x57
[   12.886133]  [<ffffffff8020bad3>] ? restore_args+0x0/0x30
[   12.886137]  [<ffffffff8023e43d>] ? kthread+0x0/0x7b
[   12.886137]  [<ffffffff8020bf0e>] ? child_rip+0x0/0x12
[   12.886137]
[   12.886137] ---[ end trace 60e7f098a6913839 ]---
[   12.886137] possible reason: unannotated irqs-on.
[   12.886137] irq event stamp: 20
[   12.886137] hardirqs last  enabled at (19): [<ffffffff80249cc3>] 
trace_hardirqs_on+0xd/0xf
[   12.886137] hardirqs last disabled at (20): [<ffffffff80248565>] 
trace_hardirqs_off+0xd/0xf
[   12.886137] softirqs last  enabled at (0): [<ffffffff80229fef>] 
copy_process+0x2da/0x109e
[   12.886137] softirqs last disabled at (0): [<0000000000000000>] 0x0

Do I understand this correctly that something enabled irqs in a way that 
got around lockdep?  I assume the problem is not in watchdog, just that 
the watchdog was the next thing to run that interacted with irqs and 
thus lockdep picked up the situation then?

Is there additional debugging I can do, given some instructions?  If the 
cause is readily apparent to anyone, could they let me know (for my own 
interest) why it is apparent so that I can investigate things like this 
further next time?

This is completely reproducible on every boot - should I try to bisect it?

-- 
Kevin Winchester


