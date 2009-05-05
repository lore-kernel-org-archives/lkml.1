Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbZEEWST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbZEEWST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZEEWSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:18:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753357AbZEEWSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:18:08 -0400
Date: Tue, 5 May 2009 15:15:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, npiggin@suse.de, gerg@snapgear.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH 3/3] NOMMU: Make the initial mmap allocation excess
 behaviour Kconfig configurable
Message-Id: <20090505151520.070c84c1.akpm@linux-foundation.org>
In-Reply-To: <20090505212648.17034.18375.stgit@warthog.procyon.org.uk>
References: <20090505212638.17034.10989.stgit@warthog.procyon.org.uk>
	<20090505212648.17034.18375.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 May 2009 22:26:48 +0100
David Howells <dhowells@redhat.com> wrote:

> NOMMU mmap() has an option controlled by a sysctl variable that determines
> whether the allocations made by do_mmap_private() should have the excess space
> trimmed off and returned to the allocator.  Make the initial setting of this
> variable a Kconfig configuration option.
> 
> The reason there can be excess space is that the allocator only allocates in
> power-of-2 size chunks, but mmap()'s can be made in sizes that aren't a power
> of 2.
> 
> There are two alternatives:
> 
>  (1) Keep the excess as dead space.  The dead space then remains unused for the
>      lifetime of the mapping.  Mappings of shared objects such as libc, ld.so
>      or busybox's text segment may retain their dead space forever.
> 
>  (2) Return the excess to the allocator.  This means that the dead space is
>      limited to less than a page per mapping, but it means that for a transient
>      process, there's more chance of fragmentation as the excess space may be
>      reused fairly quickly.
> 
> During the boot process, a lot of transient processes are created, and this can
> cause a lot of fragmentation as the pagecache and various slabs grow greatly
> during this time.
> 
> By turning off the trimming of excess space during boot and disabling batching
> of frees, Coldfire can manage to boot.
> 
> A better way of doing things might be to have /sbin/init turn this option off.
> By that point libc, ld.so and init - which are all long-duration processes -
> have all been loaded and trimmed.
> 

Nasty problem.

> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -66,7 +66,7 @@ struct percpu_counter vm_committed_as;
>  int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
>  int sysctl_overcommit_ratio = 50; /* default is 50% */
>  int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
> -int sysctl_nr_trim_pages = 1; /* page trimming behaviour */
> +int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
>  int heap_stack_gap = 0;
>  

But there's a risk of -ENOMEM regression on other system here?

It's unlikely to be a huge problem for real-world embedded developers,
as long as they know about this change.  And because you set the
Kconfig default to "no change" then I guess they'll be none the wiser.

I think that patches 2 and 3 (and #1 unless I reorder and redo things)
are 2.6.30 material.  Agree?

