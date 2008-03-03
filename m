Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYCCMl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYCCMl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYCCMlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:41:45 -0500
Received: from ns1.suse.de ([195.135.220.2]:46745 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbYCCMlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:41:44 -0500
Date: Mon, 3 Mar 2008 13:41:42 +0100
From: Nick Piggin <npiggin@suse.de>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [rfc][patch 3/3] use SLAB_ALIGN_SMP
Message-ID: <20080303124142.GB13138@wotan.suse.de>
References: <20080303093449.GA15091@wotan.suse.de> <20080303093624.GC15091@wotan.suse.de> <47CBCAB0.2040604@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47CBCAB0.2040604@cosmosbay.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 10:53:52AM +0100, Eric Dumazet wrote:
> Nick Piggin a écrit :
> >Use SLAB_SMP_ALIGN in a few places.
> >
> >  
> 
> I dont understand why you added SLAB_SMP_ALIGN, without removing 
> SLAB_HWCACHE_ALIGN on these places.

Because I thought that in most of the cases, we also want some cacheline
alignment on UP systems as well because we care about the layout of the
structure WRT the cachelines for the mandatory/capacity miss cases, as
well as wanting to avoid false sharing misses on SMP.

Actually I didn't think _too_ hard about them, possibly some could be
removed. But the problem is that these things do require careful
thought so I should not change them unless I have done that ;)

I guess there are some basic guidelines -- if size is a problem (ie if
there can be lots of these structures), then that is going to be a
factor; if the total pool of objects is likely to be fairly densely
resident in cache, then it will start to favour dense packing rather
than good alignment.

> 
> >Signed-off-by: Nick Piggin <npiggin@suse.de>
> >---
> >Index: linux-2.6/fs/block_dev.c
> >===================================================================
> >--- linux-2.6.orig/fs/block_dev.c
> >+++ linux-2.6/fs/block_dev.c
> >@@ -332,8 +332,8 @@ void __init bdev_cache_init(void)
> > {
> > 	int err;
> > 	bdev_cachep = kmem_cache_create("bdev_cache", sizeof(struct 
> > 	bdev_inode),
> >-			0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
> >-				SLAB_MEM_SPREAD|SLAB_PANIC),
> >+			0, (SLAB_HWCACHE_ALIGN|SLAB_SMP_ALIGN|
> >+			SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|SLAB_PANIC),
> > 			init_once);
> > 	err = register_filesystem(&bd_type);
> > 	if (err)
> >Index: linux-2.6/kernel/fork.c
> >===================================================================
> >--- linux-2.6.orig/kernel/fork.c
> >+++ linux-2.6/kernel/fork.c
> >@@ -1547,23 +1547,23 @@ void __init proc_caches_init(void)
> > {
> > 	sighand_cachep = kmem_cache_create("sighand_cache",
> > 			sizeof(struct sighand_struct), 0,
> >-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU,
> >+		 
> >SLAB_HWCACHE_ALIGN|SLAB_SMP_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU,
> > 			sighand_ctor);
> > 	signal_cachep = kmem_cache_create("signal_cache",
> > 			sizeof(struct signal_struct), 0,
> >-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
> >+			SLAB_HWCACHE_ALIGN|SLAB_SMP_ALIGN|SLAB_PANIC, NULL);
> > 	files_cachep = kmem_cache_create("files_cache",
> > 			sizeof(struct files_struct), 0,
> >-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
> >+			SLAB_HWCACHE_ALIGN|SLAB_SMP_ALIGN|SLAB_PANIC, NULL);
> > 	fs_cachep = kmem_cache_create("fs_cache",
> > 			sizeof(struct fs_struct), 0,
> >-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
> >+			SLAB_HWCACHE_ALIGN|SLAB_SMP_ALIGN|SLAB_PANIC, NULL);
> > 	vm_area_cachep = kmem_cache_create("vm_area_struct",
> > 			sizeof(struct vm_area_struct), 0,
> > 			SLAB_PANIC, NULL);
> > 	mm_cachep = kmem_cache_create("mm_struct",
> > 			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
> >-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
> >+			SLAB_HWCACHE_ALIGN|SLAB_SMP_ALIGN|SLAB_PANIC, NULL);
> > }
> > 
> > /*
> >Index: linux-2.6/kernel/pid.c
> >===================================================================
> >--- linux-2.6.orig/kernel/pid.c
> >+++ linux-2.6/kernel/pid.c
> >@@ -526,5 +526,5 @@ void __init pidmap_init(void)
> > 	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
> > 
> > 	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
> >-			SLAB_HWCACHE_ALIGN | SLAB_PANIC);
> >+			SLAB_HWCACHE_ALIGN | SLAB_SMP_ALIGN | SLAB_PANIC);
> > }
> >Index: linux-2.6/kernel/user.c
> >===================================================================
> >--- linux-2.6.orig/kernel/user.c
> >+++ linux-2.6/kernel/user.c
> >@@ -503,7 +503,7 @@ static int __init uid_cache_init(void)
> > 	int n;
> > 
> > 	uid_cachep = kmem_cache_create("uid_cache", sizeof(struct 
> > 	user_struct),
> >-			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
> >+			0, SLAB_HWCACHE_ALIGN|SLAB_SMP_ALIGN|SLAB_PANIC, 
> >NULL);
> > 
> > 	for(n = 0; n < UIDHASH_SZ; ++n)
> > 		INIT_HLIST_HEAD(init_user_ns.uidhash_table + n);
> >--
> >To unsubscribe from this list: send the line "unsubscribe netdev" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >  
> 
> 
> 
