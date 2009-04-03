Return-Path: <linux-kernel-owner+w=401wt.eu-S933911AbZDCPOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbZDCPOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZDCPOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:14:42 -0400
Received: from rtr.ca ([76.10.145.34]:46985 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340AbZDCPOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:14:41 -0400
Message-ID: <49D627DF.6090501@rtr.ca>
Date: Fri, 03 Apr 2009 11:14:39 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Rees <drees76@gmail.com>,
       Janne Grunau <j@jannau.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090325183011.GN32307@mit.edu> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel> <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org> <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain> <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 2 Apr 2009, Linus Torvalds wrote:
>> On Thu, 2 Apr 2009, Andrew Morton wrote:
>>> A suitable design for the streaming might be, every 4MB:
>>>
>>> - run sync_file_range(SYNC_FILE_RANGE_WRITE) to get the 4MB underway
>>>   to the disk
>>>
>>> - run fadvise(POSIX_FADV_DONTNEED) against the previous 4MB to
>>>   discard it from pagecache.
>> Here's an example. I call it "overwrite.c" for obvious reasons.
> 
> Oh, except my example doesn't do the fadvise. Instead, I make sure to 
> throttle the writes and the old range with
> 
> 	SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE|SYNC_FILE_RANGE_WAIT_AFTER
> 
> which makes sure that the old pages are easily dropped by the VM - and 
> they will be, since they end up always being on the cold list.
> 
> I _wanted_ to add a SYNC_FILE_RANGE_DROP but I never bothered because this 
> particular load it didn't matter. The system was perfectly usable while 
> overwriting even huge disks because there was never more than 8MB of dirty 
> data in flight in the IO queues at any time.
..

Note that for mythtv, this may not be the best behaviour.

A common use scenario is "watching live TV", a few minutes behind
real-time so that the commercial-skipping can work its magic.

In that scenario, those pages are going to be needed again
within a short while, and it might be useful to keep them around.

But then Myth itself could probably decide whether to discard them
or not, not based upon that kind of knowledge.
