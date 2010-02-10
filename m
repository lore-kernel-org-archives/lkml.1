Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab0BJLP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 06:15:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:46244 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab0BJLPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 06:15:55 -0500
Message-ID: <4B7296DF.207@kernel.org>
Date: Wed, 10 Feb 2010 20:22:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Feb 2010 11:15:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.

On 02/09/2010 11:59 PM, Miklos Szeredi wrote:
> On Tue, 09 Feb 2010, Tejun Heo wrote:
> Okay, I'm a bit confused about these offsets.
> 
> Client asks to map a file at an offset.  Server receives offset, may
> change it (but only by multiple of SHMLBA) then returns it to the
> kernel.  The returned offset globally identifies not only the mapped
> region but the page within the region.  Sounds neat.
> 
> But then fuse_do_mmap() goes and changes vma->vm_pgoff, which will
> show up in /proc/PID/maps for example, which is really not nice.
>
> Can't this page ID rather be put in vma->vm_private_data?

Yeah, sure, it can be put anywhere.  I just never thought about it
being visible under /proc.  Will move it inside fuse_dmmap_vm.

> Also can we take this page ID abstraction a step further, and say that
> the ID has nothing to do with the original offset, the only
> requirement is that it'd globally identify all direct mapped pages.
> 
> And the coherency requirements would be satisfied by the
> fuse_dev_mmap() code.  Haven't looked into what that would take, but
> it sounds doable.

The coherency requirement is not really between the address and offset
but virtual addresses different maps which may end up sharing the same
physical page.  On an architecture with virtually indexed but
physically tagged caches, virtual addresses which map to the same page
must end up hitting the same cache group; otherwise, the processor
wouldn't be able to determine whether the two addresses point to the
same page (as only the tags inside the same cache group are matched
against the physical address).

This is achieved by enforcing address to offset alignment.  IOW, all
maps are forced to be SHMLBA aligned to offset so that all maps are
SHMLBA aligned to each other.  And without knowing which maps are
gonna end up sharing which pages beforehand, enforcing SHMLBA
alignment against something is pretty much the only way to achieve
this and that's the reason why something as low level as processor
cache orgnization is exported to userland as SHMLBA for shared memory
in the first place.

FUSE dmmap has exactly the same problem as it basically is a shared
memory implementation with slightly different interface.  Unless we
can know which maps are gonna be shared beforehand, and we can't know
this either for between the client and server or between clients, the
only way to make those shared mappings fall into the same cache slot
is aligning them to address space offsets.

So, I don't think it's feasible to do the address matching from inside
the kernel without a lot of convolution.  The only way to do it would
be adjusting the mapping addresses but this has at least two problems
- 1. the VM layer isn't made that way and virtual address is
determined by vm generic and arch code before ->mmap() is invoked and
can't be changed after that.  2. the SHMLBA alignment is good in the
sense that it gives the userland something to rely on when determining
mapping address for address hint or fixed mapping.  I don't think it
would be wise to break such assumptions which hold for *ALL* existing
memory mappings.

Thanks.

-- 
tejun
