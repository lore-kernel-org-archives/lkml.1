Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218AbZHHFws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbZHHFws (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 01:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZHHFws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 01:52:48 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:61108 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZHHFwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 01:52:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VBhvdEnrONo94ALipmtC95TvC0L6gJ7En1aBHa1bnexHCxl5hYL8UO02Y/GtE8PPsb
         dTXDAwAiOmYGus6GJZh619yGo6s8RHnzjvWgsp5uRaefu6x/PA2UGGXr5DzT5/JAnx9c
         W9vzEZRtlEq/nzgiV4mVGTi13HuQZ8VphwXIw=
MIME-Version: 1.0
In-Reply-To: <20090807173118.GA10446@csn.ul.ie>
References: <20090805165302.5BC8.A69D9226@jp.fujitsu.com>
	 <20090805094019.GB21950@csn.ul.ie>
	 <20090807100502.5BDC.A69D9226@jp.fujitsu.com>
	 <20090807173118.GA10446@csn.ul.ie>
Date: Sat, 8 Aug 2009 14:44:40 +0900
X-Google-Sender-Auth: 73cfa5cde76fb0d1
Message-ID: <2f11576a0908072244n45e57c93x6def9f6b64b24133@mail.gmail.com>
Subject: Re: [PATCH 1/4] tracing, page-allocator: Add trace events for page 
	allocation and page freeing
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > In the NUMA case, this will be true but addressing it involves passing down
>> > an additional argument in the non-tracing case which I wanted to avoid.
>> > As the stacktrace option is available to ftrace, I think I'll drop call_site
>> > altogether as anyone who really needs that information has options.
>>
>> Insted, can we move this tracepoint to alloc_pages_current(), alloc_pages_node() et al ?
>> On page tracking case, call_site information is one of most frequently used one.
>> if we need multiple trace combination, it become hard to use and reduce usefulness a bit.
>>
>
> Ok, lets think about that. The potential points that would need
> annotation are
>
>        o alloc_pages_current
>        o alloc_page_vma
>        o alloc_pages_node
>        o alloc_pages_exact_node
>
> The inlined functions that call those and should preserve the call_site
> are
>
>        o alloc_pages
>
> The slightly lower functions they call are as follows. These cannot
> trigger a tracepoint event because it would look like a duplicate.
>
>        o __alloc_pages_nodemask
>                - called by __alloc_pages
>        o __alloc_pages
>                - called by alloc_page_interleave() but event logged
>                - called by alloc_pages_node but event logged
>                - called by alloc_pages_exact_node but event logged
>
> The more problematic ones are
>
>        o __get_free_pages
>        o get_zeroed_page
>        o alloc_pages_exact
>
> The are all real functions that call down to functions that would log
> events already based on your suggestion - alloc_pages_current() in
> particularly.
>
> Looking at it, it would appear the page allocator API would need a fair
> amount of reschuffling to preserve call_site and not duplicate events or
> else to pass call_site down through the API even in the non-tracing case.
> Minimally, that makes it a standalone patch but it would also need a good
> explanation as to why capturing the stack trace on the event is not enough
> to track the page for things like catching memory leaks.

I agree this is need to some cleanup.
I think I can do that and I can agree your.
