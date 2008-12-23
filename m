Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbYLWVif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbYLWVif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 16:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYLWViW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 16:38:22 -0500
Received: from cet.com.ru ([195.178.208.66]:43339 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYLWViV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 16:38:21 -0500
Date: Wed, 24 Dec 2008 00:38:18 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>, netdev@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Miller <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: Re: [PATCH][RFC 23/23]: Support for zero-copy TCP transmit of user space data
Message-ID: <20081223213817.GB16883@ioremap.net>
References: <494C1E5E.7070809@goop.org> <20081219223314.GA2736@ioremap.net> <494C50BB.5030809@goop.org> <20081220020250.GA15064@gondor.apana.org.au> <494C8D57.7040808@goop.org> <20081220065105.GA16936@gondor.apana.org.au> <494CA226.9000200@goop.org> <20081220081045.GA17439@gondor.apana.org.au> <20081220103209.GA23632@ioremap.net> <49513909.1050100@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49513909.1050100@vlnb.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 10:16:25PM +0300, Vladislav Bolkhovitin (vst@vlnb.net) wrote:
> Actually, there's another way, which seems to be a lot simpler. Alexey 
> Kuznetsov privately suggested it to me.
> 
> In skb_shared_info new pointer transaction_token would be added, which 
> would point on:
> 
> struct sk_transaction_token
> {
> 	atomic_t			io_count;
> 	struct sk_transaction_token	*next;
> 	unsigned long			token;
> 	unsigned long			private;
> 	void				(*finish_callback)(struct 
> 	sk_transaction_token *);
> };
> 
> When skb is translated, transaction_token inherited. If 2 skb are merged 
> (the same places where I put net_get_page's in my patch), the *older* 
> token is inherited. This is the main point of this idea.
> 
> Before starting new asynchronous send a client would open a new token. 
> Everything sent then would receive that token. Finish_callback() would 
> be called and the corresponding token freed, when io_count == 0 *AND* 
> all previous tokens closed.
> 
> This idea seems to be simpler, than even what Rusty implemented. Correct 
> me, if I wrong. But, unfortunately, in the near future I will have no 
> time to develop it.. :-(

Yes, it is simpler and cleaner, but it requires additional allocation.
This is additional (and quite noticeble) overhead.

-- 
	Evgeniy Polyakov
