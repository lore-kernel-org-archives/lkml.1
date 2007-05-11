Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbXEKFUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbXEKFUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 01:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbXEKFUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 01:20:37 -0400
Received: from gw-e.panasas.com ([65.194.124.178]:59752 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754308AbXEKFUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 01:20:36 -0400
Message-ID: <4643FD1C.1040401@panasas.com>
Date: Fri, 11 May 2007 08:20:28 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/12] crypto: don't pollute the global namespace with
  sg_next()
References: <11787972373654-git-send-email-jens.axboe@oracle.com> <11787972372499-git-send-email-jens.axboe@oracle.com> <4643243C.8030906@panasas.com> <20070510213743.GY4163@kernel.dk>
In-Reply-To: <20070510213743.GY4163@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 May 2007 05:20:30.0439 (UTC) FILETIME=[179F9F70:01C7938C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, May 10 2007, Benny Halevy wrote:
>> Jens Axboe wrote:
>>> It's a subsystem function, prefix it as such.
>> Jens, Boaz and I talked about this over lunch.
>> I wonder whether the crypto code must use your implementation
>> instead of its own as it needs to over the sglist, e.g. for
>> calculating iscsi (data) digest.
> 
> The thought did cross my mind, and yes I think that would be a good
> idea. The whole thing should probably just migrate to
> lib/scattersomething.c
> 
>> The crypto implementation of chained sglists in crypto/scatterwalk.h
>> determines the chain link by !sg->length which will sorta work
>> with your implementation, however the marker bit on page pointer must
>> be cleared to use it.
> 
> I don't like using sg->length, as that may be modified for legitimate
> reason. That's why I chose to use the lsb bit of the page pointer.
> 
>> Also, is it possible that after the original sglist has gone through
>> dma_map_sg and entries were merged, some entries will have zero
>> length?  I'm not sure... If so, if the crypto implementation scans
>> the sg list after it was dma mapped (maybe in a retry path) it
>> may hit an entry that looks to it like a chaining link.  This
>> might be an existing bug and another reason for the crypto code
>> to use your implementation.
> 
> It's hard to say, depends heavily on the sub system or arch. Even if
> using the pointer tagging mechanism seems a bit nasty, I think it's the
> more resilient approach.
> 

We're in agreement then :)
I was trying to say that the methods should be compatible, otherwise
bugs can happen, and that your scheme is better since it can
handle sglists with zero length entries that aren't the last.
A case that might be valid after dma mapping and merging.
If indeed this case is possible, this seems to be the right time
to converge to your scheme.

Benny
