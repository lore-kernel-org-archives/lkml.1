Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZDWKj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZDWKj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZDWKjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:39:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38959 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbZDWKjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:39:44 -0400
Message-ID: <49F0456B.2050502@garzik.org>
Date: Thu, 23 Apr 2009 06:39:39 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
References: <20090422090929.GA14928@havoc.gtf.org> <49EEE225.3010700@garzik.org> <20090423063542.GK4593@kernel.dk>
In-Reply-To: <20090423063542.GK4593@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Apr 22 2009, Jeff Garzik wrote:
>> Jeff Garzik wrote:
>>> Currently, libata creates a Scsi_Host per port.  This was originally
>>> done to leverage SCSI's infrastructure to arbitrate among master/slave
>>> devices, but is not needed for most modern SATA controllers.   And I
>>> _think_ it is not needed for master/slave if done properly, either.
>> BTW note the above, with regards to the libata SCSI->block conversion.  
>> libata currently relies on SCSI for some amount of generic device  
>> arbitration, in several situations (see ->qc_defer,  
>> SCSI_MLQUEUE_.*_BUSY).  libata expects SCSI to be intelligent and not  
>> starve devices, etc.
> 
> Defer looks like internal policy, I don't see that functioning any
> different in the block layer. SCSI_MLQUEUE_*_BUSY in SCSI is primarily
> using the block layer functionality of BLKPREP_DEFER to begin with, so I
> think we're pretty close to providing all that already.

It's not quite that simple.  I am referring mainly to arbitration across 
multiple request_queue's.  SCSI has useful code in place to deal with 
target-busy and host-busy conditions, both of which could potentially be 
blocking and unblocking multiple request queues.

mlqueue is much more than just a wrapper over block requeueing 
functions.  Read scsi_next_command() and scsi_run_queue(), and grep for 
starved_list, host_{busy,blocked}, target_{busy,blocked}, 
device_{busy,blocked}.

In our master/slave case, we must choose between queue A and queue B, 
making sure to starve neither.  For simplex DMA, we potentially have 
queues A, B, C and D serving requests across the "bus bottleneck," and 
must ensure no starvation of A, B, C or D.


Although I have no code to back this up, my gut feeling is that a 
"request queue group" object, with associated functions, that would be 
the appropriate place for cross-queue or "host-wide" (as in, struct 
Scsi_Host or struct ata_host) functionality.

Whatever the solution, libata definitely makes use of SCSI's 
cross-request_queue arbitration, so any move to block will require 
similar functionality.

	Jeff



