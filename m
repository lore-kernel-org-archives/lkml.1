Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZKTQPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZKTQPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZKTQPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:15:13 -0500
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:51400 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbZKTQPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:15:12 -0500
From: hooanon05@yahoo.co.jp
To: Catalin Marinas <catalin.marinas@arm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org
Subject: Q, slab, kmemleak_erase() and redzone?
Date: Sat, 21 Nov 2009 01:14:56 +0900
Message-ID: <15109.1258733696@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in short: Is it safe to assign NULL to the un-adjusted pointer in
	  kmemleak_erase()?

in long:
I've met a strange redzone warning at deleting a module.

----------------------------------------------------------------------
slab error in verify_redzone_free(): cache `size-256': memory outside object was overwritten
Pid: 5080, comm: modprobe Not tainted 2.6.32-rc7aufsD #320
Call Trace:
 [<ffffffff811010d1>] ? dbg_redzone2+0x31/0x70
 [<ffffffff81101371>] __slab_error+0x21/0x30
 [<ffffffff811022cd>] cache_free_debugcheck+0x1fd/0x300
 [<ffffffff811041e5>] ? __kmem_cache_destroy+0x65/0x110
 [<ffffffff81103bc0>] kfree+0x1c0/0x260
 [<ffffffff811041e5>] __kmem_cache_destroy+0x65/0x110
 [<ffffffff81104336>] kmem_cache_destroy+0xa6/0x100
 [<ffffffffa03130b4>] au_cache_fin+0xb4/0xf0 [aufs]
 [<ffffffff81458387>] ? _write_unlock+0x57/0x70
 [<ffffffffa0348c75>] aufs_exit+0x15/0x39 [aufs]
 [<ffffffff81095cdb>] sys_delete_module+0x19b/0x260
 [<ffffffff81087e3d>] ? trace_hardirqs_on_caller+0x14d/0x1a0
 [<ffffffff8145797e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff810127c2>] system_call_fastpath+0x16/0x1b
ffff88000e87aa40: redzone 1:0xd84156c5635688c0, redzone 2:0x0.
----------------------------------------------------------------------

When delete_module(2) removes aufs.ko, aufs_exit() calls
kmem_cache_destroy() (SLAB) to remove some aufs specific caches whose
name are NOT 'size-256.' Diving into kmemcache, I found the trigger is
in __kmem_cache_destroy(),
	for_each_online_cpu(i)
	    kfree(cachep->array[i]);
The 'cachep->array[i]' is in 'size-256' cache, and kfree() for it
produced the warning.

At first, I thought I made mistakes in my module and corruped
memory. But I could not find such bug.
Inserting some code to check the correctness of cachep->array[i] for
size-256 everywhere led me to kmemleak_erase() in ____cache_alloc().

__cache_alloc()
{
	objp = __do_cache_alloc(cachep, flags);
	:::
	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
	:::
	return objp;
}

__do_cache_alloc()
{
	:::
	objp = ____cache_alloc(cache, flags);
	:::
	return objp;
}
	
____cache_alloc()
{
	objp = ac->entry[--ac->avail];
	or
	objp = cache_alloc_refill(cachep, flags);
	:::
	kmemleak_erase(&ac->entry[ac->avail]);
	return objp;
}

kmemleak_erase(void **ptr)
{
	*ptr = NULL;
}

cache_alloc_debugcheck_after() adjusts the passed objp by
	objp += obj_offset(cachep);
which is 4 or 8 bytes when CONFIG_DEBUG_SLAB is enabled (also
cache_alloc_refill() may return NULL).
In other words, the passed pointer to kmemleak_erase() is not adjusted
yet.
Is it safe to assign NULL to the un-adjusted pointer in kmemleak_erase()?


J. R. Okajima
