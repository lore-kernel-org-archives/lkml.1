Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbYD2T0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbYD2T0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYD2T0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:26:04 -0400
Received: from brick.kernel.dk ([87.55.233.238]:3887 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbYD2T0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:26:03 -0400
Date: Tue, 29 Apr 2008 21:25:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mike Anderson <andmike@linux.vnet.ibm.com>,
       Alasdair Graeme Kergon <agk@redhat.com>
Subject: Re: [PATCH] Optimize lock in queue unplugging
Message-ID: <20080429192556.GB12774@kernel.dk>
References: <Pine.LNX.4.64.0804291459030.17110@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804291459030.17110@engineering.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29 2008, Mikulas Patocka wrote:
> Hi
> 
> Mike Anderson was doing an OLTP benchmark on a computer with 48 physical 
> disks mapped to one logical device via device mapper.
> 
> He found that there was a slowdown on request_queue->lock in function 
> generic_unplug_device. The slowdown is caused by the fact that when some 
> code calls unplug on the device mapper, device mapper calls unplug on all 
> physical disks. These unplug calls take the lock, find that the queue is 
> already unplugged, release the lock and exit.
> 
> With the below patch, performance of the benchmark was increased by 18% 
> (the whole OLTP application, not just block layer microbenchmarks).
> 
> So I'm submitting this patch for upstream. I think the patch is correct, 
> because when more threads call simultaneously plug and unplug, it is 
> unspecified, if the queue is or isn't plugged (so the patch can't make 
> this worse). And the caller that plugged the queue should unplug it 
> anyway. (if it doesn't, there's 3ms timeout).

Where were these unplug calls coming from? The block layer will
generally only unplug when it is already unplugged, so if you are seeing
so many unplug calls that the patch redues overhead by as much
described, perhaps the callsite is buggy?

-- 
Jens Axboe

