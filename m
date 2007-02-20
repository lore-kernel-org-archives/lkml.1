Return-Path: <linux-kernel-owner+w=401wt.eu-S964983AbXBTPKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983AbXBTPKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964986AbXBTPKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:10:13 -0500
Received: from pat.uio.no ([129.240.10.15]:33374 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964983AbXBTPKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:10:11 -0500
Subject: Re: [PATCH] nfs: init req_lock in nfs_alloc_inode
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070216170532.GA4895@lixom.net>
References: <20070216170532.GA4895@lixom.net>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 10:10:00 -0500
Message-Id: <1171984200.6271.15.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: D9B0750873B0F91D53C9618AB6CF2443D765283A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 327 total 581794 max/h 2803 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 11:05 -0600, Olof Johansson wrote:
> Seems like req_lock is never initialized. CONFIG_DEBUG_SPINLOCK reported:
> 
> BUG: spinlock bad magic on CPU#0, mount/1073
>  lock: c00000007fdca108, .magic: 00000000, .owner: /24576, .owner_cpu: 0
> Call Trace:
> [C00000007E913750] [C0000000000107B4] .show_stack+0x54/0x1f0 (unreliable)
> [C00000007E913800] [C0000000001D2234] .spin_bug+0xa4/0x120
> [C00000007E913890] [C0000000001D247C] ._raw_spin_lock+0xdc/0x1d0
> [C00000007E913930] [C0000000004DF990] ._spin_lock+0x10/0x30
> [C00000007E9139B0] [C00000000017623C] .nfs_sync_mapping_wait+0xac/0x310
> [C00000007E913AA0] [C000000000176F18] .nfs_sync_mapping_range+0x98/0x110
> [C00000007E913B80] [C00000000016CAA0] .nfs_getattr+0x40/0xf0
> [C00000007E913C20] [C0000000000BE668] .vfs_getattr+0x38/0x70
> [C00000007E913CA0] [C0000000000BF05C] .vfs_fstat+0x3c/0x70
> [C00000007E913D30] [C0000000000BF0B8] .sys_fstat64+0x28/0x60
> [C00000007E913E30] [C000000000008608] syscall_exit+0x0/0x40
> 
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> ---
> 
> Trond, is your MAINTAINERS entry up to date? Seems like you mostly post
> from @netapp.com these days.

I tend to be easier to get hold of via the fys.uio.no address, since
that isn't hidden behind a VPN. I use the netapp.com address when
posting patches etc since that is sort of required by the developers
certificate of origin.

> Index: linux-2.6/fs/nfs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/nfs/inode.c
> +++ linux-2.6/fs/nfs/inode.c
> @@ -1123,6 +1123,7 @@ struct inode *nfs_alloc_inode(struct sup
>  	nfsi->flags = 0UL;
>  	nfsi->cache_validity = 0UL;
>  	nfsi->cache_change_attribute = jiffies;
> +	nfsi->req_lock = SPIN_LOCK_UNLOCKED;
>  #ifdef CONFIG_NFS_V3_ACL
>  	nfsi->acl_access = ERR_PTR(-EAGAIN);
>  	nfsi->acl_default = ERR_PTR(-EAGAIN);

As Andrew implied, this spin lock should already be initialised by the
slab allocator in the "init_once" callback. Is this a vanilla kernel, or
do you have any extra patches applied?

Cheers
  Trond

