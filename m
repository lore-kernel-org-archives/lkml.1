Return-Path: <linux-kernel-owner+w=401wt.eu-S932744AbZHZBbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbZHZBbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbZHZBbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:31:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497AbZHZBbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:31:36 -0400
Message-ID: <4A94905F.7050705@redhat.com>
Date: Tue, 25 Aug 2009 21:31:11 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Andrei Tanas <andrei@tanas.ca>, linux-kernel@vger.kernel.org
Subject: Re: MD/RAID: what's wrong with sector 1953519935?
References: <004e01ca25e4$c11a54e0$434efea0$@ca>    <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name>    <4A948A82.4080901@redhat.com> <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name>
In-Reply-To: <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2009 09:24 PM, NeilBrown wrote:
> On Wed, August 26, 2009 11:06 am, Ric Wheeler wrote:
>> On 08/25/2009 08:50 PM, NeilBrown wrote:
>
>>> All 1TB drives are exactly the same size.
>>> If you create a single partition (e.g. sdb1) on such a device, and that
>>> partition starts at sector 63 (which is common), and create an md
>>> array using that partition, then the superblock will always be at the
>>> address you quote.
>>> The superblock is probably updated more often than any other block in
>>> the array, so there is probably an increased likelyhood of an error
>>> being reported against that sector.
>>>
>>> So it is not just a coincidence.
>>> Whether there is some deeper underlying problem though, I cannot say.
>>> Google only claims 68 matches for that number which doesn't seem
>>> big enough to be significant.
>>>
>>> NeilBrown
>>>
>>>
>>
>> Neil,
>>
>> One thing that can happen is when we have a hot spot (like the super
>> block) on high capacity drives is that the frequent write degrade the
>> data in adjacent tracks.  Some drives have firmware that watches for
>> this and rewrites adjacent tracks, but it is also a good idea to avoid
>> too frequent updates.
>
> Yet another detail to worry about.... :-(

it never ends :-)

>
>>
>> Didn't you have a tunable to decrease this update frequency?
>
> /sys/block/mdX/md/safe_mode_delay
> is a time in seconds (Default 0.200) between when the last write to
> the array completes and when the superblock is marked as clean.
> Depending on the actual rate of writes to the array, the superblock
> can be updated as much as twice in this time (once to mark dirty,
> once to mark clean).
>
> Increasing the number can decrease the update frequency of the superblock,
> but the exact effect on update frequency is very load-dependant.
>
> Obviously a write-intent-bitmap, which is rarely more that a few
> sectors, can also see lots of updates, and it is harder to tune
> that (you have to set things up when you create the bitmap).
>
> NeilBrown
>

We did see issues in practice with adjacent sectors with some drives, so this 
one is worth tuning down.

I would suggest that Andrei might try to write and clear the IO error at that 
offset. You can use Mark Lord's hdparm to clear a specific sector or just do the 
math (carefully!) and dd over it. It the write succeeds (without bumping your 
remapped sectors count) this is a likely match to this problem,

ric




