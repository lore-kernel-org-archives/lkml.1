Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835Ab0BEJiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:38:09 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63801 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748Ab0BEJiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:38:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sRae1sbPImgkvuybrDezWlsw+3LbyZ1IeQ5dLsNRReT3GaibWmwejmXBrbQdUPqlMW
         3P0qjDkK+itRcuy5ClpVXbQU9mDJf1rxToYBc81pXggI0LwDLMjG+ptcPPkAndGayDSM
         EdSx/dLeJLFecY3ew2CLQWsYiRlJmavG2UQnQ=
Date: Fri, 5 Feb 2010 12:37:52 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: reiserfs deadlock
Message-ID: <20100205093752.GA13441@orion>
References: <a4423d671002031103r230f66cai4ab25236504bcf15@mail.gmail.com>
 <a4423d671002031108x6c2682edl9a147c35ac9c2815@mail.gmail.com>
 <20100203202909.GA5068@nowhere>
 <a4423d671002031443q283bab49wd15cd4de556d9557@mail.gmail.com>
 <20100203225232.GI5068@nowhere>
 <a4423d671002041746q1d918972i7c180d38a7c1d52@mail.gmail.com>
 <20100205035953.GB5408@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205035953.GB5408@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 04:59:57AM +0100, Frederic Weisbecker wrote:
> On Fri, Feb 05, 2010 at 04:46:38AM +0300, Alexander Beregalov wrote:
> > Hi Frederic
> > 
> > Does it help?
> 
> 
> Nope :-S
> 
> I need the full stracktraces. Plus the fact a thread holds
> the reiserfs lock doesn't help much in this regard. This
> is a drawback of lockdep: "holding" a lock in such lock dump
> means either: the task holds the lock _or_ the task requests the
> lock and block on it.
> 
> The only way to determine if a task really holds the reiserfs
> lock is to look at the stack trace and see if it blocks on
> reiserfs_write_lock_*() or something else. If this is something
> else, then it means it really holds it, and there are fair
> chances this is exactly the stacktrace we want: the one that
> raised the softlockup.
> 
> Thanks!


INFO: task svscan:1600 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
svscan        D bea5aec3  5248  1600      1 0x00000000
 f67abda0 00000046 00000007 bea5aec3 0000000b f676eb30 f676e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f676e8b0 f67abde4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f5a19dc4 f614fa9c f676e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by svscan/1600:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1739 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 39af5827  5700  1739      2 0x00000000
 f614fa78 00000046 00000007 39af5827 0000000b f6204150 f6203ed0 c104e4c4
 f7313a54 f7313a54 00000246 f6203ed0 f614fabc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f67abdc4 f7313a7c f6203ed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c1102687>] search_by_key+0x247/0x21b0
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c105891b>] ? __module_text_address+0xb/0x50
 [<c1058968>] ? is_module_text_address+0x8/0x10
 [<c103b257>] ? __kernel_text_address+0x47/0x70
 [<c10051a1>] ? print_context_stack+0x41/0xb0
 [<c10042ff>] ? dump_trace+0x7f/0xd0
 [<c104bb6a>] ? __bfs+0x1a/0x200
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c10ebfdf>] reiserfs_read_locked_inode+0x5f/0x5a0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec5af>] reiserfs_iget+0x8f/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1739:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1741 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 38f62cfa  6636  1741      2 0x00000000
 f62d3c50 00000046 f62d3c30 38f62cfa 0000000b f6206b30 f62068b0 f62d3c90
 f62d3c58 f62d3c88 00000000 f62d3c90 f62d3c58 c10a4838 f62d3c74 c134dc75
 c10a4830 c27efab8 c27efab8 f6fbbf9c f62d3ca4 f62d3cb0 c134dd00 00000002
Call Trace:
 [<c10a4838>] inode_wait+0x8/0x10
 [<c134dc75>] __wait_on_bit+0x45/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c134dd00>] out_of_line_wait_on_bit+0x60/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c103d530>] ? wake_bit_function+0x0/0x50
 [<c10a51dc>] ifind+0x8c/0xb0
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10a5f90>] iget5_locked+0x40/0x170
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10ec554>] reiserfs_iget+0x34/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1741:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task agetty:1868 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
agetty        D f601a9e0  5444  1868      1 0x00000000
 f6017cd4 00000046 00000007 f601a9e0 c134e72d f601ac60 f601a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f601a9e0 f6017d18 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f628fcdc f5a19dc4 f601a9e0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10e87ab>] reiserfs_lookup+0x5b/0x130
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c109a563>] do_lookup+0x163/0x1c0
 [<c1099eda>] ? generic_permission+0x1a/0xa0
 [<c109c06e>] link_path_walk+0x3be/0xc10
 [<c109ca23>] path_walk+0x43/0xa0
 [<c109cb51>] do_path_lookup+0x51/0x60
 [<c109dc8a>] do_filp_open+0x4fa/0x9f0
 [<c1097229>] ? check_unsafe_exec+0xd9/0x110
 [<c1097c4f>] open_exec+0x2f/0x100
 [<c1097179>] ? check_unsafe_exec+0x29/0x110
 [<c109847b>] do_execve+0xab/0x250
 [<c1008b0d>] sys_execve+0x2d/0x60
 [<c1002b86>] ptregs_execve+0x12/0x18
 [<c1002b10>] ? sysenter_do_call+0x12/0x36
3 locks held by agetty/1868:
 #0:  (&p->cred_guard_mutex){+.+.+.}, at: [<c10972f4>] prepare_bprm_creds+0x24/0x60
 #1:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109a4bb>] do_lookup+0xbb/0x1c0
 #2:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task sshd:1869 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sshd          D be338e6a  6576  1869   1816 0x00000000
 f5a15d78 00000046 ffffffff be338e6a 0000000f f601c150 f601bed0 00000000
 f601c3a4 7fffffff 00000000 f5a15e70 f5a15de8 c134da45 00000000 f5a15d8c
 c104ca3b 00000000 7fffffff 0000000f be3432d8 f601bed0 00000000 00000000
Call Trace:
 [<c134da45>] schedule_timeout+0x125/0x1b0
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c1350152>] ? _raw_spin_unlock_irq+0x22/0x30
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c134d7d0>] wait_for_common+0xd0/0x130
 [<c1024850>] ? default_wake_function+0x0/0x10
 [<c134d8c2>] wait_for_completion+0x12/0x20
 [<c1039709>] call_usermodehelper_exec+0x89/0xb0
 [<c1039471>] ? call_usermodehelper_setup+0x71/0xb0
 [<c134d730>] ? wait_for_common+0x30/0x130
 [<c10398e2>] __request_module+0xa2/0xf0
 [<c10a6136>] ? new_inode+0x76/0x80
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c12cc89f>] __sock_create+0x18f/0x1f0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c12cc967>] sock_create+0x37/0x40
 [<c12ccb1e>] sys_socket+0x3e/0x70
 [<c12ccbb0>] sys_socketcall+0x60/0x270
 [<c1002b43>] ? sysenter_exit+0xf/0x18
 [<c11d5eb4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002b10>] sysenter_do_call+0x12/0x36
no locks held by sshd/1869.
INFO: task modprobe:1871 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe      D be576d77  6740  1871   1870 0x00000000
 f5a19da0 00000046 00000007 be576d77 0000000f f601eb30f601e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f601e8b0 f5a19de4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6017cf8 f67abdc4 f601e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by modprobe/1871:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task svscan:1600 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
svscan        D bea5aec3  5248  1600      1 0x00000000
 f67abda0 00000046 00000007 bea5aec3 0000000b f676eb30 f676e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f676e8b0 f67abde4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f5a19dc4 f614fa9c f676e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by svscan/1600:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1736 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290cabe3  5576  1736      2 0x00000000
 f679fcb8 00000046 00000007 290cabe3 00000027 f6200280 f6200000 c104e4c4
 f7313a54 f7313a54 00000246 f6200000 f679fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6087cdc f628fcdc f6200000
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1736:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1737 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 215298ab  5912  1737      2 0x00000000
 f6087cb8 00000046 00000007 215298ab 00000035 f6201770 f62014f0 c104e4c4
 f7313a54 f7313a54 00000246 f62014f0 f6087cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6187cdc f679fcdc f62014f0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1737:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1738 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 21535e50  6560  1738      2 0x00000000
 f6187cb8 00000046 00000007 21535e50 00000035 f6202c60 f62029e0 c104e4c4
 f7313a54 f7313a54 00000246 f62029e0 f6187cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6427d60 f6087cdc f62029e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1738:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1739 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 39af5827  5700  1739      2 0x00000000
 f614fa78 00000046 00000007 39af5827 0000000b f6204150 f6203ed0 c104e4c4
 f7313a54 f7313a54 00000246 f6203ed0 f614fabc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f67abdc4 f7313a7c f6203ed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c1102687>] search_by_key+0x247/0x21b0
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c105891b>] ? __module_text_address+0xb/0x50
 [<c1058968>] ? is_module_text_address+0x8/0x10
 [<c103b257>] ? __kernel_text_address+0x47/0x70
 [<c10051a1>] ? print_context_stack+0x41/0xb0
 [<c10042ff>] ? dump_trace+0x7f/0xd0
 [<c104bb6a>] ? __bfs+0x1a/0x200
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c10ebfdf>] reiserfs_read_locked_inode+0x5f/0x5a0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec5af>] reiserfs_iget+0x8f/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1739:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1740 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290bda91  5944  1740      2 0x00000000
 f628fcb8 00000046 00000007 290bda91 00000027 f6205640 f62053c0 c104e4c4
 f7313a54 f7313a54 00000246 f62053c0 f628fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f679fcdc f6017cf8 f62053c0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1740:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1741 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 38f62cfa  6636  1741      2 0x00000000
 f62d3c50 00000046 f62d3c30 38f62cfa 0000000b f6206b30 f62068b0 f62d3c90
 f62d3c58 f62d3c88 00000000 f62d3c90 f62d3c58 c10a4838 f62d3c74 c134dc75
 c10a4830 c27efab8 c27efab8 f6fbbf9c f62d3ca4 f62d3cb0 c134dd00 00000002
