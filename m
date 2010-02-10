Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0BJL3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 06:29:43 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47424 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab0BJL3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 06:29:41 -0500
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <4B7296DF.207@kernel.org> (message from Tejun Heo on Wed, 10 Feb
	2010 20:22:07 +0900)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org>
Message-Id: <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 10 Feb 2010 12:29:28 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Feb 2010, Tejun Heo wrote:
> > Also can we take this page ID abstraction a step further, and say that
> > the ID has nothing to do with the original offset, the only
> > requirement is that it'd globally identify all direct mapped pages.
> > 
> > And the coherency requirements would be satisfied by the
> > fuse_dev_mmap() code.  Haven't looked into what that would take, but
> > it sounds doable.
> 
> The coherency requirement is not really between the address and offset
> but virtual addresses different maps which may end up sharing the same
> physical page.  On an architecture with virtually indexed but
> physically tagged caches, virtual addresses which map to the same page
> must end up hitting the same cache group; otherwise, the processor
> wouldn't be able to determine whether the two addresses point to the
> same page (as only the tags inside the same cache group are matched
> against the physical address).
> 
> This is achieved by enforcing address to offset alignment.  IOW, all
> maps are forced to be SHMLBA aligned to offset so that all maps are
> SHMLBA aligned to each other.

Okay, lets be a little clearer.  There are client side maps and server
side maps.  Client side maps are naturally aligned (same offset ->
same page).

So that leaves server side maps needing to be aligned to client side
maps.  Since we use the offset into the mmap as the ID, we might as
well just cheat and calculate a maching offset for the server side map
and use that.  I'm not worried about changing vma->vm_pgoff there, if
that's the only way to get proper alignment, since those are not
"proper" mmaps anyway.

> FUSE dmmap has exactly the same problem as it basically is a shared
> memory implementation with slightly different interface.  Unless we
> can know which maps are gonna be shared beforehand, and we can't know
> this either for between the client and server or between clients, the
> only way to make those shared mappings fall into the same cache slot
> is aligning them to address space offsets.

Currently you are aligning client/client maps by changing the
requested offset.  That's like saying: you wanted the file mapped from
offset X, but we mapped it from offset Y because that's better
aligned.  It doesn't make much sense, if the filesystem is doing
something nasty like that, then to hell with cache alignment.

Thanks,
Miklos
