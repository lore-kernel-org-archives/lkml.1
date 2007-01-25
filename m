Return-Path: <linux-kernel-owner+w=401wt.eu-S932948AbXAYAM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948AbXAYAM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932965AbXAYAM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:12:58 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:25615 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932948AbXAYAM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:12:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=SUG/0qvcxeFnLgrcwo+MdUKRKMnHVXMD1ZALUDcM+Ya7ZBVTClXe6UiXDLpAPx2VK7zB2nqabEsW6KO5jniY3OkpuYzWwKaLVbI/3GxELWldXsLPctfRQsL/MGmmic54bngsJzPy6sv5WZEqeYAZe3uZ7QGwPc8wH6Jl8e3aucI=  ;
X-YMail-OSG: vBQBlUgVM1nL5FVXzyr6L1deC41pJun8tVa9X3TepIrBDJXRYFfqjiFAwiwCOXg2g4MG_wDHEw--
Message-ID: <45B7F5F9.2070308@yahoo.com.au>
Date: Thu, 25 Jan 2007 11:12:41 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@osdl.org
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
References: <20070123223702.GF33919298@melbourne.sgi.com> <1169640835.6189.14.camel@twins> <45B7627B.8050202@yahoo.com.au> <20070124224654.GN33919298@melbourne.sgi.com>
In-Reply-To: <20070124224654.GN33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Thu, Jan 25, 2007 at 12:43:23AM +1100, Nick Piggin wrote:

>>And why not just leave it in the pagecache and be done with it?
> 
> 
> because what is in cache is then not coherent with what is on disk,
> and a direct read is supposed to read the data that is present
> in the file at the time it is issued. 

So after a writeout it will be coherent of course, so the point in
question is what happens when someone comes in and dirties it at the
worst possible moment? That relates to the paragraph below...

>>All you need is to do a writeout before a direct IO read, which is
>>what generic dio code does.
> 
> 
> No, that's not good enough - after writeout but before the
> direct I/O read is issued a process can fault the page and dirty
> it. If you do a direct read, followed by a buffered read you should
> get the same data. The only way to guarantee this is to chuck out
> any cached pages across the range of the direct I/O so they are
> fetched again from disk on the next buffered I/O. i.e. coherent
> at the time the direct I/O is issued.

... so surely if you do a direct read followed by a buffered read,
you should *not* get the same data if there has been some activity
to modify that part of the file in the meantime (whether that be a
buffered or direct write).

>>but in that case you'll either have to live with some racyness
>>(which is what the generic code does), or have a higher level
>>synchronisation to prevent buffered + direct IO writes I suppose?
> 
> 
> The XFS inode iolock - direct I/O writes take it shared, buffered
> writes takes it exclusive - so you can't do both at once. Buffered
> reads take is shared, which is another reason why we need to purge
> the cache on direct I/O writes - they can operate concurrently
> (and coherently) with buffered reads.

Ah, I'm glad to see somebody cares about doing the right thing ;)
Maybe I'll use XFS for my filesystems in future.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
