Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZBSX16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZBSX16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 18:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZBSX1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 18:27:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325AbZBSX1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 18:27:48 -0500
Date: Thu, 19 Feb 2009 15:27:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: airlied@linux.ie, benh@kernel.crashing.org,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Preserve SHMLBA bits in hash key for _DRM_SHM
 mappings.
Message-Id: <20090219152726.9551fb7a.akpm@linux-foundation.org>
In-Reply-To: <20090218.154102.122148224.davem@davemloft.net>
References: <20090218.154102.122148224.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 15:41:02 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> 
> Platforms such as sparc64 have D-cache aliasing issues.  We
> cannot allow virtual mappings in different contexts to be such
> that two cache lines can be loaded for the same backing data.
> Updates to one cache line won't be seen by accesses to the other
> cache line.
> 
> Code in sparc64 and other architectures solve this problem by
> making sure that all userland mappings of MAP_SHARED objects have
> the same virtual address base.  They implement this by keying
> off of the page offset, and using that to choose a suitably
> consistent virtual address for mmap() requests.
> 
> Making things even worse, getting this wrong on sparc64 can result
> in hangs during DRM lock acquisition.  This is because, at least on
> UltraSPARC-III, normal loads consult the D-cache but atomics such
> as 'cas' (which is what cmpxchg() is implement using) only consult
> the L2 cache.  So if a D-cache alias is inserted, the load can
> see different data than the atomic, and we'll loop forever because
> the atomic compare-and-exchange will never complete successfully.
> 
> So to make this all work properly, we need to make sure that the
> hash address computed by drm_map_handle() preserves the SHMLBA
> relevant bits, and that's what this patch does for _DRM_SHM mappings.
> 
> As a historical note, many years ago this bug didn't exist because we
> used to just use the low 32-bits of the address as the hash and just
> hope for the best.  This preserved the SHMLBA bits properly.  But when
> the hashtab code was added to DRM, this was no longer the case.
> 
> ...
>  
>  #include <linux/vmalloc.h>
> +#include <linux/log2.h>
> +#include <asm/shmparam.h>
>  #include "drmP.h"
>  

The inclusion of asm/shmparam.h direct from a driver is a bit risky. 
It assumes that asm/shmparam.h is compileable in isolation from the
additional things which include/linux/shm.h includes.  In particular,
asm/page.h.

eg:

arch/xtensa/include/asm/shmparam.h
#define SHMLBA  ((PAGE_SIZE > DCACHE_WAY_SIZE)? PAGE_SIZE : DCACHE_WAY_SIZE)


But including linux/shm.h here seems a bit silly.   We'll see..
