Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbXCSJ6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbXCSJ6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbXCSJ6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:58:00 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:27369 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753779AbXCSJ57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:57:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=P7FnmBStmYSjl+/AAIvpcvn6J5RtcwQK/drQWA0k+zSs8Qeb6Omd097ZEisKDyv5yj4+0aB5k9O3003lnLzTdFM7t4i3xI2+fGSs5ppfJ1nr68GlaPz+32c13fxBeQ6+lwH587MJF8D3VByWtzIwQC32ZBmXD+cgxemeQgsIUeQ=  ;
X-YMail-OSG: x7jl4b0VM1lDuQXKGp.dFg_RRJeA1M51rYD5lyLvn_Q.FUgnaCdBnpa0nJ19suYyMdpoAlHPphf85XxodgNeVdeksiRTrGh3tT4q9YkmflcSUA7RJnCcAwZGfMHzZ5UOr5PkkELiKxe_QyM-
Message-ID: <45FE5E9F.7040705@yahoo.com.au>
Date: Mon, 19 Mar 2007 20:57:51 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
References: <20070318233008.GA32597093@melbourne.sgi.com> <45FE2F8F.6010603@yahoo.com.au> <20070319081258.GE32597093@melbourne.sgi.com>
In-Reply-To: <20070319081258.GE32597093@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Mon, Mar 19, 2007 at 05:37:03PM +1100, Nick Piggin wrote:
> 
>>David Chinner wrote:
>>

>>>+block_page_mkwrite(struct vm_area_struct *vma, struct page *page,
>>>+		   get_block_t get_block)
>>>+{
>>>+	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
>>>+	unsigned long end;
>>>+	loff_t size;
>>>+	int ret = -EINVAL;
>>>+
>>>+	lock_page(page);
>>>+	size = i_size_read(inode);
>>>+	if ((page->mapping != inode->i_mapping) ||
>>>+	    ((page->index << PAGE_CACHE_SHIFT) > size)) {
>>>+		/* page got truncated out from underneath us */
>>>+		goto out_unlock;
>>>+	}
>>
>>I see your explanation above, but I still don't see why this can't
>>just follow the conventional if (!page->mapping) check for truncation.
>>If the test happens to be performed after truncate concurrently
>>decreases i_size, then the blocks are going to get truncated by the
>>truncate afterwards anyway.
> 
> 
> We have to read the inode size in the normal case so that we know if
> the page is at EOF and is a partial page so we don't allocate past EOF in
> block_prepare_write().  Hence it seems like a no-brainer to me to check
> and error out on a page that we *know* is beyond EOF.
> 
> I can drop the check if you see no value in it - I just don't
> like the idea of ignoring obvious boundary condition violations...

I would prefer it dropped, to be honest. I can see how the check does
pick up that corner case, however truncate is difficult enough (at
least, it has been an endless source of problems) that we want to keep
everyone else simple and have all the non-trivial stuff in truncate.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