Call Trace:
 [<c10a4838>] inode_wait+0x8/0x10
 [<c134dc75>] __wait_on_bit+0x45/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c134dd00>] out_of_line_wait_on_bit+0x60/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c103d530>] ? wake_bit_function+0x0/0x50
 [<c10a51dc>] ifind+0x8c/0xb0
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10a5f90>] iget5_locked+0x40/0x170
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10ec554>] reiserfs_iget+0x34/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1741:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task agetty:1868 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
agetty        D f601a9e0  5444  1868      1 0x00000000
 f6017cd4 00000046 00000007 f601a9e0 c134e72d f601ac60 f601a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f601a9e0 f6017d18 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f628fcdc f5a19dc4 f601a9e0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10e87ab>] reiserfs_lookup+0x5b/0x130
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c109a563>] do_lookup+0x163/0x1c0
 [<c1099eda>] ? generic_permission+0x1a/0xa0
 [<c109c06e>] link_path_walk+0x3be/0xc10
 [<c109ca23>] path_walk+0x43/0xa0
 [<c109cb51>] do_path_lookup+0x51/0x60
 [<c109dc8a>] do_filp_open+0x4fa/0x9f0
 [<c1097229>] ? check_unsafe_exec+0xd9/0x110
 [<c1097c4f>] open_exec+0x2f/0x100
 [<c1097179>] ? check_unsafe_exec+0x29/0x110
 [<c109847b>] do_execve+0xab/0x250
 [<c1008b0d>] sys_execve+0x2d/0x60
 [<c1002b86>] ptregs_execve+0x12/0x18
 [<c1002b10>] ? sysenter_do_call+0x12/0x36
3 locks held by agetty/1868:
 #0:  (&p->cred_guard_mutex){+.+.+.}, at: [<c10972f4>] prepare_bprm_creds+0x24/0x60
 #1:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109a4bb>] do_lookup+0xbb/0x1c0
 #2:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task sshd:1869 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sshd          D be338e6a  6576  1869   1816 0x00000000
 f5a15d78 00000046 ffffffff be338e6a 0000000f f601c150 f601bed0 00000000
 f601c3a4 7fffffff 00000000 f5a15e70 f5a15de8 c134da45 00000000 f5a15d8c
 c104ca3b 00000000 7fffffff 0000000f be3432d8 f601bed0 00000000 00000000
Call Trace:
 [<c134da45>] schedule_timeout+0x125/0x1b0
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c1350152>] ? _raw_spin_unlock_irq+0x22/0x30
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c134d7d0>] wait_for_common+0xd0/0x130
 [<c1024850>] ? default_wake_function+0x0/0x10
 [<c134d8c2>] wait_for_completion+0x12/0x20
 [<c1039709>] call_usermodehelper_exec+0x89/0xb0
 [<c1039471>] ? call_usermodehelper_setup+0x71/0xb0
 [<c134d730>] ? wait_for_common+0x30/0x130
 [<c10398e2>] __request_module+0xa2/0xf0
 [<c10a6136>] ? new_inode+0x76/0x80
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c12cc89f>] __sock_create+0x18f/0x1f0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c12cc967>] sock_create+0x37/0x40
 [<c12ccb1e>] sys_socket+0x3e/0x70
 [<c12ccbb0>] sys_socketcall+0x60/0x270
 [<c1002b43>] ? sysenter_exit+0xf/0x18
 [<c11d5eb4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002b10>] sysenter_do_call+0x12/0x36
no locks held by sshd/1869.
INFO: task modprobe:1871 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe      D be576d77  6740  1871   1870 0x00000000
 f5a19da0 00000046 00000007 be576d77 0000000f f601eb30 f601e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f601e8b0 f5a19de4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6017cf8 f67abdc4 f601e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by modprobe/1871:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task metalog:1558 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
metalog       D 4f4322f1  5448  1558      1 0x00000000
 f6427d3c 00000046 00000007 4f4322f1 00000039 f61cc150 f61cbed0 c104e4c4
 f7313a54 f7313a54 00000246 f61cbed0 f6427d80 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f674bcdc f6187cdc f61cbed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10f7152>] reiserfs_dirty_inode+0x22/0xc0
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c10ade0c>] __mark_inode_dirty+0x2c/0x130
 [<c10a48e2>] file_update_time+0xa2/0x110
 [<c106a199>] __generic_file_aio_write+0x1c9/0x4f0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c106a514>] generic_file_aio_write+0x54/0xb0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c109218c>] do_sync_write+0x9c/0xd0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c10f01d8>] reiserfs_file_write+0x88/0xa0
 [<c1092b5a>] vfs_write+0x9a/0x160
 [<c10f0150>] ? reiserfs_file_write+0x0/0xa0
 [<c1092ccd>] sys_write+0x3d/0x70
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by metalog/1558:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c106a501>] generic_file_aio_write+0x41/0xb0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task svscan:1600 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
svscan        D bea5aec3  5248  1600      1 0x00000000
 f67abda0 00000046 00000007 bea5aec3 0000000b f676eb30 f676e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f676e8b0 f67abde4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f5a19dc4 f614fa9c f676e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by svscan/1600:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1734 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D f66d68b0  6560  1734      2 0x00000000
 f677bcb8 00000046 00000007 f66d68b0 c134e72d f66d6b30 f66d68b0 c104e4c4
 f7313a54 f7313a54 00000246 f66d68b0 f677bcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6463da8 f674bcdc f66d68b0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1734:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1735 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 11df5955  6940  1735      2 0x00000000
 f674bcb8 00000046 00000007 11df5955 00000051 f676ac60 f676a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f676a9e0 f674bcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f677bcdc f6427d60 f676a9e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1735:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1736 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290cabe3  5576  1736      2 0x00000000
 f679fcb8 00000046 00000007 290cabe3 00000027 f6200280 f6200000 c104e4c4
 f7313a54 f7313a54 00000246 f6200000 f679fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6087cdc f628fcdc f6200000
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object0/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1736:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1737 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 215298ab  5912  1737      2 0x00000000
 f6087cb8 00000046 00000007 215298ab 00000035 f6201770 f62014f0 c104e4c4
 f7313a54 f7313a54 00000246 f62014f0 f6087cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6187cdc f679fcdc f62014f0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1737:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1738 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 21535e50  6560  1738      2 0x00000000
 f6187cb8 00000046 00000007 21535e50 00000035 f6202c60 f62029e0 c104e4c4
 f7313a54 f7313a54 00000246 f62029e0 f6187cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6427d60 f6087cdc f62029e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1738:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1739 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 39af5827  5700  1739      2 0x00000000
 f614fa78 00000046 00000007 39af5827 0000000b f6204150 f6203ed0 c104e4c4
 f7313a54 f7313a54 00000246 f6203ed0 f614fabc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f67abdc4 f7313a7c f6203ed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c1102687>] search_by_key+0x247/0x21b0
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c105891b>] ? __module_text_address+0xb/0x50
 [<c1058968>] ? is_module_text_address+0x8/0x10
 [<c103b257>] ? __kernel_text_address+0x47/0x70
 [<c10051a1>] ? print_context_stack+0x41/0xb0
 [<c10042ff>] ? dump_trace+0x7f/0xd0
 [<c104bb6a>] ? __bfs+0x1a/0x200
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c10ebfdf>] reiserfs_read_locked_inode+0x5f/0x5a0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec5af>] reiserfs_iget+0x8f/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1739:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1740 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290bda91  5944  1740      2 0x00000000
 f628fcb8 00000046 00000007 290bda91 00000027 f6205640 f62053c0 c104e4c4
 f7313a54 f7313a54 00000246 f62053c0 f628fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f679fcdc f6017cf8 f62053c0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1740:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1741 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 38f62cfa  6636  1741      2 0x00000000
 f62d3c50 00000046 f62d3c30 38f62cfa 0000000b f6206b30 f62068b0 f62d3c90
 f62d3c58 f62d3c88 00000000 f62d3c90 f62d3c58 c10a4838 f62d3c74 c134dc75
 c10a4830 c27efab8 c27efab8 f6fbbf9c f62d3ca4 f62d3cb0 c134dd00 00000002
