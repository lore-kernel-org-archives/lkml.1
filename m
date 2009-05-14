Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbZENRHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbZENRHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbZENRGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:06:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:44697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbZENRGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:06:55 -0400
Message-ID: <4A0C4F67.5080802@kernel.org>
Date: Thu, 14 May 2009 10:05:43 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mel@csn.ul.ie, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       cl@linux-foundation.org, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       rusty@rustcorp.com.au, steiner@sgi.com, rientjes@google.com
Subject: Re: [PATCH 5/5] mm: clear N_HIGH_MEMORY map before se set it again
 -v2
References: <4A05269D.8000701@kernel.org>	<20090512111623.GG25923@csn.ul.ie>	<4A0A64FB.4080504@kernel.org>	<20090513145950.GB28097@csn.ul.ie>	<4A0C4910.7090508@kernel.org>	<4A0C4A2A.6080009@kernel.org> <20090514095414.ba8356e5.akpm@linux-foundation.org>
In-Reply-To: <20090514095414.ba8356e5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 14 May 2009 09:43:22 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> incase some system strange SRAT table. some kind of small range.
>> or with mem= etc
>>
> 
> That description is very hard to understand.  Please provide more details.

if the wrong SRAT table, have small range for some node. that node will not be onlined.
In the early checking, the bit in node_states[N_HIGH_MEMORY] for the node is set even 
that node has less RAM like 1M, and it is not cleared before the bit is set again in 
the following loop according online nodes.

> 
>> Signed-off-by: Yinghai Lu <Yinghai@kernel.org>
>> Tested-by: Jack Steiner <steiner@sgi.com>
> 
> What reason did Jack have to test this?  Perhaps he hit some bug? 
> If so, please fully describe that bug in the changelog.

for some memmoryless node and strange memmap.

> 
> 
>> Index: linux-2.6/mm/page_alloc.c
>> ===================================================================
>> --- linux-2.6.orig/mm/page_alloc.c
>> +++ linux-2.6/mm/page_alloc.c
>> @@ -4041,6 +4047,11 @@ void __init free_area_init_nodes(unsigne
>>  						early_node_map[i].start_pfn,
>>  						early_node_map[i].end_pfn);
>>  
>> +	/*
>> +	 * find_zone_movable_pfns_for_nodes/early_calculate_totalpages init
>> +	 * that node_mask, clear it at first
>> +	 */
>> +	nodes_clear(node_states[N_HIGH_MEMORY]);
>>  	/* Initialise every node */
>>  	mminit_verify_pageflags_layout();
>>  	setup_nr_node_ids();
> 
> If CONFIG_HIGHMEM=n, this will clear the N_NORMAL_MEMORY entry in
> node_states[].  Why is this correct and desirable?

then N_NORMAL_MEMORY == N_HIGH_MEMORY

YH
