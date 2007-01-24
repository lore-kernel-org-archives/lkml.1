Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbXAXNno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbXAXNno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 08:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXAXNno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 08:43:44 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:26436 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751439AbXAXNnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 08:43:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ww6UHRDFgrxKBffDWQUKiZstr2KZirT5coAfPzSNDavq+UJTTiwdXpTyy/z5HPDHVWXW54OSxEJeulHDkiZeXZ/g1OMHrCKbcoJD3BlhqgMFjMs/jZBE+A8FGK0id5V+5icMx+W07S/drm49NMkV3aZiqpgP0uuPZvAaQWzB03k=  ;
X-YMail-OSG: lHEGZOoVM1n2QDgHw0oNf0PZxd5UlnE3JMqgxlfAWMAoQYeUC.P2zvuR1gur0FZhawxgNvLjsw--
Message-ID: <45B7627B.8050202@yahoo.com.au>
Date: Thu, 25 Jan 2007 00:43:23 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       akpm@osdl.org
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
References: <20070123223702.GF33919298@melbourne.sgi.com> <1169640835.6189.14.camel@twins>
In-Reply-To: <1169640835.6189.14.camel@twins>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2007-01-24 at 09:37 +1100, David Chinner wrote:
> 
>>With the recent changes to cancel_dirty_pages(), XFS will
>>dump warnings in the syslog because it can truncate_inode_pages()
>>on dirty mapped pages.
>>
>>I've determined that this is indeed correct behaviour for XFS
>>as this can happen in the case of races on mmap()d files with
>>direct I/O. In this case when we do a direct I/O read, we
>>flush the dirty pages to disk, then truncate them out of the
>>page cache. Unfortunately, between the flush and the truncate
>>the mmap could dirty the page again. At this point we toss a
>>dirty page that is mapped.
> 
> 
> This sounds iffy, why not just leave the page in the pagecache if its
> mapped anyway?

And why not just leave it in the pagecache and be done with it?

All you need is to do a writeout before a direct IO read, which is
what generic dio code does.

I guess you'll say that direct writes still need to remove pages,
but in that case you'll either have to live with some racyness
(which is what the generic code does), or have a higher level
synchronisation to prevent buffered + direct IO writes I suppose?

>>None of the existing functions for truncating pages or invalidating
>>pages work in this situation. Invalidating a page only works for
>>non-dirty pages with non-dirty buffers, and they only work for
>>whole pages and XFS requires partial page truncation.
>>
>>On top of that the page invalidation functions don't actually
>>call into the filesystem to invalidate the page and so the filesystem
>>can't actually invalidate the page properly (e.g. do stuff based on
>>private buffer head flags).
> 
> 
> Have you seen the new launder_page() a_op? called from
> invalidate_inode_pages2_range()

It would have been nice to make that one into a more potentially
useful generic callback.

But why was it introduced, exactly? I can't tell from the code or
the discussion why NFS couldn't start the IO, and signal the caller
to wait_on_page_writeback and retry? That seemed to me like the
convetional fix.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
