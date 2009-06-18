Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZFRSMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZFRSMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZFRSMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:12:47 -0400
Received: from mail.fieldses.org ([141.211.133.115]:52717 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbZFRSMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:12:46 -0400
Date: Thu, 18 Jun 2009 14:12:42 -0400
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: David Rientjes <rientjes@google.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1: nfsd: page allocation failure - nfsd or kernel
	problem?
Message-ID: <20090618181242.GI9679@fieldses.org>
References: <4A37FE48.6070306@msgid.tls.msk.ru> <4A38ACC0.3060501@msgid.tls.msk.ru> <alpine.DEB.2.00.0906170542170.3600@p34.internal.lan> <4A38C7CA.7040005@msgid.tls.msk.ru> <20090617185139.GF24040@fieldses.org> <4A395119.5060108@msgid.tls.msk.ru> <alpine.DEB.2.00.0906171335590.4786@chino.kir.corp.google.com> <4A3A00D9.8090504@msgid.tls.msk.ru> <alpine.DEB.2.00.0906180956560.2894@chino.kir.corp.google.com> <4A3A7FDE.2050301@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3A7FDE.2050301@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 09:56:46PM +0400, Michael Tokarev wrote:
> David Rientjes wrote:
>> On Thu, 18 Jun 2009, Michael Tokarev wrote:
>>
>>> David Rientjes wrote:
>>>> On Thu, 18 Jun 2009, Michael Tokarev wrote:
>>>>
>>>>>> 	http://bugzilla.kernel.org/show_bug.cgi?id=13518
>>>>> Does not look similar.
>>>>>
>>>>> I repeated the issue here.  The slab which is growing here is buffer_head.
>>>>> It's growing slowly -- right now, after ~5 minutes of constant writes over
>>>>> nfs, its size is 428423 objects, growing at about 5000 objects/minute
>>>>> rate.
>>>>> When stopping writing, the cache shrinks slowly back to an acceptable
>>>>> size, probably when the data gets actually written to disk.
>>>> Not sure if you're referring to the bugzilla entry or Justin's reported
>>>> issue.  Justin's issue is actually allocating a skbuff_head_cache slab while
>>>> the system is oom.
>>> We have the same issue - I replied to Justin's initial email with exactly
>>> the same trace as him.  I didn't see your reply up until today, -- the one
>>> you're referring to below.
>>>
>>
>> If it's the exact same trace, then the page allocation failure is  
>> occurring as the result of slab's growth of the skbuff_head_cache 
>> cache, not buffer_head.
>
> See http://lkml.org/lkml/2009/6/16/550 -- second message in this thread
> is mine, it shows exactly the same trace.
>
>> So it appears as though the issue you're raising is that buffer_head is 
>> consuming far too much memory, which causes the system to be oom when  
>> attempting a GFP_ATOMIC allocation for skbuff_head_cache and is 
>> otherwise unseen with alloc_buffer_head() because it is allowed to 
>> invoke direct reclaim:
>>
>> 	$ grep -r alloc_buffer_head\( fs/*
>> 	fs/buffer.c:		bh = alloc_buffer_head(GFP_NOFS);
>> 	fs/buffer.c:struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
>> 	fs/gfs2/log.c:	bh = alloc_buffer_head(GFP_NOFS | __GFP_NOFAIL);
>> 	fs/jbd/journal.c:	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
>> 	fs/jbd2/journal.c:	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
>
> Might be.
>
> Here, I see the following scenario.  With freshly booted server, 1.9Gb RAM,
> slabtop shows about 11K entries in buffer_head slab, and about 1.7Gb free RAM.
>
> When starting writing from another machine to this one over nfs, buffer_head
> slab grows quite rapidly up to about 450K entries (total size 48940K) and
> free memory drops to almost zero -- this happens in first 1..2 minutes
> (GigE network, writing from /dev/zero using dd).
>
> The cache does not grow further -- just because there's no free memory for
> growing.  On a 4Gb machine it grows up to about 920K objects.
>
> And from time to time during write the same warning occurs.  And slows
> down write from ~70Mb/sec (it is almost the actual speed of the target
> drive - it can do ~80Mb/sec) to almost zero for several seconds.
>
>>> As far as I can see, the warning itself, while harmless, indicates some
>>> deeper problem.  Namely, we shouldn't have an OOM condition - the system
>>> is doing nothing but NFS, there's only one NFS client which writes single
>>> large file, the system has 2GB (or 4Gb on another machine) RAM.  It should
>>> not OOM to start with.
>>
>> Thanks to the page allocation failure that Justin posted earlier, which 
>> shows the state of the available system memory, it shows that the 
>> machine truly is oom.  You seem to have isolated that to an enormous 
>> amount of buffer_head slab, which is a good start.
>
> It's not really slabs it seems.  In my case the total amount of buffer_heads
> is about 49Mb which is very small compared with the amount of memory on the
> system.  But as far as I can *guess* buffer_head is just that - head, a
> pointer to some other place...  Unwritten or cached data?
>
> Note that the only way to shrink that buffer_head cache back is to remove
> the file in question on the server.
>
>>> Well, there ARE side-effects actually.  When the issue happens, the I/O
>>> over NFS slows down to almost zero bytes/sec for some while, and resumes
>>> slowly after about half a minute - sometimes faster, sometimes slower.
>>> Again, the warning itself is harmless, but it shows a deeper issue.  I
>>> don't think it's wise to ignore the sympthom -- the actual cause should
>>> be fixed instead.  I think.
>>
>> Since the GFP_ATOMIC allocation cannot trigger reclaim itself, it must  
>> rely on other allocations or background writeout to free the memory and 
>> this will be considerably slower than a blocking allocation.  The page  
>> allocation failure messages from Justin's post indicate there are 0 
>> pages under writeback at the time of oom yet ZONE_NORMAL has 
>> reclaimable memory; this is the result of the nonblocking allocation.
>
> So... what's the "consensus" so far?  Just shut up the warning as you
> initially proposed?

No, it's normal for clients to want to write data as fast as they can,
and we should throttle them so that we offer the disk bandwidth
consistently instead of accepting too much and then stalling.

Unfortunately I'm not very good at thinking about this kind of io/vm
behavior!  I guess what should be happening is the nfsd thread's writes
should start blocking earlier than they are.  I'm not sure where that's
decided.

There's always the dumb approach of going back in time to see
if there's an older kernel that handled this better, then bisecting to
figure out what changed.  Testing on server with much less RAM might
help reproduce the problem faster.

(E.g. from a very quick test yesterday it looked to me like I could
reproduce something like this fairly quickly with a small virtual server
on my laptop.)

--b.
