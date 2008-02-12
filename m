Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbYBLDUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbYBLDUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 22:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbYBLDUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 22:20:11 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34425 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbYBLDUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 22:20:09 -0500
Date: Mon, 11 Feb 2008 21:16:52 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] Avoid buffer overflows in get_user_pages()
In-reply-to: <fa.NNs+hqAlLlf93+yNZ/YJzSyGQbs@ifi.uio.no>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Message-id: <47B10FA4.2000808@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.5jOFf0zR7ZoK3hLDItf3Omow4lE@ifi.uio.no>
 <fa.NNs+hqAlLlf93+yNZ/YJzSyGQbs@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tuesday 12 February 2008 10:17, Jonathan Corbet wrote:
>> Avoid buffer overflows in get_user_pages()
>>
>> So I spent a while pounding my head against my monitor trying to figure
>> out the vmsplice() vulnerability - how could a failure to check for
>> *read* access turn into a root exploit?  It turns out that it's a buffer
>> overflow problem which is made easy by the way get_user_pages() is
>> coded.
>>
>> In particular, "len" is a signed int, and it is only checked at the
>> *end* of a do {} while() loop.  So, if it is passed in as zero, the loop
>> will execute once and decrement len to -1.  At that point, the loop will
>> proceed until the next invalid address is found; in the process, it will
>> likely overflow the pages array passed in to get_user_pages().
>>
>> I think that, if get_user_pages() has been asked to grab zero pages,
>> that's what it should do.  Thus this patch; it is, among other things,
>> enough to block the (already fixed) root exploit and any others which
>> might be lurking in similar code.  I also think that the number of pages
>> should be unsigned, but changing the prototype of this function probably
>> requires some more careful review.
>>
>> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index e5628a5..7f50fd8 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -989,6 +989,8 @@ int get_user_pages(struct task_struct *tsk, struct
>> mm_struct *mm, int i;
>>  	unsigned int vm_flags;
>>
>> +	if (len <= 0)
>> +		return 0;
> 
> BUG_ON()?

Well, not if the code involved in the exploit can pass a zero value, 
otherwise it's just turning it into a DoS..
