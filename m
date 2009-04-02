Return-Path: <linux-kernel-owner+w=401wt.eu-S1762536AbZDBJcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762536AbZDBJcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbZDBJbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:31:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43418 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbZDBJbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:31:49 -0400
Message-ID: <49D48600.2070109@garzik.org>
Date: Thu, 02 Apr 2009 05:31:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux IDE mailing list <linux-ide@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: IDE, packet commands and REQ_TYPE_SENSE?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at REQ_TYPE_*, I see that REQ_TYPE_SENSE is only used once in an 
assignment, and appears to never be tested anywhere.

Furthermore, the use of REQ_TYPE_SENSE immediately follows a previous 
assignment rq->cmd_type assignment:

cdrom_queue_request_sense():
[...]
         /* stuff the sense request in front of our current request */
         blk_rq_init(NULL, rq);
         rq->cmd_type = REQ_TYPE_ATA_PC;
         rq->rq_disk = info->disk;

         rq->data = sense;
         rq->cmd[0] = GPCMD_REQUEST_SENSE;
         rq->cmd[4] = 18;
         rq->data_len = 18;

         rq->cmd_type = REQ_TYPE_SENSE;
         rq->cmd_flags |= REQ_PREEMPT;
[...]

First, the code assigns REQ_TYPE_ATA_PC, then without any intervening 
tests or branches, it assigns REQ_TYPE_SENSE.

So, some questions...

Is REQ_TYPE_ATA_PC sufficient (i.e. the first assignment)?

Can we get rid of REQ_TYPE_SENSE?

What are the differences between REQ_TYPE_ATA_PC and REQ_TYPE_BLOCK_PC? 
  Would it be possible to eliminate REQ_TYPE_ATA_PC after some work, as 
well?

	Jeff



