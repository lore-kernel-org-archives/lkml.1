Return-Path: <linux-kernel-owner+w=401wt.eu-S1763106AbXEYPLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763106AbXEYPLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 11:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762952AbXEYPKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 11:10:55 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:46478 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752021AbXEYPKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 11:10:54 -0400
Message-ID: <4656FC87.6030901@cfl.rr.com>
Date: Fri, 25 May 2007 11:11:03 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
       David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
References: <18006.38689.818186.221707@notabene.brown>
In-Reply-To: <18006.38689.818186.221707@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2007 15:11:03.0451 (UTC) FILETIME=[E920AEB0:01C79EDE]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15198.000
X-TM-AS-Result: No--11.764900-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> There is no guarantee that a device can support BIO_RW_BARRIER - it is
> always possible that a request will fail with EOPNOTSUPP.

Why is it not the job of the block layer to translate for broken devices 
and send them a flush/write/flush?

>    These devices would find it very hard to support BIO_RW_BARRIER.
>    Doing this would require keeping track of all in-flight requests
>    (which some, possibly all, of the above don't) and then:

The device mapper keeps track of in flight requests already.  When 
switching tables it has to hold new requests and wait for in flight 
requests to complete before switching to the new table.  When it gets a 
barrier request it just needs to do the same thing, only not switch 
tables.

>    I think the best approach for this class of devices is to return
>    -EOPNOSUP.  If the filesystem does the wait (which they all do
>    already) and the blkdev_issue_flush (which is easy to add), they
>    don't need to support BIO_RW_BARRIER.

Why?  The personalities should just pass the BARRIER flag down to each 
underlying device, and the dm common code should wait for all in flight 
io to complete before sending the barrier to the personality.

> For devices that don't support QUEUE_ORDERED_TAG (i.e. commands sent to
> the controller can be tagged as barriers), SCSI will use the
> SYNCHRONIZE_CACHE command to flush the cache after the barrier
> request (a bit like the filesystem calling blkdev_issue_flush, but at

Don't you have to flush the cache BEFORE the barrier to ensure that 
previous IO is committed first, THEN the barrier write?


