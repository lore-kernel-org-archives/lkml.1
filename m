Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZDPOlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZDPOlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZDPOlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:41:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:39179 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbZDPOlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:41:10 -0400
Message-ID: <49E74377.6050209@kernel.org>
Date: Thu, 16 Apr 2009 23:40:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Nikanth Karthikesan <knikanth@suse.de>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] make hd_struct->in_flight atomic to avoid diskstat
 corruption
References: <200904161254.41433.knikanth@suse.de> <20090416073557.GU5178@kernel.dk> <200904161445.03955.knikanth@suse.de>
In-Reply-To: <200904161445.03955.knikanth@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 16 Apr 2009 14:40:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Nikanth, Jens.

Nikanth Karthikesan wrote:
>> Hmm. Did you observe this behaviour?
> 
> Sorry, not on current kernels. But on a very old 2.6.5 kernel.
> 
> Reading Documentation/iostats.txt and the changelog of commit 
> e71bf0d0ee89e51b92776391c5634938236977d5 made me assume that this could be a 
> problem even today.

The only problem we can run into there is if a request doesn't get
attributed to a partition on issue but gets attributed to a partition
on completion, which seems to be possible if a new partition is added
while IO on the whole device which fell into the new partition area is
already in progress, which, on the first glance, seems possible if the
admin tries really hard.  I think we can get around the problem by
doing part->in_flight = min(max(new_val, part0->in_flight), 0) in
dec_in_flight().  This is pretty extreme corner case tho.

>> A quick glance at the code reveals
>> that the callers of part_inc_in_flight() and part_dec_in_flight() in the
>> block layer are always done under the queue lock. Ditto
>> part_round_stats(), which calls part_round_stats_single() and also needs
>> protection for in_flight.
>>
>> That basically just leaves the code reading this out and reporting, and
>> driver calls to part_round_stats(). I'd suggest looking there instead,
>> we're not going to make ->in_flight an atomic just because of some
>> silliness there that could be fixed.
> 
> Isn't this also true for the stats protected by the
> part_stat_lock()? Only places where we are only reading seems to be
> called without the queue lock.

part_stat_lock() doesn't protect against simultaneous access.  I don't
think we have any place where in_flight is updated without queuelock
and the counters being equal to or smaller then ulong, reading
shouldn't be a problem.

I don't think the bug you saw in 2.6.5 kernel applies to upstream
kernel.  The minus in_flight value was seen on the diskstats of the
whole device which can't be affected by partition coming up while IOs
are in progress.

Thanks.

-- 
tejun
