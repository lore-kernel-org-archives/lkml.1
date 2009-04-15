Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbZDOXIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbZDOXIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbZDOXHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:07:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbZDOXHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:07:46 -0400
Date: Thu, 16 Apr 2009 01:07:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Beregalov <a.beregalov@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-nfs@vger.kernel.org,
       netdev@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [tree] latest kill-the-BKL tree, v12
Message-ID: <20090415230736.GA22710@elte.hu>
References: <1239680065-25013-1-git-send-email-fweisbec@gmail.com> <20090414045109.GA26908@orion> <20090414090146.GH27003@elte.hu> <a4423d670904151558r4252c7eamd115793fb36a9163@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4423d670904151558r4252c7eamd115793fb36a9163@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Beregalov <a.beregalov@gmail.com> wrote:

> 2009/4/14 Ingo Molnar <mingo@elte.hu>:
> >
> > * Alexander Beregalov <a.beregalov@gmail.com> wrote:
> >
> >> On Tue, Apr 14, 2009 at 05:34:22AM +0200, Frederic Weisbecker wrote:
> >> > Ingo,
> >> >
> >> > This small patchset fixes some deadlocks I've faced after trying
> >> > some pressures with dbench on a reiserfs partition.
> >> >
> >> > There is still some work pending such as adding some checks to ensure we
> >> > _always_ release the lock before sleeping, as you suggested.
> >> > Also I have to fix a lockdep warning reported by Alessio Igor Bogani.
> >> > And also some optimizations....
> >> >
> >> > Thanks,
> >> > Frederic.
> >> >
> >> > Frederic Weisbecker (3):
> >> >   kill-the-BKL/reiserfs: provide a tool to lock only once the write lock
> >> >   kill-the-BKL/reiserfs: lock only once in reiserfs_truncate_file
> >> >   kill-the-BKL/reiserfs: only acquire the write lock once in
> >> >     reiserfs_dirty_inode
> >> >
> >> >  fs/reiserfs/inode.c         |   10 +++++++---
> >> >  fs/reiserfs/lock.c          |   26 ++++++++++++++++++++++++++
> >> >  fs/reiserfs/super.c         |   15 +++++++++------
> >> >  include/linux/reiserfs_fs.h |    2 ++
> >> >  4 files changed, 44 insertions(+), 9 deletions(-)
> >> >
> >>
> >> Hi
> >>
> >> The same test - dbench on reiserfs on loop on sparc64.
> >>
> >> [ INFO: possible circular locking dependency detected ]
> >> 2.6.30-rc1-00457-gb21597d-dirty #2
> >
> > I'm wondering ... your version hash suggests you used vanilla
> > upstream as a base for your test. There's a string of other fixes
> > from Frederic in tip:core/kill-the-BKL branch, have you picked them
> > all up when you did your testing?
> >
> > The most coherent way to test this would be to pick up the latest
> > core/kill-the-BKL git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/kill-the-BKL
> >
> 
> I did not know about this branch, now I am testing it and there is 
> no more problem with that testcase (dbench).
> 
> I will continue testing.

thanks for testing it! It seems reiserfs with Frederic's changes 
appears to be more stable now on your system.

I saw your NFS circular locking kill-the-BKL problem report on LKML 
- also attached below.

Hopefully someone on the Cc: list with NFS experience can point out 
the BKL assumption that is causing this.

	Ingo

----- Forwarded message from Alexander Beregalov <a.beregalov@gmail.com> -----

Date: Wed, 15 Apr 2009 22:08:01 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, linux-nfs@vger.kernel.org
Subject: [core/kill-the-BKL] nfs3: possible circular locking dependency

Hi

I have pulled core/kill-the-BKL on top of 2.6.30-rc2.

device: '0:18': device_add

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.30-rc2-00057-g30aa902-dirty #5
-------------------------------------------------------
mount.nfs/1740 is trying to acquire lock:
 (kernel_mutex){+.+.+.}, at: [<00000000006f32dc>] lock_kernel+0x28/0x3c

