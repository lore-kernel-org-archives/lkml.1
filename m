Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbZAGMi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbZAGMi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZAGMiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:38:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2208 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZAGMiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:38:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bPsMyJ9qyDguU2FfLdsNqamavXSQSJnDWvgrNPQ0vkLIH3RGF09FmSv+L7J2MMkrSJ
         1lX8Wqk0qAS+vZBHFKhl7bQMqtn31IzKyoow/AoIPKmMnCiVANKo6f3v383D0PVyZrQ0
         bFwjxtxF9+Qcg2yn30YWHBkw1mmSpLDdTAyYo=
Date: Wed, 7 Jan 2009 12:38:04 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Willy Tarreau <w@1wt.eu>, Jens Axboe <jens.axboe@oracle.com>,
       Changli Gao <xiaosuo@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107123804.GB9597@ff.dom.local>
References: <20081224152841.GB13113@1wt.eu> <20090106085442.GA9513@ff.dom.local> <20090106094138.GE25644@1wt.eu> <20090106100112.GB9513@ff.dom.local> <20090106155715.GA28783@1wt.eu> <20090107093915.GA6899@ff.dom.local> <20090107122205.GA6051@1wt.eu> <20090107122407.GC25673@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107122407.GC25673@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 11:24:07PM +1100, Herbert Xu wrote:
> On Wed, Jan 07, 2009 at 01:22:05PM +0100, Willy Tarreau wrote:
> >
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 5110b35..4c080cd 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -73,17 +73,13 @@ static struct kmem_cache *skbuff_fclone_cache __read_mostly;
> > >  static void sock_pipe_buf_release(struct pipe_inode_info *pipe,
> > >  				  struct pipe_buffer *buf)
> > >  {
> > > -	struct sk_buff *skb = (struct sk_buff *) buf->private;
> > > -
> > > -	kfree_skb(skb);
> > > +	put_page(buf->page);
> > >  }
> > >  
> > >  static void sock_pipe_buf_get(struct pipe_inode_info *pipe,
> > >  				struct pipe_buffer *buf)
> > >  {
> > > -	struct sk_buff *skb = (struct sk_buff *) buf->private;
> > > -
> > > -	skb_get(skb);
> > > +	get_page(buf->page);
> > >  }
> 
> Well this patch can only make it worse because not only are you
> still ref counting skb->head with get_page, but you've also
> completely removed the skb ref count which means that the corruption
> can only occur sooner.

But we don't need this skb... except its ->frags[]  pages, which are
get_paged?! (The rest is copied to new pages.)

Jarek P.
