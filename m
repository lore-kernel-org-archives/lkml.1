Return-Path: <linux-kernel-owner+w=401wt.eu-S1762887AbZDBRof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762887AbZDBRof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbZDBRoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:44:24 -0400
Received: from smtp-out.google.com ([216.239.33.17]:32157 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZDBRoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:44:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=RVYfk7KstdWR/MBStBHzwk3sf+Ixn9S2mJgZWnse2K38zBkW/tufGxOaLtk/aDyd3
	ZRYlJ48FPxtvxujK3PPpw==
MIME-Version: 1.0
In-Reply-To: <200904030251.22197.nickpiggin@yahoo.com.au>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com>
	 <200904022224.31060.nickpiggin@yahoo.com.au>
	 <20090402113400.GC3010@duck.suse.cz>
	 <200904030251.22197.nickpiggin@yahoo.com.au>
Date: Thu, 2 Apr 2009 10:44:14 -0700
Message-ID: <604427e00904021044n73302f4uc39ca09fe96caf57@mail.gmail.com>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
From: Ying Han <yinghan@google.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jan Kara <jack@suse.cz>, "Martin J. Bligh" <mbligh@mbligh.org>,
       linux-ext4@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 8:51 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Thursday 02 April 2009 22:34:01 Jan Kara wrote:
>> On Thu 02-04-09 22:24:29, Nick Piggin wrote:
>> > On Thursday 02 April 2009 09:36:13 Ying Han wrote:
>> > > Hi Jan:
>> > >     I feel that the problem you saw is kind of differnt than mine. As
>> > > you mentioned that you saw the PageError() message, which i don't see
>> > > it on my system. I tried you patch(based on 2.6.21) on my system and
>> > > it runs ok for 2 days, Still, since i don't see the same error message
>> > > as you saw, i am not convineced this is the root cause at least for
>> > > our problem. I am still looking into it.
>> > >     So, are you seeing the PageError() every time the problem happened?
>> >
>> > So I asked if you could test with my workaround of taking truncate_mutex
>> > at the start of ext2_get_blocks, and report back. I never heard of any
>> > response after that.
>> >
>> > To reiterate: I was able to reproduce a problem with ext2 (I was testing
>> > on brd to get IO rates high enough to reproduce it quite frequently).
>> > I think I narrowed the problem down to block allocation or inode block
>> > tree corruption because I was unable to reproduce it with that hack in
>> > place.
>>   Nick, what load did you use for reproduction? I'll try to reproduce it
>> here so that I can debug ext2...
>
> OK, I set up the filesystem like this:
>
> modprobe rd rd_size=$[3*1024*1024]   #almost fill memory so we reclaim buffers
> dd if=/dev/zero of=/dev/ram0 bs=4k   #prefill brd so we don't get alloc deadlock
> mkfs.ext2 -b1024 /dev/ram0           #1K buffers
>
> Test is basically unmodified except I use 64MB files, and start 8 of them
> at once to (8 core system, so improve chances of hitting the bug). Although I
> do see it with only 1 running it takes longer to trigger.
>
> I also run a loop doing 'sync ; echo 3 > /proc/sys/vm/drop_caches' but I don't
> know if that really helps speed up reproducing it. It is quite random to hit,
> but I was able to hit it IIRC in under a minute with that setup.
>

Here is how i reproduce it:
Filesystem is ext2 with blocksize 4096
Fill up the ram with 95% anon memory and mlockall ( put enough memory
pressure which will trigger page reclaim and background writeout)
Run one thread of the test program

and i will see "bad pages" within few minutes.

--Ying
