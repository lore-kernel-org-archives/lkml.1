Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbZFZOoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbZFZOoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbZFZOn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:43:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbZFZOn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:43:56 -0400
Message-ID: <4A44DE14.2080403@redhat.com>
Date: Fri, 26 Jun 2009 09:41:24 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, arjan@infradead.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, npiggin@suse.de,
       linux-ext4@vger.kernel.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
References: <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com> <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu> <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com> <20090625203743.GD6472@mit.edu> <20090625212628.GO3385@webber.adilger.int> <20090625220504.GG6472@mit.edu> <4A43F60D.2040801@redhat.com> <20090626011155.GI6472@mit.edu> <Pine.LNX.4.64.0906260815260.18724@melkki.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0906260815260.18724@melkki.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> Hi Ted,
> 
> On Thu, Jun 25, 2009 at 05:11:25PM -0500, Eric Sandeen wrote:
>>> ecryptfs used to do kmalloc(PAGE_CACHE_SIZE) & virt_to_page on that, and
>>> with SLUB + slub debug, that gave back non-aligned memory, causing
>>> eventual corruption ...
> 
> On Thu, 25 Jun 2009, Theodore Tso wrote:
>> Grumble.  Any chance we could add an kmem_cache option which requires
>> the memory to be aligned?  Otherwise we could rewrite our own sub-page
>> allocator in ext4 that only handled aligned filesystem block sizes
>> (i.e., 1k, 2k, 4k, etc.) but that would be really silly and be extra
>> code that really should be done once at core functionality.
> 
> We alredy have SLAB_HW_ALIGN but I wonder if this is a plain old bug in 
> SLUB. Christoph, Nick, don't we need something like this in the allocator? 
> Eric, does this fix your case?

I'll test it; it'd be great if it did, I'm um, a bit ashamed at how I
fixed it ;)

Thanks!
-Eric

> 			Pekka
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 819f056..7cd1e69 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2400,7 +2400,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
>  	 * user specified and the dynamic determination of cache line size
>  	 * on bootup.
>  	 */
> -	align = calculate_alignment(flags, align, s->objsize);
> +	align = calculate_alignment(flags, align, size);
>  
>  	/*
>  	 * SLUB stores one object immediately after another beginning from

