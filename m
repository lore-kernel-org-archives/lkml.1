Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbZESM2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbZESM2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZESM22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:28:28 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:60383 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZESM21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RuRkAC7tRj24OSiuP0tFxOj02b5a/stkWgn3PE1FHQD0V05sI0sqH+z86roJRpHPbs
         Xb7OvMnGD+nHbvl8oVD0kM3e7lKos1IMGaM99ux6seboG8+xSo53Vmw1dkQpjAPki8F4
         bHapMKa2FqX7DPyU/FL+qRrUBZwal1burAh5Y=
MIME-Version: 1.0
In-Reply-To: <20090519085354.GB2121@localhost>
References: <20090519161756.4EE4.A69D9226@jp.fujitsu.com>
	 <20090519074925.GA690@localhost>
	 <20090519170208.742C.A69D9226@jp.fujitsu.com>
	 <20090519085354.GB2121@localhost>
Date: Tue, 19 May 2009 21:28:28 +0900
X-Google-Sender-Auth: 304681dabc0a15f1
Message-ID: <2f11576a0905190528n5eb29e3fme42785a76eed3551@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first class 
	citizen
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

2009/5/19 Wu Fengguang <fengguang.wu@intel.com>:
> On Tue, May 19, 2009 at 04:06:35PM +0800, KOSAKI Motohiro wrote:
>> > > > Like the console mode, the absolute nr_mapped drops considerably - to 1/13 of
>> > > > the original size - during the streaming IO.
>> > > >
>> > > > The delta of pgmajfault is 3 vs 107 during IO, or 236 vs 393 during the whole
>> > > > process.
>> > >
>> > > hmmm.
>> > >
>> > > about 100 page fault don't match Elladan's problem, I think.
>> > > perhaps We missed any addional reproduce condition?
>> >
>> > Elladan's case is not the point of this test.
>> > Elladan's IO is use-once, so probably not a caching problem at all.
>> >
>> > This test case is specifically devised to confirm whether this patch
>> > works as expected. Conclusion: it is.
>>
>> Dejection ;-)
>>
>> The number should address the patch is useful or not. confirming as expected
>> is not so great.
>
> OK, let's make the conclusion in this way:
>
> The changelog analyzed the possible beneficial situation, and this
> test backs that theory with real numbers, ie: it successfully stops
> major faults when the active file list is slowly scanned when there
> are partially cache hot streaming IO.
>
> Another (amazing) finding of the test is, only around 1/10 mapped pages
> are actively referenced in the absence of user activities.
>
> Shall we protect the remaining 9/10 inactive ones? This is a question ;-)

Unfortunately, I don't reproduce again.
I don't apply your patch yet. but mapped ratio is reduced only very little.

I think smem can show which library evicted.  Can you try it?

download:  http://www.selenic.com/smem/
usage:   ./smem -m -r --abbreviate


We can't decide 9/10 is important or not. we need know actual evicted file list.

Thanks.


> Or, shall we take the "protect active VM_EXEC mapped pages" approach,
> or Christoph's "protect all mapped pages all time, unless they grow
> too large" attitude?  I still prefer the best effort VM_EXEC heuristics.
>
> 1) the partially cache hot streaming IO is far more likely to happen
>   on (file) servers. For them, evicting the 9/10 inactive mapped
>   pages over night should be acceptable for sysadms.
>
> 2) for use-once IO on desktop, we have Rik's active file list
>   protection heuristics, so nothing to worry at all.
>
> 3) for big working set small memory desktop, the active list will
>   still be scanned, in this situation, why not evict some of the
>   inactive mapped pages? If they have not been accessed for 1 minute,
>   they are not likely be the user focus, and the tight memory
>   constraint can only afford to cache the user focused working set.
>
> Does that make sense?
