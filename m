Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbXEBJPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbXEBJPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbXEBJPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:15:20 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:42487 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753952AbXEBJPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:15:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=t3lAdToF1nG2KLgbXND9d3ifS0uUCfHdo2fIjg7ZcWqzbE8ZzjKKvA+eu8vaELv/MriEhk6ox3jgSuwxcx5C/j/79EHt8n7s+vLZSpVeQfUYtfFYkKxO1KvojsQ4UGO1p16ha5AqoKlq2Uz2g4ARj/8+xVQOxX8D5uqAJ1f5vFQ=  ;
X-YMail-OSG: ujzyC90VM1kWlAhyR3Eir.wJSS3NYAtc1VuSxqzSoYkQWsn0
Message-ID: <46385699.4090201@yahoo.com.au>
Date: Wed, 02 May 2007 19:15:05 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrea Arcangeli <andrea@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.22 -mm merge plans -- vm bugfixes
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <4636FDD7.9080401@yahoo.com.au> <Pine.LNX.4.64.0705011931520.16502@blonde.wat.veritas.com> <4638009E.3070408@yahoo.com.au>
In-Reply-To: <4638009E.3070408@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Hugh Dickins wrote:
> 
>> On Tue, 1 May 2007, Nick Piggin wrote:
> 
> 
>>> There were concerns that we could do this more cheaply, but I think it
>>> is important to start with a base that is simple and more likely to
>>> be correct and build on that. My testing didn't show any obvious
>>> problems with performance.
>>
>>
>>
>> I don't see _problems_ with performance, but I do consistently see the
>> same kind of ~5% degradation in lmbench fork, exec, sh, mmap latency
>> and page fault tests on SMP, several machines, just as I did last year.
> 
> 
> OK. I did run some tests at one stage which didn't show a regression
> on my P4, however I don't know that they were statistically significant.
> I'll try a couple more runs and post numbers.

I didn't have enough time tonight to get means/stddev, etc, but the runs
are pretty stable.

Patch tested was just the lock page one.

SMP kernel, tasks bound to 1 CPU:

P4 Xeon
          pagefault   fork          exec
2.6.21   1.67-1.69   140.7-142.0   449.5-460.8
+patch   1.75-1.77   144.0-145.5   456.2-463.0

So it's taken on nearly 5% on pagefault, but looks like less than 2% on
fork, so not as bad as your numbers (phew).

G5
          pagefault   fork          exec
2.6.21   1.49-1.51   164.6-170.8   741.8-760.3
+patch   1.71-1.73   175.2-180.8   780.5-794.2

Bigger hit there.

Page faults can be improved a tiny bit by not using a test and clear op
in unlock_page (less barriers for the G5).

I don't think that's really a blocker problem for a merge, but I wonder
what we can do to improve it. Lockless pagecache shaves quite a bit of
straight line find_get_page performance there.

Going to a non-sleeping lock might be one way to go in the long term, but
it would require quite a lot of restructuring.

-- 
SUSE Labs, Novell Inc.
