Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0CJUW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 15:22:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843Ab0CJUWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 15:22:25 -0500
Date: Wed, 10 Mar 2010 12:21:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
       Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: mmotm 2010-03-09-19-15: Lot of scheduling while atomic warnings
 related to RCU
Message-Id: <20100310122138.a7da6f65.akpm@linux-foundation.org>
In-Reply-To: <20100310195745.GP4883@csn.ul.ie>
References: <201003100342.o2A3gKvA022440@imap1.linux-foundation.org>
	<20100310195745.GP4883@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010 19:57:46 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

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

Thanks.  It's Neil's
sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch which does

--- a/lib/kobject_uevent.c~sysctl-fix-up-remaining-references-to-uevent_helper-fix
+++ a/lib/kobject_uevent.c
@@ -273,10 +273,11 @@ int kobject_uevent_env(struct kobject *k
 #endif
 
 	/* call uevent_helper, usually only enabled during early boot */
+	rcu_read_lock();
 	helper = rcu_dereference(uevent_helper);
 	if (helper[0])
 		retval = uevent_call_helper(subsystem, env);
-
+	rcu_read_unlock();
 exit:
 	kfree(devpath);
 	kfree(env);


Ho hum.  I guess all of

#rcu-add-rcustring-adt-for-rcu-protected-strings.patch: TBU
rcu-add-rcustring-adt-for-rcu-protected-strings.patch
#add-a-kernel_address-that-works-for-data-too.patch: TBU
add-a-kernel_address-that-works-for-data-too.patch
sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings.patch
sysctl-use-rcu-strings-for-core_pattern-sysctl.patch
sysctl-add-call_usermodehelper_cleanup.patch
sysctl-convert-modprobe_path-to-proc_rcu_string.patch
sysctl-convert-poweroff_command-to-proc_rcu_string.patch
#sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch: jirislaby crash
sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
#sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch: Joel nack
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch
#
sysctl-fix-up-remaining-references-to-uevent_helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch
#
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
#
sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed.patch
#
#
sysctl-extern-cleanup-c_a_d.patch
sysctl-extern-cleanup-signal.patch
sysctl-extern-cleanup-binfmts.patch
sysctl-extern-cleanup-pid.patch
sysctl-extern-cleanup-mm.patch
sysctl-extern-cleanup-compat.patch
sysctl-extern-cleanup-latencytop.patch
sysctl-extern-cleanup-file-nr.patch
sysctl-extern-cleanup-rcu.patch
sysctl-extern-cleanup-block-iopoll.patch
sysctl-extern-cleanup-module.patch
sysctl-extern-cleanup-sg.patch
sysctl-extern-cleanup-acct.patch
sysctl-extern-cleanup-rtmutex.patch
sysctl-extern-cleanup-lockdep.patch
sysctl-extern-cleanup-poll.patch
#
kmod-add-init-function-to-usermodehelper.patch
kmod-add-init-function-to-usermodehelper-fix.patch
kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limitcleanup.patch

are not a prospect for 2.6.34.  There are issues in the rcustring
patches and the others have dependencies.  I suppose I can rebase
sysctl-extern-cleanup-* though.

