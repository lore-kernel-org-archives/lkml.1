Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbZA0K6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbZA0K6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 05:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZA0K5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 05:57:50 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:25392 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZA0K5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:57:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AKqsCN+bbqkkIth/vABeSk2So4XqFPX69RaElDZ5jkhKyJoOCUVuyL+FoUihNYrf9k
         aJzutfonKSkGh6opIDqpKb4YSrJ8848ckz7GP2Yh7kIvAnu2xXwXqh2j6SOFTIki1cRm
         d3Gfa5YjXp3o6RSFCYtItLJCW4lw7+zjre5Fo=
Date: Tue, 27 Jan 2009 10:57:39 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, zbr@ioremap.net, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v3] tcp: splice as many packets as possible at once
Message-ID: <20090127105739.GA5778@ff.dom.local>
References: <20090125.212203.15909648.davem@davemloft.net> <20090127071130.GA29125@gondor.apana.org.au> <20090127075418.GB4197@ff.dom.local> <20090127100958.GA30239@gondor.apana.org.au> <20090127103511.GE4197@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127103511.GE4197@ff.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 10:35:11AM +0000, Jarek Poplawski wrote:
> On Tue, Jan 27, 2009 at 09:09:58PM +1100, Herbert Xu wrote:
> > On Tue, Jan 27, 2009 at 07:54:18AM +0000, Jarek Poplawski wrote:
> > > 
> > > Yes, but ip_append_data() (and skb_append_datato_frags() for
> > > NETIF_F_UFO only, so currently not a problem), uses this differently,
> > > and these pages in sk->sk_sndmsg_page could leak or be used after
> > > kfree. (I didn't track locking in these other places).
> > 
> > It'll be freed when the socket is freed so that should be fine.
> > 
> 
> I don't think so: these places can overwrite sk->sk_sndmsg_page left
> after tcp_sendmsg(), or skb_splice_bits() now, with NULL or a new
> pointer without put_page() (they only reference copied chunks and
> expect auto freeing). On the other hand, if tcp_sendmsg() reads after
> them it could use a pointer after the page is freed, I guess.

tcp_v4_destroy_sock() looks like vulnerable too.

BTW, skb_append_datato_frags() currently doesn't need to use this
sk->sk_sndmsg_page at all - it doesn't use caching between calls.

Jarek P.