Call Trace:
 [<c10a4838>] inode_wait+0x8/0x10
 [<c134dc75>] __wait_on_bit+0x45/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c134dd00>] out_of_line_wait_on_bit+0x60/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c103d530>] ? wake_bit_function+0x0/0x50
 [<c10a51dc>] ifind+0x8c/0xb0
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10a5f90>] iget5_locked+0x40/0x170
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10ec554>] reiserfs_iget+0x34/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1741:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task agetty:1868 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
agetty        D f601a9e0  5444  1868      1 0x00000000
 f6017cd4 00000046 00000007 f601a9e0 c134e72d f601ac60 f601a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f601a9e0 f6017d18 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f628fcdc f5a19dc4 f601a9e0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10e87ab>] reiserfs_lookup+0x5b/0x130
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c109a563>] do_lookup+0x163/0x1c0
 [<c1099eda>] ? generic_permission+0x1a/0xa0
 [<c109c06e>] link_path_walk+0x3be/0xc10
 [<c109ca23>] path_walk+0x43/0xa0
 [<c109cb51>] do_path_lookup+0x51/0x60
 [<c109dc8a>] do_filp_open+0x4fa/0x9f0
 [<c1097229>] ? check_unsafe_exec+0xd9/0x110
 [<c1097c4f>] open_exec+0x2f/0x100
 [<c1097179>] ? check_unsafe_exec+0x29/0x110
 [<c109847b>] do_execve+0xab/0x250
 [<c1008b0d>] sys_execve+0x2d/0x60
 [<c1002b86>] ptregs_execve+0x12/0x18
 [<c1002b10>] ? sysenter_do_call+0x12/0x36
3 locks held by agetty/1868:
 #0:  (&p->cred_guard_mutex){+.+.+.}, at: [<c10972f4>] prepare_bprm_creds+0x24/0x60
 #1:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109a4bb>] do_lookup+0xbb/0x1c0
 #2:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task sshd:1869 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sshd          D be338e6a  6576  1869   1816 0x00000000
 f5a15d78 00000046 ffffffff be338e6a 0000000f f601c150 f601bed0 00000000
 f601c3a4 7fffffff 00000000 f5a15e70 f5a15de8 c134da45 00000000 f5a15d8c
 c104ca3b 00000000 7fffffff 0000000f be3432d8 f601bed0 00000000 00000000
Call Trace:
 [<c134da45>] schedule_timeout+0x125/0x1b0
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c1350152>] ? _raw_spin_unlock_irq+0x22/0x30
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c134d7d0>] wait_for_common+0xd0/0x130
 [<c1024850>] ? default_wake_function+0x0/0x10
 [<c134d8c2>] wait_for_completion+0x12/0x20
 [<c1039709>] call_usermodehelper_exec+0x89/0xb0
 [<c1039471>] ? call_usermodehelper_setup+0x71/0xb0
 [<c134d730>] ? wait_for_common+0x30/0x130
 [<c10398e2>] __request_module+0xa2/0xf0
 [<c10a6136>] ? new_inode+0x76/0x80
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c12cc89f>] __sock_create+0x18f/0x1f0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c12cc967>] sock_create+0x37/0x40
 [<c12ccb1e>] sys_socket+0x3e/0x70
 [<c12ccbb0>] sys_socketcall+0x60/0x270
 [<c1002b43>] ? sysenter_exit+0xf/0x18
 [<c11d5eb4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002b10>] sysenter_do_call+0x12/0x36
no locks held by sshd/1869.
INFO: task modprobe:1871 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe      D be576d77  6740  1871   1870 0x00000000
 f5a19da0 00000046 00000007 be576d77 0000000f f601eb30 f601e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f601e8b0 f5a19de4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6017cf8 f67abdc4 f601e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by modprobe/1871:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task metalog:1558 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
metalog       D 4f4322f1  5448  1558      1 0x00000000
 f6427d3c 00000046 00000007 4f4322f1 00000039 f61cc150 f61cbed0 c104e4c4
 f7313a54 f7313a54 00000246 f61cbed0 f6427d80 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f674bcdc f6187cdc f61cbed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10f7152>] reiserfs_dirty_inode+0x22/0xc0
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c10ade0c>] __mark_inode_dirty+0x2c/0x130
 [<c10a48e2>] file_update_time+0xa2/0x110
 [<c106a199>] __generic_file_aio_write+0x1c9/0x4f0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c106a514>] generic_file_aio_write+0x54/0xb0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c109218c>] do_sync_write+0x9c/0xd0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c10f01d8>] reiserfs_file_write+0x88/0xa0
 [<c1092b5a>] vfs_write+0x9a/0x160
 [<c10f0150>] ? reiserfs_file_write+0x0/0xa0
 [<c1092ccd>] sys_write+0x3d/0x70
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by metalog/1558:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c106a501>] generic_file_aio_write+0x41/0xb0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task svscan:1600 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
svscan        D bea5aec3  5248  1600      1 0x00000000
 f67abda0 00000046 00000007 bea5aec3 0000000b f676eb30 f676e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f676e8b0 f67abde4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f5a19dc4 f614fa9c f676e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by svscan/1600:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1734 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D f66d68b0  6560  1734      2 0x00000000
 f677bcb8 00000046 00000007 f66d68b0 c134e72d f66d6b30 f66d68b0 c104e4c4
 f7313a54 f7313a54 00000246 f66d68b0 f677bcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6463da8 f674bcdc f66d68b0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1734:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1735 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 11df5955  6940  1735      2 0x00000000
 f674bcb8 00000046 00000007 11df5955 00000051 f676ac60 f676a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f676a9e0 f674bcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f677bcdc f6427d60 f676a9e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1735:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1736 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290cabe3  5576  1736      2 0x00000000
 f679fcb8 00000046 00000007 290cabe3 00000027 f6200280 f6200000 c104e4c4
 f7313a54 f7313a54 00000246 f6200000 f679fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6087cdc f628fcdc f6200000
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1736:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1737 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 215298ab  5912  1737      2 0x00000000
 f6087cb8 00000046 00000007 215298ab 00000035 f6201770 f62014f0 c104e4c4
 f7313a54 f7313a54 00000246 f62014f0 f6087cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6187cdc f679fcdc f62014f0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1737:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1738 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 21535e50  6560  1738      2 0x00000000
 f6187cb8 00000046 00000007 21535e50 00000035 f6202c60 f62029e0 c104e4c4
 f7313a54 f7313a54 00000246 f62029e0 f6187cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6427d60 f6087cdc f62029e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1738:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1739 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 39af5827  5700  1739      2 0x00000000
 f614fa78 00000046 00000007 39af5827 0000000b f6204150 f6203ed0 c104e4c4
 f7313a54 f7313a54 00000246 f6203ed0 f614fabc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f67abdc4 f7313a7c f6203ed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c1102687>] search_by_key+0x247/0x21b0
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c105891b>] ? __module_text_address+0xb/0x50
 [<c1058968>] ? is_module_text_address+0x8/0x10
 [<c103b257>] ? __kernel_text_address+0x47/0x70
 [<c10051a1>] ? print_context_stack+0x41/0xb0
 [<c10042ff>] ? dump_trace+0x7f/0xd0
 [<c104bb6a>] ? __bfs+0x1a/0x200
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c10ebfdf>] reiserfs_read_locked_inode+0x5f/0x5a0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec5af>] reiserfs_iget+0x8f/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1739:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1740 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290bda91  5944  1740      2 0x00000000
 f628fcb8 00000046 00000007 290bda91 00000027 f6205640 f62053c0 c104e4c4
 f7313a54 f7313a54 00000246 f62053c0 f628fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f679fcdc f6017cf8 f62053c0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1740:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1741 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 38f62cfa  6636  1741      2 0x00000000
 f62d3c50 00000046 f62d3c30 38f62cfa 0000000b f6206b30 f62068b0 f62d3c90
 f62d3c58 f62d3c88 00000000 f62d3c90 f62d3c58 c10a4838 f62d3c74 c134dc75
 c10a4830 c27efab8 c27efab8 f6fbbf9c f62d3ca4 f62d3cb0 c134dd00 00000002
