Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZKVJfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZKVJfQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 04:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbZKVJfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 04:35:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:55261 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZKVJfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 04:35:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ORpWVdjkDYDR8kSmE+yAP6e8BUGsyTy+Y+Lzg5AC8sj6uVR1tF9Ow3H44tcZeO/YeH
         v5T3jPfnVplRPe6B5DHsH+VEiWP/qQ5R0fNbPrNPcc1+KKvw9V5O8/eLvEaHKwQiWu2h
         2jNgumA9B0/76rZLK7bw54/hLWFCpVEwvRlss=
MIME-Version: 1.0
In-Reply-To: <15109.1258733696@jrobl>
References: <15109.1258733696@jrobl>
Date: Sun, 22 Nov 2009 11:35:17 +0200
X-Google-Sender-Auth: 668b226e7c78383d
Message-ID: <84144f020911220135l466247c5i9612386fcc30a28c@mail.gmail.com>
Subject: Re: Q, slab, kmemleak_erase() and redzone?
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: hooanon05@yahoo.co.jp
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 6:14 PM,  <hooanon05@yahoo.co.jp> wrote:
> in short: Is it safe to assign NULL to the un-adjusted pointer in
>          kmemleak_erase()?
>
> in long:
> I've met a strange redzone warning at deleting a module.
>
> ----------------------------------------------------------------------
> slab error in verify_redzone_free(): cache `size-256': memory outside object was overwritten
> Pid: 5080, comm: modprobe Not tainted 2.6.32-rc7aufsD #320
> Call Trace:
>  [<ffffffff811010d1>] ? dbg_redzone2+0x31/0x70
>  [<ffffffff81101371>] __slab_error+0x21/0x30
>  [<ffffffff811022cd>] cache_free_debugcheck+0x1fd/0x300
>  [<ffffffff811041e5>] ? __kmem_cache_destroy+0x65/0x110
>  [<ffffffff81103bc0>] kfree+0x1c0/0x260
>  [<ffffffff811041e5>] __kmem_cache_destroy+0x65/0x110
>  [<ffffffff81104336>] kmem_cache_destroy+0xa6/0x100
>  [<ffffffffa03130b4>] au_cache_fin+0xb4/0xf0 [aufs]
>  [<ffffffff81458387>] ? _write_unlock+0x57/0x70
>  [<ffffffffa0348c75>] aufs_exit+0x15/0x39 [aufs]
>  [<ffffffff81095cdb>] sys_delete_module+0x19b/0x260
>  [<ffffffff81087e3d>] ? trace_hardirqs_on_caller+0x14d/0x1a0
>  [<ffffffff8145797e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff810127c2>] system_call_fastpath+0x16/0x1b
> ffff88000e87aa40: redzone 1:0xd84156c5635688c0, redzone 2:0x0.
> ----------------------------------------------------------------------
>
> When delete_module(2) removes aufs.ko, aufs_exit() calls
> kmem_cache_destroy() (SLAB) to remove some aufs specific caches whose
> name are NOT 'size-256.' Diving into kmemcache, I found the trigger is
> in __kmem_cache_destroy(),
>        for_each_online_cpu(i)
>            kfree(cachep->array[i]);
> The 'cachep->array[i]' is in 'size-256' cache, and kfree() for it
> produced the warning.
>
> At first, I thought I made mistakes in my module and corruped
> memory. But I could not find such bug.
> Inserting some code to check the correctness of cachep->array[i] for
> size-256 everywhere led me to kmemleak_erase() in ____cache_alloc().
>
> __cache_alloc()
> {
>        objp = __do_cache_alloc(cachep, flags);
>        :::
>        objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
>        :::
>        return objp;
> }
>
> __do_cache_alloc()
> {
>        :::
>        objp = ____cache_alloc(cache, flags);
>        :::
>        return objp;
> }
>
> ____cache_alloc()
> {
>        objp = ac->entry[--ac->avail];
>        or
>        objp = cache_alloc_refill(cachep, flags);
>        :::
>        kmemleak_erase(&ac->entry[ac->avail]);
>        return objp;
> }
>
> kmemleak_erase(void **ptr)
> {
>        *ptr = NULL;
> }
>
> cache_alloc_debugcheck_after() adjusts the passed objp by
>        objp += obj_offset(cachep);
> which is 4 or 8 bytes when CONFIG_DEBUG_SLAB is enabled (also
> cache_alloc_refill() may return NULL).
> In other words, the passed pointer to kmemleak_erase() is not adjusted
> yet.
> Is it safe to assign NULL to the un-adjusted pointer in kmemleak_erase()?

We are setting an element in the per CPU array to NULL so the the
kmemleak code in ____cache_alloc() is safe. Red-zoning is done at the
_object_ which is not touched by kmemleak. Looking at the oops, it
does seem likely that you have a bug in your module (or in some other
part of the kernel).

                        Pekka
