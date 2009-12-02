Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZLBCAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZLBCAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 21:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZLBCAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 21:00:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbZLBCAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 21:00:52 -0500
Message-ID: <4B15CA27.3040903@redhat.com>
Date: Tue, 01 Dec 2009 21:00:07 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Larry Woodman <lwoodman@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [RFC] high system time & lock contention running large mixed
 workload
References: <20091125133752.2683c3e4@bree.surriel.com> <1259618429.2345.3.camel@dhcp-100-19-198.bos.redhat.com> <20091201100444.GN30235@random.random>
In-Reply-To: <20091201100444.GN30235@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2009 05:04 AM, Andrea Arcangeli wrote:
> On Mon, Nov 30, 2009 at 05:00:29PM -0500, Larry Woodman wrote:
>    
>> Before the splitLRU patch shrink_active_list() would only call
>> page_referenced() when reclaim_mapped got set.  reclaim_mapped only got
>> set when the priority worked its way from 12 all the way to 7. This
>> prevented page_referenced() from being called from shrink_active_list()
>> until the system was really struggling to reclaim memory.
>>      
> page_referenced should never be called and nobody should touch ptes
> until priority went down to 7. This is a regression in splitLRU that
> should be fixed. With light VM pressure we should never touch ptes ever.
>    
You appear to have not read the code, either.

The VM should not look at the active anon list much,
unless it has a good reason to start evicting anonymous
pages.  Yes, there was a bug in shrink_list(), but Kosaki
and I just posted patches to fix that.

As for page_referenced not being called until priority
goes down to 7 - that is one of the root causes the old
VM did not scale.  The number of pages that need to
be scanned to get down to that point is staggeringly
huge on systems with 1TB of RAM - a much larger
number than we should EVER scan in the pageout code.

There is no way we could go back to that heuristic.
It fell apart before and it would continue to fall apart
if we reintroduced it.
