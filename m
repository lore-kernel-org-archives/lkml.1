Return-Path: <linux-kernel-owner+w=401wt.eu-S1765796AbXGZHxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765796AbXGZHxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 03:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbXGZHxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 03:53:39 -0400
Received: from ppsw-9.csi.cam.ac.uk ([131.111.8.139]:42127 "EHLO
	ppsw-9.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbXGZHxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 03:53:38 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <20070726023639.GD20727@wotan.suse.de>
References: <20070710210326.GA29963@think.oraclecorp.com> <20070724160032.7a7097db@think.oraclecorp.com> <1185307985.6586.50.camel@localhost> <1185312343.5535.5.camel@lappy> <20070724192509.5bc9b3fe@think.oraclecorp.com> <20070725023217.GA32076@wotan.suse.de> <20070725081853.4b325e7f@think.oraclecorp.com> <20070726013728.GB20727@wotan.suse.de> <20070725221007.0edcc2dc@think.oraclecorp.com> <20070726023639.GD20727@wotan.suse.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <377C3238-BFBE-49B4-98E7-EB866A4EBAC6@cam.ac.uk>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [PATCH RFC] extent mapped page cache
Date: Thu, 26 Jul 2007 08:53:21 +0100
To: Nick Piggin <npiggin@suse.de>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 26 Jul 2007, at 03:36, Nick Piggin wrote:

> On Wed, Jul 25, 2007 at 10:10:07PM -0400, Chris Mason wrote:
>> On Thu, 26 Jul 2007 03:37:28 +0200
>> Nick Piggin <npiggin@suse.de> wrote:
>>
>>>
>>>> One advantage to the state tree is that it separates the state from
>>>> the memory being described, allowing a simple kmap style interface
>>>> that covers subpages, highmem and superpages.
>>>
>>> I suppose so, although we should have added those interfaces long
>>> ago ;) The variants in fsblock are pretty good, and you could always
>>> do an arbitrary extent (rather than block) based API using the
>>> pagecache tree if it would be helpful.
>>
>> Yes, you could use fsblock for the state bits and make a separate API
>> to map the actual pages.
>>
>>>
>>>
>>>> It also more naturally matches the way we want to do IO, making for
>>>> easy clustering.
>>>
>>> Well the pagecache tree is used to reasonable effect for that now.
>>> OK the code isn't beautiful ;). Granted, this might be an area where
>>> the seperate state tree ends up being better. We'll see.
>>>
>>
>> One thing it gains us is finding the start of the cluster.  Even if
>> called by kswapd, the state tree allows writepage to find the  
>> start of
>> the cluster and send down a big bio (provided I implement trylock to
>> avoid various deadlocks).
>
> That's very true, we could potentially also do that with the block  
> extent
> tree that I want to try with fsblock.
>
> I'm looking at "cleaning up" some of these aops APIs so hopefully  
> most of
> the deadlock problems go away. Should be useful to both our  
> efforts. Will
> post patches hopefully when I get time to finish the draft this  
> weekend.
>
>
>>>> O_DIRECT becomes a special case of readpages and writepages....the
>>>> memory used for IO just comes from userland instead of the page
>>>> cache.
>>>
>>> Could be, although you'll probably also need to teach the mm about
>>> the state tree and/or still manipulate the pagecache tree to prevent
>>> concurrency?
>>
>> Well, it isn't coded yet, but I should be able to do it from the FS
>> specific ops.
>
> Probably, if you invalidate all the pagecache in the range beforehand
> you should be able to do it (and I guess you want to do the invalidate
> anyway). Although, below deadlock issues might still bite somehwere...
>
>
>>> But isn't the main aim of O_DIRECT to do as little locking and
>>> synchronisation with the pagecache as possible? I thought this is
>>> why your race fixing patches got put on the back burner (although
>>> they did look fairly nice from a correctness POV).
>>
>> I put the placeholder patches on hold because handling a corner case
>> where userland did O_DIRECT from a mmap'd region of the same file  
>> (Linus
>> pointed it out to me).  Basically my patches had to work in 64k  
>> chunks
>> to avoid a deadlock in get_user_pages.  With the state tree, I can
>> allow the page to be faulted in but still properly deal with it.
>
> Oh right, I didn't think of that one. Would you still have similar
> issues with the external state tree? I mean, the filesystem doesn't
> really know why the fault is taken. O_DIRECT read from a file into
> mmapped memory of the same block in the file is almost hopeless I
> think.
>
>
>>> Well I'm kind of handwaving when it comes to O_DIRECT ;) It does  
>>> look
>>> like this might be another advantage of the state tree (although you
>>> aren't allowed to slow down buffered IO to achieve the locking ;)).
>>
>> ;) The O_DIRECT benefit is a fringe thing.  I've long wanted to help
>> clean up that code, but the real point of the patch is to make  
>> general
>> usage faster and less complex.  If I can't get there, the O_DIRECT
>> stuff doesn't matter.
>
> Sure, although unifying code is always a plus so I like that you've
> got that in mind.
>
>
>>>> The ability to put in additional tracking info like the process  
>>>> that
>>>> first dirtied a range is also significant.  So, I think it is worth
>>>> trying.
>>>
>>> Definitely, and I'm glad you are. You haven't converted me yet, but
>>> I look forward to finding the best ideas from our two approaches  
>>> when
>>> the patches are further along (ext2 port of fsblock coming along, so
>>> we'll be able to have races soon :P).
>>
>> I'm sure we can find some river in Cambridge, winner gets to throw
>> Axboe in.
>
> Very noble of you to donate your colleage to such a worthy cause.

Cambridge = Cam + Bridge = Bridge over the river Cam

The Cam is a bit muddy though so it is not a very enjoyable  
experience falling/being thrown into it.

Nice for punting on though when the weather is nice.  (-:

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


