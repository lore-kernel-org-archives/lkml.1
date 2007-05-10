Return-Path: <linux-kernel-owner+w=401wt.eu-S1760038AbXEJNz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbXEJNz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbXEJNzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:55:51 -0400
Received: from gw-e.panasas.com ([65.194.124.178]:37973 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754948AbXEJNzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:55:51 -0400
Message-ID: <4643243C.8030906@panasas.com>
Date: Thu, 10 May 2007 16:55:08 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/12] crypto: don't pollute the global namespace with
 sg_next()
References: <11787972373654-git-send-email-jens.axboe@oracle.com> <11787972372499-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <11787972372499-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 May 2007 13:55:09.0785 (UTC) FILETIME=[D2BC2490:01C7930A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> It's a subsystem function, prefix it as such.

Jens, Boaz and I talked about this over lunch.
I wonder whether the crypto code must use your implementation
instead of its own as it needs to over the sglist, e.g. for
calculating iscsi (data) digest.

The crypto implementation of chained sglists in crypto/scatterwalk.h
determines the chain link by !sg->length which will sorta work
with your implementation, however the marker bit on page pointer must
be cleared to use it.

Also, is it possible that after the original sglist has gone through
dma_map_sg and entries were merged, some entries will have zero
length?  I'm not sure... If so, if the crypto implementation scans
the sg list after it was dma mapped (maybe in a retry path) it
may hit an entry that looks to it like a chaining link.  This
might be an existing bug and another reason for the crypto code
to use your implementation.

Thanks,

Benny

