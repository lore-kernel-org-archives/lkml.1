Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZKWQSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZKWQSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZKWQSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:18:09 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48670 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbZKWQSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:18:08 -0500
Subject: Re: [PATCH 1/1] Defer skb allocation for both mergeable buffers
	and big packets in virtio_net
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091123094323.GA3748@redhat.com>
References: <1258697745.7416.20.camel@localhost.localdomain>
	 <4B063509.10006@gmail.com> <1258734101.11049.1.camel@localhost.localdomain>
	 <20091123094323.GA3748@redhat.com>
Content-Type: text/plain
Date: Mon, 23 Nov 2009 08:18:08 -0800
Message-Id: <1258993088.5022.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 11:43 +0200, Michael S. Tsirkin wrote:

> should be !npage->private
> and nesting is too deep here:
> this is cleaner in a give_a_page subroutine
> as it was.

This will be addressed with Rusty's comment.


> > +		/* use private to chain big packets */
> 
> packets? or pages?

Will change it to chain pages for big packets

> > +		p->private = (unsigned long)0;
> 
> the comment is not really helpful:
> you say you use private to chain but 0 does not
> chain anything. You also do not need the cast to long?

Ok.

> > +	if (len > (PAGE_SIZE - f->page_offset))
> 
> brackets around math are not needed.

OK.

> typo
> 
> > +			 * header and data */
Got it.

> please think of a way to get rid of magic constants like 6 and 2
> here and elsewhere.

Will do.

> replace MAX_SKB_FRAGS + 2 with something symbolic? We have it in 2 palces now.
> And comment.

Ok, I can change it.

> terrible goto based loop
> move stuff into subfunction, it will be much
> more manageable, and convert this to a simple
> for loop.

Will change it to different functions based on Rusty's comment.

> and here it is MAX_SKB_FRAGS + 1

I think I should use MAX_SKB_FRAGS + 2 instead. Now I only use
MAX_SKB_FRAGS + 1 but allocated + 2.

> > +				page->private = (unsigned long)first_page;
> > +				first_page = page;
> > +				if (--i == 1) {
> 
> this is pretty hairy ... has to be this way?
> What you are trying to do here
> is fill buffer with pages, in a loop, with first one
> using a partial page, and then add it.
> Is that it?
Yes.

> So please code this in a straight forward manner.
> it should be as simple as:

> 	offset = XXX
> 	for (i = 0; i < MAX_SKB_FRAGS + 2; ++i) {
> 		
> 		sg_set_buf(sg + i, p + offset, PAGE_SIZE - offset);
> 		offset = 0;
> 
> 	}
Ok, looks more neat.

> space around +
> sg + 1 here is same as &sg[i] in fact?

Ok.

> callback -> destructor?

Ok.

I will integrate these comments with Rusty's and resubmit the patch set.

Thanks
Shirley

