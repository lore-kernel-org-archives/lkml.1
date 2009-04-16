Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbZDPHgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbZDPHgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 03:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZDPHf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 03:35:59 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57051 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbZDPHf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 03:35:59 -0400
Date: Thu, 16 Apr 2009 09:35:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] [RFC] make hd_struct->in_flight atomic to avoid
	diskstat corruption
Message-ID: <20090416073557.GU5178@kernel.dk>
References: <200904161254.41433.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904161254.41433.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16 2009, Nikanth Karthikesan wrote:
> The disk statistics exported to userspace through proc and sysfs are
> not protected by locks to avoid performance overhead. Since most of
> the statistics are maintained in the per_cpu struct disk_stats, the
> chances of them getting corrupted is negligible. But the in_flight
> counter, that records the no of requests currently in progress is not
> per-cpu. This increases the chance of it getting corrupted. And
> corruption of this value would result in visibly distorted statistics
> such as negative in_flight. This can be avoided by making this field
> atomic.

Hmm. Did you observe this behaviour? A quick glance at the code reveals
that the callers of part_inc_in_flight() and part_dec_in_flight() in the
block layer are always done under the queue lock. Ditto
part_round_stats(), which calls part_round_stats_single() and also needs
protection for in_flight.

That basically just leaves the code reading this out and reporting, and
driver calls to part_round_stats(). I'd suggest looking there instead,
we're not going to make ->in_flight an atomic just because of some
silliness there that could be fixed.

-- 
Jens Axboe

