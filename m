Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbZDPQk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbZDPQk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbZDPQkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:40:35 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:57176 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453AbZDPQkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:40:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=AqppttvevoQN8F50m/DIlIHjULiKS89V3lZpT1atY/rUnHP1m8a4l0Rtfx+j7g3hsD
         dsWziM/PxsrO2r8tChIcZBTMUZ3LnDY4PBM35QQukT9j3TRAKA5Qu+/+apYnsGOYz/Wn
         mPzrgLqPrbDjfsJOigewGktBrZ30AMzcixfqM=
Date: Thu, 16 Apr 2009 18:40:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-nfs@vger.kernel.org,
       netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [tree] latest kill-the-BKL tree, v12
Message-ID: <20090416164024.GJ6004@nowhere>
References: <1239680065-25013-1-git-send-email-fweisbec@gmail.com> <20090414045109.GA26908@orion> <20090414090146.GH27003@elte.hu> <a4423d670904151558r4252c7eamd115793fb36a9163@mail.gmail.com> <20090415230736.GA22710@elte.hu> <20090415233533.GA5962@nowhere> <20090416085153.GC9813@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090416085153.GC9813@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 10:51:53AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Thu, Apr 16, 2009 at 01:07:36AM +0200, Ingo Molnar wrote:
> > > 
> > > * Alexander Beregalov <a.beregalov@gmail.com> wrote:
> > > 
> > > > 2009/4/14 Ingo Molnar <mingo@elte.hu>:
> > > > >
> > > > > * Alexander Beregalov <a.beregalov@gmail.com> wrote:
> > > > >
> > > > >> On Tue, Apr 14, 2009 at 05:34:22AM +0200, Frederic Weisbecker wrote:
> > > > >> > Ingo,
> > > > >> >
> > > > >> > This small patchset fixes some deadlocks I've faced after trying
> > > > >> > some pressures with dbench on a reiserfs partition.
> > > > >> >
> > > > >> > There is still some work pending such as adding some checks to ensure we
> > > > >> > _always_ release the lock before sleeping, as you suggested.
> > > > >> > Also I have to fix a lockdep warning reported by Alessio Igor Bogani.
> > > > >> > And also some optimizations....
> > > > >> >
> > > > >> > Thanks,
> > > > >> > Frederic.
> > > > >> >
> > > > >> > Frederic Weisbecker (3):
> > > > >> >   kill-the-BKL/reiserfs: provide a tool to lock only once the write lock
> > > > >> >   kill-the-BKL/reiserfs: lock only once in reiserfs_truncate_file
> > > > >> >   kill-the-BKL/reiserfs: only acquire the write lock once in
> > > > >> >     reiserfs_dirty_inode
> > > > >> >
> > > > >> >  fs/reiserfs/inode.c         |   10 +++++++---
> > > > >> >  fs/reiserfs/lock.c          |   26 ++++++++++++++++++++++++++
> > > > >> >  fs/reiserfs/super.c         |   15 +++++++++------
> > > > >> >  include/linux/reiserfs_fs.h |    2 ++
> > > > >> >  4 files changed, 44 insertions(+), 9 deletions(-)
> > > > >> >
> > > > >>
> > > > >> Hi
> > > > >>
> > > > >> The same test - dbench on reiserfs on loop on sparc64.
> > > > >>
> > > > >> [ INFO: possible circular locking dependency detected ]
> > > > >> 2.6.30-rc1-00457-gb21597d-dirty #2
> > > > >
> > > > > I'm wondering ... your version hash suggests you used vanilla
> > > > > upstream as a base for your test. There's a string of other fixes
> > > > > from Frederic in tip:core/kill-the-BKL branch, have you picked them
> > > > > all up when you did your testing?
> > > > >
> > > > > The most coherent way to test this would be to pick up the latest
> > > > > core/kill-the-BKL git tree from:
> > > > >
> > > > >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/kill-the-BKL
> > > > >
> > > > 
> > > > I did not know about this branch, now I am testing it and there is 
> > > > no more problem with that testcase (dbench).
> > > > 
> > > > I will continue testing.
> > > 
> > > thanks for testing it! It seems reiserfs with Frederic's changes 
> > > appears to be more stable now on your system.
> > 
> > 
> > 
> > 
> > Yeah, thanks a lot for this testing!
> > 
> > 
> >  
> > > I saw your NFS circular locking kill-the-BKL problem report on LKML 
> > > - also attached below.
> > > 
> > > Hopefully someone on the Cc: list with NFS experience can point out 
> > > the BKL assumption that is causing this.
> > > 
> > > 	Ingo
> > > 
> > > ----- Forwarded message from Alexander Beregalov <a.beregalov@gmail.com> -----
> > > 
> > > Date: Wed, 15 Apr 2009 22:08:01 +0400
> > > From: Alexander Beregalov <a.beregalov@gmail.com>
> > > To: linux-kernel <linux-kernel@vger.kernel.org>,
> > > 	Ingo Molnar <mingo@elte.hu>, linux-nfs@vger.kernel.org
> > > Subject: [core/kill-the-BKL] nfs3: possible circular locking dependency
> > > 
> > > Hi
> > > 
> > > I have pulled core/kill-the-BKL on top of 2.6.30-rc2.
> > > 
> > > device: '0:18': device_add
> > > 
> > > =======================================================
> > > [ INFO: possible circular locking dependency detected ]
> > > 2.6.30-rc2-00057-g30aa902-dirty #5
> > > -------------------------------------------------------
> > > mount.nfs/1740 is trying to acquire lock:
> > >  (kernel_mutex){+.+.+.}, at: [<00000000006f32dc>] lock_kernel+0x28/0x3c
> > > 
> > > but task is already holding lock:
> > >  (&type->s_umount_key#24/1){+.+.+.}, at: [<00000000004b88a0>] sget+0x228/0x36c
> > > 
> > > which lock already depends on the new lock.
> > > 
> > > 
> > > the existing dependency chain (in reverse order) is:
> > > 
> > > -> #1 (&type->s_umount_key#24/1){+.+.+.}:
> > >        [<00000000004776d0>] lock_acquire+0x5c/0x74
> > >        [<0000000000469f5c>] down_write_nested+0x38/0x50
> > >        [<00000000004b88a0>] sget+0x228/0x36c
> > >        [<00000000005688fc>] nfs_get_sb+0x80c/0xa7c
> > >        [<00000000004b7ec8>] vfs_kern_mount+0x44/0xa4
> > >        [<00000000004b7f84>] do_kern_mount+0x30/0xcc
> > >        [<00000000004cf300>] do_mount+0x7c8/0x80c
> > >        [<00000000004ed2a4>] compat_sys_mount+0x224/0x274
> > >        [<0000000000406154>] linux_sparc_syscall32+0x34/0x40
> > > 
> > > -> #0 (kernel_mutex){+.+.+.}:
> > >        [<00000000004776d0>] lock_acquire+0x5c/0x74
> > >        [<00000000006f0ebc>] mutex_lock_nested+0x48/0x380
> > >        [<00000000006f32dc>] lock_kernel+0x28/0x3c
> > >        [<00000000006d20ec>] rpc_wait_bit_killable+0x64/0x8c
> > >        [<00000000006f0620>] __wait_on_bit+0x64/0xc0
> > >        [<00000000006f06e4>] out_of_line_wait_on_bit+0x68/0x7c
> > >        [<00000000006d2938>] __rpc_execute+0x150/0x2b4
> > >        [<00000000006d2ac0>] rpc_execute+0x24/0x34
> > >        [<00000000006cc338>] rpc_run_task+0x64/0x74
> > >        [<00000000006cc474>] rpc_call_sync+0x58/0x7c
> > >        [<00000000005717b0>] nfs3_rpc_wrapper+0x24/0xa0
> > >        [<0000000000572024>] do_proc_get_root+0x6c/0x10c
> > >        [<00000000005720dc>] nfs3_proc_get_root+0x18/0x5c
> > >        [<000000000056401c>] nfs_get_root+0x34/0x17c
> > >        [<0000000000568adc>] nfs_get_sb+0x9ec/0xa7c
> > >        [<00000000004b7ec8>] vfs_kern_mount+0x44/0xa4
> > >        [<00000000004b7f84>] do_kern_mount+0x30/0xcc
> > >        [<00000000004cf300>] do_mount+0x7c8/0x80c
> > >        [<00000000004ed2a4>] compat_sys_mount+0x224/0x274
> > >        [<0000000000406154>] linux_sparc_syscall32+0x34/0x40
> > 
> > 
> > 
> > 
> > This is still the dependency between bkl and s_umount_key that has 
> > been reported recently. I wonder if this is not a problem in the 
> > fs layer. I should investigate on it.
> 
> The problem seem to be that this NFS call context:
> 
> -> #0 (kernel_mutex){+.+.+.}:
>        [<00000000004776d0>] lock_acquire+0x5c/0x74
>        [<00000000006f0ebc>] mutex_lock_nested+0x48/0x380
>        [<00000000006f32dc>] lock_kernel+0x28/0x3c
>        [<00000000006d20ec>] rpc_wait_bit_killable+0x64/0x8c
>        [<00000000006f0620>] __wait_on_bit+0x64/0xc0
>        [<00000000006f06e4>] out_of_line_wait_on_bit+0x68/0x7c
>        [<00000000006d2938>] __rpc_execute+0x150/0x2b4
>        [<00000000006d2ac0>] rpc_execute+0x24/0x34
>        [<00000000006cc338>] rpc_run_task+0x64/0x74
>        [<00000000006cc474>] rpc_call_sync+0x58/0x7c
>        [<00000000005717b0>] nfs3_rpc_wrapper+0x24/0xa0
>        [<0000000000572024>] do_proc_get_root+0x6c/0x10c
>        [<00000000005720dc>] nfs3_proc_get_root+0x18/0x5c
>        [<000000000056401c>] nfs_get_root+0x34/0x17c
>        [<0000000000568adc>] nfs_get_sb+0x9ec/0xa7c
>        [<00000000004b7ec8>] vfs_kern_mount+0x44/0xa4
>        [<00000000004b7f84>] do_kern_mount+0x30/0xcc
>        [<00000000004cf300>] do_mount+0x7c8/0x80c
>        [<00000000004ed2a4>] compat_sys_mount+0x224/0x274
>        [<0000000000406154>] linux_sparc_syscall32+0x34/0x40
> 
> Can be called with the BKL held - and then it schedule()s with the 
> BKL held, creating dependencies. I did the quick hack below (a year 
> ago! :-) but indeed that's probably wrong: we just drop and then 
> re-acquire the BKL at a very low level - inverting the dependency 
> chain.


Indeed, the problem remains if we do that :-)


