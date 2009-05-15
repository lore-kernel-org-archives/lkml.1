Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbZEOKHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbZEOKHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 06:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbZEOKGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 06:06:51 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9844 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbZEOKGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 06:06:50 -0400
Date: Fri, 15 May 2009 12:06:42 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] Physical Memory Management [0/1]
In-reply-to: <1242321000.6642.1456.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
       kyungmin.park@samsung.com, linux-mm@kvack.org
Message-id: <op.utyudge07p4s8u@amdc030>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.00 (Win32)
References: <op.utu26hq77p4s8u@amdc030>
 <20090513151142.5d166b92.akpm@linux-foundation.org>
 <op.utwwmpsf7p4s8u@amdc030> <1242300002.6642.1091.camel@laptop>
 <op.utw4fdhz7p4s8u@amdc030> <1242302702.6642.1140.camel@laptop>
 <op.utw7yhv67p4s8u@amdc030>
 <20090514100718.d8c20b64.akpm@linux-foundation.org>
 <1242321000.6642.1456.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2009-05-14 at 10:07 -0700, Andrew Morton wrote:
>> We do have capability in page reclaim to deliberately free up
>> physically contiguous pages (known as "lumpy reclaim").

Doesn't this require swap?

>> It would be interesting were someone to have a go at making that
>> available to userspace: ask the kernel to give you 1MB of physically
>> contiguous memory.  There are reasons why this can fail, but migrating
>> pages can be used to improve the success rate, and userspace can be
>> careful to not go nuts using mlock(), etc.

On Thu, 14 May 2009 19:10:00 +0200, Peter Zijlstra wrote:
> I thought we already exposed this, its called hugetlbfs ;-)

On Thu, 14 May 2009 21:33:11 +0200, Andi Kleen wrote:
> You could just define a hugepage size for that and use hugetlbfs
> with a few changes to map in pages with multiple PTEs.
> It supports boot time reservation and is a well established
> interface.
>
> On x86 that would give 2MB units, on other architectures whatever
> you prefer.

Correct me if I'm wrong, but if I understand correctly, currently only
one size of huge page may be defined, even if underlaying architecture
supports many different sizes.

So now, there are two cases: (i) either define huge page size to the
largest blocks that may ever be requested and then waste a lot of
memory when small pages are requested or (ii) define smaller huge
page size but then special handling of large regions need to be
implemented.

The first solution is not acceptable, as a lot of memory may be wasted.
If for example, you have a 4 mega pixel camera you'd have to configure
4 MiB-large huge pages but in most cases, you won't be needing that
much.  Often you will work with say 320x200x2 images (125KiB) and
more then 3MiBs will be wasted!

In the later, with (say) 128 KiB huge pages no (or little) space will be
wasted when working with 320x200x2 images but then when someone would
really need 4 MiB to take a photo the very same problem we started with
will occur -- we will have to find 32 contiguous pages.

So to sum up, if I understand everything correctly, hugetlb would be a
great solution when working with buffers of similar sizes.  However, it's
not so good when size of requested buffer may vary greatly.

-- 
Best regards,                                            _     _
 .o. | Liege of Serenly Enlightened Majesty of         o' \,=./ `o
 ..o | Computer Science,  Michał "mina86" Nazarewicz      (o o)
 ooo +-<m.nazarewicz@samsung.com>-<mina86@jabber.org>-ooO--(_)--Ooo--

