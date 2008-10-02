Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYJBP1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYJBP1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYJBP06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:26:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42949 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYJBP05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:26:57 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <7969951.1222961144280.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 3 Oct 2008 00:25:44 +0900 (JST)
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: Re: [PATCH 4/4] capture pages freed during direct reclaim for allocation by the reclaimer
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081002150221.GF11089@brain>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <20081002150221.GF11089@brain>
 <1222864261-22570-1-git-send-email-apw@shadowen.org> <1222864261-22570-5-git-send-email-apw@shadowen.org> <20081002162414.03470f46.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----

>On Thu, Oct 02, 2008 at 04:24:14PM +0900, KAMEZAWA Hiroyuki wrote:
>> On Wed,  1 Oct 2008 13:31:01 +0100
>> Andy Whitcroft <apw@shadowen.org> wrote:
>> 
>> > When a process enters direct reclaim it will expend effort identifying
>> > and releasing pages in the hope of obtaining a page.  However as these
>> > pages are released asynchronously there is every possibility that the
>> > pages will have been consumed by other allocators before the reclaimer
>> > gets a look in.  This is particularly problematic where the reclaimer is
>> > attempting to allocate a higher order page.  It is highly likely that
>> > a parallel allocation will consume lower order constituent pages as we
>> > release them preventing them coelescing into the higher order page the
>> > reclaimer desires.
>> > 
>> > This patch set attempts to address this for allocations above
>> > ALLOC_COSTLY_ORDER by temporarily collecting the pages we are releasing
>> > onto a local free list.  Instead of freeing them to the main buddy lists,
>> > pages are collected and coelesced on this per direct reclaimer free list.
>> > Pages which are freed by other processes are also considered, where they
>> > coelesce with a page already under capture they will be moved to the
>> > capture list.  When pressure has been applied to a zone we then consult
>> > the capture list and if there is an appropriatly sized page available
>> > it is taken immediatly and the remainder returned to the free pool.
>> > Capture is only enabled when the reclaimer's allocation order exceeds
>> > ALLOC_COSTLY_ORDER as free pages below this order should naturally occur
>> > in large numbers following regular reclaim.
>> > 
>> > Thanks go to Mel Gorman for numerous discussions during the development
>> > of this patch and for his repeated reviews.
>> > 
>> 
>> Hmm.. is this routine better than
>>   mm/memory_hotplug.c::do_migrate_range(start_pfn, end_pfn) ?
>
>Are you suggesting that it might be more adventageous to try and migrate
>things out of this area as part of reclaim?  If so then I tend to agree,
>though that would be a good idea generally with or without capture.
>
>/me adds it to his todo list to test that out.
>
I just remember I did the same kind of work to offline pages.
Sorry for noise.

I just have an idea to support following kind of interface via memory hotplug
This makes all pages in the section to be hugepage.

 #echo huge > /sys/device/system/memory/memoryXXX/state
 (memory hotplug interface supports online/offline here.)

But no patches yet...

Thanks,
-Kame


