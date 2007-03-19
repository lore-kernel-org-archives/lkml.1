Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080AbXCSK2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbXCSK2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 06:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbXCSK2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 06:28:13 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:37057 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752080AbXCSK2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 06:28:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=mviz8nJV/GTXKzlYz25J44et7qW5xLVSYGH30V68anMdmKknHzaEnIIMYInHqoNsYssgCQRPACVR066tqBP/pys7XsbbIbPJwA60KJxxnzE2RpHf+SLVRRBFV75jm+FDM8WcLLGrRpyiCA7rUVxftgTvXbFQnAkLUFAYz8tp9lQ=  ;
X-YMail-OSG: avymY4QVM1nsc5vSL0qEqrkuDYRlqey5ltU5JZeGG2K2_dDZJ4ZJwHkW2YsGP1dHf6Y7Ksy94iIojiFEN8pC6_pPQz_mJiCJjB4imCjDZq3Fgkhc4ZAY.fHvYGg.5hHrgun4AsGCtmV20I4-
Message-ID: <45FE65B0.7090105@yahoo.com.au>
Date: Mon, 19 Mar 2007 21:28:00 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
References: <20070318233008.GA32597093@melbourne.sgi.com> <45FE2F8F.6010603@yahoo.com.au> <20070319081258.GE32597093@melbourne.sgi.com> <45FE5E9F.7040705@yahoo.com.au>
In-Reply-To: <45FE5E9F.7040705@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> David Chinner wrote:
> 
>> On Mon, Mar 19, 2007 at 05:37:03PM +1100, Nick Piggin wrote:
>>
>>> David Chinner wrote:
>>>
> 
>>>> +block_page_mkwrite(struct vm_area_struct *vma, struct page *page,
>>>> +           get_block_t get_block)
>>>> +{
>>>> +    struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
>>>> +    unsigned long end;
>>>> +    loff_t size;
>>>> +    int ret = -EINVAL;
>>>> +
>>>> +    lock_page(page);
>>>> +    size = i_size_read(inode);
>>>> +    if ((page->mapping != inode->i_mapping) ||
>>>> +        ((page->index << PAGE_CACHE_SHIFT) > size)) {
>>>> +        /* page got truncated out from underneath us */
>>>> +        goto out_unlock;
>>>> +    }
>>>
>>>
>>> I see your explanation above, but I still don't see why this can't
>>> just follow the conventional if (!page->mapping) check for truncation.
>>> If the test happens to be performed after truncate concurrently
>>> decreases i_size, then the blocks are going to get truncated by the
>>> truncate afterwards anyway.
>>
>>
>>
>> We have to read the inode size in the normal case so that we know if
>> the page is at EOF and is a partial page so we don't allocate past EOF in
>> block_prepare_write().  Hence it seems like a no-brainer to me to check
>> and error out on a page that we *know* is beyond EOF.
>>
>> I can drop the check if you see no value in it - I just don't
>> like the idea of ignoring obvious boundary condition violations...
> 
> 
> I would prefer it dropped, to be honest. I can see how the check does
> pick up that corner case, however truncate is difficult enough (at
> least, it has been an endless source of problems) that we want to keep
> everyone else simple and have all the non-trivial stuff in truncate.
> 

Hmm, actually on second thoughts it probably is reasonable to recheck
i_size under the page lock... we need to do similar in the nopage path
to close the nopage vs invalidate race.

However, the already-truncated test I think can just be !page->mapping:
there should be no way for the page mapping to change to something
other than NULL.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
