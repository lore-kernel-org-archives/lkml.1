Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYKUPMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYKUPMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYKUPML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:12:11 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40128 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbYKUPMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:12:09 -0500
Date: Fri, 21 Nov 2008 07:12:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.28-rc5] RCU detected CPU 0 stall (t=4294893165/750
	jiffies)
Message-ID: <20081121151205.GA6775@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081119123717.GE24427@vanheusden.com> <49267FA4.60609@cn.fujitsu.com> <20081121094543.GP24427@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121094543.GP24427@vanheusden.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 10:45:53AM +0100, Folkert van Heusden wrote:
> Hi,
> 
> I'm afraid there's no script for that: it happens during boot.

This is a HZ=250 machine, correct?  If so, please try the following
patch (already in -tip), which helps suppress boot-time false positives.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 5f89b62..301dda8 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -41,7 +41,7 @@
 #include <linux/seqlock.h>
 
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-#define RCU_SECONDS_TILL_STALL_CHECK	( 3 * HZ) /* for rcp->jiffies_stall */
+#define RCU_SECONDS_TILL_STALL_CHECK	(10 * HZ) /* for rcp->jiffies_stall */
 #define RCU_SECONDS_TILL_STALL_RECHECK	(30 * HZ) /* for rcp->jiffies_stall */
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */


> On Fri, Nov 21, 2008 at 05:30:12PM +0800, Lai Jiangshan wrote:
> > Hi, Folkert van Heusden,
> > 
> > Can you tell me how can I reproduce this bug.
> > 
> > Thanx, Lai
> > 
> > Folkert van Heusden wrote:
> > > During the boot-process of a 2.6.28-RC5 kernel I got the followin on
> > > the console:
> > > 
> > > - [    3.479998] RCU detected CPU 0 stall (t=4294893165/750 jiffies)
> > > ! [    3.480004] Pid: 1, comm: swapper Not tainted 2.6.28-rc5-custom2 #1
> > > ! [    3.480004] Call Trace:
> > > ! [    3.480004]  [<c0300c33>] ? printk+0xf/0x14
> > > ! [    3.480004]  [<c0166f15>] __rcu_pending+0x53/0x189
> > > ! [    3.480004]  [<c0167067>] rcu_pending+0x1c/0x47
> > > ! [    3.480004]  [<c0132aa4>] update_process_times+0x2b/0x4e
> > > ! [    3.480004]  [<c0144c8d>] tick_sched_timer+0x6d/0x9b
> > > ! [    3.480004]  [<c0144c20>] ? tick_sched_timer+0x0/0x9b
> > > ! [    3.480004]  [<c013e0cc>] __run_hrtimer+0x60/0x97
> > > ! [    3.480004]  [<c013eb35>] hrtimer_interrupt+0xfe/0x166
> > > ! [    3.480004]  [<c0112eea>] smp_apic_timer_interrupt+0x6c/0x7f
> > > ! [    3.480004]  [<c0104829>] apic_timer_interrupt+0x2d/0x34
> > > ! [    3.480004]  [<c043c454>] ? inflate_codes+0x272/0x3bc
> > > ! [    3.480004]  [<c043cf22>] inflate_dynamic+0x4c0/0x4f0
> > > ! [    3.480004]  [<c043d775>] unpack_to_rootfs+0x524/0x975
> > > ! [    3.480004]  [<c0147eaf>] ? debug_check_no_locks_freed+0x1a/0x123
> > > ! [    3.480004]  [<c043e202>] ? populate_rootfs+0x0/0xcd
> > > ! [    3.480004]  [<c043e202>] ? populate_rootfs+0x0/0xcd
> > > ! [    3.480004]  [<c043e278>] populate_rootfs+0x76/0xcd
> > > ! [    3.480004]  [<c0101130>] _stext+0x48/0x11e
> > > ! [    3.480004]  [<c0206830>] ? ida_get_new_above+0x157/0x171
> > > ! [    3.480004]  [<c0218a08>] ? _raw_spin_lock+0x53/0xfa
> > > ! [    3.480004]  [<c02189b1>] ? _raw_spin_unlock+0x74/0x78
> > > ! [    3.480004]  [<c0303759>] ? _spin_unlock+0x1d/0x20
> > > ! [    3.480004]  [<c01c1ab1>] ? proc_register+0x146/0x157
> > > ! [    3.480004]  [<c01c1bda>] ? create_proc_entry+0x7b/0x91
> > > ! [    3.480004]  [<c0166600>] ? register_irq_proc+0x7b/0x9b
> > > ! [    3.480004]  [<c0166666>] ? init_irq_proc+0x46/0x59
> > > ! [    3.480004]  [<c04392ee>] kernel_init+0x102/0x150
> > > ! [    3.480004]  [<c04391ec>] ? kernel_init+0x0/0x150
> > > ! [    3.480004]  [<c0104987>] kernel_thread_helper+0x7/0x10
> > > + [    4.773412] Freeing initrd memory: 53252k freed
> > > 
> > > This is a P4 with hyperthreading. 0.5GB ram. IDE disk.
> > > 
> > > 
> > > Folkert van Heusden
> > > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> Folkert van Heusden
> 
> -- 
> Looking for a cheap but fast webhoster with an excellent helpdesk?
> http://keetweej.vanheusden.com/redir.php?id=1001
> ----------------------------------------------------------------------
> Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
