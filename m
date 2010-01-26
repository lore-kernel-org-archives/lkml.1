Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859Ab0AZNjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab0AZNjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726Ab0AZNjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:39:20 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45776 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab0AZNjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:39:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=K+wzhNn/m0z/rF1eYEo4gvmp8LDV/PKTAHmBwC/VMlAoVBRwTo9mJKCQ8WxYFAF2+d
         yLaIByv6ceqycht3Tp1e9tRoTn5cIpdka6oeqdEmSSr4ldIKPgF/prMvKonZoDJyZSyE
         OYC3HBEXAGOBkPhdcGDeR+2XmD0/G/BQvHeFs=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "A Rojas" <nqn1976list@gmail.com>,
       "Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Eric Anholt" <eric@anholt.net>,
       "Chris Wilson" <chris@chris-wilson.co.uk>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
References: <20100126141055.5AAD.A69D9226@jp.fujitsu.com>
 <op.u64t84zuasvm2a@kedge> <20100126183412.6AC9.A69D9226@jp.fujitsu.com>
Date: Tue, 26 Jan 2010 14:41:54 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: "Roman Jarosz" <kedgedev@gmail.com>
Message-ID: <op.u646z3e7asvm2a@kedge>
In-Reply-To: <20100126183412.6AC9.A69D9226@jp.fujitsu.com>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 12:07:43 +0100, KOSAKI Motohiro  
<kosaki.motohiro@jp.fujitsu.com> wrote:

> (Restore all cc and add Hugh and Chris)
>
>
>> > Hi all,
>> >
>> > Strangely, all reproduce machine are x86_64 with Intel i915. but I  
>> don't
>> > have any solid evidence.
>> > Can anyone please apply following debug patch and reproduce this  
>> issue?
>> >
>> > this patch write some debug message into /var/log/messages.
>> >
>>
>> Here it is
>>
>> Jan 26 09:34:32 kedge kernel: ->fault OOM shmem_fault 1 1
>> Jan 26 09:34:32 kedge kernel: X invoked oom-killer: gfp_mask=0x0,  
>> order=0,
>> oom_adj=0
>> Jan 26 09:34:32 kedge kernel: Pid: 1927, comm: X Not tainted 2.6.33-rc5  
>> #3
>
>
> Very thank you!!
>
> Current status and analysis are
>   - OOM is invoked by VM_FAULT_OOM in page fault
>   - GEM use lots shmem internally. i915 use GEM.
>   - VM_FAULT_OOM is created by shmem.
>   - shmem allocate some memory by using  
> mapping_gfp_mask(inode->i_mapping).
>     and if allocation failed, it can return -ENOMEM and -ENOMEM generate  
> VM_FAULT_OOM.
>   - But, GEM have following code.
>
>
> drm_gem.c drm_gem_object_alloc()
> --------------------
>         obj->filp = shmem_file_setup("drm mm object", size,  
> VM_NORESERVE);
> (snip)
>         /* Basically we want to disable the OOM killer and handle ENOMEM
>          * ourselves by sacrificing pages from cached buffers.
>          * XXX shmem_file_[gs]et_gfp_mask()
>          */
>         mapping_set_gfp_mask(obj->filp->f_path.dentry->d_inode->i_mapping,
>                              GFP_HIGHUSER |
>                              __GFP_COLD |
>                              __GFP_FS |
>                              __GFP_RECLAIMABLE |
>                              __GFP_NORETRY |
>                              __GFP_NOWARN |
>                              __GFP_NOMEMALLOC);
>
>
> This comment is lie. __GFP_NORETY cause ENOMEM to shmem, not GEM itself.
> GEM can't handle nor recover it. I suspect following commit is wrong.
>
> ----------------------------------------------------
> commit 07f73f6912667621276b002e33844ef283d98203
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Mon Sep 14 16:50:30 2009 +0100
>
>     drm/i915: Improve behaviour under memory pressure
>
>     Due to the necessity of having to take the struct_mutex, the i915
>     shrinker can not free the inactive lists if we fail to allocate  
> memory
>     whilst processing a batch buffer, triggering an OOM and an ENOMEM  
> that
>     is reported back to userspace. In order to fare better under such
>     circumstances we need to manually retry a failed allocation after
>     evicting inactive buffers.
>
>     To do so involves 3 steps:
>     1. Marking the backing shm pages as NORETRY.
>     2. Updating the get_pages() callers to evict something on failure  
> and then
>        retry.
>     3. Revamping the evict something logic to be smarter about the  
> required
>        buffer size and prefer to use volatile or clean inactive pages.
>
>     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> ----------------------------------------------------
>
>
> but unfortunatelly it can't revert easily.
> So, Can you please try following partial revert patch?
>
>
>
> From a27115f93d4f3ff6538860e69a7b444761cef91b Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Tue, 26 Jan 2010 19:51:57 +0900
> Subject: [PATCH] Revert NORETRY
>
> ---
>  drivers/gpu/drm/drm_gem.c |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index e9dbb48..8bf3770 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -142,19 +142,6 @@ drm_gem_object_alloc(struct drm_device *dev, size_t  
> size)
>  	if (IS_ERR(obj->filp))
>  		goto free;
> -	/* Basically we want to disable the OOM killer and handle ENOMEM
> -	 * ourselves by sacrificing pages from cached buffers.
> -	 * XXX shmem_file_[gs]et_gfp_mask()
> -	 */
> -	mapping_set_gfp_mask(obj->filp->f_path.dentry->d_inode->i_mapping,
> -			     GFP_HIGHUSER |
> -			     __GFP_COLD |
> -			     __GFP_FS |
> -			     __GFP_RECLAIMABLE |
> -			     __GFP_NORETRY |
> -			     __GFP_NOWARN |
> -			     __GFP_NOMEMALLOC);
> -
>  	kref_init(&obj->refcount);
>  	kref_init(&obj->handlecount);
>  	obj->size = size;

I've applied this patch and I'm testing it right now.
Btw. what this patch will do from user(my) point of view?

Regards
Roman


