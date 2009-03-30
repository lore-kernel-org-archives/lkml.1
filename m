Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZC3Pri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZC3Pri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZC3Pr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:47:27 -0400
Received: from exc01vs1.exchange.cysonet.com ([85.158.200.82]:18825 "EHLO
	exc01vs1.exchange.cysonet.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbZC3PrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:47:25 -0400
User-Agent: Microsoft-Entourage/12.15.0.081119
Date: Mon, 30 Mar 2009 17:47:19 +0100
Subject: Re: Page Cache writeback too slow,   SSD/noop scheduler/ext2
From: Jos Houtman <jos@hyves.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, <linux-kernel@vger.kernel.org>,
       Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
       <linux-fsdevel@vger.kernel.org>, <jens.axboe@oracle.com>,
       <akpm@linux-foundation.org>, <hch@infradead.org>,
       <linux-nfs@vger.kernel.org>
Message-ID: <C5F6B627.D9D0%jos@hyves.nl>
Thread-Topic: Page Cache writeback too slow,   SSD/noop scheduler/ext2
Thread-Index: AcmwFsYCqkFwmUxBTpma/AE+p/juyQBOAivb
In-Reply-To: <20090329023238.GA7825@localhost>
X-Priority: 10
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 30 Mar 2009 15:47:21.0268 (UTC) FILETIME=[D00A6F40:01C9B14E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Thanx for the patch, but for the next time: How should I apply it?
>> it seems to be context aware (@@) and broke on all kernel versions I tried
>> 2.6.28/2.6.28.7/2.6.29
> 
> Do you mean that the patch applies after removing " @@.*$"?

I didn't try that, but this time it worked. So it was probably my error.

> 
> You are right. In your case, there are several big dirty files in sdb1,
> and the sdb write queue is constantly (almost-)congested. The SSD write
> speed is so slow, that in each round of sdb1 writeback, it begins with
> an uncongested queue, but quickly fills up after writing some pages.
> Hence all the inodes will get redirtied because of (nr_to_write > 0).
> 
> The following quick fix should solve the slow-writeback-on-congested-SSD
> problem. However the writeback sequence is suboptimal: it sync-and-requeue
> each file until congested (in your case about 3~600 pages) instead of
> until MAX_WRITEBACK_PAGES=1024 pages.

Yeah that fixed it, but performance dropped due to the more constant
congestion. So I will need to try some different io schedulers.


Next to that I was wondering if there are any plans to make sure that not
all dirty-files are written back in the same interval.

In my case all database files are written back each 30 seconds, while I
would prefer them to be more divided over the interval.

Thanks,

Jos

