Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbZG2Lzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbZG2Lzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbZG2Lzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:55:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58496 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbZG2Lzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:55:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 29 Jul 2009 20:53:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Mike Smith <scgtrp@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] vmalloc: reorder unmap and removal entry
Message-Id: <20090729205351.9678e7f8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090729094034.GF5856@cr0.nay.redhat.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
	<20090728160527.1da52682.akpm@linux-foundation.org>
	<20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
	<525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
	<20090729123209.690baa48.kamezawa.hiroyu@jp.fujitsu.com>
	<20090729173600.540878a3.kamezawa.hiroyu@jp.fujitsu.com>
	<20090729094034.GF5856@cr0.nay.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 17:40:34 +0800
Amerigo Wang <xiyou.wangcong@gmail.com> wrote:

> On Wed, Jul 29, 2009 at 05:36:00PM +0900, KAMEZAWA Hiroyuki wrote:
> >> I wonder fs/proc/kcore.c's vmalloc area access needs some fix. let me try.
> >> 
> >> Thanks,
> >Finally, I wrote 2 patches. maybe 2/2 is a fix for the bug.
> >but needs comments.
> >
> >Comaparing 2 calls, vfree() and vread()
> >==
> >vfree()
> >  -> __vumap()
> >     -> remove_vm_area()
> >       -> free_unmap_vmap_area         #
> >	 -> try_purge_vmap_area_lazy() #
> >           ->__purge_vmap_area_lazy(); #
> >             -> unmap_vmap_area()      # unmap memory here.
> >       -> write_lock(&vmlist_lock)
> >          remvoe vm_struct from list
> >          write_unlock(&vmlist_lock).
> >==
> >vread()
> > -> read_lock(&vmlist_lock);
> >    get vm_struct -> do memcpy
> >    read_unlock(&vmlist_lock);
> >==
> 
> 
> I think this is a very good catch!
> 
> Your patch looks reasonable for me.
> 
> >
> >Hmm, maybe not related to original bug but above order should be fixed.
> >
> >From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> >vmap area should be purged after vm_struct is removed from the list
> >because vread/vwrite etc...believes the range is valid while it's on
> >vm_struct list.
> >
> >Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> 
> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> Aside, would you like to replace vmlist, a single list, with our
> generic list API? :) Just as you did for kcore. Pls send it in
> a seprate patch.
> 

I'll schedule it up after investigation.  (I'm not sure why private
list handle code is used.) and some pending patchs.

Thanks,
-Kame

> Thanks!
> 
> 
> >---
> > mm/vmalloc.c |   14 +++++++++-----
> > 1 file changed, 9 insertions(+), 5 deletions(-)
> >
> >Index: linux-2.6.31-rc4/mm/vmalloc.c
> >===================================================================
> >--- linux-2.6.31-rc4.orig/mm/vmalloc.c
> >+++ linux-2.6.31-rc4/mm/vmalloc.c
> >@@ -1256,17 +1256,21 @@ struct vm_struct *remove_vm_area(const v
> > 	if (va && va->flags & VM_VM_AREA) {
> > 		struct vm_struct *vm = va->private;
> > 		struct vm_struct *tmp, **p;
> >-
> >-		vmap_debug_free_range(va->va_start, va->va_end);
> >-		free_unmap_vmap_area(va);
> >-		vm->size -= PAGE_SIZE;
> >-
> >+		/*
> >+		 * remove from list and disallow access to this vm_struct
> >+		 * before unmap. (address range confliction is maintained by
> >+		 * vmap.)
> >+		 */
> > 		write_lock(&vmlist_lock);
> > 		for (p = &vmlist; (tmp = *p) != vm; p = &tmp->next)
> > 			;
> > 		*p = tmp->next;
> > 		write_unlock(&vmlist_lock);
> > 
> >+		vmap_debug_free_range(va->va_start, va->va_end);
> >+		free_unmap_vmap_area(va);
> >+		vm->size -= PAGE_SIZE;
> >+
> > 		return vm;
> > 	}
> > 	return NULL;
> >
> 

