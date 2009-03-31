Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZCaLUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZCaLUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 07:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZCaLU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 07:20:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54271 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZCaLU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:20:26 -0400
Message-ID: <49D1FB64.8000505@redhat.com>
Date: Tue, 31 Mar 2009 07:15:48 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       =?ISO-8859-1?Q?Fernando_Luis_?= =?ISO-8859-1?Q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk> <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain> <49D17CA2.5060105@redhat.com> <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 30 Mar 2009, Ric Wheeler wrote:
>   
>> One thing the caller could do is to disable the write cache on the device.
>>     
>
> First off, that's not the callers job. If the sysadmin enabled it, some 
> random filesystem shouldn't disable it.
>
> Secondly, this whole insane belief that "write cache" has anything to do 
> with "unable to flush" is just bogus. 
>   

First I have heard anyone (other than you above) claim that "unable to 
flush" is tied to the write cache on disks.

What I was responding to is your objection to exposing the proper error 
codes to the file system layer instead of hiding them in the block 
layer. True, the write cache example I used is pretty contrived, but it 
would be a valid strategy if your sacred sys admin had mounted with the 
"I do care about my data" mount option and left it up to the file system 
to make it happen.
>   
>> A second would be to stop using the transactions - skip the journal, 
>> just go back to ext2 mode or BSD like soft updates.
>>     
>
> f*ck me, what's so hard with understanding that EOPNOTSUPP doesn't mean 
> "no ordering". It means what it says - the op isn't supported. For all you 
> know, ALL WRITES MAY BE TOTALLY ORDERED, but perhaps there is no way to 
> make a _single_ write totally atomic (ie the "set barrier on a command 
> that actually does IO").
>   

Now you are just being silly. The drive and the write cache - without 
barriers or similar tagged operations - will almost certainly reorder 
all of the IO's internally.

No one designs code based on the "it might be ordered" basis.

The way the barriers work does absolutely give you full ordering.  All 
previous IO's are sent to the drive and flushed (barrier flush 1), the 
commit record is sent down followed by a second barrier flush. There is 
no way that the commit block will pass its dependent IO's.
> Besides, why the hell do you think the filesystem (again) should do 
> something that the admin didn't ask it to do.
>
> If the admin wants the thing to fall back to ext2, then he can ask to 
> disable the journal.
>
>   
>> Basically, it lets the file system know that its data integrity building
>> blocks are not really there and allows it (if it cares) to try and minimize
>> the chance of data loss.
>>     
>
> Your whole idiotic "as a filesystem designer I know better than everybody 
> else" model where the filesystem is in total control is total crap.
>
> The fact is, it's not the filesystems job to make that decision. If the 
> admin wants to have write caching enabled, the filesystem should get the 
> hell out of the way.
>   

This is not me being snotty - this is really very basic to how 
transactions work. You need ordering and file systems (or data bases) 
that use transactions must have these building blocks to do the job right.

Your argument seems to be, "Well, it will mostly be ordered anyway, as 
long as you don't lose power" which I simply don't agree is a good 
assumption.

The logic conclusion of that argument is that we really should not use 
transactions at all - basically remove the journal from ext3/4, xfs, 
btrfs, etc.  That is a point of view - drives are crap, journalling does 
not help anyway, why bother. 

> What about laptop mode? Do you expect your filesystem to always decide 
> that "ok, the user wanted to spin down disks, but I know better"?
>   

Laptop mode is pretty much a red herring here. Mount it without barriers 
enabled - your drive will still spin up occasionally, but as you argued 
above, that existing options allows you the user/admin to make that 
trade off.

> What about people who have UPS's and don't worry about that part? They 
> want write caching on the disk, and simply don't want to sync? They still 
> worry about OS crashing, since they run random -git development kernels?
>   
If you run with a UPS or have a battery backed write cache, you should 
run without barriers since both of those mechanisms give you the 
required promise of ordering even in face of power outage.  Again, mount 
with barriers disabled (or rely on the storage target to ignore your 
cache flush commands, which higher end gear will do on a cache flush 
command).

Not hard to do, no additional code needed. We can even automate it as it 
is done in some of the linux based home storage boxes.

> In short, stop this IDIOTIC notion that you know better. YOU DO NOT KNOW 
> BETTER. The filesystem DOES NOT KNOW BETTER. It should damn well not do 
> those kinds of decisions that are simply not filesystem decisions to make!
>
> 			Linus
>   

Not surprisingly, I still disagree with you. Based, strangely enough, on 
looking at real data over many years, not just my personal experience 
with a small handful of drives.

If you don't want to run with the data integrity that we have painfully 
baked into the file & storage stack over many years, you can simply 
mount without barriers.

Why tear down & attack the infrastructure for those users who do care?

ric



