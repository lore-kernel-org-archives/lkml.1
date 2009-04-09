Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbZDICk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbZDICk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 22:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZDICkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 22:40:46 -0400
Received: from sandeen.net ([209.173.210.139]:29401 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbZDICkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 22:40:45 -0400
Message-ID: <49DD602B.5060208@sandeen.net>
Date: Wed, 08 Apr 2009 21:40:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ray Lee <ray-lk@madrabbit.org>, Hua Zhong <hzhong@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>  <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>  <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>  <20090406183157.GD7376@mit.edu> <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>  <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>  <003001c9b6ff$a9259ce0$fb70d6a0$@com> <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com> <alpine.LFD.2.00.0904061509020.7443@localhost.localdomain> <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 6 Apr 2009, Linus Torvalds wrote:
>> thing that we think people would be happiest with.
>>
>> I think "ordered" was a reasonable default, but that was at least partly 
>> because _both_ ordered and writeback sucked (partly in different ways).
>>
>> I do think we could make it a config option.
> 
> A patch _something_ like this.
> 
> A few notes:
> 
>  - This is UNTESTED (of course)
> 
>  - If I did this right, this _only_ overrides the data mode if it's not 
>    explicitly specified on disk in the superblock mount options.
> 
> IOW, if you have done a 
> 
> 	tune2fs -o journal_data_ordered
> 
> then this will _not_ override that. Only in the absense of any explicit 
> flags should this trigger and then make the choice be 'writeback'.
> 
> And just to be _extra_ backwards compatible, if you really want the old 
> behavior, and don't want to set the ordering flag explicitly, just answer 
> 'y' to the EXT3_DEFAULTS_TO_ORDERED Kconfig question. 
> 
> What do people think? Anybody want to test?

I think this is a terrible idea.  I ran the following test with
data=writeback on 2.6.29.1 (which doesn't have the rename & truncate
hacks, but they would not help in this case, either):

tar xvjf linux-2.6.29.1.tar.bz2; echo b > /proc/sysrq-trigger

This simulates a crash on a busy system.  I got back 8000+ files
containing other people's data.

data=ordered isn't just "nicer" behavior than writeback on a crash, it's
necessary today for security.  Making data=writeback default is a
security flaw.

Are we really considering (wait, not considering; it's checked in
already!) - blowing a huge security hole in the filesystem used on the
vast majority of installations in the name of speed?

Chris suggested earlier in this thread that we should use the XFS trick
of not extending the i_size until io completion, and I agree that it
makes sense.  Chris even offered to take a stab at it and I hope I can
work with him on this.  It's a -much- better answer than this
reactionary change.

-Eric
