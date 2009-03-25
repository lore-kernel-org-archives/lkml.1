Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbZCYTxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbZCYTxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZCYTxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:53:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37538 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbZCYTxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:53:22 -0400
Message-ID: <49CA8ADA.3040709@redhat.com>
Date: Wed, 25 Mar 2009 15:49:46 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk>
In-Reply-To: <20090325194341.GB27476@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Mar 25 2009, Jeff Garzik wrote:
>   
>> Jens Axboe wrote:
>>     
>>> On Tue, Mar 24 2009, Jeff Garzik wrote:
>>>       
>>>> Linus Torvalds wrote:
>>>>         
>>>>> But I really don't understand filesystem people who think that 
>>>>> "fsck" is the important part, regardless of whether the data is 
>>>>> valid or not. That's just stupid and _obviously_ bogus.
>>>>>           
>>>> I think I can understand that point of view, at least:
>>>>
>>>> More customers complain about hours-long fsck times than they do 
>>>> about  silent data corruption of non-fsync'd files.
>>>>
>>>>
>>>>         
>>>>> The point is, if you write your metadata earlier (say, every 5 sec) 
>>>>> and the real data later (say, every 30 sec), you're actually MORE 
>>>>> LIKELY to see corrupt files than if you try to write them together.
>>>>>
>>>>> And if you write your data _first_, you're never going to see  
>>>>> corruption at all.
>>>>>           
>>>> Amen.
>>>>
>>>> And, personal filesystem pet peeve:  please encourage proper FLUSH 
>>>> CACHE  use to give users the data guarantees they deserve.  Linux's 
>>>> sync(2) and  fsync(2) (and fdatasync, etc.) should poke the block 
>>>> layer to guarantee  a media write.
>>>>         
>>> fsync already does that, at least if you have barriers enabled on your
>>> drive.
>>>       
>> Erm, no, you don't enable barriers on your drive, they are not a  
>> hardware feature.  You enable barriers via your filesystem.
>>     
>
> Thanks for the lesson Jeff, I'm obviously not aware how that stuff
> works...
>
>   
>> Stating "fsync already does that" borders on false, because that assumes
>> (a) the user has a fs that supports barriers
>> (b) the user is actually aware of a 'barriers' mount option and what it  
>> means
>> (c) the user has turned on an option normally defaulted to off.
>>
>> Or in other words, it pretty much never happens.
>>     
>
> That is true, except if you use xfs/ext4. And this discussion is fine,
> as was the one a few months back that got ext4 to enable barriers by
> default. If I had submitted patches to do that back in 2001/2 when the
> barrier stuff was written, I would have been shot for introducing such a
> slow down. After people found out that it just wasn't something silly,
> then you have a way to enable it.
>
> I'd still wager that most people would rather have a 'good enough
> fsync' on their desktops than incur the penalty of barriers or write
> through caching. I know I do.
>
>   
>> Furthermore, a blatantly obvious place to flush data to media --  
>> fsync(2), fdatasync(2) and sync_file_range(2) -- should cause the block  
>> layer to issue a FLUSH CACHE for __any__ filesystem.  But that doesn't  
>> happen either.
>>
>> So, no, for 95% of Linux users, fsync does _not_ already do that.  If  
>> you are lucky enough to use XFS or ext4, you're covered.  That's it.
>>     
>
> The point is that you need to expose this choice somewhere, and that
> 'somewhere' isn't manually editing fstab and enabling barriers or
> fsync-for-real. And it should be easier.
>
> Another problem is that FLUSH_CACHE sucks. Really. And not just on
> ext3/ordered, generally. Write a 50 byte file, fsync, flush cache and
> wit for the world to finish. Pretty hard to teach people to use a nicer
> fdatasync(), when the majority of the cost now becomes flushing the
> cache of that 1TB drive you happen to have 8 partitions on. Good luck
> with that.
>
>   
And, as I am sure that you do know, to add insult to injury, FLUSH_CACHE 
is per device (not file system).

When you issue an fsync() on a disk with multiple partitions, you will 
flush the data for all of its partitions from the write cache....

ric

