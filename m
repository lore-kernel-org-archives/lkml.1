Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbYHaPnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbYHaPnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 11:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYHaPnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 11:43:23 -0400
Received: from il.qumranet.com ([212.179.150.194]:39525 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbYHaPnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 11:43:22 -0400
Message-ID: <48BABC19.1060509@qumranet.com>
Date: Sun, 31 Aug 2008 18:43:21 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [REGRESSION] High, likely incorrect process cpu usage counters with
 kvm and 2.6.2[67]
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running an idle Windows VM on Linux 2.6.26+ with kvm, one sees high 
values for the kvm process in top (30%-70% cpu), where one would 
normally expect 0%-1%.  Surprisingly, the per-cpu system counters show 
almost 100% idle, leading me to believe this is an accounting error and 
that the process does not actually consume this much cpu.

I bisected this to a scheduler change, namely

commit 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Sat May 3 18:29:28 2008 +0200

    sched: add optional support for CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
   
    this replaces the rq->clock stuff (and possibly cpu_clock()).
   
     - architectures that have an 'imperfect' hardware clock can set
       CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
   
     - the 'jiffie' window might be superfulous when we update tick_gtod
       before the __update_sched_clock() call in sched_clock_tick()
   
     - cpu_clock() might be implemented as:
   
         sched_clock_cpu(smp_processor_id())
   
       if the accuracy proves good enough - how far can TSC drift in a
       single jiffie when considering the filtering and idle hooks?
   
    [ mingo@elte.hu: various fixes and cleanups ]
   
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Which is a bit too complex for me to work out.

Further information:
- the kvm thread which has the incorrect counter is the one that 
actually executes guest code
- this thread mostly sleeps in schedule(), as one would expect
- it is periodically woken up by a timer; perhaps the problem is that 
the process is sampled using the same timer, so it always shows as 
running (though I'd expect it to report 100% cpu in that case).

Any help will be appreciated (or provided).

-- 
error compiling committee.c: too many arguments to function