> It's not a problem of the NFS code, it's the probem of 
> vfs_kern_mount taking the BKL.


Yes, and I think the idea of Alessio to remove the Bkl at this level
is the right way. Even though this patch is beeing discussed, I
think it opened the right direction to dig.


> Maybe it would be better if nfs_get_sb() dropped the BKL (knowing 
> that it's called with the BKL held) - since it does not rely on the 
> BKL? Not rpc_wait_bit_killable().


I wonder if it is not dropped because it implicitly protects something else.
May be simply concurrent accesses to the superblock?

Frederic.


> 	Ingo
> 
> -------------->
> From 352e0d25def53e6b36234e4dc2083ca7f5d712a9 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 14 May 2008 17:31:41 +0200
> Subject: [PATCH] remove the BKL: restructure NFS code
> 
> the naked schedule() in rpc_wait_bit_killable() caused the BKL to
> be auto-dropped in the past.
> 
> avoid the immediate hang in such code. Note that this still leaves
> some other locking dependencies to be sorted out in the NFS code.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  net/sunrpc/sched.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
> index 6eab9bf..e12e571 100644
> --- a/net/sunrpc/sched.c
> +++ b/net/sunrpc/sched.c
> @@ -224,9 +224,15 @@ EXPORT_SYMBOL_GPL(rpc_destroy_wait_queue);
>  
>  static int rpc_wait_bit_killable(void *word)
>  {
> +	int bkl = kernel_locked();
> +
>  	if (fatal_signal_pending(current))
>  		return -ERESTARTSYS;
> +	if (bkl)
> +		unlock_kernel();
>  	schedule();
> +	if (bkl)
> +		lock_kernel();


Yeah as you said, it may not drop but invert the dependency.


>  	return 0;
>  }
>  

