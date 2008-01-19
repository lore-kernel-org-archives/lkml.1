Return-Path: <linux-kernel-owner+w=401wt.eu-S1762823AbYASCvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762823AbYASCvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 21:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760501AbYASCu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 21:50:58 -0500
Received: from relay1.sgi.com ([192.48.171.29]:42317 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758900AbYASCu5 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 21:50:57 -0500
Date: Sat, 19 Jan 2008 13:50:24 +1100
From: David Chinner <dgc@sgi.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: David Chinner <dgc@sgi.com>, Michael Rubin <mrubin@google.com>,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] Converting writeback linked lists to a tree based data structure
Message-ID: <20080119025024.GW155259@sgi.com>
References: <20080115080921.70E3810653@localhost> <400562938.07583@ustc.edu.cn> <532480950801171307q4b540ewa3acb6bfbea5dbc8@mail.gmail.com> <20080118050107.GS155259@sgi.com> <E1JFjyv-0001hU-FA@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JFjyv-0001hU-FA@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 01:41:33PM +0800, Fengguang Wu wrote:
> > That is, think of large file writes like process scheduler batch
> > jobs - bulk throughput is what matters, so the larger the time slice
> > you give them the higher the throughput.
> > 
> > IMO, the sort of result we should be looking at is a
> > writeback design that results in cycling somewhat like:
> > 
> > 	slice 1: iterate over small files
> > 	slice 2: flush large file 1
> > 	slice 3: iterate over small files
> > 	slice 4: flush large file 2
> > 	......
> > 	slice n-1: flush large file N
> > 	slice n: iterate over small files
> > 	slice n+1: flush large file N+1
> > 
> > So that we keep the disk busy with a relatively fair mix of
> > small and large I/Os while both are necessary.
> 
> If we can sync fast enough, the lower layer would be able to merge
> those 4MB requests.

No, not necessarily - think of a stripe with a chunk size of 512k.
That 4MB will be split into 8x512k chunks and sent to different
devices (and hence elevator queues). The only way you get elevator
merging in this sort of config is that if you send multiple stripe
*width* sized amounts to the device in a very short time period.
I see quite a few filesystems with stripe widths in the tens of MB
range.....

> > Put simply:
> > 
> > 	The higher the bandwidth of the device, the more frequently
> > 	we need to be servicing the inodes with large amounts of
> > 	dirty data to be written to maintain write throughput at a
> > 	significant percentage of the device capability.
> > 
> > The writeback algorithm needs to take this into account for it
> > to be able to scale effectively for high throughput devices.
> 
> Slow queues go full first. Currently the writeback code will skip
> _and_ congestion_wait() for congested filesystems. The better policy
> is to congestion_wait() _after_ all other writable pages have been
> synced.

Agreed.

The comments I've made are mainly concerned with getting efficient
flushing of a single device occuring. Interactions between multiple
devices are a separable issue....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
