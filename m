Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYIREb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYIREb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 00:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYIREbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 00:31:19 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52854 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYIREbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 00:31:18 -0400
Date: Thu, 18 Sep 2008 06:31:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: blk: queue cleanup at device shutdown
Message-ID: <20080918043114.GG20055@kernel.dk>
References: <48C97CD9.8000808@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C97CD9.8000808@am.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11 2008, Geoff Levand wrote:
> Hi Jens,
> 
> I'm wondering about what is needed in ps3disk_remove(), to clean
> up the request_queue (priv->queue) the driver uses.
> ps3disk_remove() is called from the main device_shutdown()
> routine via the ps3_system_bus remove routine.
> 
> The current code follows, and as can be seen, there is no check
> or handling of the queue before blk_cleanup_queue() is called.
> Can it be assumed that the queue is empty at this point,
> or is something else needed here?

The queue should be empty, at least there should be no one else
submitting IO for the device given the contet in which it is called. But
I suppose we could have pending IO (given the kexec context you
explained to me in person), so the below patch could be needed. It may
actually be a good idea to put this into blk_cleanup_queue(), since we
should have process context there anyway.

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index d797e20..dce64d0 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -537,6 +537,8 @@ static int ps3disk_remove(struct ps3_system_bus_device *_dev)
 	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
 	struct ps3disk_private *priv = dev->sbd.core.driver_data;
 
+	blk_sync_queue(priv->queue);
+
 	mutex_lock(&ps3disk_mask_mutex);
 	__clear_bit(priv->gendisk->first_minor / PS3DISK_MINORS,
 		    &ps3disk_mask);

-- 
Jens Axboe

