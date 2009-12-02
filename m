Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbZLBE6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbZLBE6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbZLBE6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:58:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbZLBE6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:58:17 -0500
Message-ID: <4B15F3B1.9020600@redhat.com>
Date: Tue, 01 Dec 2009 23:57:21 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Larry Woodman <lwoodman@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] Replace page_mapping_inuse() with page_mapped()
References: <20091202115358.5C4F.A69D9226@jp.fujitsu.com> <4B15D9F8.9090800@redhat.com> <20091202121152.5C52.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091202121152.5C52.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2009 10:28 PM, KOSAKI Motohiro wrote:
>> On 12/01/2009 09:55 PM, KOSAKI Motohiro wrote:
>>      
>>>> btw, current shrink_active_list() have unnecessary page_mapping_inuse() call.
>>>> it prevent to drop page reference bit from unmapped cache page. it mean
>>>> we protect unmapped cache page than mapped page. it is strange.
>>>>
>>>>          
>>> How about this?
>>>
>>> ---------------------------------
>>> SplitLRU VM replacement algorithm assume shrink_active_list() clear
>>> the page's reference bit. but unnecessary page_mapping_inuse() test
>>> prevent it.
>>>
>>> This patch remove it.
>>>
>>>        
>> Shrink_page_list ignores the referenced bit on pages
>> that are !page_mapping_inuse().
>>
>>                   if (sc->order<= PAGE_ALLOC_COSTLY_ORDER&&
>>                                           referenced&&
>> page_mapping_inuse(page)
>> &&  !(vm_flags&  VM_LOCKED))
>>                           goto activate_locked;
>>
>> The reason we leave the referenced bit on unmapped
>> pages is that we want the next reference to a deactivated
>> page cache page to move that page back to the active
>> list.  We do not want to require that such a page gets
>> accessed twice before being reactivated while on the
>> inactive list, because (1) we know it was a frequently
>> accessed page already and (2) ongoing streaming IO
>> might evict it from the inactive list before it gets accessed
>> twice.
>>
>> Arguably, we should just replace the page_mapping_inuse()
>> in both places with page_mapped() to simplify things.
>>      
> Ah, yes. /me was slept. thanks correct me.
>
>
>  From 61340720e6e66b645db8d5410e89fd3b67eda907 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Date: Wed, 2 Dec 2009 12:05:26 +0900
> Subject: [PATCH] Replace page_mapping_inuse() with page_mapped()
>
> page reclaim logic need to distingish mapped and unmapped pages.
> However page_mapping_inuse() don't provide proper test way. it test
> the address space (i.e. file) is mmpad(). Why `page' reclaim need
> care unrelated page's mapped state? it's unrelated.
>
> Thus, This patch replace page_mapping_inuse() with page_mapped()
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>    
Reviewed-by: Rik van Riel <riel@redhat.com>
