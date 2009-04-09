Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbZDIOEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbZDIOEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760238AbZDIOD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:03:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50488 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759429AbZDIODz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:03:55 -0400
Message-ID: <49DDFFC6.2040104@redhat.com>
Date: Thu, 09 Apr 2009 10:01:42 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ray Lee <ray-lk@madrabbit.org>, Hua Zhong <hzhong@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>,
       "Stephen C. Tweedie" <sct@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>  <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>  <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>  <20090406183157.GD7376@mit.edu> <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>  <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>  <003001c9b6ff$a9259ce0$fb70d6a0$@com> <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com> <alpine.LFD.2.00.0904061509020.7443@localhost.localdomain> <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain> <49DD602B.5060208@sandeen.net>
In-Reply-To: <49DD602B.5060208@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2009 10:40 PM, Eric Sandeen wrote:
> Linus Torvalds wrote:
>    
>> On Mon, 6 Apr 2009, Linus Torvalds wrote:
>>      
>>> thing that we think people would be happiest with.
>>>
>>> I think "ordered" was a reasonable default, but that was at least partly
>>> because _both_ ordered and writeback sucked (partly in different ways).
>>>
>>> I do think we could make it a config option.
>>>        
>> A patch _something_ like this.
>>
>> A few notes:
>>
>>   - This is UNTESTED (of course)
>>
>>   - If I did this right, this _only_ overrides the data mode if it's not
>>     explicitly specified on disk in the superblock mount options.
>>
>> IOW, if you have done a
>>
>> 	tune2fs -o journal_data_ordered
>>
>> then this will _not_ override that. Only in the absense of any explicit
>> flags should this trigger and then make the choice be 'writeback'.
>>
>> And just to be _extra_ backwards compatible, if you really want the old
>> behavior, and don't want to set the ordering flag explicitly, just answer
>> 'y' to the EXT3_DEFAULTS_TO_ORDERED Kconfig question.
>>
>> What do people think? Anybody want to test?
>>      
>
> I think this is a terrible idea.  I ran the following test with
> data=writeback on 2.6.29.1 (which doesn't have the rename&  truncate
> hacks, but they would not help in this case, either):
>
> tar xvjf linux-2.6.29.1.tar.bz2; echo b>  /proc/sysrq-trigger
>
> This simulates a crash on a busy system.  I got back 8000+ files
> containing other people's data.
>
> data=ordered isn't just "nicer" behavior than writeback on a crash, it's
> necessary today for security.  Making data=writeback default is a
> security flaw.
>
> Are we really considering (wait, not considering; it's checked in
> already!) - blowing a huge security hole in the filesystem used on the
> vast majority of installations in the name of speed?
>
> Chris suggested earlier in this thread that we should use the XFS trick
> of not extending the i_size until io completion, and I agree that it
> makes sense.  Chris even offered to take a stab at it and I hope I can
> work with him on this.  It's a -much- better answer than this
> reactionary change.
>
> -Eric
>    

I agree - we definitely should work to fix the fsync latency problems, 
but this seems to jump back in time to the early 80's for UNIX file systems.

Writeback mode is just not a safe default for naive users or even more 
sophisticated users who don't understand the risks here. Definitely not 
a journal mode that any distribution would be able to ship as a default.

Wouldn't it make much more sense to leave the default at the safe data 
ordered mode and let the few people who understand the tradeoff remount 
file systems in writeback mode?

Regards,

Ric

