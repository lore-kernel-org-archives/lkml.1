Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbXJWSdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbXJWSdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbXJWSd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:33:27 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20539 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbXJWSd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:33:26 -0400
Date: Tue, 23 Oct 2007 20:33:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071023183321.GA14671@kernel.dk>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <471E2A96.7050304@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471E2A96.7050304@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Boaz Harrosh wrote:
> On Mon, Oct 22 2007 at 20:11 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> > Change the page member of the scatterlist structure to be an unsigned
> > long, and encode more stuff in the lower bits:
> > 
> > - Bits 0 and 1 zero: this is a normal sg entry. Next sg entry is located
> >   at sg + 1.
> > - Bit 0 set: this is a chain entry, the next real entry is at ->page_link
> >   with the two low bits masked off.
> > - Bit 1 set: this is the final entry in the sg entry. sg_next() will return
> >   NULL when passed such an entry.
> > 
> > It's thus important that sg table users use the proper accessors to get
> > and set the page member.
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> <snip>
> >  
> >  /**
> >   * sg_set_page - Set sg entry to point at given page
> > @@ -20,11 +37,20 @@
> >   **/
> >  static inline void sg_set_page(struct scatterlist *sg, struct page *page)
> >  {
> > -	sg->page = page;
> > +	unsigned long page_link = sg->page_link & 0x3;
> > +
> You might want to put a BUG_ON(page & 0x3); Make sure
> you're not loosing information. (The m68k problem)

That's a really good idea, thanks Boaz! I'll add that.

-- 
Jens Axboe

