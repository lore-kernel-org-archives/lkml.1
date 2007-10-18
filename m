Return-Path: <linux-kernel-owner+w=401wt.eu-S1763624AbXJRBhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763624AbXJRBhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbXJRBhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:37:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625AbXJRBhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:37:09 -0400
Date: Wed, 17 Oct 2007 18:36:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
In-Reply-To: <20071017.181907.63126798.davem@davemloft.net>
Message-ID: <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org>
 <20071018080048O.fujita.tomonori@lab.ntt.co.jp>
 <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
 <20071017.181907.63126798.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, David Miller wrote:
>
> I believe that we have enough of a limited set of accessors to
> sg->page that we can more aggressively encode things in the lower
> bits.
> 
> I'm thinking of encoding the low two bits of sg->page as
> follows:
> 
> 1) bits == 0
> 
>    then the SG list is linear and sg_next() is sg++
> 
> 2) bits == 1
> 
>    the nest SG is an indirect chunk, sg_next() is
>    therefore something like:
> 
> 	next = *((struct scatterlist **)(sg + 1));
> 
> 3) bits == 2
> 
>    this is the last entry in the scatterlist, sg_next() is NULL
> 
> So for the cases of ARCH_HAS_SG_CHAIN not being set (ie. back
> compatible), we can do no bit encoding in page->flags and just do
> sg_next() == sg++, as is done now.

Yes, that sounds sane.

Although I also wonder whether we want one global per-arch 
ARCH_HAS_SG_CHAIN, or perhaps have something more dynamic, which allows a 
per-SG-list choice (which in turn would require some kind of "head" entry 
that is passed into sg_next(), and in general descibes the SG list)

		Linus
