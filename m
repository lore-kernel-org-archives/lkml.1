Return-Path: <linux-kernel-owner+w=401wt.eu-S1764340AbYFGBdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764340AbYFGBdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757917AbYFGBXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:23:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957AbYFGBXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:23:16 -0400
Date: Fri, 6 Jun 2008 21:22:31 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 06/25] split LRU lists into anon & file sets
Message-ID: <20080606212231.5a51237c@bree.surriel.com>
In-Reply-To: <20080606180439.e5954a2e.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.681500833@redhat.com>
	<20080606180439.e5954a2e.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 18:04:39 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> The changelogs are a bit scrappy and could do with some care
> 
> - stale assertions such as the above
> 
> - "From:<random number of spaces>Lee" in various places
> 
> - Some have the --- separator and others don't (this trips me up).
> 
> - Stuff like "Against: 2.6.26-rc2-mm1" right in the middle of the
>   changelog for me to hunt down and squish.

I got rid of all of those - until I merged in Lee's latest :(

> - "TODO:  DEBUGGING ONLY: NOT FOR UPSTREAM MERGE" <<-- what's up with this?

I'll remove this one.

> - random Capitalisation in Various patch Titles.
> 
> - "V2 -> V3:" logging in the main changelog - not relevant in the
>   final commit hence more for me to edit away.

I got rid of all of those - again, before merging Lee's latest.
Then I got rid of most of them, but apparently missed a few...

> - Strange inventions like "Originally Signed-off-by:"
> 
> - please prefer to prefix the patch titles with a suitable subsystem
>   identifier.  In this case "vmscan: " would suit.

Will do.

