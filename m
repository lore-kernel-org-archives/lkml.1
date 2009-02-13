Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbZBMGUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbZBMGUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 01:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZBMGUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 01:20:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51493 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZBMGUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 01:20:43 -0500
Message-ID: <49951121.80807@redhat.com>
Date: Fri, 13 Feb 2009 00:20:17 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
CC: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@MIT.EDU>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
References: <20090114165952.GH6222@mit.edu>	 <1232021211.14626.19.camel@sebastian.kern.oss.ntt.co.jp>	 <20090115234544.GA7579@duck.suse.cz>	 <1232109069.13775.35.camel@sebastian.kern.oss.ntt.co.jp>	 <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp>	 <20090116163039.GE10617@duck.suse.cz>	 <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>	 <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>	 <20090119120349.GA10193@duck.suse.cz>	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>	 <20090128095518.GA16554@duck.suse.cz>	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>	 <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp>	 <499458C1.90105@redhat.com> <1234487679.3795.15.camel@sebastian.kern.oss.ntt.co.jp>
In-Reply-To: <1234487679.3795.15.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis Vázquez Cao wrote:
> On Thu, 2009-02-12 at 11:13 -0600, Eric Sandeen wrote:
>> Fernando Luis Vázquez Cao wrote:
>>> This mount flag will be used to determine whether the block device's write
>>> cache should be flush or not on fsync()/fdatasync().
>>>
>>> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
>>> ---
>> Again, apologies for chiming in late.
>>
>> But wouldn't it be better to make this a block device property rather
>> than a new filesystem mount option?
>>
>> That way the filesystem can always do "the right thing" and call the
>> blkdev flush on fsync.
>>
>> The block device *could* choose to ignore this in hardware if it knows
>> it's built with a nonvolatile write cache or if it has no write cache.
>>
>> Somewhere in the middle, if an administrator knows they have a UPS they
>> trust and hardware that stays connected to it, they could tune the bdev
>> to ignore these flush requests.
>>
>> Also that way if you have 8 partitions on a battery-backed blockdev, you
>> can tune it once, instead of needing to mount all 8 filesystems with the
>> new option.
> 
> The main reason I decided to go for the mount option approach is to be
> consistent with what we do when it comes to write barriers. Treating one
> as a mount option and the other as a (possibly) sysfs tunable property
> seems a bit confusing to me.

well... technically, I think barriers really *should* mean "don't
reorder these writes, I need them this way for consistency" - and that
is really specific to the fs implementation, isn't it? (we just happen
to implement them as cache flushes) and so that is a per-fs setting, I
think.

Maybe there is no good argument for ignoring barriers on one fs, and
implementing them on another, other than playing fast & loose &
dangerous.... hrm.

> Do you suggest using sysfs tunables instead?

For a per-bdev flush setting, yes...

I guess I'll have to try to convince myself one way or another whether
barrier mount options are consistent with this view.  :)

I guess sometimes you do have workloads where you simply want speed, and
on a crash you start over.  In this case you don't care about barriers
(ordering constraints - if you don't care about fs integrity if fsck or
re-mkfs is ok) or flushing (caches - if you don't care about data
integrity, you regenerate your results).  That could vary from fs to fs....

I'm just a little leery of the "dangerous" mount option proliferation, I
guess.

-Eric

> - Fernando
> 

