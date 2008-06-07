Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbYFGBFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbYFGBFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYFGBFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:05:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754059AbYFGBFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:05:05 -0400
Date: Fri, 6 Jun 2008 18:04:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com
Subject: Re: [PATCH -mm 06/25] split LRU lists into anon & file sets
Message-Id: <20080606180439.e5954a2e.akpm@linux-foundation.org>
In-Reply-To: <20080606202858.681500833@redhat.com>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.681500833@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 16:28:44 -0400
Rik van Riel <riel@redhat.com> wrote:

> From: Rik van Riel <riel@redhat.com>
> 
> Split the LRU lists in two, one set for pages that are backed by
> real file systems ("file") and one for pages that are backed by
> memory and swap ("anon").  The latter includes tmpfs.
> 
> Eventually mlocked pages will be taken off the LRUs alltogether.
> A patch for that already exists and just needs to be integrated
> into this series.
> 
> This patch mostly has the infrastructure and a basic policy to
> balance how much we scan the anon lists and how much we scan
> the file lists. The big policy changes are in separate patches.
>

The changelogs are a bit scrappy and could do with some care

- stale assertions such as the above

- "From:<random number of spaces>Lee" in various places

- Some have the --- separator and others don't (this trips me up).

- Stuff like "Against: 2.6.26-rc2-mm1" right in the middle of the
  changelog for me to hunt down and squish.

- "TODO:  DEBUGGING ONLY: NOT FOR UPSTREAM MERGE" <<-- what's up with this?

- random Capitalisation in Various patch Titles.

- "V2 -> V3:" logging in the main changelog - not relevant in the
  final commit hence more for me to edit away.

- Strange inventions like "Originally Signed-off-by:"

- please prefer to prefix the patch titles with a suitable subsystem
  identifier.  In this case "vmscan: " would suit.

- Other stuff I forgot.  A general recheck and cleanup would be nice.

  I've actually fixed all ofthe above but I don't yet know whether
  I'll be checking all this in.

> Index: linux-2.6.26-rc2-mm1/fs/proc/proc_misc.c
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/fs/proc/proc_misc.c	2008-05-23 14:21:21.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/fs/proc/proc_misc.c	2008-05-23 14:21:34.000000000 -0400
> @@ -132,6 +132,10 @@ static int meminfo_read_proc(char *page,
>  	unsigned long allowed;
>  	struct vmalloc_info vmi;
>  	long cached;
> +	unsigned long inactive_anon;
> +	unsigned long active_anon;
> +	unsigned long inactive_file;
> +	unsigned long active_file;

Shouldn't this be an array[NR_LRU_LISTS]?

>  /*
>   * display in kilobytes.
> @@ -150,48 +154,61 @@ static int meminfo_read_proc(char *page,
>  
>  	get_vmalloc_info(&vmi);
>  
> +	inactive_anon = global_page_state(NR_INACTIVE_ANON);
> +	active_anon   = global_page_state(NR_ACTIVE_ANON);
> +	inactive_file = global_page_state(NR_INACTIVE_FILE);
> +	active_file   = global_page_state(NR_ACTIVE_FILE);

then this can perhaps become a loop.

>  	/*
>  	 * Tagged format, for easy grepping and expansion.
>  	 */
>  	len = sprintf(page,
> -		"MemTotal:     %8lu kB\n"
> -		"MemFree:      %8lu kB\n"
> -		"Buffers:      %8lu kB\n"
> -		"Cached:       %8lu kB\n"
> -		"SwapCached:   %8lu kB\n"
> -		"Active:       %8lu kB\n"
> -		"Inactive:     %8lu kB\n"
> +		"MemTotal:       %8lu kB\n"
> +		"MemFree:        %8lu kB\n"
> +		"Buffers:        %8lu kB\n"
> +		"Cached:         %8lu kB\n"
> +		"SwapCached:     %8lu kB\n"
> +		"Active:         %8lu kB\n"
> +		"Inactive:       %8lu kB\n"
> +		"Active(anon):   %8lu kB\n"
> +		"Inactive(anon): %8lu kB\n"
> +		"Active(file):   %8lu kB\n"
> +		"Inactive(file): %8lu kB\n"
>  #ifdef CONFIG_HIGHMEM
> -		"HighTotal:    %8lu kB\n"
> -		"HighFree:     %8lu kB\n"
> -		"LowTotal:     %8lu kB\n"
> -		"LowFree:      %8lu kB\n"
> -#endif
> -		"SwapTotal:    %8lu kB\n"
> -		"SwapFree:     %8lu kB\n"
> -		"Dirty:        %8lu kB\n"
> -		"Writeback:    %8lu kB\n"
> -		"AnonPages:    %8lu kB\n"
> -		"Mapped:       %8lu kB\n"
> -		"Slab:         %8lu kB\n"
> -		"SReclaimable: %8lu kB\n"
> -		"SUnreclaim:   %8lu kB\n"
> -		"PageTables:   %8lu kB\n"
> -		"NFS_Unstable: %8lu kB\n"
> -		"Bounce:       %8lu kB\n"
> -		"WritebackTmp: %8lu kB\n"
> -		"CommitLimit:  %8lu kB\n"
> -		"Committed_AS: %8lu kB\n"
> -		"VmallocTotal: %8lu kB\n"
> -		"VmallocUsed:  %8lu kB\n"
> -		"VmallocChunk: %8lu kB\n",
> +		"HighTotal:      %8lu kB\n"
> +		"HighFree:       %8lu kB\n"
> +		"LowTotal:       %8lu kB\n"
> +		"LowFree:        %8lu kB\n"
> +#endif
> +		"SwapTotal:      %8lu kB\n"
> +		"SwapFree:       %8lu kB\n"
> +		"Dirty:          %8lu kB\n"
> +		"Writeback:      %8lu kB\n"
> +		"AnonPages:      %8lu kB\n"
> +		"Mapped:         %8lu kB\n"
> +		"Slab:           %8lu kB\n"
> +		"SReclaimable:   %8lu kB\n"
> +		"SUnreclaim:     %8lu kB\n"
> +		"PageTables:     %8lu kB\n"
> +		"NFS_Unstable:   %8lu kB\n"
> +		"Bounce:         %8lu kB\n"
> +		"WritebackTmp:   %8lu kB\n"
> +		"CommitLimit:    %8lu kB\n"
> +		"Committed_AS:   %8lu kB\n"
> +		"VmallocTotal:   %8lu kB\n"
> +		"VmallocUsed:    %8lu kB\n"
> +		"VmallocChunk:   %8lu kB\n",
>  		K(i.totalram),
>  		K(i.freeram),
>  		K(i.bufferram),
>  		K(cached),
>  		K(total_swapcache_pages),
> -		K(global_page_state(NR_ACTIVE)),
> -		K(global_page_state(NR_INACTIVE)),
> +		K(active_anon   + active_file),
> +		K(inactive_anon + inactive_file),
> +		K(active_anon),
> +		K(inactive_anon),
> +		K(active_file),
> +		K(inactive_file),

Do we really want to put all this stuff into /proc/meminfo?

Would it be better to aggregate it in some manner for meminfo and show
the fine-grained info in /proc/vmstat?



