Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbYHZQml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbYHZQml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbYHZQmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:42:33 -0400
Received: from blackbird.sr71.net ([64.146.134.44]:50567 "EHLO
	blackbird.sr71.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbYHZQmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:42:32 -0400
Subject: Re: [RFC v2][PATCH 2/9] General infrastructure for checkpoint
	restart
From: Dave Hansen <dave@sr71.net>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, arnd@arndb.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <48B21D3C.8090601@cs.columbia.edu>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0808202303460.17436@takamine.ncl.cs.columbia.edu>
	 <1219435302.20559.121.camel@nimitz>  <48B21D3C.8090601@cs.columbia.edu>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 09:42:29 -0700
Message-Id: <1219768949.8680.26.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-24 at 22:47 -0400, Oren Laadan wrote:
> > I replaced all of the uses of these with kmalloc()/kfree() and stack
> > allocations.  I'm really not sure what these buy us since our allocators
> > are already so fast.  tbuf, especially, worries me if it gets used in
> > any kind of nested manner we're going to get some really fun bugs.
> 
> I disagree with putting some of the cr_hdr_... on the stack: first, if they
> grow in size, it's easy to forget to change the allocation to stack.

I can buy that. 

> Second,
> using a standard code/handling for all cr_hdr_... makes the code more readable
> and easier for others to extend by simply following existing code.

It actually makes it harder for others to jump into because they see
something which is basically a kmalloc() to the rest of the kernel.  We
don't have ext2_alloc() or usb_alloc(), so I'm not sure we should have
cr_alloc(), effectively.

> The main argument for ->hbuf is that eventually we would like to buffer
> data in the kernel to avoid potentially slow writing/reading when processes
> are frozen during checkpoint/restart.

Um, we're writing to a file descriptor and kmap()'ing.  Those can both
potentially be very, very slow.  I don't think that a few kmalloc()s
thrown in there are going to be noticeable.

> By using the simple cr_get_hbuf() and
> cr_put_hbuf() we prepare for that: now they just allocate room in ->hbuf,
> but later they will provide a pointer directly in the data buffer. Moreover,
> it simplifies the error path since cleanup (of ->hbuf) is implicit.

It simplifies *one* error path.  But, it complicates the ctx creation
and makes *that* error path more complex.  Pick your poison, I guess.

> Also,
> it is designed to allow checkpoint and restart function to be called in a
> nested manner, again simplifying the code. Finally, my experience was that
> it can impact performance if you are after very short downtimes, especially
> for the checkpoint.

Right, but I'm comparing it to kmalloc()  Certainly kmalloc()s can be
used in a nested manner.

> >> +/* read the checkpoint header */
> >> +static int cr_read_hdr(struct cr_ctx *ctx)
> >> +{
> >> +	struct cr_hdr_head *hh = cr_hbuf_get(ctx, sizeof(*hh));
> >> +	int ret;
> >> +
> >> +	ret = cr_read_obj_type(ctx, hh, sizeof(*hh), CR_HDR_HEAD);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +	else if (ret != 0)
> >> +		return -EINVAL;
> > 
> > How about just making cr_read_obj_type() stop returning positive values?
> > Is it ever valid for it to return >0?
> 
> The idea with cr_read_obj_type() is that it returns the 'ptag' - parent tag -
> field of the object that it reads in. The 'ptag' is the tag of the parent
> object, and is useful in several places. For instance, the 'ptag' of an MM
> header identifies (is equal to) the 'tag' of TASK to which it belongs. In
> this case, the 'ptag' should be zero because it has no parent object.
> 
> I'll change the variable name from 'ret' to 'ptag' to make it more obvious.

Since this ptag isn't actually used, I can't really offer a suggestion.
I don't see the whole picture.

-- Dave

