Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbYKEM5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbYKEM5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 07:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYKEM52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 07:57:28 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:51471 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbYKEM51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 07:57:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Xeu5YdD3OiGjQC6CfeU3ekXKYyrYRGxrHzEW2LkvxQSXofg9Hl5MiW0btQjUklaPOx
         bsFoUkqFHwtPPncmmC8E6dtfNs3LBDFoLlsNbr1b0fiOEWE+zAHLof2rLTr4zX4eLQdI
         R/xLgyQ/wlFu/y2mVrw4YT9GWZLMjWeLs5TJk=
Message-ID: <c4e36d110811050457m36346fe1m63ffbb143f684637@mail.gmail.com>
Date: Wed, 5 Nov 2008 13:57:27 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: sys_sched_yield keeps locked irq before call of schedule()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

With recent 2.6.28-rc3 kernel I've noticed that  schedule() is
sometime being called with locked IRQ

Call Trace:
 [<ffffffff81334592>] _spin_lock_irq+0x92/0xa0
 [<ffffffff8133126b>] schedule+0x13b/0x4cb
 [<ffffffff81013c10>] ? native_sched_clock+0x70/0xa0
 [<ffffffff81040930>] ? sys_sched_yield+0x0/0x80
 [<ffffffff810409a5>] sys_sched_yield+0x75/0x80
 [<ffffffff8100c6bb>] system_call_fastpath+0x16/0x1b


Which is a result of the function sys_sched_yield() that calls
schedule() while it keeps irq.

Is it correct to call the function schedule() which 'usually' expects
irq being unlocked and do some 'lenghty'
operations (i.e. debug statistics)  which do not need to keep irq
locked for such a long time?

I've no idea whether this bug or feature and for now  I'm using this
simple patch to fix this issue.

diff --git a/kernel/sched.c b/kernel/sched.c
index e8819bc..80eb633 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5546,6 +5546,7 @@ asmlinkage long sys_sched_yield(void)
        spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
        _raw_spin_unlock(&rq->lock);
        preempt_enable_no_resched();
+       local_irq_enable();

        schedule();


Zdenek
