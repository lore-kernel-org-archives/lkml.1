Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbYD2UGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbYD2UGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759102AbYD2UFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:05:23 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17836 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406AbYD2UFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:05:21 -0400
Date: Tue, 29 Apr 2008 22:05:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mike Anderson <andmike@linux.vnet.ibm.com>,
       Alasdair Graeme Kergon <agk@redhat.com>
Subject: Re: [PATCH] Optimize lock in queue unplugging
Message-ID: <20080429200513.GG12774@kernel.dk>
References: <Pine.LNX.4.64.0804291459030.17110@engineering.redhat.com> <20080429192556.GB12774@kernel.dk> <Pine.LNX.4.64.0804291554490.26643@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804291554490.26643@engineering.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29 2008, Mikulas Patocka wrote:
> 
> 
> On Tue, 29 Apr 2008, Jens Axboe wrote:
> 
> >On Tue, Apr 29 2008, Mikulas Patocka wrote:
> >>Hi
> >>
> >>Mike Anderson was doing an OLTP benchmark on a computer with 48 physical
> >>disks mapped to one logical device via device mapper.
> >>
> >>He found that there was a slowdown on request_queue->lock in function
> >>generic_unplug_device. The slowdown is caused by the fact that when some
> >>code calls unplug on the device mapper, device mapper calls unplug on all
> >>physical disks. These unplug calls take the lock, find that the queue is
> >>already unplugged, release the lock and exit.
> >>
> >>With the below patch, performance of the benchmark was increased by 18%
> >>(the whole OLTP application, not just block layer microbenchmarks).
> >>
> >>So I'm submitting this patch for upstream. I think the patch is correct,
> >>because when more threads call simultaneously plug and unplug, it is
> >>unspecified, if the queue is or isn't plugged (so the patch can't make
> >>this worse). And the caller that plugged the queue should unplug it
> >>anyway. (if it doesn't, there's 3ms timeout).
> >
> >Where were these unplug calls coming from? The block layer will
> >generally only unplug when it is already unplugged, so if you are seeing
> >so many unplug calls that the patch redues overhead by as much
> >described, perhaps the callsite is buggy?
> >
> >-- 
> >Jens Axboe
> 
> unplug is called on any wait_on_buffer (and similar calls) 
> __wait_on_buffer -> sync_buffer -> blk_run_address_space -> 
> blk_run_backing_dev -> bdi->unplug_io_fn(bdi, page);
> 
> (I'm not sure that this was the IBM's case, I'm just guessing - this is 
> the most obvious example where unplug is called repeatedly)
> 
> 
> There is not any test that the queue is plugged and there shouldn't be. If 
> you have this situation
> 
> dm-linear(unplugged) -> physical-disk(plugged)
> 
> then uplung should be called on dm-linear (that will call dm-unplug method 
> dm_unplug_all and that will unplug the disk). If you add the test of 
> plugged queue to the upper layer, you mess this situation with stacked 
> drivers completely.
> 
> The test for already plugged queue should be at the lowest physical device 
> driver, not in upper layers.

Fair enough, I'll put the patch under closer scrutiny and queue it up.
Thanks!

-- 
Jens Axboe