Call Trace:
 [<c10a4838>] inode_wait+0x8/0x10
 [<c134dc75>] __wait_on_bit+0x45/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c134dd00>] out_of_line_wait_on_bit+0x60/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c103d530>] ? wake_bit_function+0x0/0x50
 [<c10a51dc>] ifind+0x8c/0xb0
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10a5f90>] iget5_locked+0x40/0x170
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10ec554>] reiserfs_iget+0x34/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1741:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task agetty:1868 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
agetty        D f601a9e0  5444  1868      1 0x00000000
 f6017cd4 00000046 00000007 f601a9e0 c134e72d f601ac60 f601a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f601a9e0 f6017d18 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f628fcdc f5a19dc4 f601a9e0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10e87ab>] reiserfs_lookup+0x5b/0x130
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c109a563>] do_lookup+0x163/0x1c0
 [<c1099eda>] ? generic_permission+0x1a/0xa0
 [<c109c06e>] link_path_walk+0x3be/0xc10
 [<c109ca23>] path_walk+0x43/0xa0
 [<c109cb51>] do_path_lookup+0x51/0x60
 [<c109dc8a>] do_filp_open+0x4fa/0x9f0
 [<c1097229>] ? check_unsafe_exec+0xd9/0x110
 [<c1097c4f>] open_exec+0x2f/0x100
 [<c1097179>] ? check_unsafe_exec+0x29/0x110
 [<c109847b>] do_execve+0xab/0x250
 [<c1008b0d>] sys_execve+0x2d/0x60
 [<c1002b86>] ptregs_execve+0x12/0x18
 [<c1002b10>] ? sysenter_do_call+0x12/0x36
3 locks held by agetty/1868:
 #0:  (&p->cred_guard_mutex){+.+.+.}, at: [<c10972f4>] prepare_bprm_creds+0x24/0x60
 #1:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109a4bb>] do_lookup+0xbb/0x1c0
 #2:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task sshd:1869 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sshd          D be338e6a  6576  1869   1816 0x00000000
 f5a15d78 00000046 ffffffff be338e6a 0000000f f601c150 f601bed0 00000000
 f601c3a4 7fffffff 00000000 f5a15e70 f5a15de8 c134da45 00000000 f5a15d8c
 c104ca3b 00000000 7fffffff 0000000f be3432d8 f601bed0 00000000 00000000
Call Trace:
 [<c134da45>] schedule_timeout+0x125/0x1b0
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c1350152>] ? _raw_spin_unlock_irq+0x22/0x30
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c134d7d0>] wait_for_common+0xd0/0x130
 [<c1024850>] ? default_wake_function+0x0/0x10
 [<c134d8c2>] wait_for_completion+0x12/0x20
 [<c1039709>] call_usermodehelper_exec+0x89/0xb0
 [<c1039471>] ? call_usermodehelper_setup+0x71/0xb0
 [<c134d730>] ? wait_for_common+0x30/0x130
 [<c10398e2>] __request_module+0xa2/0xf0
 [<c10a6136>] ? new_inode+0x76/0x80
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c12cc89f>] __sock_create+0x18f/0x1f0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c12cc967>] sock_create+0x37/0x40
 [<c12ccb1e>] sys_socket+0x3e/0x70
 [<c12ccbb0>] sys_socketcall+0x60/0x270
 [<c1002b43>] ? sysenter_exit+0xf/0x18
 [<c11d5eb4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002b10>] sysenter_do_call+0x12/0x36
no locks held by sshd/1869.
INFO: task modprobe:1871 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe      D be576d77  6740  1871   1870 0x00000000
 f5a19da0 00000046 00000007 be576d77 0000000f f601eb30 f601e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f601e8b0 f5a19de4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6017cf8 f67abdc4 f601e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by modprobe/1871:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task fcron:1872 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fcron         D f62d8000  7144  1872   1636 0x00000000
 f6463d84 00000046 00000007 f62d8000 c134e72d f62d8280 f62d8000 c104e4c4
 f7313a54 f7313a54 00000246 f62d8000 f6463dc8 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f7313a7c f677bcdc f62d8000
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10e87ab>] reiserfs_lookup+0x5b/0x130
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c109a674>] __lookup_hash+0xb4/0x110
 [<c109a6fd>] lookup_hash+0x2d/0x40
 [<c109d90b>] do_filp_open+0x17b/0x9f0
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c10a739a>] ? alloc_fd+0xba/0xf0
 [<c11d6545>] ? strncpy_from_user+0x35/0x60
 [<c109060f>] do_sys_open+0x4f/0x110
 [<c13526a5>] ? do_page_fault+0x155/0x370
 [<c1090739>] sys_open+0x29/0x40
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by fcron/1872:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109d903>] do_filp_open+0x173/0x9f0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task metalog:1558 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
metalog       D 4f4322f1  5448  1558      1 0x00000000
 f6427d3c 00000046 00000007 4f4322f1 00000039 f61cc150 f61cbed0 c104e4c4
 f7313a54 f7313a54 00000246 f61cbed0 f6427d80 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f674bcdc f6187cdc f61cbed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10f7152>] reiserfs_dirty_inode+0x22/0xc0
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c10ade0c>] __mark_inode_dirty+0x2c/0x130
 [<c10a48e2>] file_update_time+0xa2/0x110
 [<c106a199>] __generic_file_aio_write+0x1c9/0x4f0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c106a514>] generic_file_aio_write+0x54/0xb0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c109218c>] do_sync_write+0x9c/0xd0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c10f01d8>] reiserfs_file_write+0x88/0xa0
 [<c1092b5a>] vfs_write+0x9a/0x160
 [<c10f0150>] ? reiserfs_file_write+0x0/0xa0
 [<c1092ccd>] sys_write+0x3d/0x70
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by metalog/1558:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c106a501>] generic_file_aio_write+0x41/0xb0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task svscan:1600 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
svscan        D bea5aec3  5248  1600      1 0x00000000
 f67abda0 00000046 00000007 bea5aec3 0000000b f676eb30 f676e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f676e8b0 f67abde4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f5a19dc4 f614fa9c f676e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by svscan/1600:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1734 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D f66d68b0  6560  1734      2 0x00000000
 f677bcb8 00000046 00000007 f66d68b0 c134e72d f66d6b30 f66d68b0 c104e4c4
 f7313a54 f7313a54 00000246 f66d68b0 f677bcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6463da8 f674bcdc f66d68b0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/00
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1734:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1735 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 11df5955  6940  1735      2 0x00000000
 f674bcb8 00000046 00000007 11df5955 00000051 f676ac60 f676a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f676a9e0 f674bcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f677bcdc f6427d60 f676a9e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x60x1c
2 locks held by nfsd/1735:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1736 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290cabe3  5576  1736      2 0x00000000
 f679fcb8 00000046 00000007 290cabe3 00000027 f6200280 f6200000 c104e4c4
 f7313a54 f7313a54 00000246 f6200000 f679fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6087cdc f628fcdc f6200000
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1736:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1737 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 215298ab  5912  1737      2 0x00000000
 f6087cb8 00000046 00000007 215298ab 00000035 f6201770 f62014f0 c104e4c4
 f7313a54 f7313a54 00000246 f62014f0 f6087cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6187cdc f679fcdc f62014f0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1737:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1738 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 21535e50  6560  1738      2 0x00000000
 f6187cb8 00000046 00000007 21535e50 00000035 f6202c60 f62029e0 c104e4c4
 f7313a54 f7313a54 00000246 f62029e0 f6187cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6427d60 f6087cdc f62029e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1738:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1739 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 39af5827  5700  1739      2 0x00000000
 f614fa78 00000046 00000007 39af5827 0000000b f6204150 f6203ed0 c104e4c4
 f7313a54 f7313a54 00000246 f6203ed0 f614fabc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f67abdc4 f7313a7c f6203ed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c1102687>] search_by_key+0x247/0x21b0
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c105891b>] ? __module_text_address+0xb/0x50
 [<c1058968>] ? is_module_text_address+0x8/0x10
 [<c103b257>] ? __kernel_text_address+0x47/0x70
 [<c10051a1>] ? print_context_stack+0x41/0xb0
 [<c10042ff>] ? dump_trace+0x7f/0xd0
 [<c104bb6a>] ? __bfs+0x1a/0x200
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c10ebfdf>] reiserfs_read_locked_inode+0x5f/0x5a0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec5af>] reiserfs_iget+0x8f/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1739:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1740 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290bda91  5944  1740      2 0x00000000
 f628fcb8 00000046 00000007 290bda91 00000027 f6205640 f62053c0 c104e4c4
 f7313a54 f7313a54 00000246 f62053c0 f628fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f679fcdc f6017cf8 f62053c0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1740:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1741 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 38f62cfa  6636  1741      2 0x00000000
 f62d3c50 00000046 f62d3c30 38f62cfa 0000000b f6206b30 f62068b0 f62d3c90
 f62d3c58 f62d3c88 00000000 f62d3c90 f62d3c58 c10a4838 f62d3c74 c134dc75
 c10a4830 c27efab8 c27efab8 f6fbbf9c f62d3ca4 f62d3cb0 c134dd00 00000002
