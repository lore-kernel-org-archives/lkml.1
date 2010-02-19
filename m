Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0BSVFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 16:05:24 -0500
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:42366 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752260Ab0BSVFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 16:05:21 -0500
Date: Sat, 20 Feb 2010 08:05:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hung task - sync - 2.6.33-rc7  w/md6 multicore rebuild in
	process
Message-ID: <20100219210517.GF28392@discord.disaster>
References: <4B76D87E.3050107@majjas.com> <4B76EC83.5050401@majjas.com> <20100218023934.GC8897@atrey.karlin.mff.cuni.cz> <4B7D74BE.6030906@majjas.com> <20100219014349.GD28392@discord.disaster> <4B7DF80D.6090309@majjas.com> <20100219040206.GE28392@discord.disaster> <4B7E2221.4020009@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7E2221.4020009@majjas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 12:31:13AM -0500, Michael Breuer wrote:
> On 2/18/2010 11:02 PM, Dave Chinner wrote:
>> On Thu, Feb 18, 2010 at 09:31:41PM -0500, Michael Breuer wrote:
>>    
>>> On 2/18/2010 8:43 PM, Dave Chinner wrote:
>>>      
>>>>
>>>> This is probably where the barrier IOs are coming from.  With a RAID
>>>> resync going on (so all IO is going to be slow to begin with) and
>>>> writeback is causing barriers to be issued (which are really slow on
>>>> software RAID5/6), having sync take so long is not out of the
>>>> question if you have lots of dirty inodes to write back. A kernel
>>>> compile will generate lots of dirty inodes.
>>>>
>>>> Even taking the barrier IOs out of the question, I've seen reports
>>>> of sync or unmount taking over 10 hours to complete on software
>>>> RAID5 because there were hundreds of thousands of dirty inodes to
>>>> write back and each inode being written back caused a synchronous
>>>> RAID5 RMW cycle to occur. Hence writeback could only clean 50
>>>> inodes/sec because as soon as RMW cycles RAID5/6 devices start
>>>> they go slower than single spindle devices.  This sounds very
>>>> similar to what you are seeing here,
>>>>
>>>> i.e. The reports don't indicate to me that there is a bug in the
>>>> writeback code, just your disk subsystem has very, very low
>>>> throughput in these conditions....
>>>>        
>>> Probably true... and the system does recover. The only thing I'd point
>>> out is that the subsystem isn't (or perhaps shouldn't) be this sluggish.
>>> I hypothesize that the low throughput under these condition is a result
>>> of:
>>> 1) multicore raid support (pushing the resync at higher rates)
>>>      
>> Possibly, though barrier support for RAID5/6 is shiny new as well.
>>
>>    
>>> 2) time spent in fs cache reclaim. The sync slowdown only occurs when fs
>>> cache is in heavy (10Gb) use.
>>>      
>> Not surprising ;)
>>
>>    
>>> I actually could not recreate the issue until I did a grep -R foo /usr/
>>>      
>>>> /dev/null to force high fs cache utilization. For what it's worth, two
>>>>        
>>> kernel rebuilds (many dirty inodes) and then a sync with about 12Mb
>>> dirty (/proc/meminfo) didn't cause an issue. The issue only happens when
>>> fs cache is heavily used. I also never saw this before enabling
>>> multicore raid.
>>>      
>> "grep -R foo /usr/" will dirty every inode that touchs (atime) and
>> they have to be written back out. That's almost certainly creating
>> more dirty inodes than a kernel build - there are about 400,000
>> inodes under /usr on my system. That would be enough to trigger very
>> long sync times if inode writeback is slow.
>
> My filesystems are mounted relatime.

If the inode atime is older than a day, then they will still
have atime updated (i.e. be dirtied) and need writing out. Relatime
only reduces the number of atime updates; it doesn't prevent them
entirely like noatime does.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
