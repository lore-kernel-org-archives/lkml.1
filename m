Return-Path: <linux-kernel-owner+w=401wt.eu-S1752421AbYLWTRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbYLWTRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 14:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYLWTQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 14:16:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:55574 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYLWTQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 14:16:52 -0500
Message-ID: <49513909.1050100@vlnb.net>
Date: Tue, 23 Dec 2008 22:16:25 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
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
Subject: Re: [PATCH][RFC 23/23]: Support for zero-copy TCP transmit of user
 space data
References: <494C0255.8010208@goop.org> <20081219220452.GB704@ioremap.net> <494C1E5E.7070809@goop.org> <20081219223314.GA2736@ioremap.net> <494C50BB.5030809@goop.org> <20081220020250.GA15064@gondor.apana.org.au> <494C8D57.7040808@goop.org> <20081220065105.GA16936@gondor.apana.org.au> <494CA226.9000200@goop.org> <20081220081045.GA17439@gondor.apana.org.au> <20081220103209.GA23632@ioremap.net>
In-Reply-To: <20081220103209.GA23632@ioremap.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18jYv0brpCOVXUYgz1IQC88u8MUUeIyPH0MGX6
 vsd8O0l1ST0cmcFuA3AvmGnCqD5V0/PQNMhp5iBbHsjg/cC4Oj
 oX95+cwAPp0dk68oGQEPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov, on 12/20/2008 01:32 PM wrote:
> On Sat, Dec 20, 2008 at 07:10:45PM +1100, Herbert Xu (herbert@gondor.apana.org.au) wrote:
>>> Hm.  So if I get a destructor call from the shared_info, can I go an  
>>> inspect the page refcounts to see if its really the last use?
>> The pages that were originally in the shared_info at creation
>> time may no longer be there by the time it's freed because of
>> pskb_pull_tail.
> 
> Things should work fine, since pskb_expand_head() copies whole shared
> info structure (and thus will copy destructor), get all pages and then
> copy all pointers into the new skb, and then release old skb's data.
> 
> So destructor for the pages should not rely on which skb it is called on
> and check if pages are about to be really freed (i.e. check theirs
> reference counter).
> 
> __pskb_pull_tail() is tricky, it just puts some pages it does not want
> to be present in the skb, but it could be possible to add there
> destructor callback from the original skb with partial flag (or just
> having destructor with two parameters: skb and page, and if page is not
> NULL, then actually only given page is freed, otherwise the whole skb).

Actually, there's another way, which seems to be a lot simpler. Alexey 
Kuznetsov privately suggested it to me.

In skb_shared_info new pointer transaction_token would be added, which 
would point on:

struct sk_transaction_token
{
	atomic_t			io_count;
	struct sk_transaction_token	*next;
	unsigned long			token;
	unsigned long			private;
	void				(*finish_callback)(struct sk_transaction_token *);
};

When skb is translated, transaction_token inherited. If 2 skb are merged 
(the same places where I put net_get_page's in my patch), the *older* 
token is inherited. This is the main point of this idea.

Before starting new asynchronous send a client would open a new token. 
Everything sent then would receive that token. Finish_callback() would 
be called and the corresponding token freed, when io_count == 0 *AND* 
all previous tokens closed.

This idea seems to be simpler, than even what Rusty implemented. Correct 
me, if I wrong. But, unfortunately, in the near future I will have no 
time to develop it.. :-(

Vlad