Call Trace:
 [<c10a4838>] inode_wait+0x8/0x10
 [<c134dc75>] __wait_on_bit+0x45/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c134dd00>] out_of_line_wait_on_bit+0x60/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c103d530>] ? wake_bit_function+0x0/0x50
 [<c10a51dc>] ifind+0x8c/0xb0
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10a5f90>] iget5_locked+0x40/0x170
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10ec554>] reiserfs_iget+0x34/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1741:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task agetty:1868 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
agetty        D f601a9e0  5444  1868      1 0x00000000
 f6017cd4 00000046 00000007 f601a9e0 c134e72d f601ac60 f601a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f601a9e0 f6017d18 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f628fcdc f5a19dc4 f601a9e0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10e87ab>] reiserfs_lookup+0x5b/0x130
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c109a563>] do_lookup+0x163/0x1c0
 [<c1099eda>] ? generic_permission+0x1a/0xa0
 [<c109c06e>] link_path_walk+0x3be/0xc10
 [<c109ca23>] path_walk+0x43/0xa0
 [<c109cb51>] do_path_lookup+0x51/0x60
 [<c109dc8a>] do_filp_open+0x4fa/0x9f0
 [<c1097229>] ? check_unsafe_exec+0xd9/0x110
 [<c1097c4f>] open_exec+0x2f/0x100
 [<c1097179>] ? check_unsafe_exec+0x29/0x110
 [<c109847b>] do_execve+0xab/0x250
 [<c1008b0d>] sys_execve+0x2d/0x60
 [<c1002b86>] ptregs_execve+0x12/0x18
 [<c1002b10>] ? sysenter_do_call+0x12/0x36
3 locks held by agetty/1868:
 #0:  (&p->cred_guard_mutex){+.+.+.}, at: [<c10972f4>] prepare_bprm_creds+0x24/0x60
 #1:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109a4bb>] do_lookup+0xbb/0x1c0
 #2:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task sshd:1869 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sshd          D be338e6a  6576  1869   1816 0x00000000
 f5a15d78 00000046 ffffffff be338e6a 0000000f f601c150 f601bed0 00000000
 f601c3a4 7fffffff 00000000 f5a15e70 f5a15de8 c134da45 00000000 f5a15d8c
 c104ca3b 00000000 7fffffff 0000000f be3432d8 f601bed0 00000000 00000000
Call Trace:
 [<c134da45>] schedule_timeout+0x125/0x1b0
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c1350152>] ? _raw_spin_unlock_irq+0x22/0x30
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c134d7d0>] wait_for_common+0xd0/0x130
 [<c1024850>] ? default_wake_function+0x0/0x10
 [<c134d8c2>] wait_for_completion+0x12/0x20
 [<c1039709>] call_usermodehelper_exec+0x89/0xb0
 [<c1039471>] ? call_usermodehelper_setup+0x71/0xb0
 [<c134d730>] ? wait_for_common+0x30/0x130
 [<c10398e2>] __request_module+0xa2/0xf0
 [<c10a6136>] ? new_inode+0x76/0x80
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c12cc89f>] __sock_create+0x18f/0x1f0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c12cc967>] sock_create+0x37/0x40
 [<c12ccb1e>] sys_socket+0x3e/0x70
 [<c12ccbb0>] sys_socketcall+0x60/0x270
 [<c1002b43>] ? sysenter_exit+0xf/0x18
 [<c11d5eb4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002b10>] sysenter_do_call+0x12/0x36
no locks held by sshd/1869.
INFO: task modprobe:1871 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe      D be576d77  6740  1871   1870 0x00000000
 f5a19da0 00000046 00000007 be576d77 0000000f f601eb30 f601e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f601e8b0 f5a19de4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6017cf8 f67abdc4 f601e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by modprobe/1871:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task fcron:1872 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fcron         D f62d8000  7144  1872   1636 0x00000000
 f6463d84 00000046 00000007 f62d8000 c134e72d f62d8280 f62d8000 c104e4c4
 f7313a54 f7313a54 00000246 f62d8000 f6463dc8 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f7313a7c f677bcdc f62d8000
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10e87ab>] reiserfs_lookup+0x5b/0x130
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c109a674>] __lookup_hash+0xb4/0x110
 [<c109a6fd>] lookup_hash+0x2d/0x40
 [<c109d90b>] do_filp_open+0x17b/0x9f0
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c10a739a>] ? alloc_fd+0xba/0xf0
 [<c11d6545>] ? strncpy_from_user+0x35/0x60
 [<c109060f>] do_sys_open+0x4f/0x110
 [<c13526a5>] ? do_page_fault+0x155/0x370
 [<c1090739>] sys_open+0x29/0x40
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by fcron/1872:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109d903>] do_filp_open+0x173/0x9f0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task metalog:1558 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
metalog       D 4f4322f1  5448  1558      1 0x00000000
 f6427d3c 00000046 00000007 4f4322f1 00000039 f61cc150 f61cbed0 c104e4c4
 f7313a54 f7313a54 00000246 f61cbed0 f6427d80 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f674bcdc f6187cdc f61cbed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10f7152>] reiserfs_dirty_inode+0x22/0xc0
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c10ade0c>] __mark_inode_dirty+0x2c/0x130
 [<c10a48e2>] file_update_time+0xa2/0x110
 [<c106a199>] __generic_file_aio_write+0x1c9/0x4f0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c106a514>] generic_file_aio_write+0x54/0xb0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c109218c>] do_sync_write+0x9c/0xd0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c10f01d8>] reiserfs_file_write+0x88/0xa0
 [<c1092b5a>] vfs_write+0x9a/0x160
 [<c10f0150>] ? reiserfs_file_write+0x0/0xa0
 [<c1092ccd>] sys_write+0x3d/0x70
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by metalog/1558:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c106a501>] generic_file_aio_write+0x41/0xb0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task svscan:1600 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
svscan        D bea5aec3  5248  1600      1 0x00000000
 f67abda0 00000046 00000007 bea5aec3 0000000b f676eb30 f676e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f676e8b0 f67abde4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f5a19dc4 f614fa9c f676e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by svscan/1600:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1734 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D f66d68b0  6560  1734      2 0x00000000
 f677bcb8 00000046 00000007 f66d68b0 c134e72d f66d6b30 f66d68b0 c104e4c4
 f7313a54 f7313a54 00000246 f66d68b0 f677bcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6463da8 f674bcdc f66d68b0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1734:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1735 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 11df5955  6940  1735      2 0x00000000
 f674bcb8 00000046 00000007 11df5955 00000051 f676ac60 f676a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f676a9e0 f674bcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f677bcdc f6427d60 f676a9e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1735:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1736 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290cabe3  5576  1736      2 0x00000000
 f679fcb8 00000046 00000007 290cabe3 00000027 f6200280 f6200000 c104e4c4
 f7313a54 f7313a54 00000246 f6200000 f679fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6087cdc f628fcdc f6200000
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1736:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1737 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 215298ab  5912  1737      2 0x00000000
 f6087cb8 00000046 00000007 215298ab 00000035 f6201770 f62014f0 c104e4c4
 f7313a54 f7313a54 00000246 f62014f0 f6087cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6187cdc f679fcdc f62014f0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1737:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1738 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 21535e50  6560  1738      2 0x00000000
 f6187cb8 00000046 00000007 21535e50 00000035 f6202c60 f62029e0 c104e4c4
 f7313a54 f7313a54 00000246 f62029e0 f6187cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6427d60 f6087cdc f62029e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1738:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1739 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 39af5827  5700  1739      2 0x00000000
 f614fa78 00000046 00000007 39af5827 0000000b f6204150 f6203ed0 c104e4c4
 f7313a54 f7313a54 00000246 f6203ed0 f614fabc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f67abdc4 f7313a7c f6203ed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c1102687>] search_by_key+0x247/0x21b0
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c105891b>] ? __module_text_address+0xb/0x50
 [<c1058968>] ? is_module_text_address+0x8/0x10
 [<c103b257>] ? __kernel_text_address+0x47/0x70
 [<c10051a1>] ? print_context_stack+0x41/0xb0
 [<c10042ff>] ? dump_trace+0x7f/0xd0
 [<c104bb6a>] ? __bfs+0x1a/0x200
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c10ebfdf>] reiserfs_read_locked_inode+0x5f/0x5a0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec5af>] reiserfs_iget+0x8f/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1739:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1740 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290bda91  5944  1740      2 0x00000000
 f628fcb8 00000046 00000007 290bda91 00000027 f6205640 f62053c0 c104e4c4
 f7313a54 f7313a54 00000246 f62053c0 f628fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f679fcdc f6017cf8 f62053c0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1740:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1741 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 38f62cfa  6636  1741      2 0x00000000
 f62d3c50 00000046 f62d3c30 38f62cfa 0000000b f6206b30 f62068b0 f62d3c90
 f62d3c58 f62d3c88 00000000 f62d3c90 f62d3c58 c10a4838 f62d3c74 c134dc75
 c10a4830 c27efab8 c27efab8 f6fbbf9c f62d3ca4 f62d3cb0 c134dd00 00000002
