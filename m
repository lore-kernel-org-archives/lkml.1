Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab0CLXiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 18:38:51 -0500
Received: from mail2.shareable.org ([80.68.89.115]:46848 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385Ab0CLXit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 18:38:49 -0500
Date: Fri, 12 Mar 2010 23:38:20 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>,
       David Woodhouse <dwmw2@infradead.org>,
       "Kreuzer, Michael (NSN - DE/Ulm)" <michael.kreuzer@nsn.com>,
       linux-mtd@lists.infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] fix MTD CFI/LPDDR flash driver huge latency bug
Message-ID: <20100312233820.GH6491@shareable.org>
References: <1267894137.18869.0.camel@wall-e> <20100312142344.174bd46f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312142344.174bd46f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 06 Mar 2010 17:48:57 +0100
> Stefani Seibold <stefani@seibold.net> wrote:
> 
> > This patch fix a huge latency problem in the MTD CFI and LPDDR flash
> > drivers.
> > 
> > The use of a memcpy() during a spinlock operation will cause very long
> > thread context switch delays if the flash chip bandwidth is low and the
> > data to be copied large, because a spinlock will disable preemption.
> > 
> > For example: A flash with 6,5 MB/s bandwidth will cause under ubifs,
> > which request sometimes 128 KB (the flash erase size), a preemption
> > delay of 20 milliseconds. High priority threads will not be served
> > during this time, regardless whether this threads access the flash or
> > not. This behavior breaks real time.

I agree that's a problem, and it's not just real time that's affected.

I've just realised I have a video player with ~1.5 MB/s bandwidth
64kb/block flash attached, and this might be the reason JFFS2 activity
makes video play less smooth on it.  44ms is even worse.

> > The patch change all the use of spin_lock operations for xxxx->mutex
> > into mutex operations, which is exact what the name says and means.

It would be even better if it also split the critical sections into
smaller ones with cond_resched() between, so that non-preemptible
kernels benefit too.

> > There is no performance regression since the mutex is normally not
> > acquired.
> 
> hm, big scary patch.  Are you sure this mutex is never taken from
> atomic or irq contexts?  Is it ully tested with all relevant debug options
> and lockdep enabled?

Including from mtdoops?

-- Jamie
