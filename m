Return-Path: <linux-kernel-owner+w=401wt.eu-S1751239AbXFYHQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbXFYHQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 03:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbXFYHQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 03:16:29 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:46440 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750950AbXFYHQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 03:16:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=FCulWej0wrwFxbOUlBGxC03gfrfuI6r5BmKfoZS4YE6psbrn9oxJ+q0maoCgMPcxyEVUOmnIwfr1hm5b4PvONdE2+/gsRCzA3UJHfwqCROdQRL5zzD6av4sfgM5cC03liLcf9uNLV0kzuf30Uc0hUg8vRzOGgQYAm11hZylanow=  ;
X-YMail-OSG: axTNW7cVM1mgi06r7tmV.rEVtGX2CWhEVqdOxT5NhxOCYtkWMEynyNtfEDFjZkFpEzZGPeUaOQ--
Message-ID: <467F6BC6.60209@yahoo.com.au>
Date: Mon, 25 Jun 2007 17:16:22 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] fsblock
References: <20070624014528.GA17609@wotan.suse.de> <p73lke95tfm.fsf@bingen.suse.de>
In-Reply-To: <p73lke95tfm.fsf@bingen.suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Nick Piggin <npiggin@suse.de> writes:
> 
>>- Structure packing. A page gets a number of buffer heads that are
>>  allocated in a linked list. fsblocks are allocated contiguously, so
>>  cacheline footprint is smaller in the above situation.
> 
> 
> It would be interesting to test if that makes a difference for 
> database benchmarks running over file systems. Databases
> eat a lot of cache so in theory any cache improvements
> in the kernel which often runs cache cold then should be beneficial. 
> 
> But I guess it would need at least ext2 to test; Minix is probably not
> good enough.

Yeah, you are right. ext2 would be cool to port as it would be
a reasonable platform for basic performance testing and comparisons.


> In general have you benchmarked the CPU overhead of old vs new code? 
> e.g. when we went to BIO scalability went up, but CPU costs
> of a single request also went up. It would be nice to not continue
> or better reverse that trend.

At the moment there are still a few silly things in the code, such
as always calling the insert_mapping indirect function (which is
the get_block equivalent). And it does a bit more RMWing than it
should still.

Also, it always goes to the pagecache radix-tree to find fsblocks,
wheras the buffer layer has a per-CPU cache front-end... so in
that regard, fsblock is really designed with lockless pagecache
in mind, where find_get_page is much faster even in the serial case
(though fsblock shouldn't exactly be slow with the current pagecache).

However, I don't think there are any fundamental performance
problems with fsblock. It even uses one less layer of locking to
do regular IO compared with buffer.c, so in theory it might even
have some advantage.

Single threaded performance of request submission is something I
will definitely try to keep optimal.


>>- Large block support. I can mount and run an 8K block size minix3 fs on
>>  my 4K page system and it didn't require anything special in the fs. We
>>  can go up to about 32MB blocks now, and gigabyte+ blocks would only
>>  require  one more bit in the fsblock flags. fsblock_superpage blocks
>>  are > PAGE_CACHE_SIZE, midpage ==, and subpage <.
> 
> 
> Can it be cleanly ifdefed or optimized away?

Yeah, it pretty well stays out of the way when using <= PAGE_CACHE_SIZE
size blocks, generally just a single test and branch of an already-used
cacheline. It can be optimised away completely by commenting out
#define BLOCK_SUPERPAGE_SUPPORT from fsblock.h.


> Unless the fragmentation
> problem is not solved it would seem rather pointless to me. Also I personally
> still think the right way to approach this is larger softpage size.

It does not suffer from a fragmentation problem. It will do scatter
gather IO if the pagecache of that block is not contiguous. My naming
may be a little confusing: fsblock_superpage (which is a function that
returns true if the given fsblock is larger than PAGE_CACHE_SIZE) is
just named as to whether the fsblock is larger than a page, rather than
having a connection to VM superpages.

Don't get me wrong, I think soft page size is a good idea for other
reasons as well (less page metadata and page operations), and that
8 or 16K would probably be a good sweet spot for today's x86 systems.

-- 
SUSE Labs, Novell Inc.
