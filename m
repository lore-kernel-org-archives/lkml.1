Return-Path: <linux-kernel-owner+w=401wt.eu-S1762685AbYDVKF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762685AbYDVKF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 06:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbYDVKFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 06:05:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36608
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758558AbYDVKFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 06:05:17 -0400
Date: Tue, 22 Apr 2008 03:05:19 -0700 (PDT)
Message-Id: <20080422.030519.259068348.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: Soft lockup regression from today's sched.git merge.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080422091456.GC9939@elte.hu>
References: <20080422.015931.70144614.davem@davemloft.net>
	<20080422091456.GC9939@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 22 Apr 2008 11:14:56 +0200

> so i only have the untested patch below for now - does it fix the bug 
> for you?
 ...
> Index: linux/kernel/time/tick-sched.c
> ===================================================================
> --- linux.orig/kernel/time/tick-sched.c
> +++ linux/kernel/time/tick-sched.c
> @@ -393,6 +393,7 @@ void tick_nohz_restart_sched_tick(void)
>  		sub_preempt_count(HARDIRQ_OFFSET);
>  	}
>  
> +	touch_softlockup_watchdog();
>  	/*
>  	 * Cancel the scheduled timer and restore the tick
>  	 */

The NOHZ lockup warnings are gone.  But this seems like
a band-aid.  We made sure that cpus don't get into this
state via commit:

----------------------------------------
commit d3938204468dccae16be0099a2abf53db4ed0505
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Nov 28 15:52:56 2007 +0100

    softlockup: fix false positives on CONFIG_NOHZ
    
    David Miller reported soft lockup false-positives that trigger
    on NOHZ due to CPUs idling for more than 10 seconds.
    
    The solution is touch the softlockup watchdog when we return from
    idle. (by definition we are not 'locked up' when we were idle)
    
     http://bugzilla.kernel.org/show_bug.cgi?id=9409
    
    Reported-by: David Miller <davem@davemloft.net>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 27a2338..cb89fa8 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -133,6 +133,8 @@ void tick_nohz_update_jiffies(void)
 	if (!ts->tick_stopped)
 		return;
 
+	touch_softlockup_watchdog();
+
 	cpu_clear(cpu, nohz_cpu_mask);
 	now = ktime_get();
----------------------------------------

While what the guilty patch we're discussing here does is change how
cpu_clock() is computed, that's it.  softlockup uses cpu_clock() to
calculate it's timestamp.  The guilty change modified nothing about
when touch_softlockup_watchdog() is called, nor any other aspect about
how the softlockup mechanism itself works.

So we need to figure out why in the world changing how cpu_clock()
gets calculated makes a difference.

Anyways, this is with HZ=1000 FWIW.  And I really don't feel this is a
128-cpu moster system thing, I bet my 2-cpu workstation triggers this
too, and I'll make sure of that for you..

BTW, I'm also getting cpu's wedged in the group aggregate code:

[  121.338742] TSTATE: 0000009980001602 TPC: 000000000054ea20 TNPC: 0000000000456828 Y: 00000000    Not tainted
[  121.338778] TPC: <__first_cpu+0x4/0x28>
[  121.338791] g0: 0000000000000000 g1: 0000000000000002 g2: 0000000000000000 g3: 0000000000000002
[  121.338809] g4: fffff803fe9b24c0 g5: fffff8001587c000 g6: fffff803fe9d0000 g7: 00000000007b7260
[  121.338827] o0: 0000000000000002 o1: 00000000007b7258 o2: 0000000000000000 o3: 00000000007b7800
[  121.338845] o4: 0000000000845000 o5: 0000000000000400 sp: fffff803fe9d2ed1 ret_pc: 0000000000456820
[  121.338879] RPC: <aggregate_group_shares+0x10c/0x16c>
[  121.338893] l0: 0000000000000400 l1: 000000000000000d l2: 00000000000003ff l3: 0000000000000000
[  121.338911] l4: 0000000000000000 l5: 0000000000000000 l6: fffff803fe9d0000 l7: 0000000080009002
[  121.338928] i0: 0000000000801c20 i1: fffff800161ca508 i2: 00000000000001d8 i3: 0000000000000001
[  121.338946] i4: fffff800161d9c00 i5: 0000000000000001 i6: fffff803fe9d2f91 i7: 0000000000456904
[  121.338968] I7: <aggregate_get_down+0x84/0x13c>

I'm suspecting the deluge of cpumask changes that also went in today.

I guess I'll be bisecting all day tomorrow too :-/
