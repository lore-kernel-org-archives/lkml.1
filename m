Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYIKURo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYIKURo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYIKURg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:17:36 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21503 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbYIKURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:17:35 -0400
X-BigFish: VPS1(zzzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <48C97CD9.8000808@am.sony.com>
Date: Thu, 11 Sep 2008 13:17:29 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: blk: queue cleanup at device shutdown
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Sep 2008 20:17:29.0960 (UTC) FILETIME=[6A8E8E80:01C9144B]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I'm wondering about what is needed in ps3disk_remove(), to clean
up the request_queue (priv->queue) the driver uses.
ps3disk_remove() is called from the main device_shutdown()
routine via the ps3_system_bus remove routine.

The current code follows, and as can be seen, there is no check
or handling of the queue before blk_cleanup_queue() is called.
Can it be assumed that the queue is empty at this point,
or is something else needed here?

-Geoff

static int ps3disk_remove(struct ps3_system_bus_device *_dev)
{
	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
	struct ps3disk_private *priv = dev->sbd.core.driver_data;

	mutex_lock(&ps3disk_mask_mutex);
	__clear_bit(priv->gendisk->first_minor / PS3DISK_MINORS,
		    &ps3disk_mask);
	mutex_unlock(&ps3disk_mask_mutex);

	del_gendisk(priv->gendisk);
	blk_cleanup_queue(priv->queue);
	put_disk(priv->gendisk);
	dev_notice(&dev->sbd.core, "Synchronizing disk cache\n");
	ps3disk_sync_cache(dev);
	ps3stor_teardown(dev);
	kfree(dev->bounce_buf);
	dev->bounce_buf = NULL;
	kfree(priv);
	dev->sbd.core.driver_data = NULL;
	return 0;
}







