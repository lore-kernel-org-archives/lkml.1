Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbXH2AO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbXH2AO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 20:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbXH2AOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 20:14:18 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:24763 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753071AbXH2AOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 20:14:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Fj6G6ETjhEdyPaZraJO6WIUVELXK7qPoI9HFtsyKE2wH+vRDw24QR+NZI6aLht9lsFfSnezhOYga8JXUs5wEtpE3eN5HOQNPViGMrMPDQK/Be68e1E0UbxsY57NhSfEiLbzRrmzt/eNof0RiKzwzyUJyyTakSXSEIDZ0pXR6uq8=  ;
X-YMail-OSG: 6w091gIVM1lMeyNmFK_zQWozipPnxn3XrQd.b2lqy8iKWKbjPZNOQPwnG_l85ya2vlAIbpHtgw--
Message-ID: <46D4BA53.5070005@yahoo.com.au>
Date: Wed, 29 Aug 2007 10:14:11 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Mitchell Erblich <erblichs@earthlink.net>
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] : mm : / Patch / code : Suggestion :snip kswapd &get_page_from_freelist()
 : No more no page failures. (WHY????)
References: <000501c7e9b5$7f73db00$6501a8c0@earthlink.net>
In-Reply-To: <000501c7e9b5$7f73db00$6501a8c0@earthlink.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mitchell Erblich wrote:
> Nick Piggin wrote:

> --------
> Nick Piggin, et al,
> 
>     First diffs would generate alot of noise, since I rip and insert
>     alot of code based on whether I think the code is REALLY
>     needed for MY TEST environment. These suggestions are
>     basicly minimal merge suggestions between my
>     development envir and the public Linux tree.

That's OK. So long as the patch is against a well known tree, it
is just less ambiguous even if it doesn't actually compile :)


> 
>     Now the why for this SUGGESTION/PATCH...
> 
> 
>>When we're in the (min,low) watermark range, we'll wake up kswapd
>>_before_ allocating anything, so what is better about the change to
>>wake up kswapd after allocating? Can you perhaps come up with an
>>example situation also to make this more clear?
> 
> 
> Answer
>     Will GFP_ATOMIC alloc be failing at that point? If yes, then why
>     not allow kswapd attempt to prevent this condition from occuring?
>     The existing code reads that the first call to get_page_from_freelist()
>     has returned no page. Now you are going to start up something that
>     is at best going to take millisecs to start helping out. Won't it first
>     grab some pages to do its work? So we are going to be lower
>     in free memory right when it starts up. Right?

GFP_ATOMIC will not be failing at this point (also, kswapd could
probably have reclaimed several hundred or thousand pages in 1ms,
but that's besides the point -- we do have correct buffering here).

The watermarks go roughly like this:

high -- kswapd stops reclaiming
low  -- kswapd is started by any allocation, nothing else happens
min  -- non-GFP_ATOMIC can't go below this point; enter direct reclaim
min/X-- GFP_ATOMIC allocations fail below this point
0    -- PF_MEMALLOC fails.

-- 
SUSE Labs, Novell Inc.
