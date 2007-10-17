Return-Path: <linux-kernel-owner+w=401wt.eu-S932623AbXJQTp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbXJQTp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbXJQTpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:45:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754346AbXJQTpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:45:15 -0400
Date: Wed, 17 Oct 2007 12:42:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
In-Reply-To: <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0710171233320.26902@woody.linux-foundation.org>
References: <20071017154655.GA13394@elte.hu>
 <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org>
 <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk>
 <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk>
 <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu>
 <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk>
 <20071017190901.GA13780@elte.hu>
 <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Linus Torvalds wrote:
> 
> I think you'll always hit it if you have a scatter-gather list that is 
> exactly filled up.

In fact, I think you'll hit it even if you use the "for_each_sg()" 
helper function. Exactly because it does the sg = sg_next(sg) at the end 
of the for-loop, so it will do it for the last entry too, even though that 
will access one past the end.

So it really *is* the case that every *single* use of that SG chain needs 
to be switched over to only do the sg_next() when required, or sg_next() 
needs to be fixed to look at the current-in-use entry (which we *can* 
access) when it decides what to do about the next one (which we can *not* 
access).

Moving the sg_is_chain() bit to the previous entry would work, but it 
requires that nobody who could have a chained scatterlist must *ever* 
access "sg->page" directly - you'd always need to use some helper function 
that masks off the bit, eg

 - rename "sg->page" into "sh->page_and_flag", and make it "unsigned long" 
   instead of a pointer.

 - change every single "sg->page" access to use "sg_page(sg)" instead:

	#define sg_pointer(sg)	((void *)((sg)->page_and_flag & ~1ul))

	static inline struct page *sg_page(struct scatterist *sg)
	{
		return sg_pointer(sg);
	}

 - change "sg_next()" to do

	static inline struct scatterlist *sg_next(struct scatterlist *sg)
	{
		if (sg->page_and_flag & 1)
			sg = sg_pointer(sg+1)-1;
		return ++sg;
	}

where the magic is exactly the fact that now "sg_next()" will *not* 
derefence the next SG entry unless the current one was marked 
appropriately.

And then *creating* the chain obviously needs to properly mark the 
next-to-last entry with the "next entry is a pointer" flag.

Big diff, it sounds like. But I don't see many alternatives. Jens?

		Linus
