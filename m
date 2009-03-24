Return-Path: <linux-kernel-owner+w=401wt.eu-S1759040AbZCXKT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbZCXKT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757685AbZCXKSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:18:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51004 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958AbZCXKSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:18:49 -0400
Date: Tue, 24 Mar 2009 11:18:47 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: forbid to re-enable I/O stat accounting
Message-ID: <20090324101847.GF27476@kernel.dk>
References: <200903201333.n2KDXONh023780@dhcp-0-152.brq.redhat.com> <20090321030309.f783ec8c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321030309.f783ec8c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21 2009, Andrew Morton wrote:
> 
> Please fix your email headers - what I received was
> 
> From: Jerome Marchand <jmarchan@redhat.com>
> To: unlisted-recipients:;;@imap1.linux-foundation.org (no To-header on input)
> Cc: Jens Axboe <axboe@kernel.dk>
> 
> 
> On Thu, 19 Mar 2009 11:36:50 +0100 Jerome Marchand <jmarchan@redhat.com> wrote:
> 
> > When we stop I/O stat accounting we stop to update the in-flight
> > requests counter and we need this counter to be reliable for
> > accounting I/O stats. Unfortunately updating in_flight field may
> > affect performance. So, until we have a better solution, just forbid
> > to re-enable I/O stat accounting after it has been disabled.
> 
> hm.  Is it really so hard to just quiesce the device until all in-flight
> requests have drained?  freeze_bdev() might be a suitable starting point?

freeze_bdev() is too far up, I think. It would be better to just reuse
the quiscing code we use for switching io schedulers on-the-fly.
Basically something ala:

        spin_lock_irq(q->queue_lock);
        queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
        elv_drain_elevator(q);
        while (q->rq.elvpriv) {
                blk_start_queueing(q);
                spin_unlock_irq(q->queue_lock);
                msleep(10);
                spin_lock_irq(q->queue_lock);
                elv_drain_elevator(q);
        }

        re-enable IO accounting;
        spin_unlock_irq(q->queue_lock);

and then don't account requests that don't have REQ_ELVPRIV set. I think
that should be acceptable. I was pretty sure I had a patch for something
else that yanked this logic into start/stop helpers... Ah, found it:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=8cb9f793b82024cd43ed5d4583a5287d002abdf8

-- 
Jens Axboe

