Return-Path: <linux-kernel-owner+w=401wt.eu-S967168AbXILVYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967168AbXILVYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934027AbXILVYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:24:13 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:33505 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934495AbXILVYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:24:10 -0400
Message-ID: <46E858D4.3080902@linux.vnet.ibm.com>
Date: Thu, 13 Sep 2007 02:53:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
CC: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Joachim Deguara <joachim.deguara@amd.com>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Eric Whitney <eric.whitney@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: Kernel Panic - 2.6.23-rc4-mm1 ia64 - was Re: Update:
 [Automatic] NUMA replicated pagecache ...
References: <20070727084252.GA9347@wotan.suse.de> <1186604723.5055.47.camel@localhost> <1186780099.5246.6.camel@localhost> <20070813074351.GA15609@wotan.suse.de> <1189543962.5036.97.camel@localhost> <46E74679.9020805@linux.vnet.ibm.com> <1189604927.5004.12.camel@localhost> <46E7F2D8.3080003@linux.vnet.ibm.com> <1189609787.5004.33.camel@localhost> <20070912154130.GS4835@shadowen.org> <1189626374.5004.61.camel@localhost>
In-Reply-To: <1189626374.5004.61.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Schermerhorn wrote:
> On Wed, 2007-09-12 at 16:41 +0100, Andy Whitcroft wrote:
>> On Wed, Sep 12, 2007 at 11:09:47AM -0400, Lee Schermerhorn wrote:
>>
>>>> Interesting, I don't see a memory controller function in the stack
>>>> trace, but I'll double check to see if I can find some silly race
>>>> condition in there.
>>> right.  I noticed that after I sent the mail.  
>>>
>>> Also, config available at:
>>> http://free.linux.hp.com/~lts/Temp/config-2.6.23-rc4-mm1-gwydyr-nomemcont
>> Be interested to know the outcome of any bisect you do.  Given its
>> tripping in reclaim.
> 
> Problem isolated to memory controller patches.  This patch seems to fix
> this particular problem.  I've only run the test for a few minutes with
> and without memory controller configured, but I did observe reclaim
> kicking in several times.  W/o this patch, system would panic as soon as
> I entered direct/zone reclaim--less than a minute.
> 

Thanks, excellent catch! The patch looks sane.  Thanks for your help in
sorting this issue out. Hmm.. that means I never hit direct/zone reclaim
in my tests (I'll make a mental note to enhance my test cases to cover
this scenario).

> Lee
> --------------------------------
> 
> PATCH 2.6.23-rc4-mm1 Memory Controller:  initialize all scan_controls'
> 	isolate_pages member.
> 
> We need to initialize all scan_controls' isolate_pages member.
> Otherwise, shrink_active_list() attempts to execute at undefined
> location.
> 
> Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
> 
>  mm/vmscan.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: Linux/mm/vmscan.c
> ===================================================================
> --- Linux.orig/mm/vmscan.c	2007-09-10 13:22:21.000000000 -0400
> +++ Linux/mm/vmscan.c	2007-09-12 15:30:27.000000000 -0400
> @@ -1758,6 +1758,7 @@ unsigned long shrink_all_memory(unsigned
>  		.swap_cluster_max = nr_pages,
>  		.may_writepage = 1,
>  		.swappiness = vm_swappiness,
> +		.isolate_pages = isolate_pages_global,
>  	};
> 
>  	current->reclaim_state = &reclaim_state;
> @@ -1941,6 +1942,7 @@ static int __zone_reclaim(struct zone *z
>  					SWAP_CLUSTER_MAX),
>  		.gfp_mask = gfp_mask,
>  		.swappiness = vm_swappiness,
> +		.isolate_pages = isolate_pages_global,
>  	};
>  	unsigned long slab_reclaimable;
> 
> 
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
