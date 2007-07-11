Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbXGKIjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbXGKIjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbXGKIjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:39:00 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:40441 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbXGKIi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:38:59 -0400
Message-ID: <46949541.4040206@itg.hitachi.co.jp>
Date: Wed, 11 Jul 2007 17:30:57 +0900
From: Piotr Muszynski <piotr@itg.hitachi.co.jp>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: REQUEST_SENSE and ide-cd.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am adding transparent ATAPI capability to USB gadget Mass Storage 
driver. The idea is to pass USB traffic to block device queue as packet 
requests. At the end of the queue, the requests are handled by ide-cd.c 
driver.

It breaks when the ide-cd.c driver unconditionally generates 
REQUEST_SENSE for requests that ended in unit attention condition.

By clearing the drive's unit attention condition, this additional 
REQUEST_SENSE confuses the host, which fires it's own REQUEST_SENSE 
packet, to which the drive replies with NO SENSE.

I can see three solutions:

1. Intercept the sense data returned by ide-cd.c and emulate unit 
attention condition in file_storage.c driver;

2. Introduce a new request flag causing ide-cd.c to skip calling 
cdrom_queue_request_sense() for flagged requests, like below:

     cdrom_decode_status() 2.6.12:
     -    if (stat & ERR_STAT) {
     +    if (stat & ERR_STAT && !(rq->flags & REQ_NO_AUTOSENSE)) {
              spin_lock_irqsave(&ide_lock, flags);
              blkdev_dequeue_request(rq);
              HWGROUP(drive)->rq = NULL;
              spin_unlock_irqrestore(&ide_lock, flags);
              cdrom_queue_request_sense(drive, rq->sense, rq);
          } else
              cdrom_end_request(drive, 0);

3. Acknowledge that ide-cd.c was not meant to work as in (2) and search 
for another mechanism. Where?

(1) would unnecessarily duplicate the drive's state. I'd rather do (3).

So far, the (2) works well, but how bad is it?
I'd greatly appreciate any critical feedback.

TIA,
Piotr Muszynski

