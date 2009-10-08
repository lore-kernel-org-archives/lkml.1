Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbZJHMNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbZJHMNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757576AbZJHMNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:13:12 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:59615 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbZJHMNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:13:11 -0400
Message-ID: <4ACDD71D.30809@linux.vnet.ibm.com>
Date: Thu, 08 Oct 2009 14:12:13 +0200
From: Gerald Schaefer <geralds@linux.vnet.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Robert Jennings <rcj@linux.vnet.ibm.com>
CC: Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2][v2] powerpc: Make the CMM memory hotplug aware
References: <20091002184458.GC4908@austin.ibm.com> <20091002185248.GD4908@austin.ibm.com>
In-Reply-To: <20091002185248.GD4908@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am currently working on the s390 port for the cmm + hotplug
patch, and I'm a little confused about the memory allocation
policy, see below. Is it correct that the balloon cannot grow
into ZONE_MOVABLE, while the pages for the balloon page list
can?

Robert Jennings wrote:
> @@ -110,6 +125,9 @@ static long cmm_alloc_pages(long nr)
>  	cmm_dbg("Begin request for %ld pages\n", nr);
> 
>  	while (nr) {
> +		if (atomic_read(&hotplug_active))
> +			break;
> +
>  		addr = __get_free_page(GFP_NOIO | __GFP_NOWARN |
>  				       __GFP_NORETRY | __GFP_NOMEMALLOC);
>  		if (!addr)
> @@ -119,8 +137,10 @@ static long cmm_alloc_pages(long nr)
>  		if (!pa || pa->index >= CMM_NR_PAGES) {
>  			/* Need a new page for the page list. */
>  			spin_unlock(&cmm_lock);
> -			npa = (struct cmm_page_array *)__get_free_page(GFP_NOIO | __GFP_NOWARN |
> -								       __GFP_NORETRY | __GFP_NOMEMALLOC);
> +			npa = (struct cmm_page_array *)__get_free_page(
> +					GFP_NOIO | __GFP_NOWARN |
> +					__GFP_NORETRY | __GFP_NOMEMALLOC |
> +					__GFP_MOVABLE);
>  			if (!npa) {
>  				pr_info("%s: Can not allocate new page list\n", __func__);
>  				free_page(addr);

Why is the __GFP_MOVABLE added here, for the page list alloc, and not
above for the balloon page alloc?

--
Regards,
Gerald

