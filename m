Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbZAVTku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbZAVTku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZAVTkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:40:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:38697 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZAVTkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:40:41 -0500
Subject: Re: [RFC PATCH 01/19] lockdep: annotate reclaim context
 (__GFP_NOFS)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20090122174052.061744802@chello.nl>
References: <20090122173701.674448070@chello.nl>
	 <20090122174052.061744802@chello.nl>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 20:40:34 +0100
Message-Id: <1232653234.4890.135.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 18:37 +0100, Peter Zijlstra wrote:
>  
> +void lockdep_trace_alloc(gfp_t gfp_mask)
> +{
> +       struct task_struct *curr = current;
> +
> +       /* this guy won't enter reclaim */
> +       if (curr->flags & PF_MEMALLOC)
> +               return;
> +
> +       /* We're only interested __GFP_FS allocations for now */
> +       if (!(gfp_mask & __GFP_FS))
> +               return;
> +
> +       if (unlikely(!debug_locks))
> +               return;
> +       if (DEBUG_LOCKS_WARN_ON(irqs_disabled()))
> +               return;
> +
> +       mark_held_locks(curr, RECLAIM_FS);
> +}

Not quite seeing how this happens though...

[    6.998258] WARNING: at /usr/src/linux-2.6/kernel/lockdep.c:2266 lockdep_trace_alloc+0x58/0x69()                                                             
[    7.003081] Hardware name: To Be Filled By O.E.M.                            
[    7.003081] Modules linked in: shpchp                                        
[    7.003081] Pid: 726, comm: grep Not tainted 2.6.29-rc2-tip #53     
[    7.003081] Call Trace:                                                      
[    7.003081]  [<ffffffff8023fcc0>] warn_slowpath+0xd8/0x114                   
[    7.003081]  [<ffffffff80235dc6>] ? enqueue_task_fair+0x235/0x286            
[    7.003081]  [<ffffffff80261d7f>] ? trace_hardirqs_off+0xd/0xf               
[    7.003081]  [<ffffffff8054fc8a>] ? _spin_unlock_irqrestore+0x3d/0x4c        
[    7.003081]  [<ffffffff8023c1c6>] ? try_to_wake_up+0x2ba/0x2cc               
[    7.003081]  [<ffffffff80262c05>] ? mark_held_locks+0x8a/0xa9                
[    7.003081]  [<ffffffff8054fc91>] ? _spin_unlock_irqrestore+0x44/0x4c        
[    7.003081]  [<ffffffff80262e67>] ? trace_hardirqs_on+0xd/0xf                
[    7.003081]  [<ffffffff802333cd>] ? __wake_up+0x48/0x55                      
[    7.003081]  [<ffffffff80262c7c>] lockdep_trace_alloc+0x58/0x69              
[    7.003081]  [<ffffffff8029e34f>] __alloc_pages_internal+0x72/0x439          
[    7.003081]  [<ffffffff802e6f7e>] ? unlock_buffer+0x17/0x19                  
[    7.003081]  [<ffffffff802e9117>] ? __bread+0x45/0x92                        
[    7.003081]  [<ffffffff803201cf>] ? ext3_get_branch+0x7b/0xee                
[    7.003081]  [<ffffffff8029aae8>] ? mempool_alloc_slab+0x16/0x18             
[    7.003081]  [<ffffffff802c1aee>] __slab_alloc+0x1a2/0x569                   
[    7.003081]  [<ffffffff8029aae8>] ? mempool_alloc_slab+0x16/0x18             
[    7.003081]  [<ffffffff80262c05>] ? mark_held_locks+0x8a/0xa9                
[    7.003081]  [<ffffffff8029aae8>] ? mempool_alloc_slab+0x16/0x18             
[    7.003081]  [<ffffffff802c1f30>] kmem_cache_alloc+0x7b/0xbd                 
[    7.003081]  [<ffffffff8029aae8>] mempool_alloc_slab+0x16/0x18               
[    7.003081]  [<ffffffff8029abce>] mempool_alloc+0x4f/0x107                   
[    7.003081]  [<ffffffff802ea151>] bio_alloc_bioset+0x30/0x106                
[    7.003081]  [<ffffffff802ea2a0>] bio_alloc+0x15/0x24                        
[    7.003081]  [<ffffffff802ed6cf>] mpage_alloc+0x2b/0x86                      
[    7.003081]  [<ffffffff802ee15c>] do_mpage_readpage+0x3f8/0x4eb              
[    7.003081]  [<ffffffff80262e67>] ? trace_hardirqs_on+0xd/0xf                
[    7.003081]  [<ffffffff80298ed9>] ? add_to_page_cache_locked+0x9f/0xae       
[    7.003081]  [<ffffffff802ee37a>] mpage_readpages+0xd4/0x117                 
[    7.003081]  [<ffffffff803217ab>] ? ext3_get_block+0x0/0x101                 
[    7.003081]  [<ffffffff803217ab>] ? ext3_get_block+0x0/0x101                 
[    7.003081]  [<ffffffff8029e3d7>] ? __alloc_pages_internal+0xfa/0x439        
[    7.003081]  [<ffffffff80320e75>] ext3_readpages+0x1f/0x21                   
[    7.003081]  [<ffffffff802a0573>] __do_page_cache_readahead+0x165/0x1fe      
[    7.003081]  [<ffffffff802a0481>] ? __do_page_cache_readahead+0x73/0x1fe     
[    7.003081]  [<ffffffff80298a37>] ? find_get_page+0x0/0xcf                   
[    7.003081]  [<ffffffff802a0667>] do_page_cache_readahead+0x5b/0x68          
[    7.003081]  [<ffffffff802992f3>] filemap_fault+0x16f/0x341                  
[    7.003081]  [<ffffffff802aac3a>] __do_fault+0x59/0x3c5                      
[    7.003081]  [<ffffffff802acdf4>] handle_mm_fault+0x318/0x6a8                
[    7.003081]  [<ffffffff80552337>] do_page_fault+0x1fc/0x213                  
[    7.003081]  [<ffffffff8055031f>] page_fault+0x1f/0x30                       
[    7.003081] ---[ end trace f2b79ed5a3eafb2f ]---  

