Return-Path: <linux-kernel-owner+w=401wt.eu-S966559AbXEIFuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966559AbXEIFuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 01:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933482AbXEIFuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 01:50:25 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31642 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934620AbXEIFuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 01:50:24 -0400
Date: Wed, 9 May 2007 07:48:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: nbd problem.
Message-ID: <20070509054815.GM4163@kernel.dk>
References: <20070508194053.GA23615@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508194053.GA23615@bitwizard.nl>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08 2007, Rogier Wolff wrote:
> 
> Hi,
> 
> The nbd client still reliably hangs when I use it. 
> 
> While looking into this, I found:
> 
> 
> 446                 req->errors = 0;
> 447                 spin_unlock_irq(q->queue_lock);
>                    ^^^^^^^^^^^^^^^^^^^^
> 448 
> 449                 mutex_lock(&lo->tx_lock);
> 450                 if (unlikely(!lo->sock)) {
> 451                         mutex_unlock(&lo->tx_lock);
> 452                         printk(KERN_ERR "%s: Attempted send on closed socket\n",
> 453                                lo->disk->disk_name);
> 454                         req->errors++;
> 455                         nbd_end_request(req);
> 456                         spin_lock_irq(q->queue_lock);
> 457                         continue;
> 458                 }
> 459 
> 460                 lo->active_req = req;
> 461 
> 462                 if (nbd_send_req(lo, req) != 0) {
> 463                         printk(KERN_ERR "%s: Request send failed\n",
> 464                                         lo->disk->disk_name);
> 465                         req->errors++;
> 466                         nbd_end_request(req);
> 467                 } else {
> 468                         spin_lock(&lo->queue_lock);
>                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 469                         list_add(&req->queuelist, &lo->queue_head);
> 470                         spin_unlock(&lo->queue_lock);
> 471                 }
> 472 
> 473                 lo->active_req = NULL;
> 
> 
> As far as I read things, the function is called with the lock
> held and interrupts disabled., the lock can then be released and 
> retaken without disabling interrupts again. 
> 
> Should this be fixed?
> 
> (it doesn't fix my hang though....)

Note lo->queue_lock vs q->queue_lock.

-- 
Jens Axboe

