Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbXJLAxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbXJLAxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 20:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbXJLAw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 20:52:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52309 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbXJLAw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 20:52:57 -0400
Date: Thu, 11 Oct 2007 17:52:24 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, heiko.carstens@de.ibm.com,
       schwidefsky@de.ibm.com
Subject: Re: [PATCH net-2.6.24] remove bogus qeth type check
Message-ID: <20071011175224.130fb2f7@freepuppy.rosehill>
In-Reply-To: <20071011.172454.116363992.davem@davemloft.net>
References: <200710110909.l9B99fEM021646@imap1.linux-foundation.org>
	<20071011.024529.112295019.davem@davemloft.net>
	<20071011132458.3b536662@freepuppy.rosehill>
	<20071011.172454.116363992.davem@davemloft.net>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 17:24:54 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <shemminger@linux-foundation.org>
> Date: Thu, 11 Oct 2007 13:24:58 -0700
> 
> > Not sure why this crept in with hard-header-ops change.
> > Just kill it. Need to start doing cross-compiles for s390...
> > 
> > Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
> > 
> > --- a/drivers/s390/net/qeth_main.c	2007-10-10 08:26:48.000000000 -0700
> > +++ b/drivers/s390/net/qeth_main.c	2007-10-11 13:21:17.000000000 -0700
> > @@ -6581,9 +6581,6 @@ qeth_hard_header_parse(const struct sk_b
> >  	const struct qeth_card *card;
> >  	const struct ethhdr *eth;
> >  
> > -	if (dev->type != ARPHRD_IEEE802_TR)
> > -		return 0;
> > -
> >  	card = qeth_get_card_from_dev(skb->dev);
> >  	if (card->options.layer2)
> >  		goto haveheader;
> 
> Stephen this change is not right.
> 
> In order to preserve the semantics that existed before your
> headerops changes, this test must be there.  From the original
> qeth_main.c code:
> 
> 	if (qeth_get_netdev_flags(card) & IFF_NOARP) {
> 		dev->rebuild_header = NULL;
> 		dev->hard_header = NULL;
> 		dev->header_cache_update = NULL;
> 		dev->hard_header_cache = NULL;
> 	}
>  ...
> 	if (card->options.fake_ll &&
> 		(qeth_get_netdev_flags(card) & IFF_NOARP))
> 			dev->hard_header = qeth_fake_header;
> 	if (dev->type == ARPHRD_IEEE802_TR)
> 		dev->hard_header_parse = NULL;
> 	else
> 		dev->hard_header_parse = qeth_hard_header_parse;
> 
> With the way you set up headerops in the driver, the only way
> to preserve the ARPHRD_IEEE802_TR guard, is to keep the
> test that you added to qeth_hard_header_parse().
> 
> Andrew, please go back to using the first patch you wrote to
> fix the build, alternative resync with net-2.6.git as that
> version of the build fix is there too.

Dave, you right, that is why I put that test in. Should have kept
the staging tree and notes around longer.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
