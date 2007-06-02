Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbXFBIml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbXFBIml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 04:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbXFBIme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 04:42:34 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:31362 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754094AbXFBImd (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 04:42:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=mYRU9qC10+Ip0FU7fqOO1hhoSozIUqmi05vaF4C9EIQk59YEN3A908UoUJzS4dOoRIDmpDV9gmFqOEG+NBGFDuAoA6omSxgdVgQM3IRnhhgd1nT2KkrZc9RjF413JS1Y5Oa48sO6k1bkEBg8dFXIXr2ubqRaKmT9gO8uLjIKE9E=  ;
X-YMail-OSG: FXhiBkwVM1lubN9yfAxSDh.9c68aKxAlZjXrtdxpfbmmVHi4Bo0mUGwzIFs25UC2kRQvoQfE8Q--
Message-ID: <46612D6F.6000002@yahoo.com.au>
Date: Sat, 02 Jun 2007 18:42:23 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jared Hulbert <jaredeh@gmail.com>
CC: carsteno@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <1179871779.24163.11.camel@localhost.localdomain>	 <20070522154905.1d7e8a2e.akpm@linux-foundation.org>	 <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
In-Reply-To: <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
>> > The current xip stack relies on having struct page behind the memory
>> > segment. This causes few impact on memory management, but occupies some
>> > more memory. The cramfs patch chose to modify copy on write in order to
>> > deal with vmas that don't have struct page behind.
>> > So far, Hugh and Linus have shown strong opposition against copy on
>> > write with no struct page behind. If this implementation is acceptable
>> > to the them, it seems preferable to me over wasting memory. The xip
>> > stack should be modified to use this vma flag in that case.
>>
>> I would rather not :P
>>
>> We can copy on write without a struct page behind the source today, no?
> 
> 
> The existing COW techniques fail on some corner cases.  I'm not up to
> speed on the vm code.  I'll try to look into this a little more but it
> might be useful if I knew what questions I need to answer so you vm
> experts can understand the problem.

Previously I believe we couldn't do COW without a struct page for the
source memory, nor could we COW with a source that is not readable
from the kernel virtual mapping.

Now we can do both. cow_user_page in mm/memory.c does a copy_from_user
if there is no source page, so it uses the user mappings and does not
require a struct page.

The question is, why is that not enough (I haven't looked at these
patches enough to work out if there is anything more they provide).

> 
> Let me give one example.  If you try to debug an XIP application
> without this patch, bad things happen.  XIP in this sense is synomous
> with executing directly out of Flash and you can't just change the
> physical memory to redirect it to the debugger so easily in Flash.
> Now I don't know exactly why yet some, but not all applications,
> trigger this added vm hack.  I'm not sure exactly why it would get
> triggered under normal circumstances.  Why would a read-only map get
> written to?
> 
>> What is insufficient for the XIP code with the current COW?
> 
> 
> So I think the problem may have something to do with the nature of the
> memory in question.   We are using Flash that is ioremap()'ed to a
> usable virtual address.  And yet we go on to try to use it as if it
> were plain old system memory, like any RAM page.  We need it to be
> presented as any other memory page only physically read-only.
> ioremap() seems to be a hacky way of accomplishing that, but I can't
> think of better way.  In ARM we even had to invent ioremap_cached() to
> improve performance.  Thoughts?
> 


-- 
SUSE Labs, Novell Inc.