but task is already holding lock:
 (&type->s_umount_key#24/1){+.+.+.}, at: [<00000000004b88a0>] sget+0x228/0x36c

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&type->s_umount_key#24/1){+.+.+.}:
       [<00000000004776d0>] lock_acquire+0x5c/0x74
       [<0000000000469f5c>] down_write_nested+0x38/0x50
       [<00000000004b88a0>] sget+0x228/0x36c
       [<00000000005688fc>] nfs_get_sb+0x80c/0xa7c
       [<00000000004b7ec8>] vfs_kern_mount+0x44/0xa4
       [<00000000004b7f84>] do_kern_mount+0x30/0xcc
       [<00000000004cf300>] do_mount+0x7c8/0x80c
       [<00000000004ed2a4>] compat_sys_mount+0x224/0x274
       [<0000000000406154>] linux_sparc_syscall32+0x34/0x40

-> #0 (kernel_mutex){+.+.+.}:
       [<00000000004776d0>] lock_acquire+0x5c/0x74
       [<00000000006f0ebc>] mutex_lock_nested+0x48/0x380
       [<00000000006f32dc>] lock_kernel+0x28/0x3c
       [<00000000006d20ec>] rpc_wait_bit_killable+0x64/0x8c
       [<00000000006f0620>] __wait_on_bit+0x64/0xc0
       [<00000000006f06e4>] out_of_line_wait_on_bit+0x68/0x7c
       [<00000000006d2938>] __rpc_execute+0x150/0x2b4
       [<00000000006d2ac0>] rpc_execute+0x24/0x34
       [<00000000006cc338>] rpc_run_task+0x64/0x74
       [<00000000006cc474>] rpc_call_sync+0x58/0x7c
       [<00000000005717b0>] nfs3_rpc_wrapper+0x24/0xa0
       [<0000000000572024>] do_proc_get_root+0x6c/0x10c
       [<00000000005720dc>] nfs3_proc_get_root+0x18/0x5c
       [<000000000056401c>] nfs_get_root+0x34/0x17c
       [<0000000000568adc>] nfs_get_sb+0x9ec/0xa7c
       [<00000000004b7ec8>] vfs_kern_mount+0x44/0xa4
       [<00000000004b7f84>] do_kern_mount+0x30/0xcc
       [<00000000004cf300>] do_mount+0x7c8/0x80c
       [<00000000004ed2a4>] compat_sys_mount+0x224/0x274
       [<0000000000406154>] linux_sparc_syscall32+0x34/0x40

other info that might help us debug this:

1 lock held by mount.nfs/1740:
 #0:  (&type->s_umount_key#24/1){+.+.+.}, at: [<00000000004b88a0>]
sget+0x228/0x36c

stack backtrace:
Call Trace:
 [00000000004755ac] print_circular_bug_tail+0xfc/0x10c
 [0000000000476e24] __lock_acquire+0x12f0/0x1b40
 [00000000004776d0] lock_acquire+0x5c/0x74
 [00000000006f0ebc] mutex_lock_nested+0x48/0x380
 [00000000006f32dc] lock_kernel+0x28/0x3c
 [00000000006d20ec] rpc_wait_bit_killable+0x64/0x8c
 [00000000006f0620] __wait_on_bit+0x64/0xc0
 [00000000006f06e4] out_of_line_wait_on_bit+0x68/0x7c
 [00000000006d2938] __rpc_execute+0x150/0x2b4
 [00000000006d2ac0] rpc_execute+0x24/0x34
 [00000000006cc338] rpc_run_task+0x64/0x74
 [00000000006cc474] rpc_call_sync+0x58/0x7c
 [00000000005717b0] nfs3_rpc_wrapper+0x24/0xa0
 [0000000000572024] do_proc_get_root+0x6c/0x10c
 [00000000005720dc] nfs3_proc_get_root+0x18/0x5c
 [000000000056401c] nfs_get_root+0x34/0x17c
device: '0:19': device_add

----- End forwarded message -----