Call Trace:
 [<c10a4838>] inode_wait+0x8/0x10
 [<c134dc75>] __wait_on_bit+0x45/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c134dd00>] out_of_line_wait_on_bit+0x60/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c103d530>] ? wake_bit_function+0x0/0x50
 [<c10a51dc>] ifind+0x8c/0xb0
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10a5f90>] iget5_locked+0x40/0x170
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10ec554>] reiserfs_iget+0x34/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1741:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task agetty:1868 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
agetty        D f601a9e0  5444  1868      1 0x00000000
 f6017cd4 00000046 00000007 f601a9e0 c134e72d f601ac60 f601a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f601a9e0 f6017d18 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f628fcdc f5a19dc4 f601a9e0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10e87ab>] reiserfs_lookup+0x5b/0x130
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c109a563>] do_lookup+0x163/0x1c0
 [<c1099eda>] ? generic_permission+0x1a/0xa0
 [<c109c06e>] link_path_walk+0x3be/0xc10
 [<c109ca23>] path_walk+0x43/0xa0
 [<c109cb51>] do_path_lookup+0x51/0x60
 [<c109dc8a>] do_filp_open+0x4fa/0x9f0
 [<c1097229>] ? check_unsafe_exec+0xd9/0x110
 [<c1097c4f>] open_exec+0x2f/0x100
 [<c1097179>] ? check_unsafe_exec+0x29/0x110
 [<c109847b>] do_execve+0xab/0x250
 [<c1008b0d>] sys_execve+0x2d/0x60
 [<c1002b86>] ptregs_execve+0x12/0x18
 [<c1002b10>] ? sysenter_do_call+0x12/0x36
3 locks held by agetty/1868:
 #0:  (&p->cred_guard_mutex){+.+.+.}, at: [<c10972f4>] prepare_bprm_creds+0x24/0x60
 #1:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109a4bb>] do_lookup+0xbb/0x1c0
 #2:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task sshd:1869 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sshd          D be338e6a  6576  1869   1816 0x00000000
 f5a15d78 00000046 ffffffff be338e6a 0000000f f601c150 f601bed0 00000000
 f601c3a4 7fffffff 00000000 f5a15e70 f5a15de8 c134da45 00000000 f5a15d8c
 c104ca3b 00000000 7fffffff 0000000f be3432d8 f601bed0 00000000 00000000
Call Trace:
 [<c134da45>] schedule_timeout+0x125/0x1b0
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c1350152>] ? _raw_spin_unlock_irq+0x22/0x30
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c134d7d0>] wait_for_common+0xd0/0x130
 [<c1024850>] ? default_wake_function+0x0/0x10
 [<c134d8c2>] wait_for_completion+0x12/0x20
 [<c1039709>] call_usermodehelper_exec+0x89/0xb0
 [<c1039471>] ? call_usermodehelper_setup+0x71/0xb0
 [<c134d730>] ? wait_for_common+0x30/0x130
 [<c10398e2>] __request_module+0xa2/0xf0
 [<c10a6136>] ? new_inode+0x76/0x80
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c12cc89f>] __sock_create+0x18f/0x1f0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c12cc967>] sock_create+0x37/0x40
 [<c12ccb1e>] sys_socket+0x3e/0x70
 [<c12ccbb0>] sys_socketcall+0x60/0x270
 [<c1002b43>] ? sysenter_exit+0xf/0x18
 [<c11d5eb4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002b10>] sysenter_do_call+0x12/0x36
no locks held by sshd/1869.
INFO: task modprobe:1871 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe      D be576d77  6740  1871   1870 0x00000000
 f5a19da0 00000046 00000007 be576d77 0000000f f601eb30 f601e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f601e8b0 f5a19de4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6017cf8 f67abdc4 f601e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by modprobe/1871:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task fcron:1872 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fcron         D f62d8000  7144  1872   1636 0x00000000
 f6463d84 00000046 00000007 f62d8000 c134e72d f62d8280 f62d8000 c104e4c4
 f7313a54 f7313a54 00000246 f62d8000 f6463dc8 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f7313a7c f677bcdc f62d8000
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10e87ab>] reiserfs_lookup+0x5b/0x130
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c109a674>] __lookup_hash+0xb4/0x110
 [<c109a6fd>] lookup_hash+0x2d/0x40
 [<c109d90b>] do_filp_open+0x17b/0x9f0
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c10a739a>] ? alloc_fd+0xba/0xf0
 [<c11d6545>] ? strncpy_from_user+0x35/0x60
 [<c109060f>] do_sys_open+0x4f/0x110
 [<c13526a5>] ? do_page_fault+0x155/0x370
 [<c1090739>] sys_open+0x29/0x40
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by fcron/1872:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109d903>] do_filp_open+0x173/0x9f0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task metalog:1558 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
metalog       D 4f4322f1  5448  1558      1 0x00000000
 f6427d3c 00000046 00000007 4f4322f1 00000039 f61cc150 f61cbed0 c104e4c4
 f7313a54 f7313a54 00000246 f61cbed0 f6427d80 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f674bcdc f6187cdc f61cbed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10f7152>] reiserfs_dirty_inode+0x22/0xc0
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c10ade0c>] __mark_inode_dirty+0x2c/0x130
 [<c10a48e2>] file_update_time+0xa2/0x110
 [<c106a199>] __generic_file_aio_write+0x1c9/0x4f0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c106a514>] generic_file_aio_write+0x54/0xb0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c109218c>] do_sync_write+0x9c/0xd0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c10f01d8>] reiserfs_file_write+0x88/0xa0
 [<c1092b5a>] vfs_write+0x9a/0x160
 [<c10f0150>] ? reiserfs_file_write+0x0/0xa0
 [<c1092ccd>] sys_write+0x3d/0x70
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by metalog/1558:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c106a501>] generic_file_aio_write+0x41/0xb0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task svscan:1600 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
svscan        D bea5aec3  5248  1600      1 0x00000000
 f67abda0 00000046 00000007 bea5aec3 0000000b f676eb30 f676e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f676e8b0 f67abde4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f5a19dc4 f614fa9c f676e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by svscan/1600:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1734 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D f66d68b0  6560  1734      2 0x00000000
 f677bcb8 00000046 00000007 f66d68b0 c134e72d f66d6b30 f66d68b0 c104e4c4
 f7313a54 f7313a54 00000246 f66d68b0 f677bcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6463da8 f674bcdc f66d68b0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1734:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1735 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 11df5955  6940  1735      2 0x00000000
 f674bcb8 00000046 00000007 11df5955 00000051 f676ac60 f676a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f676a9e0 f674bcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f677bcdc f6427d60 f676a9e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1735:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1736 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290cabe3  5576  1736      2 0x00000000
 f679fcb8 00000046 00000007 290cabe3 00000027 f6200280 f6200000 c104e4c4
 f7313a54 f7313a54 00000246 f6200000 f679fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6087cdc f628fcdc f6200000
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1736:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1737 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 215298ab  5912  1737      2 0x00000000
 f6087cb8 00000046 00000007 215298ab 00000035 f6201770 f62014f0 c104e4c4
 f7313a54 f7313a54 00000246 f62014f0 f6087cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6187cdc f679fcdc f62014f0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1737:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1738 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 21535e50  6560  1738      2 0x00000000
 f6187cb8 00000046 00000007 21535e50 00000035 f6202c60 f62029e0 c104e4c4
 f7313a54 f7313a54 00000246 f62029e0 f6187cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6427d60 f6087cdc f62029e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1738:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1739 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 39af5827  5700  1739      2 0x00000000
 f614fa78 00000046 00000007 39af5827 0000000b f6204150 f6203ed0 c104e4c4
 f7313a54 f7313a54 00000246 f6203ed0 f614fabc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f67abdc4 f7313a7c f6203ed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c1102687>] search_by_key+0x247/0x21b0
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c105891b>] ? __module_text_address+0xb/0x50
 [<c1058968>] ? is_module_text_address+0x8/0x10
 [<c103b257>] ? __kernel_text_address+0x47/0x70
 [<c10051a1>] ? print_context_stack+0x41/0xb0
 [<c10042ff>] ? dump_trace+0x7f/0xd0
 [<c104bb6a>] ? __bfs+0x1a/0x200
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c10ebfdf>] reiserfs_read_locked_inode+0x5f/0x5a0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec5af>] reiserfs_iget+0x8f/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1739:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1740 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290bda91  5944  1740      2 0x00000000
 f628fcb8 00000046 00000007 290bda91 00000027 f6205640 f62053c0 c104e4c4
 f7313a54 f7313a54 00000246 f62053c0 f628fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f679fcdc f6017cf8 f62053c0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1740:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1741 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 38f62cfa  6636  1741      2 0x00000000
 f62d3c50 00000046 f62d3c30 38f62cfa 0000000b f6206b30 f62068b0 f62d3c90
 f62d3c58 f62d3c88 00000000 f62d3c90 f62d3c58 c10a4838 f62d3c74 c134dc75
 c10a4830 c27efab8 c27efab8 f6fbbf9c f62d3ca4 f62d3cb0 c134dd00 00000002
