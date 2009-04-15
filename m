Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZDOSeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZDOSeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZDOSeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:34:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:60732 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZDOSd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:33:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ewc+YK1IEjbhv7tdKqjeF00VmKCuoiLwtcyzsnoSkDJQoYI6mCSsMiChP3o72ZOPY
	NWugJaMNPlzG3HCCd5bVg==
Date: Wed, 15 Apr 2009 11:33:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nikola Ciprich <extmaillist@linuxbox.cz>,
       David Chinner <david@fromorbit.com>
cc: linux-kernel@vger.kernel.org, nikola.ciprich@linuxbox.cz
Subject: Re: 2.6.29.1: BUG: sleeping function called from invalid context at
 mm/slub.c:1599
In-Reply-To: <20090415145841.GA5106@nik-comp.linuxbox.cz>
Message-ID: <alpine.DEB.2.00.0904151127430.14961@chino.kir.corp.google.com>
References: <20090415145841.GA5106@nik-comp.linuxbox.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009, Nikola Ciprich wrote:

> Hi,
> I've recently installed 2.6.29.1 on one of my machines, and I'm observing following errors:
> 
> [ 5593.311942] BUG: sleeping function called from invalid context at mm/slub.c:1599
> [ 5593.311948] in_atomic(): 1, irqs_disabled(): 0, pid: 5430, name: nfsd

Allocating an object with __GFP_WAIT while in_atomic().

> [ 5593.311950] 4 locks held by nfsd/5430:
> [ 5593.311952]  #0:  (hash_sem){....}, at: [<ffffffffa03cb360>] exp_readlock+0x10/0x20 [nfsd]
> [ 5593.311971]  #1:  (&type->i_mutex_dir_key#6/1){....}, at: [<ffffffffa03c97e9>] nfsd_create_v3+0x309/0x490 [nfsd]
> [ 5593.311987]  #2:  (&(&ip->i_lock)->mr_lock/1){....}, at: [<ffffffffa0492352>] xfs_ilock+0x82/0xa0 [xfs]
> [ 5593.312022]  #3:  (&pag->pag_ici_lock){....}, at: [<ffffffffa04928e3>] xfs_iget+0x113/0x5f0 [xfs]

Holding pag->pag_ici_lock, meaning this is atomic.

> [ 5593.312046] Pid: 5430, comm: nfsd Not tainted 2.6.29lb.00_01_PRE13 #1
> [ 5593.312048] Call Trace:
> [ 5593.312056]  [<ffffffff80268a15>] ? __debug_show_held_locks+0x15/0x30
> [ 5593.312061]  [<ffffffff80237611>] __might_sleep+0x101/0x130
> [ 5593.312065]  [<ffffffff802c5ce1>] kmem_cache_alloc+0x91/0xd0
> [ 5593.312071]  [<ffffffff803501b0>] selinux_inode_alloc_security+0x40/0xa0

This is a GFP_NOFS allocation, which sets __GFP_WAIT.

David, do you think this could be related to holding pag->pag_ici_lock 
while calling xfs_iget_cache_hit() in 
6441e549157b749bae003cce70b4c8b62e4801fa?

> [ 5593.312075]  [<ffffffff80347e7c>] security_inode_alloc+0x1c/0x20
> [ 5593.312079]  [<ffffffff802e2cab>] inode_init_always+0xcb/0x250
> [ 5593.312099]  [<ffffffffa0492997>] xfs_iget+0x1c7/0x5f0 [xfs]
> [ 5593.312119]  [<ffffffffa04ab725>] xfs_trans_iget+0xd5/0x100 [xfs]
> [ 5593.312138]  [<ffffffffa0497006>] xfs_ialloc+0xb6/0x680 [xfs]
> [ 5593.312157]  [<ffffffffa04ac1ff>] xfs_dir_ialloc+0x7f/0x2e0 [xfs]
> [ 5593.312163]  [<ffffffff804dc29b>] ? __down_write+0xb/0x10
> [ 5593.312166]  [<ffffffff8025e240>] ? down_write_nested+0x50/0x60
> [ 5593.312185]  [<ffffffffa04ae572>] xfs_create+0x2a2/0x470 [xfs]
> [ 5593.312205]  [<ffffffffa04b9e5b>] xfs_vn_mknod+0x14b/0x250 [xfs]
> [ 5593.312224]  [<ffffffffa04b9f7b>] xfs_vn_create+0xb/0x10 [xfs]
> [ 5593.312228]  [<ffffffff802d761b>] vfs_create+0xeb/0x1a0
> [ 5593.312239]  [<ffffffffa03c96b9>] nfsd_create_v3+0x1d9/0x490 [nfsd]
> [ 5593.312252]  [<ffffffffa03d0888>] nfsd3_proc_create+0x118/0x1a0 [nfsd]
> [ 5593.312264]  [<ffffffffa03c2265>] nfsd_dispatch+0xb5/0x230 [nfsd]
> [ 5593.312285]  [<ffffffffa0308afe>] svc_process+0x45e/0x760 [sunrpc]
> [ 5593.312296]  [<ffffffffa03c29cb>] nfsd+0x18b/0x2c0 [nfsd]
> [ 5593.312307]  [<ffffffffa03c2840>] ? nfsd+0x0/0x2c0 [nfsd]
> [ 5593.312311]  [<ffffffff80259fcd>] kthread+0x4d/0x80
> [ 5593.312315]  [<ffffffff8020caba>] child_rip+0xa/0x20
> [ 5593.312318]  [<ffffffff80259f80>] ? kthread+0x0/0x80
> [ 5593.312321]  [<ffffffff8020cab0>] ? child_rip+0x0/0x20
> 
