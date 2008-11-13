Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbYKMKgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbYKMKgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 05:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYKMKgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 05:36:36 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:58182 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbYKMKgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 05:36:35 -0500
Date: Thu, 13 Nov 2008 11:34:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stern@rowland.harvard.edu, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Problems with the block-layer timeouts
Message-ID: <20081113103456.GB26778@kernel.dk>
References: <20081111155458M.fujita.tomonori@lab.ntt.co.jp> <Pine.LNX.4.44L0.0811111205390.29125-100000@netrider.rowland.org> <20081111191936.GK26778@kernel.dk> <20081112110840W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112110840W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12 2008, FUJITA Tomonori wrote:
> On Tue, 11 Nov 2008 20:19:36 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Tue, Nov 11 2008, Alan Stern wrote:
> > > On Tue, 11 Nov 2008, FUJITA Tomonori wrote:
> > > 
> > > > I don't worry about anything. I just think that these round_jiffies_up
> > > > are pointless because they were added for the block-layer users that
> > > > care about exact timeouts, however the block-layer doesn't export
> > > > blk_add_timer() so the block-layer users can't control the exact time
> > > > when the timer starts. So doing round_jiffies_up calculation per every
> > > > request doesn't make sense for me.
> > > 
> > > In fact the round_jiffies_up() routines were added for other users as
> > > well as the block layer.  However none of the others could be changed
> > > until the routines were merged.  Now that the routines are in the 
> > > mainline, you should see them start to be called in multiple places.
> > > 
> > > Also, the users of the block layer _don't_ care about exact timeouts.  
> > > That's an important aspect of round_jiffies() and round_jiffies_up() --
> > > you don't use them if you want an exact timeout.
> > > 
> > > The reason for using round_jiffies() is to insure that the timeout
> > > will occur at a 1-second boundary.  If several timeouts are set for
> > > about the same time and they all use round_jiffies() or
> > > round_jiffies_up(), then they will all occur at the same tick instead
> > > of spread out among several different ticks during the course of that
> > > 1-second interval.  As a result, the system will need to wake up only
> > > once to service all those timeouts, instead of waking up several
> > > different times.  It is a power-saving scheme.
> 
> Hmm, but for 99.9% of the cases, the timeout of the block layer
> doesn't expire, the timeout rarely happens. The power-saving scheme
> can be applied to only 0.1%, but at the cost of the round_jiffies
> overhead per every request.
> 
> If I understand correctly, round_jiffies() is designed for timers that
> will expire, such as periodic checking. The power-saving scheme nicely
> works for such usages.

Your understanding is correct. The overhead of round_jiffies() is not
large, though.

I want to get rid of this in blk_delete_timer():

        if (list_empty(&q->timeout_list))
                del_timer(&q->timeout);

though and simply let the timer run even if the list is empty, since for
sync sequential IO we'll be fiddling a much with the timer as we did
before unifying it. And then the timer will expire every x seconds
always and it becomes more important with the grouping.

-- 
Jens Axboe

