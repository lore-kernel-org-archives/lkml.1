Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbZHSN2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbZHSN2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZHSN2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:28:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52689 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbZHSN2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:28:04 -0400
Message-ID: <4A8BFDE2.1010904@garzik.org>
Date: Wed, 19 Aug 2009 09:28:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] libata: use single threaded work queue
References: <20090819112554.GY12579@kernel.dk> <4A8BE932.5090300@garzik.org> <20090819120458.GZ12579@kernel.dk> <4A8BECC2.2060607@rtr.ca> <20090819122320.GA12579@kernel.dk> <4A8BFC79.1000004@garzik.org>
In-Reply-To: <4A8BFC79.1000004@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> It would be nice to just create these threads on-demand,
>>> and destroy them again after periods of dis-use.
>>> Kind of like how Apache does worker threads.
>>
>> Well, that's the same thread pool suggestion that Jeff came up with. And
>> I agree, that's a nicer long term solution (it's also how the per-bdi
>> flushing replacement works). The problem with that appears to be that
>> any suggested patchset for thread pools spiral into certain "but what
>> color should it be?!" death.
>
> Let people complain with code :) libata has two basic needs in this area:
> (1) specifying a thread count other than "1" or "nr-cpus"
> (2) don't start unneeded threads / idle out unused threads

To be even more general,

libata needs a workqueue or thread pool that can

(a) scale up to nr-drives-that-use-pio threads, on demand
(b) scale down to zero threads, with lack of demand

That handles the worst case of each PIO-polling drive needing to sleep 
(thus massively impacting latency, if any other PIO-polling drive must 
wait for a free thread).

That also handles the best case of not needing any threads at all.

	Jeff


