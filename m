Return-Path: <linux-kernel-owner+w=401wt.eu-S933826AbXC1H6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbXC1H6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 03:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXC1H6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 03:58:33 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:34212 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753215AbXC1H6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 03:58:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=22DFHQbKIJJcwFOVCUbZymXU1OkOhRmQ7mzhYDDydIhHMOdKdQfy9hmmjSFmX/cLVuXI2RKipKfhugTguS3Q0JqSbE31/JVJA5XiRsjjlLf+yzmI03e9aebgHW9eM1iEeVPWyAqPijMWN5/ZFSu0n2ukDJU0H24o5gbloOJQVjE=  ;
X-YMail-OSG: __ZTbUgVM1mgSHmdo5MTOEz1LUTF1F0eEpcw2sNdawGU7cwFOMOxUN3zbYfgsVqa1TUqHZ.8jiuxG6l8oKcmVusMH9X4XDDtdBY7HoqY2sUk83NxcWw-
Message-ID: <460A201C.3070405@yahoo.com.au>
Date: Wed, 28 Mar 2007 17:58:20 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: linux@horizon.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
References: <20070328014816.4159.qmail@science.horizon.com>
In-Reply-To: <20070328014816.4159.qmail@science.horizon.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux@horizon.com wrote:
>>Linux _will_ write all modified data to permanent storage locations.
>>Since 2.6.17 it will do this regardless of msync().  Before 2.6.17 you
>>do need msync() to enable data to be written back.
>>
>>But it will not start I/O immediately, which is not a requirement in
>>the standard, or at least it's pretty vague about that.
> 
> 
> As I've said before, I disagree, but I'm not going to start a major
> flame war about it.
> 
> The most relevant paragraph is:
> 
> # When MS_ASYNC is specified, msync() returns immediately once all the
> # write operations are initiated or queued for servicing; when MS_SYNC is
> # specified, msync() will not return until all write operations are
> # completed as defined for synchronised I/O data integrity completion.
> # Either MS_ASYNC or MS_SYNC is specified, but not both.
> 
> Note two things:
> 1) In the paragraphs before, what msync does is defined independently
>    of the MS_* flags.  Only the time of the return to user space varies.
>    Thus, whatever the delay between calling msync() and the data being
>    written, it should be the same whether MS_SYNC or MS_ASYNC is used.
> 
>    The implementation intended is:
>    - Start all I/O
>    - If MS_SYNC, wait for I/O to complete
>    - Return to user space

set_page_dirty queues pages for IO, and the writeout daemon will service
that queue when it sees fit. IMO it is sufficient that you cannot say the
implementation does not meet the standard.


> 2) "all the write operations are initiated or queued for servicing".
>    It is a common convention in English (and most languages, I expect)
>    that in the "or" is a preference for the first alternative.  The second
>    is a permitted alternative if the first is not possible.
> 
>    And "queued for servicing", especially "initiated or queued for
>    servicing", to me imples queuing waiting for some resource.  To have
>    the resource being waited for be a timer expiry seems like rather a
>    cheat to me.  It's perhaps doesn't break the letter of the standard,
>    but definitely bends it.  It feels like a fiddle.
> 
> Still, the basic hint function of msync(MS_ASYNC) *is* being accomplished:
> "I don't expect to write this page any more, so now would be a good time
> to clean it."
> It would just make my life easier if the kernel procrastinated less.

But if you didn't notice until now, then the current implementation
must be pretty reasonable for you use as well.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
