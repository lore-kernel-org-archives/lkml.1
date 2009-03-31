Return-Path: <linux-kernel-owner+w=401wt.eu-S1761114AbZCaA3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbZCaA3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbZCaA26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 20:28:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:3386 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540AbZCaA25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 20:28:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,449,1233561600"; 
   d="scan'208";a="125885424"
Date: Tue, 31 Mar 2009 08:28:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jos Houtman <jos@hyves.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hch@infradead.org" <hch@infradead.org>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: Page Cache writeback too slow,   SSD/noop scheduler/ext2
Message-ID: <20090331002838.GA5895@localhost>
References: <20090329023238.GA7825@localhost> <C5F6B627.D9D0%jos@hyves.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5F6B627.D9D0%jos@hyves.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 12:47:19AM +0800, Jos Houtman wrote:
> 
> >> Thanx for the patch, but for the next time: How should I apply it?
> >> it seems to be context aware (@@) and broke on all kernel versions I tried
> >> 2.6.28/2.6.28.7/2.6.29
> > 
> > Do you mean that the patch applies after removing " @@.*$"?
> 
> I didn't try that, but this time it worked. So it was probably my error.
> 
> > 
> > You are right. In your case, there are several big dirty files in sdb1,
> > and the sdb write queue is constantly (almost-)congested. The SSD write
> > speed is so slow, that in each round of sdb1 writeback, it begins with
> > an uncongested queue, but quickly fills up after writing some pages.
> > Hence all the inodes will get redirtied because of (nr_to_write > 0).
> > 
> > The following quick fix should solve the slow-writeback-on-congested-SSD
> > problem. However the writeback sequence is suboptimal: it sync-and-requeue
> > each file until congested (in your case about 3~600 pages) instead of
> > until MAX_WRITEBACK_PAGES=1024 pages.
> 
> Yeah that fixed it, but performance dropped due to the more constant
> congestion. So I will need to try some different io schedulers.

Read performance or write performance?

> Next to that I was wondering if there are any plans to make sure that not
> all dirty-files are written back in the same interval.
> 
> In my case all database files are written back each 30 seconds, while I
> would prefer them to be more divided over the interval.

pdflush will wake up every 5s to sync files dirtied more than 30s.
So the writeback of inodes should be distributed(somehow randomly)
into these 5s-interval-wakeups due to varied dirty times.

However the distribution may well be uneven in may cases. It seems to
be conflicting goals for HDD and SSD: one favors somehow small busty
writeback, another favors smooth writeback streams. I guess the better
scheme would be bursty pdflush writebacks plus IO scheduler level QoS.

Thanks,
Fengguang