Call Trace:
 [<c10a4838>] inode_wait+0x8/0x10
 [<c134dc75>] __wait_on_bit+0x45/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c134dd00>] out_of_line_wait_on_bit+0x60/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c103d530>] ? wake_bit_function+0x0/0x50
 [<c10a51dc>] ifind+0x8c/0xb0
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10a5f90>] iget5_locked+0x40/0x170
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10ec554>] reiserfs_iget+0x34/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1741:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task agetty:1868 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
agetty        D f601a9e0  5444  1868      1 0x00000000
 f6017cd4 00000046 00000007 f601a9e0 c134e72d f601ac60 f601a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f601a9e0 f6017d18 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f628fcdc f5a19dc4 f601a9e0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10e87ab>] reiserfs_lookup+0x5b/0x130
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c109a563>] do_lookup+0x163/0x1c0
 [<c1099eda>] ? generic_permission+0x1a/0xa0
 [<c109c06e>] link_path_walk+0x3be/0xc10
 [<c109ca23>] path_walk+0x43/0xa0
 [<c109cb51>] do_path_lookup+0x51/0x60
 [<c109dc8a>] do_filp_open+0x4fa/0x9f0
 [<c1097229>] ? check_unsafe_exec+0xd9/0x110
 [<c1097c4f>] open_exec+0x2f/0x100
 [<c1097179>] ? check_unsafe_exec+0x29/0x110
 [<c109847b>] do_execve+0xab/0x250
 [<c1008b0d>] sys_execve+0x2d/0x60
 [<c1002b86>] ptregs_execve+0x12/0x18
 [<c1002b10>] ? sysenter_do_call+0x12/0x36
3 locks held by agetty/1868:
 #0:  (&p->cred_guard_mutex){+.+.+.}, at: [<c10972f4>] prepare_bprm_creds+0x24/0x60
 #1:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109a4bb>] do_lookup+0xbb/0x1c0
 #2:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task sshd:1869 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sshd          D be338e6a  6576  1869   1816 0x00000000
 f5a15d78 00000046 ffffffff be338e6a 0000000f f601c150 f601bed0 00000000
 f601c3a4 7fffffff 00000000 f5a15e70 f5a15de8 c134da45 00000000 f5a15d8c
 c104ca3b 00000000 7fffffff 0000000f be3432d8 f601bed0 00000000 00000000
Call Trace:
 [<c134da45>] schedule_timeout+0x125/0x1b0
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c1350152>] ? _raw_spin_unlock_irq+0x22/0x30
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c134d7d0>] wait_for_common+0xd0/0x130
 [<c1024850>] ? default_wake_function+0x0/0x10
 [<c134d8c2>] wait_for_completion+0x12/0x20
 [<c1039709>] call_usermodehelper_exec+0x89/0xb0
 [<c1039471>] ? call_usermodehelper_setup+0x71/0xb0
 [<c134d730>] ? wait_for_common+0x30/0x130
 [<c10398e2>] __request_module+0xa2/0xf0
 [<c10a6136>] ? new_inode+0x76/0x80
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c12cc89f>] __sock_create+0x18f/0x1f0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c12cc967>] sock_create+0x37/0x40
 [<c12ccb1e>] sys_socket+0x3e/0x70
 [<c12ccbb0>] sys_socketcall+0x60/0x270
 [<c1002b43>] ? sysenter_exit+0xf/0x18
 [<c11d5eb4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002b10>] sysenter_do_call+0x12/0x36
no locks held by sshd/1869.
INFO: task modprobe:1871 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe      D be576d77  6740  1871   1870 0x00000000
 f5a19da0 00000046 00000007 be576d77 0000000f f601eb30 f601e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f601e8b0 f5a19de4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6017cf8 f67abdc4 f601e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by modprobe/1871:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task fcron:1872 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fcron         D f62d8000  7144  1872   1636 0x00000000
 f6463d84 00000046 00000007 f62d8000 c134e72d f62d8280 f62d8000 c104e4c4
 f7313a54 f7313a54 00000246 f62d8000 f6463dc8 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f6473d60 f677bcdc f62d8000
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10e87ab>] reiserfs_lookup+0x5b/0x130
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c109a674>] __lookup_hash+0xb4/0x110
 [<c109a6fd>] lookup_hash+0x2d/0x40
 [<c109d90b>] do_filp_open+0x17b/0x9f0
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c10a739a>] ? alloc_fd+0xba/0xf0
 [<c11d6545>] ? strncpy_from_user+0x35/0x60
 [<c109060f>] do_sys_open+0x4f/0x110
 [<c13526a5>] ? do_page_fault+0x155/0x370
 [<c1090739>] sys_open+0x29/0x40
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by fcron/1872:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109d903>] do_filp_open+0x173/0x9f0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task metalog:1558 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
metalog       D 4f4322f1  5448  1558      1 0x00000000
 f6427d3c 00000046 00000007 4f4322f1 00000039 f61cc150 f61cbed0 c104e4c4
 f7313a54 f7313a54 00000246 f61cbed0 f6427d80 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f674bcdc f6187cdc f61cbed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10f7152>] reiserfs_dirty_inode+0x22/0xc0
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c10ade0c>] __mark_inode_dirty+0x2c/0x130
 [<c10a48e2>] file_update_time+0xa2/0x110
 [<c106a199>] __generic_file_aio_write+0x1c9/0x4f0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c106a514>] generic_file_aio_write+0x54/0xb0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c109218c>] do_sync_write+0x9c/0xd0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c10f01d8>] reiserfs_file_write+0x88/0xa0
 [<c1092b5a>] vfs_write+0x9a/0x160
 [<c10f0150>] ? reiserfs_file_write+0x0/0xa0
 [<c1092ccd>] sys_write+0x3d/0x70
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by metalog/1558:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c106a501>] generic_file_aio_write+0x41/0xb0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task ddclient:1588 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ddclient      D f7303ed0  5180  1588      1 0x00000000
 f6103da0 00200046 00000007 f7303ed0 c134e72d f7304150 f7303ed0 c104e4c4
 f7313a54 f7313a54 00200246 f7303ed0 f6103de4 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f7313a7c f6473d60 f7303ed0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10eb0b3>] reiserfs_setattr+0x23/0x290
 [<c134eb15>] ? down_write+0x85/0x90
 [<c10a65e6>] ? notify_change+0x1d6/0x330
 [<c10a64f7>] notify_change+0xe7/0x330
 [<c1091417>] ? do_truncate+0x57/0x90
 [<c1091417>] ? do_truncate+0x57/0x90
 [<c1091421>] do_truncate+0x61/0x90
 [<c109e0bf>] do_filp_open+0x92f/0x9f0
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c10a739a>] ? alloc_fd+0xba/0xf0
 [<c11d6545>] ? strncpy_from_user+0x35/0x60
 [<c109060f>] do_sys_open+0x4f/0x110
 [<c13526a5>] ? do_page_fault+0x155/0x370
 [<c1090739>] sys_open+0x29/0x40
 [<c1002b10>] sysenter_do_call+0x12/0x36
3 locks held by ddclient/1588:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c1091417>] do_truncate+0x57/0x90
 #1:  (&sb->s_type->i_alloc_sem_key#3){+.+...}, at: [<c10a65e6>] notify_change+0x1d6/0x330
 #2:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task svscan:1600 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
svscan        D bea5aec3  5248  1600      1 0x00000000
 f67abda0 00000046 00000007 bea5aec3 0000000b f676eb30 f676e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f676e8b0 f67abde4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f5a19dc4 f614fa9c f676e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by svscan/1600:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task multilog:1615 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
