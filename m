Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbXE1GhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbXE1GhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 02:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXE1GhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 02:37:14 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:20032 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750844AbXE1GhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 02:37:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=4GCllosEXajLpjwRjPIG8HkzNN0xM2M6LfbcjeIYejgpkHv4fVnVjFtebVwPCaL6QB74vRi9AOn95ORKr5BDGMNjrj+u0fGpifFUo4L+oAj5jG+WJ15I+o4qpAsR2F+enE/XmTeX2w+D23rCPV6oz1aeqSChh/ubBTAYIqIJVRU=  ;
X-YMail-OSG: BqsESLQVM1mLbwE1qoCIbRszqpZDVjrbafJ1a0pMnZBhL5JvDftXa9ybSTIaz1FTQ1JF5Sc75w--
Message-ID: <465A7894.5090101@yahoo.com.au>
Date: Mon, 28 May 2007 16:37:08 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Preserve the dirty bit in init_page_buffers
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>	<465A55E7.50904@yahoo.com.au> <m18xb9a7sy.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m18xb9a7sy.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> 
> 
>>Eric W. Biederman wrote:
>>
>>>The problem:  When we are trying to free buffers try_to_free_buffers
>>>will look at ramdisk pages with clean buffer heads and remove the
>>>dirty bit from the page.  Resulting in ramdisk pages with data that
>>>get removed from the page cache.  Ouch!
>>>
>>>Buffer heads appear on ramdisk pages when a filesystem calls getblk,
>>>which through a series of function calls eventually calls
>>>init_page_buffers.
>>>
>>>So to fix the mismatch between buffer head state and page state this
>>>patch modifies init_page_buffers to transfer the dirty bit from the
>>>page to the buffer heads like we currently do for the uptodate bit.
>>
>>Ouch indeed!
>>
>>But can we ever have a dirty page at init_page_buffers-time?
> 
> 
> Definitely, and it was a royal pain to trace the bug that this
> caused.  An initial ramdisk having pieces disappear after mkfs
> is called can look like the entire machine is dying.
> 
> When we initialize the ramdisk by writing to /dev/ram0 usually in
> init/do_mounts_rd.c we don't allocate buffer heads but we do set
> the dirty bit, and the page is in the page cache.  So when we
> later call getblk it reuses the same page and then calls
> init_page_buffers.

Hmm, the comment above grow_dev_buffers indicates this should
not happen. But contrary to the comment, it doesn't go BUG
unless you're attaching dirty buffers to a page with dirty
buffers.

I suspect this happens more frequently with rd.c, because unlike
block_dev.c, it does not create dirty buffers in prepare_write.
However it could still happen in block_dev.c via mmaped memory,
as I said earlier.

I'm not saying this patch 1/3 is wrong, but we would at least
need to revise some comments. The grow_dev_buffers comment looks
like one of Andrew's. Maybe he can shed some more light on this?

-- 
SUSE Labs, Novell Inc.
