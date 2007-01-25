Return-Path: <linux-kernel-owner+w=401wt.eu-S933132AbXAYArp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbXAYArp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXAYArp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:47:45 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:41433 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933132AbXAYAro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:47:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=vBsEclqnEYA8YFCRqLDii4+FtB7DZDDdP5F6GPqFgZGAwKEuIw50BXakUHJ5Sq3llarKX7HLGBcoyyA5JI424T0SSO/d7RuESib/OdLqAKOE1eOXIpcIUiF/hr3VH242tveqxLUgWVFusKOhdPY7D1nU0J1Es8MNRklu3oaFg/4=  ;
X-YMail-OSG: 788orj0VM1lNOySuZHAG_Jy0qusI3Mo0w.zlGU5qPFZdFi47on4ZeYCemSuKohnaqJj5bJvGZw--
Message-ID: <45B7FE1C.3070807@yahoo.com.au>
Date: Thu, 25 Jan 2007 11:47:24 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@osdl.org
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
References: <20070123223702.GF33919298@melbourne.sgi.com> <1169640835.6189.14.camel@twins> <45B7627B.8050202@yahoo.com.au> <20070124224654.GN33919298@melbourne.sgi.com> <45B7F5F9.2070308@yahoo.com.au> <20070125003536.GS33919298@melbourne.sgi.com>
In-Reply-To: <20070125003536.GS33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Thu, Jan 25, 2007 at 11:12:41AM +1100, Nick Piggin wrote:

>>... so surely if you do a direct read followed by a buffered read,
>>you should *not* get the same data if there has been some activity
>>to modify that part of the file in the meantime (whether that be a
>>buffered or direct write).
> 
> 
> Right. And that is what happens in XFS because it purges the
> caches on direct I/O and forces data to be re-read from disk.

And that is critical for direct IO writes, of course.

> Effectively, if you are mixing direct I/O with other types of I/O
> (buffered or mmap) then the application really needs to be certain
> it is doing the right thing because there are races that can occur
> below the filesystem. All we care about in the filesystem is that
> what we cache is the same as what is on disk, and that implies that
> direct I/O needs to purge the cache regardless of the state it is in....
> 
> Hence we need to unmap pages and use truncate semantics on them to
> ensure they are removed from the page cache....

OK, I understand that this does need to happen (at least for writes),
so you need to fix it regardless of the DIO read issue.

But I'm just interested about DIO reads. I think you can get pretty
reasonable semantics without discarding pagecache, but the semantics
are weaker in one aspect.

DIO read
1. writeback page
2. read from disk

Now your read will pick up data no older than 1. And if a buffered
write happens after 2, then there is no problem either.

So if you are doing a buffered write and DIO read concurrently, you
want synchronisation so the buffered write happens either before 1
or after 2 -- the DIO read will see either all or none of the write.

Supposing your pagecache isn't invalidated, then a buffered write
(from mmap, if XFS doesn't allow write(2)) comes in between 1 and 2,
then the DIO read will find either none, some, or all of that write.

So I guess what you are preventing is the "some" case. Am I right?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
