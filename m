Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbXAYEZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbXAYEZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 23:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbXAYEZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 23:25:48 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:20855 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752115AbXAYEZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 23:25:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=5h57CT11AypD6H/bJcdbn1stFHrby4IzQSH+BPnmINE+lW2FJCwQqQ1L6Kx9GRw8VSyC+m6IL48GM7MtcXoMgrzdi+OR8tfilK0Bg9l3pEi+SnNaubdJ7Soh3Iy63RDebtVzMUfJkjLBz3+khS4FjURO8xL8Pf+z5VXHycBejT8=  ;
X-YMail-OSG: GDBSSjIVM1m8zYk78_rOBSbBIE66TPRC7xBG6bDwAYop4B6U
Message-ID: <45B83139.1040007@yahoo.com.au>
Date: Thu, 25 Jan 2007 15:25:29 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@osdl.org
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
References: <20070123223702.GF33919298@melbourne.sgi.com> <1169640835.6189.14.camel@twins> <45B7627B.8050202@yahoo.com.au> <20070124224654.GN33919298@melbourne.sgi.com> <45B7F5F9.2070308@yahoo.com.au> <20070125003536.GS33919298@melbourne.sgi.com> <45B7FE1C.3070807@yahoo.com.au> <20070125015204.GV33919298@melbourne.sgi.com> <45B80F65.6010206@yahoo.com.au> <20070125034227.GX33919298@melbourne.sgi.com>
In-Reply-To: <20070125034227.GX33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Thu, Jan 25, 2007 at 01:01:09PM +1100, Nick Piggin wrote:
> 
>>David Chinner wrote:

>>>No. The only thing that will happen here is that the direct read
>>>will see _none_ of the write because the mmap write occurred during
>>>the DIO read to a different set of pages in memory. There is no
>>>"some" or "all" case here.
>>
>>But if the buffers get partially or completely written back in the
>>meantime, then the DIO read could see that.
> 
> 
> Only if you can dirty them and flush them to disk while the direct
> read is waiting in the I/O queue (remember, the direct read flushes
> dirty cached data before being issued). Given that we don't lock the
> inode in the buffered I/O *writeback* path, we have to stop pages being
> dirtied in the page cache up front so we don't have mmap writeback
> over the top of the direct read.

However unlikely it may be, that is what I'm talking about in my "some"
or "all" cases. Note that I'm not talking about a specific implementation
(eg. XFS I guess avoids "some"), but just the possible scenarios.

> Hence we have to prevent mmap for dirtying the same file offset we
> are doing direct reads on until the direct read has been issued.
> 
> i.e. we need a barrier.

So you need to eliminate the "some" case? Because of course "none" and
"all" are unavoidable.

>>>IOWs, at a single point in time we have 2 different views
>>>of the one file which are both apparently valid and that is what
>>>we are trying to avoid. We have a coherency problem here which is
>>>solved by forcing the mmap write to reread the data off disk....
>>
>>I don't see why the mmap write needs to reread data off disk. The
>>data on disk won't get changed by the DIO read.
> 
> 
> No, but the data _in memory_ will, and now when the direct read
> completes it will data that is different to what is in the page
> cache. For direct I/O we define the correct data to be what is on
> disk, not what is in memory, so any time we bypass what is in
> memory, we need to ensure that we prevent the data being changed
> again in memory before we issue the disk I/O.

But when you drop your locks, before the direct IO read returns, some
guy can mmap and dirty the pagecache anyway. By the time the read
returns, the data is stale. This obviously must be synchronised in
userspace.

As I said, you can't avoid "none" or "all", and you can't say that
userspace will see the most uptodate copy of the data. All you can
say is that it will be no older than when the syscall is first made.
Which is what you get if you simply writeback but do not invalidate
pagecache for direct IO reads.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
