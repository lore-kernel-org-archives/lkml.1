Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbXJZOyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbXJZOyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbXJZOyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:54:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53832 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbXJZOyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:54:12 -0400
Date: Fri, 26 Oct 2007 07:52:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, Boaz Harrosh <bharrosh@panasas.com>,
       Jens Axboe <jens.axboe@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: [PATCH 09/10] Change table chaining layout
In-Reply-To: <18209.29891.911465.715995@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LFD.0.999.0710260742140.30120@woody.linux-foundation.org>
References: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
 <471DCBB2.9020706@panasas.com> <alpine.LFD.0.999.0710230808260.30120@woody.linux-foundation.org>
 <200710251840.02157.rusty@rustcorp.com.au>
 <alpine.LFD.0.999.0710250834390.30120@woody.linux-foundation.org>
 <18209.29891.911465.715995@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Paul Mackerras wrote:
>
> Linus Torvalds writes:
> 
> > Nobody should *ever* walk the list to find the length. Does anybody really 
> > do that? Yes, we pass the thing down, but do people *need* it?
> 
> Yes, I need it for devices that use the macintosh DBDMA
> (descriptor-based DMA) hardware.  The DBDMA hardware reads an array of
> descriptors from system RAM, so I need to allocate an array and fill
> it in with DBDMA command blocks (and then dma-map it and point the
> device at it).

Yes, for allocation purposes you'd need the size ahead of time, agreed. 
Otherwise you have to walk the list twice.

> Maybe the drivers for devices that use DBDMA are now buggy.  Certainly
> filling in the array of DBDMA command blocks involves walking the
> list, but it would extremely useful to know how much to allocate
> before we start filling them in.  So we at least need an upper bound
> on the number of "real" entries, even if we don't have the exact
> number.

Hmm. Depending on where you do this, and if this is some block-layer 
specific driver/code (rather than necessarily a generic SG thing), you do 
have the req->nr_phys_segments thing which should be that for you (ie the 
SG list may have _fewer_ requests in it in case some of those entries got 
squashed together due to be contiguous).

But yeah, I don't think it would be wrong at all to have a

	struct scatterlist_head {
		unsigned int entries;
		unsigned int flags;	/* ? */
		struct scatterlist *sg;
	};

which would be passed down at higher levels.

		Linus