multilog      D 2b1ba5ab  5044  1615   1605 0x00000000
 f6473d3c 00000046 00000007 2b1ba5ab 000000db f66d1770 f66d14f0 c104e4c4
 f7313a54 f7313a54 00000246 f66d14f0 f6473d80 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f6103dc4 f6463da8 f66d14f0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10f7152>] reiserfs_dirty_inode+0x22/0xc0
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c10ade0c>] __mark_inode_dirty+0x2c/0x130
 [<c10a48e2>] file_update_time+0xa2/0x110
 [<c106a199>] __generic_file_aio_write+0x1c9/0x4f0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c106a514>] generic_file_aio_write+0x54/0xb0
 [<c109218c>] do_sync_write+0x9c/0xd0
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c10f01d8>] reiserfs_file_write+0x88/0xa0
 [<c1092b5a>] vfs_write+0x9a/0x160
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c10f0150>] ? reiserfs_file_write+0x0/0xa0
 [<c1092ccd>] sys_write+0x3d/0x70
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by multilog/1615:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c106a501>] generic_file_aio_write+0x41/0xb0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task nfsd:1734 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D f66d68b0  6560  1734      2 0x00000000
 f677bcb8 00000046 00000007 f66d68b0 c134e72d f66d6b30 f66d68b0 c104e4c4
 f7313a54 f7313a54 00000246 f66d68b0 f677bcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6463da8 f674bcdc f66d68b0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1734:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1735 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 11df5955  6940  1735      2 0x00000000
 f674bcb8 00000046 00000007 11df5955 00000051 f676ac60 f676a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f676a9e0 f674bcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f677bcdc f6427d60 f676a9e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1735:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1736 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290cabe3  5576  1736      2 0x00000000
 f679fcb8 00000046 00000007 290cabe3 00000027 f6200280 f6200000 c104e4c4
 f7313a54 f7313a54 00000246 f6200000 f679fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6087cdc f628fcdc f6200000
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1736:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1737 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 215298ab  5912  1737      2 0x00000000
 f6087cb8 00000046 00000007 215298ab 00000035 f6201770 f62014f0 c104e4c4
 f7313a54 f7313a54 00000246 f62014f0 f6087cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6187cdc f679fcdc f62014f0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1737:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1738 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 21535e50  6560  1738      2 0x00000000
 f6187cb8 00000046 00000007 21535e50 00000035 f6202c60 f62029e0 c104e4c4
 f7313a54 f7313a54 00000246 f62029e0 f6187cfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6427d60 f6087cdc f62029e0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1738:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1739 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 39af5827  5700  1739      2 0x00000000
 f614fa78 00000046 00000007 39af5827 0000000b f6204150 f6203ed0 c104e4c4
 f7313a54 f7313a54 00000246 f6203ed0 f614fabc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f67abdc4 f7313a7c f6203ed0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c1102687>] search_by_key+0x247/0x21b0
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c104b5a0>] ? usage_match+0x0/0x20
 [<c105891b>] ? __module_text_address+0xb/0x50
 [<c1058968>] ? is_module_text_address+0x8/0x10
 [<c103b257>] ? __kernel_text_address+0x47/0x70
 [<c10051a1>] ? print_context_stack+0x41/0xb0
 [<c10042ff>] ? dump_trace+0x7f/0xd0
 [<c104bb6a>] ? __bfs+0x1a/0x200
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c10ebfdf>] reiserfs_read_locked_inode+0x5f/0x5a0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec5af>] reiserfs_iget+0x8f/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1739:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1740 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 290bda91  5944  1740      2 0x00000000
 f628fcb8 00000046 00000007 290bda91 00000027 f6205640 f62053c0 c104e4c4
 f7313a54 f7313a54 00000246 f62053c0 f628fcfc c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f679fcdc f6017cf8 f62053c0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10ec5ef>] reiserfs_get_dentry+0x1f/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c105f75b>] ? __call_rcu+0x3b/0x70
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1740:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task nfsd:1741 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd          D 38f62cfa  6636  1741      2 0x00000000
 f62d3c50 00000046 f62d3c30 38f62cfa 0000000b f6206b30 f62068b0 f62d3c90
 f62d3c58 f62d3c88 00000000 f62d3c90 f62d3c58 c10a4838 f62d3c74 c134dc75
 c10a4830 c27efab8 c27efab8 f6fbbf9c f62d3ca4 f62d3cb0 c134dd00 00000002
Call Trace:
 [<c10a4838>] inode_wait+0x8/0x10
 [<c134dc75>] __wait_on_bit+0x45/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c134dd00>] out_of_line_wait_on_bit+0x60/0x70
 [<c10a4830>] ? inode_wait+0x0/0x10
 [<c103d530>] ? wake_bit_function+0x0/0x50
 [<c10a51dc>] ifind+0x8c/0xb0
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10a5f90>] iget5_locked+0x40/0x170
 [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
 [<c10ec554>] reiserfs_iget+0x34/0xb0
 [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
 [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
 [<c1128b85>] exportfs_decode_fh+0x35/0x200
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c133fbc0>] ? cache_check+0x30/0x330
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108cab4>] ? slab_pad_check+0x34/0x120
 [<c11305fa>] ? exp_get_by_name+0x4a/0x70
 [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
 [<c108ce74>] ? check_object+0xe4/0x200
 [<c108d470>] ? init_object+0x40/0x70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c1042de2>] ? prepare_creds+0x22/0x50
 [<c112c3a7>] fh_verify+0x2f7/0x580
 [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
 [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
 [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
 [<c1129055>] nfsd_dispatch+0x95/0x200
 [<c133697a>] svc_process+0x40a/0x730
 [<c1129654>] nfsd+0xa4/0x130
 [<c11295b0>] ? nfsd+0x0/0x130
 [<c103d1fc>] kthread+0x6c/0x80
 [<c103d190>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c
2 locks held by nfsd/1741:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
INFO: task agetty:1868 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
agetty        D f601a9e0  5444  1868      1 0x00000000
 f6017cd4 00000046 00000007 f601a9e0 c134e72d f601ac60 f601a9e0 c104e4c4
 f7313a54 f7313a54 00000246 f601a9e0 f6017d18 c134e6ba 00000000 00000002
 00000000 c1110ed8 f7313a7c c1110ed8 f7313a90 f628fcdc f5a19dc4 f601a9e0
Call Trace:
 [<c134e72d>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
 [<c10e87ab>] reiserfs_lookup+0x5b/0x130
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c109a563>] do_lookup+0x163/0x1c0
 [<c1099eda>] ? generic_permission+0x1a/0xa0
 [<c109c06e>] link_path_walk+0x3be/0xc10
 [<c109ca23>] path_walk+0x43/0xa0
 [<c109cb51>] do_path_lookup+0x51/0x60
 [<c109dc8a>] do_filp_open+0x4fa/0x9f0
 [<c1097229>] ? check_unsafe_exec+0xd9/0x110
 [<c1097c4f>] open_exec+0x2f/0x100
 [<c1097179>] ? check_unsafe_exec+0x29/0x110
 [<c109847b>] do_execve+0xab/0x250
 [<c1008b0d>] sys_execve+0x2d/0x60
 [<c1002b86>] ptregs_execve+0x12/0x18
 [<c1002b10>] ? sysenter_do_call+0x12/0x36
3 locks held by agetty/1868:
 #0:  (&p->cred_guard_mutex){+.+.+.}, at: [<c10972f4>] prepare_bprm_creds+0x24/0x60
 #1:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109a4bb>] do_lookup+0xbb/0x1c0
 #:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>] reiserfs_write_lock_once+0x28/0x50
INFO: task sshd:1869 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sshd          D be338e6a  6576  1869   1816 0x00000000
 f5a15d78 00000046 ffffffff be338e6a 0000000f f601c150 f601bed0 00000000
 f601c3a4 7fffffff 00000000 f5a15e70 f5a15de8 c134da45 00000000 f5a15d8c
 c104ca3b 00000000 7fffffff 0000000f be3432d8 f601bed0 00000000 00000000
Call Trace:
 [<c134da45>] schedule_timeout+0x125/0x1b0
 [<c104ca3b>] ? trace_hardirqs_off+0xb/0x10
 [<c1350152>] ? _raw_spin_unlock_irq+0x22/0x30
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
 [<c134d7d0>] wait_for_common+0xd0/0x130
 [<c1024850>] ? default_wake_function+0x0/0x10
 [<c134d8c2>] wait_for_completion+0x12/0x20
 [<c1039709>] call_usermodehelper_exec+0x89/0xb0
 [<c1039471>] ? call_usermodehelper_setup+0x71/0xb0
 [<c134d730>] ? wait_for_common+0x30/0x130
 [<c10398e2>] __request_module+0xa2/0xf0
 [<c10a6136>] ? new_inode+0x76/0x80
 [<c13501cd>] ? _raw_spin_unlock+0x1d/0x20
 [<c12cc89f>] __sock_create+0x18f/0x1f0
 [<c107b22a>] ? might_fault+0x4a/0xa0
 [<c12cc967>] sock_create+0x37/0x40
 [<c12ccb1e>] sys_socket+0x3e/0x70
 [<c12ccbb0>] sys_socketcall+0x60/0x270
 [<c1002b43>] ? sysenter_exit+0xf/0x18
 [<c11d5eb4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c1002b10>] sysenter_do_call+0x12/0x36
no locks held by sshd/1869.
INFO: task modprobe:1871 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe      D be576d77  6740  1871   1870 0x00000000
 f5a19da0 00000046 00000007 be576d77 0000000f f601eb30 f601e8b0 c104e4c4
 f7313a54 f7313a54 00000246 f601e8b0 f5a19de4 c134e6ba 00000000 00000002
 00000000 c1110f28 f7313a7c c1110f28 f7313a90 f6017cf8 f67abdc4 f601e8b0
Call Trace:
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e6ba>] mutex_lock_nested+0x12a/0x2b0
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] ? reiserfs_write_lock+0x28/0x40
 [<c1110f28>] reiserfs_write_lock+0x28/0x40
 [<c10f068a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042975>] ? T.324+0x15/0x1b0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c1042c55>] ? sched_clock_cpu+0x95/0x110
 [<c1050609>] ? __lock_acquire+0x509/0xa70
 [<c104e202>] ? mark_held_locks+0x62/0x90
 [<c134e491>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e49b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c10a0112>] ? vfs_readdir+0x52/0xa0
 [<c109ff00>] ? filldir+0x0/0xd0
 [<c10f0d67>] reiserfs_readdir+0x17/0x20
 [<c10a0145>] vfs_readdir+0x85/0xa0
 [<c10a0278>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by modprobe/1871:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>] vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40
