Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYKQSJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYKQSJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYKQSJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:09:26 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37176 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYKQSJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:09:25 -0500
Date: Mon, 17 Nov 2008 19:07:38 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <htejun@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
Message-ID: <20081117180738.GW26778@kernel.dk>
References: <20081117085046.GE28786@elte.hu> <20081117085807.GF26778@kernel.dk> <20081117093425.GG26778@kernel.dk> <20081117094147.GJ28786@elte.hu> <20081117094551.GI26778@kernel.dk> <20081117111350.GJ26778@kernel.dk> <4921A4F3.1030309@goop.org> <20081117171005.GA25729@elte.hu> <4921A6BE.7000206@goop.org> <alpine.LFD.2.00.0811170922000.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811170922000.3468@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17 2008, Linus Torvalds wrote:
> 
> 
> On Mon, 17 Nov 2008, Jeremy Fitzhardinge wrote:
> 
> > Pass the struct page * to kunmap, not the vaddr of the mapping itself.
> > 
> > Pointed out by Jens Axboe <jens.axboe@oracle.com>
> > 
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > ---
> > drivers/xen/balloon.c |    2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > ===================================================================
> > --- a/drivers/xen/balloon.c
> > +++ b/drivers/xen/balloon.c
> > @@ -120,7 +120,7 @@
> > 	if (PageHighMem(page)) {
> > 		void *v = kmap(page);
> > 		clear_page(v);
> > -		kunmap(v);
> > +		kunmap(page);
> > 	} else {
> > 		void *v = page_address(page);
> > 		clear_page(v);
> 
> Well, quite frankly, the whole thing looks like crud.
> 
> First off, 'kmap/kunmap' work on regular pages too. So if you're highmem 
> aware, you should just do
> 
> 	void *v = kmap(page);
> 	clear_page(v);
> 	kunmap(page);
> 
> and be done with it. 
> 
> Secondly, we actually have a function called "clear_highpage()" that does 
> this, except it uses kmap_atomic(page, KM_USER0). Which is _probably 
> better anyway, but I didn't check if there is some magical reason why it 
> wouldn't work.

Indeed, scrub_page() should just be eliminated.

Any opinions on the kunmap/kunmap_atomic pointer checking? It's a bit
ugly that we have to enforce a void * rule for kunmap_atomic(), but
it'll definitely catch bugs. So I think it's worth it, I'd like to hear
your opinion before I queue it for 2.6.29 though.

-- 
Jens Axboe

