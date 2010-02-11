Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0BKJvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 04:51:54 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38349 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab0BKJvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 04:51:52 -0500
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Thu, 11 Feb 2010 10:31:44 +0100)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu>
Message-Id: <E1NfVho-0002nJ-V2@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 11 Feb 2010 10:51:28 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Miklos Szeredi wrote:
> On one hand it's simple, on the other it has pretty weird limitations,
> considering that server side mmap shouldn't be mandatory.  But of
> course if server side mmap isn't used, then the SHMLBA limitation is
> not necessary anymore so the implementation could choose an arbitrary
> "offset".
> 
> My biggest gripe with the kernel API is that we shouldn't be calling
> that thing in fuse_mmap_out an offset at all, because it's not and
> it's confusing (like making you set vma->vm_pgoff to that value, which
> is bogus).  Adding a separate "page_id" or whatever would make me
> happy.

And even a page_id is superfluous, since all we want is differentiate
between possibly separate maps for the same file and don't care about
individual pages.

And even differentiating between maps on the same file is only ever
possible for char devs, normal files will only ever have a single map.

So instead of "page_id" it could just be a "map_id", which will be
zero for normal maps, and whatever for /dev/fuse maps.

> And if the server wants to mmap /dev/fuse then it can do that and send
> the result in "dev_offset", to make it clear that it's a different
> offset from the one the client used on the mmap.  And it can even use
> that value as page_id, if it wants to or it can use a different
> page_id.

And there's a weakness in the current server side mmap interface, for
example:

 1) user mmaps region 3-5 (in page index)
      server maps this region at 3-5

 2) user mmaps region 1-7
     server can't tell kernel that it wants to reuse region 3-5 but
     wants to create two other regions

What happens in that case?

On the other hand if the map_id is separate from the dev_offset, then
the server can map the second region as one map and the kernel can
connect it up with the right pages based on the map_id returned in the
MMAP reply.

Thanks,
Miklos
