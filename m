Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab0BPVcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 16:32:22 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:37400 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab0BPVcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 16:32:21 -0500
Message-ID: <4B7B0D75.50808@nortel.com>
Date: Tue, 16 Feb 2010 15:26:13 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: tracking memory usage/leak in "inactive" field in /proc/meminfo?
References: <4B71927D.6030607@nortel.com>	 <20100210093140.12D9.A69D9226@jp.fujitsu.com>	 <4B72E74C.9040001@nortel.com>	 <28c262361002101645g3fd08cc7t6a72d27b1f94db62@mail.gmail.com>	 <4B74524D.8080804@nortel.com> <28c262361002111838q7db763feh851a9bea4fdd9096@mail.gmail.com> <4B7504D2.1040903@nortel.com> <4B796D31.7030006@nortel.com> <4B797D93.5090307@redhat.com> <4B7ACD4A.10101@nortel.com> <4B7AD207.20604@redhat.com>
In-Reply-To: <4B7AD207.20604@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2010 21:32:16.0457 (UTC) FILETIME=[82C2EB90:01CAAF4F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2010 11:12 AM, Rik van Riel wrote:
> On 02/16/2010 11:52 AM, Chris Friesen wrote:
>> On 02/15/2010 11:00 AM, Rik van Riel wrote:
> 
>>> Removal from the LRU is done from the page freeing code, on
>>> the final free of the page.
> 
>> There are a bunch of inline functions involved, but I think the chain
>> from page_remove_rmap() back up to unmap_vmas() looks like this:
>>
>> page_remove_rmap
>> zap_pte_range
>> zap_pmd_range
>> zap_pud_range
>> unmap_page_range
>> unmap_vmas
>>
>> So in this scenario, where do the pages actually get removed from the
>> LRU list (assuming that they're not in use by anyone else)?
> 
> __page_cache_release


For the backtrace scenario I posted it seems like it might actually be
release_pages().  There seems to be a plausible call chain:

__ClearPageLRU
release_pages
free_pages_and_swap_cache
tlb_flush_mmu
tlb_remove_page
zap_pte_range

Does that seem right?  In this case, tlb_remove_page() is called right
after page_remove_rmap() which ultimately results in clearing the
PageAnon bit.

Chris