> - Other stuff I forgot.  A general recheck and cleanup would be nice.
> 
>   I've actually fixed all ofthe above but I don't yet know whether
>   I'll be checking all this in.
> 
> > Index: linux-2.6.26-rc2-mm1/fs/proc/proc_misc.c
> > ===================================================================
> > --- linux-2.6.26-rc2-mm1.orig/fs/proc/proc_misc.c	2008-05-23 14:21:21.000000000 -0400
> > +++ linux-2.6.26-rc2-mm1/fs/proc/proc_misc.c	2008-05-23 14:21:34.000000000 -0400
> > @@ -132,6 +132,10 @@ static int meminfo_read_proc(char *page,
> >  	unsigned long allowed;
> >  	struct vmalloc_info vmi;
> >  	long cached;
> > +	unsigned long inactive_anon;
> > +	unsigned long active_anon;
> > +	unsigned long inactive_file;
> > +	unsigned long active_file;
> 
> Shouldn't this be an array[NR_LRU_LISTS]?
> 
> >  /*
> >   * display in kilobytes.
> > @@ -150,48 +154,61 @@ static int meminfo_read_proc(char *page,
> >  
> >  	get_vmalloc_info(&vmi);
> >  
> > +	inactive_anon = global_page_state(NR_INACTIVE_ANON);
> > +	active_anon   = global_page_state(NR_ACTIVE_ANON);
> > +	inactive_file = global_page_state(NR_INACTIVE_FILE);
> > +	active_file   = global_page_state(NR_ACTIVE_FILE);
> 
> then this can perhaps become a loop.

Sure, I can do that.

> >  	/*
> >  	 * Tagged format, for easy grepping and expansion.
> >  	 */
> >  	len = sprintf(page,
> > -		"MemTotal:     %8lu kB\n"
> > -		"MemFree:      %8lu kB\n"
> > -		"Buffers:      %8lu kB\n"
> > -		"Cached:       %8lu kB\n"
> > -		"SwapCached:   %8lu kB\n"
> > -		"Active:       %8lu kB\n"
> > -		"Inactive:     %8lu kB\n"
> > +		"MemTotal:       %8lu kB\n"
> > +		"MemFree:        %8lu kB\n"
> > +		"Buffers:        %8lu kB\n"
> > +		"Cached:         %8lu kB\n"
> > +		"SwapCached:     %8lu kB\n"
> > +		"Active:         %8lu kB\n"
> > +		"Inactive:       %8lu kB\n"
> > +		"Active(anon):   %8lu kB\n"
> > +		"Inactive(anon): %8lu kB\n"
> > +		"Active(file):   %8lu kB\n"
> > +		"Inactive(file): %8lu kB\n"
> >  #ifdef CONFIG_HIGHMEM
> > -		"HighTotal:    %8lu kB\n"
> > -		"HighFree:     %8lu kB\n"
> > -		"LowTotal:     %8lu kB\n"
> > -		"LowFree:      %8lu kB\n"
> > -#endif
> > -		"SwapTotal:    %8lu kB\n"
> > -		"SwapFree:     %8lu kB\n"
> > -		"Dirty:        %8lu kB\n"
> > -		"Writeback:    %8lu kB\n"
> > -		"AnonPages:    %8lu kB\n"
> > -		"Mapped:       %8lu kB\n"
> > -		"Slab:         %8lu kB\n"
> > -		"SReclaimable: %8lu kB\n"
> > -		"SUnreclaim:   %8lu kB\n"
> > -		"PageTables:   %8lu kB\n"
> > -		"NFS_Unstable: %8lu kB\n"
> > -		"Bounce:       %8lu kB\n"
> > -		"WritebackTmp: %8lu kB\n"
> > -		"CommitLimit:  %8lu kB\n"
> > -		"Committed_AS: %8lu kB\n"
> > -		"VmallocTotal: %8lu kB\n"
> > -		"VmallocUsed:  %8lu kB\n"
> > -		"VmallocChunk: %8lu kB\n",
> > +		"HighTotal:      %8lu kB\n"
> > +		"HighFree:       %8lu kB\n"
> > +		"LowTotal:       %8lu kB\n"
> > +		"LowFree:        %8lu kB\n"
> > +#endif
> > +		"SwapTotal:      %8lu kB\n"
> > +		"SwapFree:       %8lu kB\n"
> > +		"Dirty:          %8lu kB\n"
> > +		"Writeback:      %8lu kB\n"
> > +		"AnonPages:      %8lu kB\n"
> > +		"Mapped:         %8lu kB\n"
> > +		"Slab:           %8lu kB\n"
> > +		"SReclaimable:   %8lu kB\n"
> > +		"SUnreclaim:     %8lu kB\n"
> > +		"PageTables:     %8lu kB\n"
> > +		"NFS_Unstable:   %8lu kB\n"
> > +		"Bounce:         %8lu kB\n"
> > +		"WritebackTmp:   %8lu kB\n"
> > +		"CommitLimit:    %8lu kB\n"
> > +		"Committed_AS:   %8lu kB\n"
> > +		"VmallocTotal:   %8lu kB\n"
> > +		"VmallocUsed:    %8lu kB\n"
> > +		"VmallocChunk:   %8lu kB\n",
> >  		K(i.totalram),
> >  		K(i.freeram),
> >  		K(i.bufferram),
> >  		K(cached),
> >  		K(total_swapcache_pages),
> > -		K(global_page_state(NR_ACTIVE)),
> > -		K(global_page_state(NR_INACTIVE)),
> > +		K(active_anon   + active_file),
> > +		K(inactive_anon + inactive_file),
> > +		K(active_anon),
> > +		K(inactive_anon),
> > +		K(active_file),
> > +		K(inactive_file),
> 
> Do we really want to put all this stuff into /proc/meminfo?
>
> Would it be better to aggregate it in some manner for meminfo and show
> the fine-grained info in /proc/vmstat?

Good question.  I believe we'll want the memory usage statistics
in /proc/meminfo, but more temporary internal stuff like 
"writebacktmp" and "nfs_unstable" might not belong there.

-- 
All rights reversed.
