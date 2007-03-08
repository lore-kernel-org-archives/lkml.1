Return-Path: <linux-kernel-owner+w=401wt.eu-S1751133AbXCHCvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbXCHCvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 21:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXCHCvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 21:51:12 -0500
Received: from smtpout.mac.com ([17.250.248.172]:50646 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbXCHCvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 21:51:10 -0500
In-Reply-To: <f2b55d220703071725w7c09b93bgbf357aeb25a21c2b@mail.gmail.com>
References: <45ED1A3C.6030707@argo.co.il> <200703071906.58405.dada1@cosmosbay.com> <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org> <200703071952.13219.dada1@cosmosbay.com> <20070307221401.GA16938@kryten> <Pine.LNX.4.64.0703071453080.5963@woody.linux-foundation.org> <f2b55d220703071725w7c09b93bgbf357aeb25a21c2b@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6E1C86DF-D512-418C-B270-BC5C4316BC0A@mac.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [patch] epoll use a single inode ...
Date: Wed, 7 Mar 2007 21:48:43 -0500
To: "Michael K. Edwards" <medwards.linux@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 07, 2007, at 20:25:14, Michael K. Edwards wrote:
> On 3/7/07, Linus Torvalds <torvalds@linux-foundation.org> wrote
>> In general, using software prefetching is just a stupid idea, unless
>>
>>  - the prefetch really is very strict (ie for a linked list you do  
>> exactly the above kinds of things to make sure that you don't try  
>> to prefetch the non-existent end entry)
>> AND
>>  - the CPU is stupid (in-order in particular).
>>
>> I think Intel even suggests in their optimization manuals to *not*  
>> do software prefetching, because hw can usually simply do better  
>> without it.
>
> Not the XScale -- it performs quite poorly without prefetch, as  
> people who have run ARMv5-optimized binaries on it can testify.
>
> The Intel XScale(r) core prefetch load instruction is a true  
> prefetch instruction because the load destination is the data or  
> mini-data cache and not a register. Compilers for processors which  
> have data caches, but do not support prefetch, sometimes use a load  
> instruction to preload the data cache. This technique has the  
> disadvantages of using a register to load data and requiring  
> additional registers for
> subsequent preloads and thus increasing register pressure. By  
> contrast, the prefetch can be used to reduce register pressure  
> instead of increasing it.
>
> The prefetch load is a hint instruction and does not guarantee that  
> the data will be loaded. Whenever the load would cause a fault or a  
> table walk, then the processor will ignore the prefetch  
> instruction, the fault or table walk, and continue processing the  
> next instruction. This is particularly advantageous in the case  
> where a linked list or recursive data structure is terminated by a  
> NULL pointer. Prefetching the NULL pointer will not fault program  
> flow.

Prefetching is also fairly critical on a Power4 or G5 PowerPC system  
as they have a long memory latency; an L2-cache miss can cost 200+  
cycles.  On such systems the "dcbt" prefetch instruction brings in a  
single 128-byte cacheline and has no serializing effects whatsoever,  
making it ideal for use in a linked-list-traversal inner loop.

Cheers,
Kyle Moffett

