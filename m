Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbXJaLBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbXJaLBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXJaLBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:01:25 -0400
Received: from brick.kernel.dk ([87.55.233.238]:21651 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbXJaLBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:01:24 -0400
Date: Wed, 31 Oct 2007 11:58:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Philipp Gruber <philipp.gruber@flupps.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Need information on elevator_dispatch_fn
Message-ID: <20071031105842.GH5059@kernel.dk>
References: <20071031100025.GC16598@mega2000.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031100025.GC16598@mega2000.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31 2007, Philipp Gruber wrote:
> Hello everyone,
> 
> I'm just working on an I/O-scheduler that implements some QoS
> functionality.
> 
> Now I get some weird problems and need to know what triggers my
> elevator_dispatch_fn, and how the return value of it is handled.
> For now, I found that the dispatch function is called as long as there
> are requests in my queue, so probably as long as it returns 1. On the
> other hand, only every second dispatch call returns 1, the others 0, but
> still it's working. I couldn't find any documentation about that (but
> would like to write some, if I understood it). Could someone please
> explain me when and why exactly elevator_dispatch_fn is triggered?

elevator_dispatch_fn() is in charge of putting request on the dispatch
list. So it'll be called, if q->queue_head is empty to refill that. The
core is __elv_next_request(), which is called when a block driver wants
to queue more IO. The logic is essentially:

elv_next_request()
{
        while (1) {
                if (!list_empty(&q->queue_head))
                        return first rq of list
                if (!elevator_dispatch_fn())
                        return NULL;
        }
}

So if you queue_head is empty AND elevator_dispatch_fn returns 0, then
no request is given to the driver. IF elevator_dispatch_fn returns
non-zero, then it MUST have put request on the queue_head list.

-- 
Jens Axboe

