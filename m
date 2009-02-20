Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZBTUYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZBTUYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 15:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZBTUYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 15:24:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbZBTUYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 15:24:06 -0500
Date: Fri, 20 Feb 2009 12:22:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, xfs@oss.sgi.com,
       zohar@linux.vnet.ibm.com
Subject: Re: next-20090220: XFS, IMA: BUG: sleeping function called from
 invalid  context at mm/slub.c:1613
Message-Id: <20090220122242.b36a778f.akpm@linux-foundation.org>
In-Reply-To: <a4423d670902200300n1d1bfdeeg6daca4b32989c9d3@mail.gmail.com>
References: <a4423d670902200300n1d1bfdeeg6daca4b32989c9d3@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 14:00:21 +0300
Alexander Beregalov <a.beregalov@gmail.com> wrote:

> Hi
> 
> I have applied the following patch from Mimi Zohar
> http://marc.info/?l=linux-next&m=123509665514552
> 
> That is why it is dirty.
> The kernel can not boot without it when IMA is enabled.
> 
> 
> BUG: sleeping function called from invalid context at mm/slub.c:1613
> in_atomic(): 1, irqs_disabled(): 0, pid: 1514, name: mkdir
> 3 locks held by mkdir/1514:
>  #0:  (&type->i_mutex_dir_key#2/1){+.+.+.}, at: [<ffffffff802d3460>]
> lookup_create+0x30/0xd0
>  #1:  (&(&ip->i_lock)->mr_lock/1){+.+.+.}, at: [<ffffffff803ca77f>]
> xfs_ilock+0xdf/0x120
>  #2:  (&pag->pag_ici_lock){++++.+}, at: [<ffffffff803caed6>]
> xfs_iget+0x156/0x650
> Pid: 1514, comm: mkdir Not tainted 2.6.29-rc5-next-20090220-dirty #1
> Call Trace:
>  [<ffffffff8026ad33>] ? __debug_show_held_locks+0x13/0x30
>  [<ffffffff80234fe5>] __might_sleep+0x105/0x140
>  [<ffffffff802c6191>] kmem_cache_alloc+0xd1/0x100
>  [<ffffffff8045fb29>] ima_iint_insert+0x49/0xf0
>  [<ffffffff8045fbed>] ima_inode_alloc+0x1d/0x30
>  [<ffffffff802dfa5f>] inode_init_always+0xaf/0x250
>  [<ffffffff803caf86>] xfs_iget+0x206/0x650
>  [<ffffffff803eb8e8>] xfs_trans_iget+0x208/0x250
>  [<ffffffff803ce571>] xfs_ialloc+0xc1/0x700
>  [<ffffffff803ec6f9>] xfs_dir_ialloc+0xa9/0x340
>  [<ffffffff8025e009>] ? down_write_nested+0x79/0x90
>  [<ffffffff803ef0c1>] xfs_create+0x3e1/0x690
>  [<ffffffff803fb813>] xfs_vn_mknod+0x63/0xf0
>  [<ffffffff803fb8ae>] xfs_vn_mkdir+0xe/0x10
>  [<ffffffff802d487c>] vfs_mkdir+0x8c/0xd0
>  [<ffffffff802d6a56>] sys_mkdirat+0x106/0x120
>  [<ffffffff8020bc0c>] ? sysret_check+0x27/0x62
>  [<ffffffff8026c79d>] ? trace_hardirqs_on_caller+0x17d/0x1e0
>  [<ffffffff802d6a83>] sys_mkdir+0x13/0x20
>  [<ffffffff8020bbdb>] system_call_fastpath+0x16/0x1b
> BUG: sleeping function called from invalid context at mm/slub.c:1613

Please do not be tempted to switch ima_iint_insert() to use GFP_ATOMIC
to "fix" this.

Arguably, ima_iint_insert() should requite that the caller pass in the
gfp_t rather than assuming that GFP_KERNEL can be used.  But that is
not a suitable fix for this bug.

We may need to make that change to ima_iint_insert() anyway, as there's
a good chance that callers will require GFP_NOFS.


But to fix this bug, xfs needs to stop calling inode_init_always()
under read_lock().  Because inode_alloc_security() also can sleep (see
new_inode_smack()).

Also, ima_iint_insert() does a radix_tree_lookup() without holding
ima_iint_lock, which appears to be a bug.

