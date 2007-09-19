Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbXISByh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbXISByh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 21:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbXISBy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 21:54:28 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:43981 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbXISBy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 21:54:27 -0400
Message-ID: <46F08135.70401@linux.vnet.ibm.com>
Date: Wed, 19 Sep 2007 07:23:57 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, balbir@in.ibm.com,
       clameter@sgi.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc6-mm1 panic (memory controller issue ?)
References: <1190154076.31220.19.camel@dyn9047017100.beaverton.ibm.com> <1190161903.31220.24.camel@dyn9047017100.beaverton.ibm.com>
In-Reply-To: <1190161903.31220.24.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty wrote:
> On Tue, 2007-09-18 at 15:21 -0700, Badari Pulavarty wrote:
>> Hi Balbir,
>>
>> I get following panic from SLUB, while doing simple fsx tests.
>> I haven't used any container/memory controller stuff except 
>> that I configured them in :(
>>
>> Looks like slub doesn't like one of the flags passed in ?
>>
>> Known issue ? Ideas ?
>>
> 
> I think, I found the issue. I am still running tests to
> verify. Does this sound correct ?
> 
> Thanks,
> Badari
> 
> Need to strip __GFP_HIGHMEM flag while passing to mem_container_cache_charge().
> 
> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
>  mm/filemap.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.23-rc6/mm/filemap.c
> ===================================================================
> --- linux-2.6.23-rc6.orig/mm/filemap.c	2007-09-18 12:43:54.000000000 -0700
> +++ linux-2.6.23-rc6/mm/filemap.c	2007-09-18 19:14:44.000000000 -0700
> @@ -441,7 +441,8 @@ int filemap_write_and_wait_range(struct 
>  int add_to_page_cache(struct page *page, struct address_space *mapping,
>  		pgoff_t offset, gfp_t gfp_mask)
>  {
> -	int error = mem_container_cache_charge(page, current->mm, gfp_mask);
> +	int error = mem_container_cache_charge(page, current->mm,
> +			gfp_mask & ~__GFP_HIGHMEM);
>  	if (error)
>  		goto out;
> 
> 
> 

Hi, Badari,

The fix looks correct, radix_tree_preload() does the same thing in
add_to_page_cache(). Thanks for identifying the fix

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
