Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbZDQSf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbZDQSf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbZDQSfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:35:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35771 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757570AbZDQSfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:35:10 -0400
Date: Fri, 17 Apr 2009 20:34:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Al Viro <viro@ZenIV.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090417183443.GA27120@elte.hu>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416160645.GB17804@elte.hu> <20090416235649.GF26366@ZenIV.linux.org.uk> <20090417000142.GF21405@elte.hu> <20090417001345.GH26366@ZenIV.linux.org.uk> <20090417002744.GB29630@elte.hu> <20090417003805.GI26366@ZenIV.linux.org.uk> <20090417165643.GL8253@elte.hu> <1239987885.23397.4817.camel@laptop> <alpine.LFD.2.00.0904171010470.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904171010470.4042@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 17 Apr 2009, Peter Zijlstra wrote:
> > 
> > Anyway, it seems quite clear that the first thing is to push the current
> > BKL usage down into the filesystems -- which should be somewhat
> > straight-forward.
> 
> Yes, if somebody sends the obvious mechanical patch, we can apply that 
> easily. Then, most common filesystems can probably remove the BKL 
> trivially by maintainers that know that they don't do anything at all with 
> it.
> 
> Of course, right now we do hold the BKL over _multiple_ downcalls, so in 
> that sense it's not actually totally 100% correct and straightforward to 
> just move it down. Eg in the generic_shutdown_super() case we do
> 
> 	lock_kernel();
> 	  ->write_super();
> 	  ->put_super();
> 	invalidate_inodes();
> 	unlock_kernel();
> 
> and obviously if we split it up so that we push a lock_kernel() 
> into both, we end up unlocking in between. I doubt anything cares, 
> but it's still a technical difference.
> 
> There are similar issues with 'remount' holding the BKL over 
> longer sequences.
> 
> Btw, the superblock code really does seem to depend on 
> lock_kernel. Those "sb->s_flags" accesses are literally not 
> protected by anything else afaik.

The very narrow case we want to solve is this place in the NFS code 
that calls schedule() with the BKL held:

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

This creates circular locking if the BKL is a plain mutex and if 
that mutex is dropped there (it's a too lowlevel place with many 
locks held, so a re-acquire inverts the locking dependency).

I.e. the NFS code wants to drop the BKL at a high level, in 
nfs_get_sb() - the NFS folks already confirmed that they have no 
internal BKL dependencies. Preferably by never getting called with 
the BKL held by the VFS layer.

Of course we could hack around it and add an unlock_kernel() 
lock_kernel() pair into nfs_get_sb(), but we thought we'd be kernel 
nice citizens and improve the general situation too :)

	Ingo
