Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbZAGIS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbZAGIS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 03:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZAGISP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 03:18:15 -0500
Received: from brick.kernel.dk ([93.163.65.50]:22582 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbZAGISO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 03:18:14 -0500
Date: Wed, 7 Jan 2009 09:17:08 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107081708.GG32491@kernel.dk>
References: <20081224152841.GB13113@1wt.eu> <20090106183223.GA11964@ioremap.net> <20090106183704.GC32491@kernel.dk> <20090107044232.GA22218@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107044232.GA22218@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07 2009, Herbert Xu wrote:
> On Tue, Jan 06, 2009 at 06:37:05PM +0000, Jens Axboe wrote:
> > 
> > I'll give this a spin tomorrow as well. A hunch tells me that this is
> > likely a page reuse issue, that splice is getting the reference to the
> > buffer dropped before the data has really been transmitted. IOW, the
> > page is likely fine reaching the ->sendpage() bit, but will be reused
> > before the data has actually been transmitted. So once you get that far,
> > other random data from that page is going out.
> 
> I see the problem.
> 
> The socket pipes in net/core/skbuff.c use references on the skb
> to hold down the memory in skb->head as well as the pages in the
> skb.
> 
> Unfortunately, once the pipe is fed into sendpage we only use
> page reference counting to pin down the memory.  So as soon as
> sendpage returns we drop the ref count on the skb, thus freeing
> the memory in skb->head, which is yet to be transmitted.
> 
> Moral: Using page reference counts on skb->head is wrong.

So my hunch was pretty close. The fix would seem to involve NOT calling
ops->release(pipe, buf) until we actually have an ACK on that data gone
out.

-- 
Jens Axboe

