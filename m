Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbXCOKFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbXCOKFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 06:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXCOKFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 06:05:05 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:41231 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752799AbXCOKFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 06:05:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=yj3AZqkWSLgfY1gv8pKdF0XiWwQsb3VuvfK2xIHIVvCvCyGOhVLoVuM+s8AqFMKr80zE3SXaKduTjMGPZMi64pVrWw7xao2ZxlJxS9/h24y5waRH1gjJApSOXkF+3gqKT3AAG55RMmKUeJZz3bwmM+qUpaBAi1b+O4E5CUIE85I=  ;
X-YMail-OSG: Pp9MI0oVM1msuhFofkA0TywE6an_fsAAsF9t9zH5Jmc1FqgqhnuqwkZK9mZYJi4pAk9UWFVCstbZo2D4NagAu66MrmfCGHWOSg4vuqNGDWTXJJ8xhqkbg16E5GArg03qeIp5oPx.FMJzhBo-
Message-ID: <45F91A46.30608@yahoo.com.au>
Date: Thu, 15 Mar 2007 21:04:54 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Dmitriy Monakhov <dmonakhov@sw.ru>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [patch 2/5] fs: introduce new aops and infrastructure
References: <20070314112529.13798.35417.sendpatchset@linux.site>	<20070314112540.13798.97719.sendpatchset@linux.site> <87bqiuzvqy.fsf@sw.ru>
In-Reply-To: <87bqiuzvqy.fsf@sw.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitriy Monakhov wrote:
> Nick Piggin <npiggin@suse.de> writes:
> 
> 
>>Index: linux-2.6/fs/splice.c
>>===================================================================
>>--- linux-2.6.orig/fs/splice.c
>>+++ linux-2.6/fs/splice.c
>>@@ -559,7 +559,7 @@ static int pipe_to_file(struct pipe_inod
>> 	struct address_space *mapping = file->f_mapping;
>> 	unsigned int offset, this_len;
>> 	struct page *page;
>>-	pgoff_t index;
>>+	void *fsdata;
>> 	int ret;
>> 
>> 	/*
>>@@ -569,13 +569,13 @@ static int pipe_to_file(struct pipe_inod
>> 	if (unlikely(ret))
>> 		return ret;
>> 
>>-	index = sd->pos >> PAGE_CACHE_SHIFT;
>> 	offset = sd->pos & ~PAGE_CACHE_MASK;
>> 
>> 	this_len = sd->len;
>> 	if (this_len + offset > PAGE_CACHE_SIZE)
>> 		this_len = PAGE_CACHE_SIZE - offset;
>> 
>>+#if 0
>> 	/*
>> 	 * Reuse buf page, if SPLICE_F_MOVE is set and we are doing a full
>> 	 * page.
>>@@ -587,86 +587,11 @@ static int pipe_to_file(struct pipe_inod
>> 		 * locked on successful return.
>> 		 */
>> 		if (buf->ops->steal(pipe, buf))
>>-			goto find_page;
>>+#endif
> 
> One more note. It's looks like you just disabled all fancy zero copy logic.
> Off corse this is just rfc patchset.
> But i think where is fundamental problem with it:
>  Previous logic was following:
>   1)splice code responsible for: stealing(if possible) and loking the page
>   2)prepare_write() code responsible for: do fs speciffic stuff
> 
>  But with new write_begin() logic  all steps (grubbing, locking, preparing)
>  happened internaly inside write_begin() witch doesn't even know about what
>  kind of data will be copied between write_begin/write_end.
>  So fancy zero copy logic is impossible :(

Check linux-mm: zero-copy splice is broken anyway, and AFAIKS it cannot
really be fixed to work with the current prepare_write.

> I think this can be solved somehow, but i dont know yet, how can this be done
> without implementing it inside begin_write().

Actually we could do it with begin_write. All we need to do is set a
flag to say that *pagep contains a page that we can use, with a copy of
the write data on it.

The filesystem would then be able to insert that page into the pagecache
*if* it could handle such an operation.

OTOH, is splice stealing support really important? I guess it could be a
nice win for a small niche of workloads, and we probably don't want to
exclude it by design...

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
