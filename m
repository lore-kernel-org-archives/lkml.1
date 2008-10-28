Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYJ1NBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYJ1NBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 09:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYJ1NAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 09:00:55 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:43040 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbYJ1NAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 09:00:54 -0400
Subject: Re: [PATCH] memory hotplug: fix page_zone() calculation in
	test_pages_isolated()
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       y-goto@jp.fujitsu.com
In-Reply-To: <20081028093224.a0de9f64.kamezawa.hiroyu@jp.fujitsu.com>
References: <4905F114.3030406@de.ibm.com>
	 <1225128359.12673.101.camel@nimitz>
	 <1225130369.20384.33.camel@localhost.localdomain>
	 <20081028093224.a0de9f64.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 14:00:01 +0100
Message-Id: <1225198802.10037.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 09:32 +0900, KAMEZAWA Hiroyuki wrote:
> But
>  - "pfn" and "end_pfn" (and pfn in the middle of them) can be in different zone on strange machine.
> 
> Now: test_pages_isolated() is called in following sequence.
>   
>   check_page_isolated()
>      walk_memory_resource()			# read resource range and get start/end of pfn
>          -> chcek_page_isolated_cb()
> 		-> test_page_isolated().
> 
> I think all pages within [start, end) passed to test_pages_isolated() should be in the same zone.
> 
> please change this to
>   check_page_isolated()
>      walk_memory_resource()
>          -> check_page_isolated_cb()
>                  -> walk_page_range_in_same_zone()  # get page range in the same zone.
>                         -> test_page_isolated().
> 
> Could you try ?

There is already a "same zone" check at the beginning of offline_pages():

>	if (!test_pages_in_a_zone(start_pfn, end_pfn))
>		return -EINVAL;

So we should be safe here, the only problem that I see is that my
zone->lock patch in test_pages_isolated() is broken. As explained,
the pfn used in my page_zone(pfn_to_page(pfn)) is >= end_pfn.

I'll send a new patch to fix this, using __first_valid_page() again,
as described in my reply to Daves mail. The only other solution that
I see would be to remember the first/last !NULL page that was found
inside the for() loop. Not sure which is better, but I think I like
the first one more. Any other ideas?

Thanks,
Gerald


