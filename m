Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbZGaKRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbZGaKRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 06:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZGaKRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 06:17:12 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:52722 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbZGaKRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 06:17:10 -0400
Subject: Re: Possible memory leak via alloc_pid()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <20090730212956.GA26863@redhat.com>
References: <b0943d9e0907081433y599e6d51j285c390f18d7b32c@mail.gmail.com>
	 <20090729170315.f62066c0.akpm@linux-foundation.org>
	 <20090730212956.GA26863@redhat.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 31 Jul 2009 11:16:38 +0100
Message-Id: <1249035398.29967.8.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2009 10:16:39.0097 (UTC) FILETIME=[FDFEAA90:01CA11C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 23:29 +0200, Oleg Nesterov wrote:
> On 07/29, Andrew Morton wrote:
> > On Wed, 8 Jul 2009 22:33:31 +0100
> > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > This is the gdm fork for starting Xorg (with pid 2739). It first
> > > logged me in automatically, after which I logged out and gdm started
> > > another Xorg. The pid structure for the first Xorg is reported as a
> > > leak. The Xorg with pid 2739 is no longer present on my system.
> > >
> > > Using gdb vmlinux /proc/kcore shows that the pid->count is 2, so
> > > that's why it probably wasn't freed by put_pid():
> > >
> > > (gdb) print ({struct pid}0xc307aa00)
> > > $20 = {count = {counter = 2}, level = 0, tasks = {{first = 0x0}, {
> > >       first = 0x0}, {first = 0x0}}, rcu = {next = 0xc24bfd64,
> > >     func = 0xc0154e90 <delayed_put_pid>}, numbers = {{nr = 2739,
> > >       ns = 0xc0737540, pid_chain = {next = 0x0, pprev = 0x200200}}}}
> > >
> > > Note that kmemleak is aware of and scans pid_hash (which was recorded
> > > in kmemleak as a 16KB object).
> 
> This pid is detached and unhanshed. God knows who did the unbalanced
> get_pid().
> 
> Since you can reproduce the problem easily, perhaps you can use the
> hack above to track get/put ?
> 
> 	$ echo pid_of_Xorg > /proc/sys/kernel/xxx

Below is the minicom capture. By the time Xorg dies, the count is 2.
When logging out, there are two counter incrementing events via
sys_wait4 and sys_ioctl, thoush I'm not sure whether they are
unbalanced.

It was tested on an ARM platform.


pgrep Xorg
1519
10:~# pgrep Xorg > /proc/sys/kernel/xxx 
XXXXX(1519) ==22
XXXXX(1519) ++22
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c01234e9>] (tty_get_pgrp+0x29/0x4c)
[<c01234e9>] (tty_get_pgrp+0x29/0x4c) from [<c009e7cb>] (do_task_stat+0xc3/0x3c4)
[<c009e7cb>] (do_task_stat+0xc3/0x3c4) from [<c009ead7>] (proc_tgid_stat+0xb/0xc)
[<c009ead7>] (proc_tgid_stat+0xb/0xc) from [<c009c6b5>] (proc_single_show+0x35/0x5c)
[<c009c6b5>] (proc_single_show+0x35/0x5c) from [<c0085125>] (seq_read+0x125/0x294)
[<c0085125>] (seq_read+0x125/0x294) from [<c00759c9>] (vfs_read+0x69/0x11c)
[<c00759c9>] (vfs_read+0x69/0x11c) from [<c0075af5>] (sys_read+0x2d/0x48)
[<c0075af5>] (sys_read+0x2d/0x48) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --23
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009e7db>] (do_task_stat+0xd3/0x3c4)
[<c009e7db>] (do_task_stat+0xd3/0x3c4) from [<c009ead7>] (proc_tgid_stat+0xb/0xc)
[<c009ead7>] (proc_tgid_stat+0xb/0xc) from [<c009c6b5>] (proc_single_show+0x35/0x5c)
[<c009c6b5>] (proc_single_show+0x35/0x5c) from [<c0085125>] (seq_read+0x125/0x294)
[<c0085125>] (seq_read+0x125/0x294) from [<c00759c9>] (vfs_read+0x69/0x11c)
[<c00759c9>] (vfs_read+0x69/0x11c) from [<c0075af5>] (sys_read+0x2d/0x48)
[<c0075af5>] (sys_read+0x2d/0x48) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
10:~# ps -e
  PID TTY          TIME CMD
    1 ?        00:00:02 init
    2 ?        00:00:00 kthreadd
    3 ?        00:00:00 ksoftirqd/0
    4 ?        00:00:00 watchdog/0
    5 ?        00:00:00 rcu_sched_grace
    6 ?        00:00:00 events/0
    7 ?        0:00:00 khelper
   10 ?        00:00:00 async/mgr
  136 ?        00:00:00 kblockd/0
  142 ?        00:00:00 ata/0
  143 ?        00:00:00 ata_aux
  147 ?        00:00:00 ksuspend_usbd
  151 ?        00:00:00 khubd
  154 ?        00:00:00 kseriod
  160 ?        00:00:00 kmmcd
  185 ?        00:00:00 khungtaskd
  186 ?        00:00:00 pdflush
  187 ?        00:00:00 pdflush
  188 ?        00:00:00 kswapd0
  275 ?        00:00:00 aio/0
  294 ?        00:00:01 nfsiod
  416 ?        00:00:00 kapmd
  436 ?        00:00:00 scsi_eh_0
  449 ?        00:00:00 mtdblockd
  470 ?        00:00:00 kpsmoused
  503 ?        00:00:00 usbhid_resumer
  519 ?        00:00:04 rpciod/0
  527 ?        00:00:25 kmemleak
  607 ?        00:00:04 udevd
 1141 ?        00:00:00 portmap
 1154 ?        00:00:00 rpc.statd
 1288 ?        00:00:00 dbus-daemon
 1300 ?        00:00:00 lpd
 1316 ?        00:00:00 ntpd
 1330 ?        00:00:01 hald
 1331 ?        00:00:00 hald-runner
 1361 ?        00:00:00 gdm
 1391 tty1     00:00:00 getty
 1393 ttyAMA0  00:00:00 login
 1395 ttyAMA1  00:00:00 getty
 1405 ttyAMA0  00:01:02 bash
 1419 ?        00:00:05 gdm
 1426 tty2     00:00:00 getty
 1519 tty3     00:00:01 Xorg
 1527 ?        00:00:25 gdmgreeter
 1535 ttyAMA0  00:00:00 ps

