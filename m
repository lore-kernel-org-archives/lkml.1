Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835Ab0AaPmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0AaPmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 10:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699Ab0AaPmX
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 10:42:23 -0500
Received: from daytona.panasas.com ([67.152.220.89]:49062 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753673Ab0AaPmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 10:42:22 -0500
Message-ID: <4B65A4D9.5010301@panasas.com>
Date: Sun, 31 Jan 2010 17:42:17 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: =?UTF-8?B?IkluZy4gRGFuaWVsIFJvenNuecOzIg==?= <daniel@rozsnyo.com>,
       Milan Broz <mbroz@redhat.com>, Marti Raudsepp <marti@juffo.org>,
       linux-kernel@vger.kernel.org,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: bio too big - in nested raid setup
References: <4B5C963D.8040802@rozsnyo.com>	<5ec358371001250725l40b13060md880001c96be165f@mail.gmail.com>	<4B5DE2A9.4030500@redhat.com>	<20100128132812.2d01f211@notabene>	<4B6157DB.6080502@rozsnyo.com>	<20100128215015.0e0ed3a8@notabene>	<4B617E03.1050403@panasas.com> <20100129091457.0088c4af@notabene>
In-Reply-To: <20100129091457.0088c4af@notabene>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jan 2010 15:42:19.0865 (UTC) FILETIME=[F9353C90:01CAA28B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2010 12:14 AM, Neil Brown wrote:
> On Thu, 28 Jan 2010 14:07:31 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> On 01/28/2010 12:50 PM, Neil Brown wrote:
>>>

I'm totally theoretical on this. So feel free to ignore me, if it gets
boring.

>>> Both raid0 and linear register a 'bvec_mergeable' function (or whatever it is
>>> called today).
>>> This allows for the fact that these devices have restrictions that cannot be
>>> expressed simply with request sizes.  In particular they only handle requests
>>> that don't cross a chunk boundary.
>>>
>>> As raid1 never calls the bvec_mergeable function of it's components (it would
>>> be very hard to get that to work reliably, maybe impossible), it treats any
>>> device with a bvec_mergeable function as though the max_sectors were one page.
>>> This is because the interface guarantees that a one page request will always
>>> be handled.
>>>
>>
>> I'm also guilty of doing some mirror work, in exofs, over osd objects.
>>
>> I was thinking about that reliability problem with mirrors, also related
>> to that infamous problem of coping the mirrored buffers so they do not
>> change while writing at the page cache level.
> 
> So this is a totally new topic, right?
> 

Not new, I'm talking about that (no) guaranty of page not changing while in
flight, as you mention below. Which is why we need to copy the to-be-mirrored
page.

>>
>> So what if we don't fight it? what if we just keep a journal of the mirror
>> unbalanced state and do not page_uptodate until the mirror is finally balanced.
>> Only then pages can be dropped from the cache, and journal cleared.
> 
> I cannot see what you are suggesting, but it seems like a layering violation.
> The block device level cannot see anything about whether the page is up to
> date or not.  The page it has may not even be in the page cache.
> 

It is certainly a layering violation today, but theoretically speaking ,it does
not have to be. An abstract API can be made so block devices notify when page's
IO is done, at this point VFS can decide if it must resubmit do to page changing
while IO or the IO is actually valid at this point.

> The only thing that the block device can do is make a copy of the page and
> write that out twice.
> 

That is the copy I was referring to.

> If we could have a flag which the filesystem can send to say "I promise not
> to change this page until the IO completes", then that copy could be
> optimised away in lots of common cases.
> 

What I meant is: What if we only have that knowledge at end of IO, So we can decide
at that point if the page is up-to-date and is allowed to be evicted from cache.
It's the same as if we have a crash/power-failure while IO, surely the mirrors are
not balanced, and each device's file content cannot be determained some of the
last written buffer is old, some new, and some undefined. That is the roll of the
file-system to keep a journal and decide what data can be guaranteed and what
data must be reverted to a last known good state. Now what I'm wondering is what
if we prolong this window to until we know the mirrors match. The window for disaster
is wider, but should never matter in normal use. Most setups could tolerate the
bad statistics, and could use the extra bandwidth.

> 
>>
>> (Balanced-mirror-page is when a page has participated in an IO to all devices
>>  without being marked dirty from the get-go to the completion of IO)
>>
> 
> Block device cannot see the 'dirty' flag.
> 

Right, but is there some additional information a block device should communicate
to the FS so it can make a decision?

> 
>> I think Trond's last work with adding that un_updated-but-committed state to
>> pages can facilitate in doing that, though I do understand that it is a major
>> conceptual change to the the VFS-BLOCKS relationship in letting the block devices
>> participate in the pages state machine (And md keeping a journal). Sigh
>>
>> ??
>> Boaz
> 
> NeilBrown

Thanks
Boaz
