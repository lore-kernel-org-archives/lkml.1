Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbZKKThR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbZKKThR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758668AbZKKThQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:37:16 -0500
Received: from [95.166.99.235] ([95.166.99.235]:36946 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758584AbZKKThP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:37:15 -0500
Date: Wed, 11 Nov 2009 20:37:20 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Romit Dasgupta <romit@ti.com>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 1/1]: Thaws refrigerated bdi flusher threads before
	invoking kthread_stop on them
Message-ID: <20091111193719.GR8742@kernel.dk>
References: <1257928216.15415.57.camel@boson> <20091111103444.GD26423@elf.ucw.cz> <200911111230.58479.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911111230.58479.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11 2009, Rafael J. Wysocki wrote:
> On Wednesday 11 November 2009, Pavel Machek wrote:
> > On Wed 2009-11-11 14:00:16, Romit Dasgupta wrote:
> > > Kicks out frozen bdi flusher task out of the refrigerator when the flusher task
> > > needs to exit.
> > 
> > 
> > > Signed-off-by: Romit Dasgupta <romit@ti.com>
> > 
> > Ok, its slightly "interesting", but better than modifying common
> > code. Looks ok to me.
> > 
> > ACK.
> 
> Agreed.
> 
> Jens, any objections?

Nope, looks fine to me. Though I'd probably prefer just doing an
unconditional PF_FROZEN clear.

/*
 * Force unfreeze of the bdi threads before stopping it, since otherwise
 * it would never exit if it is stuck in the refrigerator.
 */
list_for_each_entry(wb, &bdi->wb_list, list) {
	wb->task->flags &= ~PF_FROZEN;
	kthread_stop(wb->task);
}

And the comment too, it's not enough to stuff this into the commit.

-- 
Jens Axboe

