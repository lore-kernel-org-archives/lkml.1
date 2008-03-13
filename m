Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbYCMHxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbYCMHxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 03:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYCMHxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 03:53:17 -0400
Received: from mail.lang.hm ([64.81.33.126]:60288 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbYCMHxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 03:53:17 -0400
Date: Thu, 13 Mar 2008 00:55:22 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Daniel Phillips <phillips@phunq.net>
cc: David Newall <davidn@davidnewall.com>, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <200803130012.36763.phillips@phunq.net>
Message-ID: <alpine.DEB.1.00.0803130046190.3786@asgard.lang.hm>
References: <200803092346.17556.phillips@phunq.net> <200803122317.24849.phillips@phunq.net> <alpine.DEB.1.00.0803122327260.3786@asgard.lang.hm> <200803130012.36763.phillips@phunq.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Daniel Phillips wrote:

> On Wednesday 12 March 2008 23:32, david@lang.hm wrote:
>> looking at the comparison of a 500G filesystem with 500G of ram allocated
>> for a buffer cache.
>>
>> yes, initially it will be a bit slower (until the files get into the
>> buffer cache), and if fsync is disabled all writes will go to the buffer
>> cache (until writeout hits)
>>
>> I may be able to see room for a few percent difference, but not 2x, let
>> alone 25x.
>
> My test ran 25 times faster because it was write intensive and included
> sync.  It did not however include seeks, which can cause an even bigger
> performance gap.

if you are not measuring the time to get from ram to disk (which you are 
not doing in your ramback device) syncs are meaningless.

seeks should only be a factor in the process of populating the buffer 
cache. both systems need to read the data from disk to the cache, they can 
either fault the data in as it's accessed, or run a process to read it all 
in as a batch.

> The truth is, my system has _more_ cache available for file buffering
> than I used for the ramdisk, and almost every file operation I do
> (typically dozens of tree diffs, hundreds of compiles per day) goes
> _way_ faster on the ram disk.  Really, really a lot faster.  Because
> frankly, Linux is not very good at using its file cache these days.
> Somebody ought to fix that.  (I am busy fixing other things.)

so you are saying that when the buffer cache stores the data from your ram 
disk it will slow down. that sounds like it equalizes the performance and 
is a problem that needs to be solved for ramdisks as well.

> In other, _real world_ NFS file serving tests, we have seen 20 - 200
> times speedup in serving snapshotted volumes via NFS, using ddsnap
> for snapshots and replication.  While it is true that ddsnap will
> eventually be optimized to improved performance on spinning media,
> I seriously doubt it will ever get closer than a factor of 20 or so,
> with a typical read/write mix.

NFS is a very different beast.

> But that is just the pragmatic reality of machines everybody has these
> days, let us not get too wrapped up in that.  Think about the Violin
> box.  How are you going to put 504 gigabytes of data in buffer cache?
> Tell me how a transaction processing system is going to run with
> latency measured in microseconds, backed by hard disk, ever?

it all depends on how you define the term 'backed by hard disk' if you 
don't write to the hard disk and just dirty pages in ram you can easily 
hit that sort of latency. I don't understand why you say it's so hard to 
put 504G of data into the buffer cache, you just read it and it's in the 
cache.

> Really guys, ramdisks are fast.  Admit it, they are really really fast.

nobody is disputing this.

> So I provide a way to make them persistent also.  For free, I might
> add.

except that you are redefining the terms 'persistent' and 'free' to mean 
something different than what everyone else understands them to be.

> Why am I reminded of old arguments like "if men were meant to fly, God
> would have given them wings"?  Please just give me your microsecond
> scale transaction processing solution and I will be impressed and
> grateful.  Until then... here is mine.  Service with a smile.

if you don't have to worry about unclean shutdowns then your system is not 
needed. all you need to do is to create a ramdisk that you populate with 
dd at boot time and save to disk with dd at shutdown. problem solved in a 
couple lines of shell scripts and no kernel changes needed.

if you want the data to be safe in the face of unclean shutdowns and 
crashes, then you need to figure out how to make the image on disk 
consistant, and at this point you have basicly said that you don't think 
that it's a problem. so we're back to what you can do today with a couple 
lines of scripting.

David Lang
