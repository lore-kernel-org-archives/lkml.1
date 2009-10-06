Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZJFN3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZJFN3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbZJFN3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:29:12 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47152 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109AbZJFN3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:29:10 -0400
Date: Tue, 6 Oct 2009 06:28:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Is RCU_PREEMPT working in 2.6.30.9 ?
Message-ID: <20091006132831.GB6732@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091005235817.GA30691@Krystal> <20091006002441.GH6949@linux.vnet.ibm.com> <20091006020018.GA8901@Krystal> <20091006021417.GB8901@Krystal> <20091006030156.GC8901@Krystal> <20091006040235.GA6732@linux.vnet.ibm.com> <20091006051400.GA24465@Krystal> <20091006053051.GB24465@Krystal> <20091006054618.GA28121@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006054618.GA28121@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 01:46:18AM -0400, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > 
> > > > Classic RCU does have known bugs in its dyntick interface, which was one
> > > > of the factors motivating its removal from mainline.  ;-)
> > > > 
> > > > 							Thanx, Paul
> > > 
> > > Recreated the problem with a simple test-case not involving lttng:
> > > 
> > > kernel 2.6.30.9
> > > TREE RCU
> > > 
> > > loading this hacky module:
> > > 
> > 
> > Please forget about this hacky module test case. It was not actually
> > hung, just really slow when 8 cpus where up to get the prompt back from
> > 1000 synchronize_sched() calls.
> 
> The only reliable way I can reproduce this on TREE RCU is with my
> tracepoint.c and marker.c code with cpu hotplug/unplug. I'll dig into
> those internals before blaming RCU itself. ;)

Well, I am not 100% certain that we have ever gotten the combination of
any RCU and CPU hotplug working completely correctly.  I certainly never
have done a formal proof of the two...

							Thanx, Paul

