Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbXJWP01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbXJWP01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbXJWP0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:26:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbXJWP0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:26:17 -0400
Date: Tue, 23 Oct 2007 08:22:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Jens Axboe <jens.axboe@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
In-Reply-To: <471DCBB2.9020706@panasas.com>
Message-ID: <alpine.LFD.0.999.0710230808260.30120@woody.linux-foundation.org>
References: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
 <Pine.LNX.4.64.0710222137520.7105@anakin>
 <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org>
 <20071022211617.31f5c63d@the-village.bc.nu>
 <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org>
 <20071022224343.4abf3c96@the-village.bc.nu>
 <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org>
 <471DBEF4.4030303@panasas.com> <20071023094142.GD5059@kernel.dk>
 <471DC3D9.2070809@panasas.com> <20071023095507.GE5059@kernel.dk>
 <471DCBB2.9020706@panasas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Oct 2007, Boaz Harrosh wrote:
>
> A nice design is to have an struct like BIO. That holds a pointer to the 
> array of scatterlists, size, ..., and a next and prev pointers to the next
> chunks. Than have all kernel code that now accepts scatterlist* and size
> accept a pointer to such structure. And all is clear and defined.

Yes, that would be one clean situation.

> But since we do not do that, and every single API in the kernel that
> receives a scatterlist pointer also receives an sg_count parameter,
> than I do not see what is so hacky about giving that sg_count parameter
> to the one that needs it the most. sg_next();

Well, I'd personally actually prefer to *not* have the count be passed 
down explicitly, because it's just too error prone. So I'd much rather see 
the count implicit in the list: whether it's in an explicit header 
structure (that is the *only* thing passed down) or whether it's embedded 
in the list itself is not important.

Since the list itself has to have the "next pointer" for chaining, and 
thus already has "embedded information" in it, it actually does make sense 
in my opinion to just embed the end-of-list information too. And the end 
result right now is pretty simple, with "sg_next()" being really simple to 
use, and there being no way to screw things up by getting the count and 
the sg pointer out of sync.

My biggest complaint right now is that a lot of users of the sg *filling* 
functions were mindlessly converted, so we have code like

	cryptoloop.c:             sg_set_page(&sg_in, in_page);
	cryptoloop.c:             sg_in.offset = in_offs;
	cryptoloop.c:             sg_in.length = sz;

which is just really stupid, and we should have a function for that. But 
worse is code like this:

	ub.c:     sg_set_page(sg, virt_to_page(sc->top_sense));
	ub.c:     sg->offset = (unsigned long)sc->top_sense & (PAGE_SIZE-1);
	ub.c:     sg->length = UB_SENSE_SIZE;

which again was converted "line by line" and we actually *do* have a 
function to do the above three lines as

	sg_set_buf(sg, sc->top_sense, UB_SENSE_SIZE);

where that *single* line is just tons shorter but more importantly, more 
readable, than the mess that is a brute-force conversion.

So I think the SG stuff looks ok now, but I think we have a lot of "fix up 
the rough edges" to go!

(The above is not the only case. Just grep for "sg_set_page", and you'll 
see several examples of this kind of hard-to-read code. Basically, I don't 
think it's ever a good idea to initialize the SG entries one by one, and 
even when we have a hard page/offset/size thing, we should not set them 
one by one, and we should probably extend sg_set_page() to always take 
offset and length too, since setting one without the other two is never 
really sensible!)

		Linus
