Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbYKSQv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbYKSQv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYKSQvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:51:18 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:64865 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbYKSQvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:51:17 -0500
X-Greylist: delayed 1511 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2008 11:51:17 EST
Subject: Possible memory leak via slub kmem_cache_create
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 19 Nov 2008 16:25:54 +0000
Message-Id: <1227111954.27162.28.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2008 16:25:55.0175 (UTC) FILETIME=[7F1F5F70:01C94A63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cristoph,

I've recently worked on reviving kmemleak (to be posted on LKML this
week) and tried the slub allocator. I got the following report of orphan
objects:

unreferenced object 0xdf80f180 (size 32):                                       
  comm "swapper", pid 1, jiffies 4294937343                                     
  backtrace:                                                                    
    [<c0082f44>] memleak_alloc                                                  
    [<c0080ff0>] __kmalloc                                                      
    [<c019edac>] proto_register                                                 
    [<c001640c>] inet_init                                                      
    [<c001e30c>] do_one_initcall                                                
    [<c0008400>] kernel_init                                                    
    [<c0035aa8>] do_exit                                                        
    [<ffffffff>]                                                                
unreferenced object 0xdf800840 (size 16):                                       
  comm "swapper", pid 1, jiffies 4294937343                                     
  backtrace:                                                                    
    [<c0082f44>] memleak_alloc                                                  
    [<c0080ff0>] __kmalloc                                                      
    [<c019ee3c>] proto_register                                                 
    [<c001640c>] inet_init                                                      
    [<c001e30c>] do_one_initcall                                                
    [<c0008400>] kernel_init                                                    
    [<c0035aa8>] do_exit                                                        
    [<ffffffff>]                                                                

The proto_register() function in net/core/sock.c allocates
request_sock_slab_name and timewait_sock_slab_name to generate the cache
names passed to kmem_cache_create(). However, this function in mm/slub.c
goes on the find_mergeable() route and doesn't update s->name to the
previously allocated pointers. Therefore, kmemleak reports them as
orphan.

It could be worse since proto_unregister() tries to free these pointers
but they don't actually point to the allocated blocks because of the
merging.

A solution could be to pass one of the SLUB_NEVER_MERGE bits to
kmem_cache_create in proto_register(), though none of them has any
meaning for this situation. Otherwise, maybe defining another bit like
SLAB_ALLOCATED_NAME to ensure that kmem_cache_name() returns the same
value.

Or just simplify proto_register() to no longer allocate memory for these
names and it should be stated somewhere that kmem_cache_create() doesn't
necessarily saves the pointer to the name.

Thanks.

-- 
Catalin

