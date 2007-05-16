Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbXEPMAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbXEPMAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758806AbXEPMAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:00:25 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:40353 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757862AbXEPMAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:00:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ILAyxrI/iIHKn8KZ0HqHV+fB6hV0DPk8E56hXXNkJ4KAuAXYvBZc41wi4SFr8HIIuya7OZ4myG3JMdtCMTirE9i7aDlEXkbz48s36uE9X1h6WCTo2I5uB7PdaD05PClTHashNcxBR2LKo8nJO5JyrUv3LxtHuVDYLcWaBgS4Akk=  ;
X-YMail-OSG: e.BPOsEVM1mRdtZz.TPpayqrLavklJC9pql7htldA5VXM3CIFn6e3Jl4boVT6JTRMnjwpzptAQ--
Message-ID: <464AF224.30105@yahoo.com.au>
Date: Wed, 16 May 2007 21:59:32 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
References: <20070318233008.GA32597093@melbourne.sgi.com> <18993.1179310769@redhat.com>
In-Reply-To: <18993.1179310769@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> David Chinner <dgc@sgi.com> wrote:
> 
> 
>>+	ret = block_prepare_write(page, 0, end, get_block);
> 
> 
> As I understand the way prepare_write() works, this is incorrect.

I think it is actually OK.


> The start and end points passed to block_prepare_write() delimit the region of
> the page that is going to be modified.  This means that prepare_write()
> doesn't need to fill it in if the page is not up to date.  It does, however,
> need to fill in the region before (if present) and the region after (if
> present).  Look at it like this:
> 
> 		+---------------+
> 		|               |
> 		|               |	<-- Filled in by prepare_write()
> 		|               |
> 	to->	|:::::::::::::::|
> 		|               |
> 		|               |	<-- Filled in by caller
> 		|               |
> 	offset->|:::::::::::::::|
> 		|               |
> 		|               |	<-- Filled in by prepare_write()
> 		|               |
> 	page->	+---------------+
> 
> However, page_mkwrite() isn't told which bit of the page is going to be
> written to.  This means it has to ask prepare_write() to make sure the whole
> page is filled in.  In other words, offset and to must be equal (in AFS I set
> them both to 0).

Dave is using prepare_write here to ensure blocks are allocated in the
given range. The filesystem's ->nopage function must ensure it is uptodate
before allowing it to be mapped.


> With what you've got, if, say, 'offset' is 0 and 'to' is calculated at
> PAGE_SIZE, then if the page is not up to date for any reason, then none of the
> page will be updated before the page is written on by the faulting code.

Consider that the code currently works OK today _without_ page_mkwrite.
page_mkwrite is being added to do block allocation / reservation.


> You probably get away with this in a blockdev-based filesystem because it's
> unlikely that the page will cease to be up to date.
> 
> However, if someone adds a syscall to punch holes in files, this may change...

We have one. Strangely enough, it is done with madvise(MADV_REMOVE).

-- 
SUSE Labs, Novell Inc.