> Sorry for the mass-self-reply,
> 
> Thanks,
> 
> Mathieu
> 
> > 
> > Mathieu
> > 
> > > /*
> > >  * test-rcu-bug.c
> > >  */
> > > 
> > > #include <linux/module.h>
> > > #include <linux/proc_fs.h>
> > > #include <linux/sched.h>
> > > #include <linux/timex.h>
> > > #include <linux/rcupdate.h>
> > > #include <asm/ptrace.h>
> > > 
> > > struct proc_dir_entry *pentry = NULL;
> > > 
> > > static int my_open(struct inode *inode, struct file *file)
> > > {
> > > 	unsigned int i;
> > > 
> > > 	for (i = 0; i < 1000; i++)
> > > 		synchronize_sched();
> > > 
> > > 	return -EPERM;
> > > }
> > > 
> > > 
> > > static struct file_operations my_operations = {
> > > 	.open = my_open,
> > > };
> > > 
> > > int init_module(void)
> > > {
> > > 	pentry = create_proc_entry("testrcu", 0444, NULL);
> > > 	if (pentry)
> > > 		pentry->proc_fops = &my_operations;
> > > 
> > > 	return 0;
> > > }
> > > 
> > > void cleanup_module(void)
> > > {
> > > 	remove_proc_entry("testrcu", NULL);
> > > }
> > > 
> > > MODULE_LICENSE("GPL");
> > > MODULE_AUTHOR("Mathieu Desnoyers");
> > > MODULE_DESCRIPTION("rcu test");
> > > 
> > > Running, in loops:
> > > 
> > > One console:
> > > for a in $(seq 1 7); do echo 0 > /sys/devices/system/cpu/cpu$a/online; done
> > > for a in $(seq 1 7); do echo 1 > /sys/devices/system/cpu/cpu$a/online; done
> > > 
> > > Another console:
> > > for a in $(seq 1 10000); do cat /proc/testrcu; done
> > > 
> > > I eventually get a hang for the cat loop. Sysrq-W shows:
> > > 
> > > 
> > > [ 1337.118630] SysRq : Show Blocked State                             
> > > [ 1337.118644]   task                        PC stack   pid father              
> > > [ 1337.118644] md1_resync    D 0000000000000000     0  1255      2
> > > [ 1337.118644]  ffffffff807eb360 0000000000000046 fffffb7fa3c41757 ffff880439150
> > > [ 1337.118644]  ffff88043e028860 00ffffff803f4b88 0000000000010a80 0000000000008
> > > [ 1337.118644]  0000000000010a80 00ff88043e028860 ffff88043e485b00 ffff88043e488
> > > [ 1337.118644] Call Trace:
> > > [ 1337.118644]  [<ffffffff80684638>] ? schedule+0x18/0x40
> > > [ 1337.118644]  [<ffffffff8052b3dc>] ? raise_barrier+0x9c/0x1a0
> > > [ 1337.118644]  [<ffffffff80236720>] ? default_wake_function+0x0/0x10
> > > [ 1337.118644]  [<ffffffff8052c4f6>] ? sync_request+0x126/0x6c0
> > > [ 1337.118644]  [<ffffffff8054609a>] ? is_mddev_idle+0xda/0x160
> > > [ 1337.118644]  [<ffffffff805467f7>] ? md_do_sync+0x6d7/0xc90
> > > [ 1337.118644]  [<ffffffff80252400>] ? autoremove_wake_function+0x0/0x30
> > > [ 1337.118644]  [<ffffffff80547677>] ? md_thread+0x47/0x120
> > > [ 1337.118644]  [<ffffffff8022e8db>] ? __wake_up_common+0x5b/0x90
> > > [ 1337.118644]  [<ffffffff80547630>] ? md_thread+0x0/0x120
> > > [ 1337.118644]  [<ffffffff80547630>] ? md_thread+0x0/0x120
> > > [ 1337.118644]  [<ffffffff80547630>] ? md_thread+0x0/0x120
> > > [ 1337.118644]  [<ffffffff80251f24>] ? kthread+0x54/0x90
> > > [ 1337.118644]  [<ffffffff80251ed0>] ? kthread+0x0/0x90
> > > [ 1337.118644]  [<ffffffff8020d00a>] ? child_rip+0xa/0x20
> > > [ 1337.118644]  [<ffffffff80251ed0>] ? kthread+0x0/0x90
> > > [ 1337.118644]  [<ffffffff80251ed0>] ? kthread+0x0/0x90
> > > [ 1337.118644]  [<ffffffff8020d000>] ? child_rip+0x0/0x20
> > > [ 1337.118644] cat           D 0000000000000000     0 28861   4758
> > > [ 1337.118644]  ffff88043f84b330 0000000000000082 0000000000000000 ffff88043f570
> > > [ 1337.118644]  0000000000000019 00ffffff80293013 0000000000010a80 0000000000008
> > > [ 1337.118644]  0000000000010a80 00ffffff80293887 ffff88043dd885b0 ffff88043dd88
> > > [ 1337.118644] Call Trace:
> > > [ 1337.118644]  [<ffffffff802df5be>] ? inode_init_always+0xfe/0x1a0
> > > [ 1337.118644]  [<ffffffff802df692>] ? alloc_inode+0x32/0xa0
> > > [ 1337.118644]  [<ffffffff80684638>] ? schedule+0x18/0x40
> > > [ 1337.118644]  [<ffffffff806849ed>] ? schedule_timeout+0x15d/0x190
> > > [ 1337.118644]  [<ffffffff8031a1fc>] ? proc_lookup_de+0xac/0x100
> > > [ 1337.118644]  [<ffffffff80683b2c>] ? wait_for_common+0x15c/0x190
> > > [ 1337.118644]  [<ffffffff80236720>] ? default_wake_function+0x0/0x10
> > > [ 1337.118644]  [<ffffffff802dba90>] ? dput+0xb0/0x180
> > > [ 1337.118644]  [<ffffffffa007c050>] ? my_open+0x0/0x20 [test_rcu_bug]
> > > [ 1337.118644]  [<ffffffff8024f8d3>] ? synchronize_rcu+0x43/0x50
> > > [ 1337.118644]  [<ffffffff8024f730>] ? wakeme_after_rcu+0x0/0x10
> > > [ 1337.118644]  [<ffffffffa007c05d>] ? my_open+0xd/0x20 [test_rcu_bug]          
> > > [ 1337.118644]  [<ffffffff80313d52>] ? proc_reg_open+0xa2/0x190                 
> > > [ 1337.118644]  [<ffffffff80313cb0>] ? proc_reg_open+0x0/0x190                  
> > > [ 1337.118644]  [<ffffffff802c6a77>] ? __dentry_open+0x127/0x350                
> > > [ 1337.118644]  [<ffffffff802d6664>] ? do_filp_open+0x2b4/0xa00                 
> > > [ 1337.118644]  [<ffffffff802e0e22>] ? alloc_fd+0x122/0x150                     
> > > [ 1337.118644]  [<ffffffff802c6816>] ? do_sys_open+0x86/0x180                   
> > > [ 1337.118644]  [<ffffffff8020beeb>] ? system_call_fastpath+0x16/0x1b           
> > > 
> > > This might be a race between queued callbacks that discards a
> > > completion.
> > > 
> > > Thanks,
> > > 
> > > Mathieu
> > > 
> > > -- 
> > > Mathieu Desnoyers
> > > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
