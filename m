Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbZDPJRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbZDPJRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZDPJRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:17:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbZDPJRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:17:24 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [RFC] make hd_struct->in_flight atomic to avoid diskstat corruption
Date: Thu, 16 Apr 2009 14:45:03 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
References: <200904161254.41433.knikanth@suse.de> <20090416073557.GU5178@kernel.dk>
In-Reply-To: <20090416073557.GU5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904161445.03955.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 April 2009 13:05:57 Jens Axboe wrote:
> On Thu, Apr 16 2009, Nikanth Karthikesan wrote:
> > The disk statistics exported to userspace through proc and sysfs are
> > not protected by locks to avoid performance overhead. Since most of
> > the statistics are maintained in the per_cpu struct disk_stats, the
> > chances of them getting corrupted is negligible. But the in_flight
> > counter, that records the no of requests currently in progress is not
> > per-cpu. This increases the chance of it getting corrupted. And
> > corruption of this value would result in visibly distorted statistics
> > such as negative in_flight. This can be avoided by making this field
> > atomic.
>
> Hmm. Did you observe this behaviour?

Sorry, not on current kernels. But on a very old 2.6.5 kernel.

Reading Documentation/iostats.txt and the changelog of commit 
e71bf0d0ee89e51b92776391c5634938236977d5 made me assume that this could be a 
problem even today.

> A quick glance at the code reveals
> that the callers of part_inc_in_flight() and part_dec_in_flight() in the
> block layer are always done under the queue lock. Ditto
> part_round_stats(), which calls part_round_stats_single() and also needs
> protection for in_flight.
>
> That basically just leaves the code reading this out and reporting, and
> driver calls to part_round_stats(). I'd suggest looking there instead,
> we're not going to make ->in_flight an atomic just because of some
> silliness there that could be fixed.

Isn't this also true for the stats protected by the part_stat_lock()? Only 
places where we are only reading seems to be called without the queue lock.

Thanks
Nikanth
