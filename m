Return-Path: <linux-kernel-owner+w=401wt.eu-S1764668AbYBZTp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764668AbYBZTp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYBZTpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:45:09 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60595 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbYBZTpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:45:06 -0500
Date: Tue, 26 Feb 2008 11:45:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] using smp_processor_id() in preemptible as suspending
Message-ID: <20080226194504.GC8395@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080226082411.GA2853@darkstar.te-china.tietoenator.com> <20080226083354.be0a7351.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226083354.be0a7351.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 08:33:54AM -0800, Andrew Morton wrote:
> On Tue, 26 Feb 2008 16:24:11 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
> 
> > I don't know whom I should mail to, could you cc the proper guy? Thanks.

Hello, Dave,

Would you be willing to try out the following (untested, might not even
compile) patch show at the very end of this message?  This assumes that
you were running with CONFIG_PREEMPT_RCU, which seems most likely based
on looking at your oops.

							Thanx, Paul

> > [  118.331674] acpi LNXSYSTM:00: suspend
> > [  118.331674] Disabling non-boot CPUs ...
> > [  118.331674] CPU0 attaching NULL sched-domain.
> > [  118.331674] CPU1 attaching NULL sched-domain.
> > [  118.438750] CPU 1 is now offline
> > [  118.438750] lockdep: fixing up alternatives.
> > [  118.438750] SMP alternatives: switching to UP code
> > [  118.438750] BUG: using smp_processor_id() in preemptible [00000000] code: s2ram/2818
> > [  118.438750] caller is rcu_offline_cpu+0x15a/0x1c0
> > [  118.438750] Pid: 2818, comm: s2ram Not tainted 2.6.25-rc3-test #2
> > [  118.438750]  [<c0129738>] ? printk+0x18/0x20
> > [  118.438750]  [<c025c551>] debug_smp_processor_id+0xb1/0xc0
> > [  118.438750]  [<c0161f8a>] rcu_offline_cpu+0x15a/0x1c0
> > [  118.438750]  [<c03d408f>] rcu_cpu_notify+0x3f/0x60
> > [  118.438750]  [<c0141b0d>] notifier_call_chain+0x3d/0x80
> > [  118.438750]  [<c0141db9>] __raw_notifier_call_chain+0x19/0x20
> > [  118.438750]  [<c0141dda>] raw_notifier_call_chain+0x1a/0x20
> > [  118.438750]  [<c015262b>] _cpu_down+0x13b/0x230
> > [  118.438750]  [<c01527c9>] disable_nonboot_cpus+0x49/0xd0
> > [  118.438750]  [<c0157492>] suspend_devices_and_enter+0x72/0x130
> > [  118.438750]  [<c0129738>] ? printk+0x18/0x20
> > [  118.438750]  [<c0157623>] enter_state+0xb3/0xe0
> > [  118.438750]  [<c015777d>] state_store+0x7d/0xc0
> > [  118.438750]  [<c0157700>] ? state_store+0x0/0xc0
> > [  118.438750]  [<c0249e4e>] kobj_attr_store+0x2e/0x40
> > [  118.438750]  [<c01ca957>] flush_write_buffer+0x47/0x70
> > [  118.438750]  [<c01ca9c9>] sysfs_write_file+0x49/0x70
> > [  118.438750]  [<c0188d41>] vfs_write+0x91/0x140
> > [  118.438750]  [<c0188e9d>] sys_write+0x3d/0x70
> > [  118.438750]  [<c0104fca>] syscall_call+0x7/0xb
> > [  118.438750]  =======================
> > [  118.438750] CPU0 attaching NULL sched-domain.
> > [  118.440335] CPU1 is down
> 
> Paul & Ingo I guess
> 
> > My .config 
> 
> Doesn't tell us whether you'r eusing CONFIG_CLASSIC_RCU or
> CONFIG_PREEMPT_RCU.  I assume CONFIG_CLASSIC_RCU, if you ran `make
> oldconfig'.
> 
> Which kernel are you running here?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcupreempt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -urpNa -X dontdiff linux-2.6.25-rc2/kernel/rcupreempt.c linux-2.6.25-rc2-rcuoffline/kernel/rcupreempt.c
--- linux-2.6.25-rc2/kernel/rcupreempt.c	2008-02-24 10:30:44.000000000 -0800
+++ linux-2.6.25-rc2-rcuoffline/kernel/rcupreempt.c	2008-02-26 11:39:33.000000000 -0800
@@ -702,8 +702,8 @@ void rcu_offline_cpu(int cpu)
 	 * fix.
 	 */
 
-	rdp = RCU_DATA_ME();
 	spin_lock_irqsave(&rdp->lock, flags);
+	rdp = RCU_DATA_ME();
 	*rdp->nexttail = list;
 	if (list)
 		rdp->nexttail = tail;