#
# CM: Xorg logout
#

10:~# XXXXX(1519) ++22
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c0042971>] (find_get_pid+0x25/0x44)
[<c0042971>] (find_get_pid+0x25/0x44) from [<c00393f5>] (sys_wait4+0x55/0x84)
[<c00393f5>] (sys_wait4+0x55/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --23
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c007605d>] (__fput+0xdd/0x160)
[<c007605d>] (__fput+0xdd/0x160) from [<c00760ff>] (fput+0x1f/0x20)
[<c00760ff>] (fput+0x1f/0x20) from [<c0073d51>] (filp_close+0x39/0x40)
[<c0073d51>] (filp_close+0x39/0x40) from [<c0073dbd>] (sys_close+0x65/0x98)
[<c0073dbd>] (sys_close+0x65/0x98) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --22
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c012a8c9>] (vt_ioctl+0xbb5/0x131c)
[<c012a8c9>] (vt_ioctl+0xbb5/0x131c) from [<c0124d65>] (tty_ioctl+0x5d9/0x620)
[<c0124d65>] (tty_ioctl+0x5d9/0x620) from [<c007d705>] (vfs_ioctl+0x15/0x50)
[<c007d705>] (vfs_ioctl+0x15/0x50) from [<c007db8d>] (do_vfs_ioctl+0x3a1/0x3c8)
[<c007db8d>] (do_vfs_ioctl+0x3a1/0x3c8) from [<c007dbd7>] (sys_ioctl+0x23/0x34)
[<c007dbd7>] (sys_ioctl+0x23/0x34) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) ++21
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c012a8e3>] (vt_ioctl+0xbcf/0x131c)
[<c012a8e3>] (vt_ioctl+0xbcf/0x131c) from [<c0124d65>] (tty_ioctl+0x5d9/0x620)
[<c0124d65>] (tty_ioctl+0x5d9/0x620) from [<c007d705>] (vfs_ioctl+0x15/0x50)
[<c007d705>] (vfs_ioctl+0x15/0x50) from [<c007db8d>] (do_vfs_ioctl+0x3a1/0x3c8)
[<c007db8d>] (do_vfs_ioctl+0x3a1/0x3c8) from [<c007dbd7>] (sys_ioctl+0x23/0x34)
[<c007dbd7>] (sys_ioctl+0x23/0x34) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --22
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --21
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --20
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --19
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --18
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --17
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --16
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --15
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --14
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --13
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --12
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --11
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --10
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --9
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --8
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --7
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4)
[<c007f44d>] (__shrink_dcache_sb+0x191/0x1f4) from [<c007f5e1>] (shrink_dcache_parent+0x25/0xb0)
[<c007f5e1>] (shrink_dcache_parent+0x25/0xb0) from [<c009d8f9>] (proc_flush_task+0x79/0x19c)
[<c009d8f9>] (proc_flush_task+0x79/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --6
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c009b20d>] (proc_delete_inode+0x19/0x34)
[<c009b20d>] (proc_delete_inode+0x19/0x34) from [<c0081843>] (generic_delete_inode+0x67/0xc4)
[<c0081843>] (generic_delete_inode+0x67/0xc4) from [<c0080e6b>] (iput+0x3f/0x4c)
[<c0080e6b>] (iput+0x3f/0x4c) from [<c007f205>] (dentry_iput+0x75/0x88)
[<c007f205>] (dentry_iput+0x75/0x88) from [<c007f29d>] (d_kill+0x21/0x40)
[<c007f29d>] (d_kill+0x21/0x40) from [<c0080609>] (dput+0xd9/0xf0)
[<c0080609>] (dput+0xd9/0xf0) from [<c009d937>] (proc_flush_task+0xb7/0x19c)
[<c009d937>] (proc_flush_task+0xb7/0x19c) from [<c00386df>] (release_task+0x27/0x380)
[<c00386df>] (release_task+0x27/0x380) from [<c0038f35>] (wait_consider_task+0x4fd/0x7b8)
[<c0038f35>] (wait_consider_task+0x4fd/0x7b8) from [<c0039279>] (do_wait+0x89/0x1b0)
[<c0039279>] (do_wait+0x89/0x1b0) from [<c0039413>] (sys_wait4+0x73/0x84)
[<c0039413>] (sys_wait4+0x73/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --5
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c003941b>] (sys_wait4+0x7b/0x84)
[<c003941b>] (sys_wait4+0x7b/0x84) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)
XXXXX(1519) --4
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c0042a2d>] (delayed_put_pid+0x9/0xc)
[<c0042a2d>] (delayed_put_pid+0x9/0xc) from [<c0056ecb>] (rcu_process_callbacks+0x43/0x50)
[<c0056ecb>] (rcu_process_callbacks+0x43/0x50) from [<c003aae1>] (__do_softirq+0x75/0xe8)
[<c003aae1>] (__do_softirq+0x75/0xe8) from [<c003ab91>] (irq_exit+0x3d/0x4c)
[<c003ab91>] (irq_exit+0x3d/0x4c) from [<c002703d>] (_text+0x3d/0x50)
[<c002703d>] (_text+0x3d/0x50) from [<c002774d>] (__irq_svc+0x4d/0xbc)
Exception stack(0xc02eff78 to 0xc02effc0)
ff60:                                                       00000001 00000004 
ff80: c02effa8 00249455 c02ee000 c0316f20 c0017c9c c02f2b98 70015e6c 411fc081 
ffa0: 0000001f 00000000 c02ee040 c02effc0 c004c753 c0028c0e 00000033 ffffffff 
[<c002774d>] (__irq_svc+0x4d/0xbc) from [<c0028c0e>] (default_idle+0x1e/0x20)
[<c0028c0e>] (default_idle+0x1e/0x20) from [<c0028f6b>] (cpu_idle+0x33/0x7c)
[<c0028f6b>] (cpu_idle+0x33/0x7c) from [<c01f9a19>] (rest_init+0x51/0x64)
[<c01f9a19>] (rest_init+0x51/0x64) from [<c000881d>] (start_kernel+0x1b5/0x1f8)
[<c000881d>] (start_kernel+0x1b5/0x1f8) from [<7000803b>] (0x7000803b)
XXXXX(1519) --3
[<c002c031>] (unwind_backtrace+0x1/0x80) from [<c01fc323>] (dump_stack+0xb/0xc)
[<c01fc323>] (dump_stack+0xb/0xc) from [<c00429f5>] (put_pid+0x19/0x48)
[<c00429f5>] (put_pid+0x19/0x48) from [<c012a8c9>] (vt_ioctl+0xbb5/0x131c)
[<c012a8c9>] (vt_ioctl+0xbb5/0x131c) from [<c0124d65>] (tty_ioctl+0x5d9/0x620)
[<c0124d65>] (tty_ioctl+0x5d9/0x620) from [<c007d705>] (vfs_ioctl+0x15/0x50)
[<c007d705>] (vfs_ioctl+0x15/0x50) from [<c007db8d>] (do_vfs_ioctl+0x3a1/0x3c8)
[<c007db8d>] (do_vfs_ioctl+0x3a1/0x3c8) from [<c007dbd7>] (sys_ioctl+0x23/0x34)
[<c007dbd7>] (sys_ioctl+0x23/0x34) from [<c0027c41>] (ret_fast_syscall+0x1/0x40)

10:~# echo scan > /sys/kernel/debug/kmemleak
kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
10:~# cat /sys/kernel/debug/kmemleak
unreferenced object 0xdfa30de0 (size 48):
  comm "gdm", pid 1419, jiffies 53918
  hex dump (first 32 bytes):
    02 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 04 24 36 de 25 2a 04 c0  .........$6.%*..
  backtrace:
    [<c00737c3>] __save_stack_trace+0x17/0x1c
    [<c0073895>] create_object+0xcd/0x188
    [<c01f9dfb>] kmemleak_alloc+0x1b/0x3c
    [<c007242d>] kmem_cache_alloc+0xa5/0xb4
    [<c0042a6d>] alloc_pid+0x11/0x22c
    [<c0036685>] copy_process+0x831/0xc90
    [<c0036bcf>] do_fork+0xeb/0x228
    [<c002a4a5>] sys_clone+0x1d/0x20
    [<c0027c41>] ret_fast_syscall+0x1/0x40
    [<ffffffff>] 0xffffffff
10:~# 

-- 
Catalin

