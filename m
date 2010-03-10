Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab0CJUc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 15:32:59 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55698 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab0CJUc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 15:32:57 -0500
Date: Wed, 10 Mar 2010 15:32:42 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: mmotm 2010-03-09-19-15: Lot of scheduling while atomic warnings
 related to RCU
Message-ID: <20100310203242.GC3770@hmsreliant.think-freely.org>
References: <201003100342.o2A3gKvA022440@imap1.linux-foundation.org>
 <20100310195745.GP4883@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310195745.GP4883@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 07:57:46PM +0000, Mel Gorman wrote:
> On Tue, Mar 09, 2010 at 07:16:03PM -0800, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2010-03-09-19-15 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.34-rc1:
> > 
> 
> With preempt and sleeping spinlock debugging on, I'm seeing a lot of warnings
> about scheduling while atomic. Starts off with messages like
> 
> [    0.572278] BUG: scheduling while atomic: swapper/1/0x00000002
> [    0.576004] 1 lock held by swapper/1:
> [    0.580002]  #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff811b6950>] kobject_uevent_env+0x363/0x4d0
> [    0.600001] Modules linked in:
> [    0.608003] Pid: 1, comm: swapper Not tainted 2.6.34-rc1-mm1-vanilla #1
> [    0.612001] Call Trace:
> [    0.616005]  [<ffffffff810727fe>] ?  __debug_show_held_locks+0x22/0x24
> [    0.620005]  [<ffffffff810395ed>] __schedule_bug+0x77/0x7c
> [    0.624004]  [<ffffffff812f4cc5>] schedule+0xcc/0x723
> [    0.628003]  [<ffffffff812f55b6>] schedule_timeout+0x2d/0x28d
> [    0.632003]  [<ffffffff8107315d>] ? mark_held_locks+0x4d/0x6b
> [    0.636004]  [<ffffffff812f81e9>] ? _raw_spin_unlock_irq+0x30/0x5d
> [    0.640003]  [<ffffffff810733de>] ?  trace_hardirqs_on_caller+0x110/0x134
> [    0.644003]  [<ffffffff812f4a0f>] wait_for_common+0xdc/0x152
> [    0.648003]  [<ffffffff8103a43b>] ? default_wake_function+0x0/0x14
> [    0.652004]  [<ffffffff812f4b28>] wait_for_completion+0x1d/0x1f
> [    0.656004]  [<ffffffff8105cdf0>] call_usermodehelper_exec+0xad/0xfa
> [    0.660004]  [<ffffffff81068429>] ?  prepare_usermodehelper_creds+0x136/0x168
> [    0.664003]  [<ffffffff811b6a37>] kobject_uevent_env+0x44a/0x4d0
> [    0.668003]  [<ffffffff811b6950>] ? kobject_uevent_env+0x363/0x4d0
> [    0.672003]  [<ffffffff811b6ac8>] kobject_uevent+0xb/0xd
> [    0.676002]  [<ffffffff811b5e65>] kset_register+0x37/0x3f
> [    0.680004]  [<ffffffff8123239a>] bus_register+0x11f/0x2b1
> [    0.684005]  [<ffffffff8175973e>] platform_bus_init+0x2c/0x44
> [    0.688003]  [<ffffffff817597b9>] driver_init+0x1d/0x29
> [    0.692004]  [<ffffffff8172c69b>] kernel_init+0x12e/0x1e3
> [    0.696003]  [<ffffffff81003be4>] kernel_thread_helper+0x4/0x10
> [    0.700004]  [<ffffffff812f8794>] ? restore_args+0x0/0x30
> [    0.704003]  [<ffffffff8172c56d>] ? kernel_init+0x0/0x1e3
> [    0.708002]  [<ffffffff81003be0>] ? kernel_thread_helper+0x0/0x10
> 
> There are a lot of warnings along these lines during boot. This system did
> boot *eventually* but it was in obvious trouble. The warnings appear to
> be all around kobject_uevent_env acquiring the RCU lock and then going to
> sleep. Most likely candidate problem patches in mmotm are
> 
> sysctl-fix-up-remaining-references-to-uevent_helper
> sysctl-fix-up-remaining-references-to-uevent_helper-fix
> 
> But there are also a whole host of other sysctl-related changes around RCU in
> there. The changelog implies that these patches are part of some long-lived
> review process so I didn't delve too deeply. The people most likely to be
> involved based on comments in the changelog are cc'd.
> 
> -- 
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
> 
Yeah, its probably this chunk:
diff -puN
lib/kobject_uevent.c~sysctl-fix-up-remaining-references-to-uevent_helper-fix
lib/kobject_uevent.c
---
a/lib/kobject_uevent.c~sysctl-fix-up-remaining-references-to-uevent_helper-fix
+++ a/lib/kobject_uevent.c
@@ -273,10 +273,11 @@ int kobject_uevent_env(struct kobject *k
 #endif

        /* call uevent_helper, usually only enabled during early boot */
+       rcu_read_lock();
        helper = rcu_dereference(uevent_helper);
        if (helper[0])
                retval = uevent_call_helper(subsystem, env);
-
+       rcu_read_unlock();
 exit:
        kfree(devpath);
        kfree(env);
_

My bad, I'm not sure why I didn't catch that, I tested using lots of module
loads/unloads while changing uevent_helper.  Anywho, should be easy to fix,
Mel, can you modify the code to copy helper to a private variable, then unlock
the rcu read side prior to calling uevent_call_helper?  I imagine that would be
the best fix.


Thanks & Regards
Neil

