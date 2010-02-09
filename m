Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0BIO77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 09:59:59 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57118 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab0BIO76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:59:58 -0500
To: Tejun Heo <tj@kernel.org>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <4B70FBE4.7050700@kernel.org> (message from Tejun Heo on Tue, 09
	Feb 2010 15:08:36 +0900)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org>
Message-Id: <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 09 Feb 2010 15:59:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Feb 2010, Tejun Heo wrote:
> Implement FUSE direct mmap support.  The server can redirect client
> mmap requests to any SHMLBA aligned offset in the custom address space
> attached to the fuse channel.  The address space is managed by the
> server using mmap/munmap(2).  The SHMLBA alignment requirement is
> necessary to avoid cache aliasing issues on archs with virtually
> indexed caches as FUSE direct mmaps are basically shared memory
> between clients and the server.
> 
> The direct mmap address space is backed by pinned kernel pages which
> are allocated on the first fault either from a client or the server.
> If used carelessly, this can easily waste and drain memory.
> Currently, a server must have CAP_SYS_ADMIN to manage dmmap regions by
> mmapping and munmapping the channel fd.

Okay, I'm a bit confused about these offsets.

Client asks to map a file at an offset.  Server receives offset, may
change it (but only by multiple of SHMLBA) then returns it to the
kernel.  The returned offset globally identifies not only the mapped
region but the page within the region.  Sounds neat.

But then fuse_do_mmap() goes and changes vma->vm_pgoff, which will
show up in /proc/PID/maps for example, which is really not nice.

Can't this page ID rather be put in vma->vm_private_data?

Also can we take this page ID abstraction a step further, and say that
the ID has nothing to do with the original offset, the only
requirement is that it'd globally identify all direct mapped pages.

And the coherency requirements would be satisfied by the
fuse_dev_mmap() code.  Haven't looked into what that would take, but
it sounds doable.

That would take the load off userspace having to search for a suitable
offset using some magic architecture dependent constant.

Otherwise I like the interface, it can be extended with fault and
reclaim requests and server side requests to load and save the map
contents as well.

Thanks,
Miklos
