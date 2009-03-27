Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZC0PHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZC0PHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 11:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbZC0PHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 11:07:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33029 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZC0PHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 11:07:08 -0400
Message-ID: <49CCEAA5.8070208@redhat.com>
Date: Fri, 27 Mar 2009 11:03:01 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090327075723.GT27476@kernel.dk> <20090327141333.GS6239@mit.edu> <20090327143543.GA17541@infradead.org>
In-Reply-To: <20090327143543.GA17541@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Mar 27, 2009 at 10:13:33AM -0400, Theodore Tso wrote:
>   
>> On Fri, Mar 27, 2009 at 08:57:23AM +0100, Jens Axboe wrote:
>>     
>>> Here's a simple patch that does that. Not even tested, it compiles. Note
>>> that file systems that currently do blkdev_issue_flush() in their
>>> ->sync() should then get it removed.
>>>
>>>       
>> That's going to be a mess.  Ext3 implements an fsync() by requesting a
>> journal commit, and then waiting for the commit to have taken place.
>> The commit happens in another thread, kjournald.  Knowing when it's OK
>> not to do a blkdev_issue_flush() because the commit was triggered by
>> an fsync() is going to be really messy.  Could we at least have a flag
>> in struct super which says, "We'll handle the flush correctly, please
>> don't try to do it for us?"
>>     
>
> Doing it in vfs_fsync also is completely wrong layering.  If people want
> it for simple filesystems add it to file_fsync instead of messing up
> the generic helper.  Removing well meaning but ill behaved policy from
> the generic path has been costing me far too much time lately.
>
> And please add a tuneable for the flush.  Preferable a generic one at
> the block device layer instead of the current mess where every
> filesystem has a slightly different option for barrier usage.
>   

I agree that we need to be careful not to put extra device flushes if 
the file system handles this properly. They can be quite expensive (say 
10-20ms on a busy s-ata disk).

I have also seen some SSD devices have performance that drops into the 
toilet when you start flushing their volatile caches.

ric

