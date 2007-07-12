Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbXGLTUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbXGLTUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbXGLTUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:20:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbXGLTUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:20:41 -0400
Message-ID: <46967EE2.8020803@redhat.com>
Date: Thu, 12 Jul 2007 15:20:02 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Tim Pepper <lnxninja@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Fengguang Wu <wfg@mail.ustc.edu.cn>,
       riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFT][PATCH] mm: drop behind
References: <1184007008.1913.45.camel@twins>	 <eada2a070707111537p20ab429anebd8b1840f5e5b5f@mail.gmail.com> <1184225086.20032.45.camel@twins>
In-Reply-To: <1184225086.20032.45.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Hi Tim,
> 
> On Wed, 2007-07-11 at 15:37 -0700, Tim Pepper wrote:
>> On 7/9/07, Peter Zijlstra <peterz@infradead.org> wrote:
>>> Use the read-ahead code to provide hints to page reclaim.
>>>
>>> This patch has the potential to solve the streaming-IO trashes my
>>> desktop problem.
>>>
>>> It tries to aggressively reclaim pages that were loaded in a strong
>>> sequential pattern and have been consumed. Thereby limiting the damage
>>> to the current resident set.
>> Interesting...
>>
>> Would it make sense to tie this into (finally) making
>> POSIX_FADV_NOREUSE something more than a noop?
> 
> We talked about that, but the thing is, if we make the functionality
> conditional, nobody will ever use it :-/
> 
> So, yes, in a perfect world that would indeed make sense. However since
> nobody ever uses these [fm]advise calls,..
> 
> So the big question is, does this functionally hurt any workload? If it
> turns out it does (which I still doubt) then we might hide it behind
> knobs, otherwise I'd like to keep it always on.

Then do what we do for FADV_SEQUENTIAL.  With that advice, we double the 
readahead window.  We're already doing readahead, but we do a lot more 
when we have the advice.  NOREUSE should put much greater pressure on 
the vm to drop these pages quickly, or perhaps simply eliminate the 
heuristic evaluation of the access pattern and short-circuit straight to 
dropping the pages.

We should be encouraging application writers to actually use things like 
fadvise when they can tune things more intelligently than kernel 
heuristics can.

	-- Chris
